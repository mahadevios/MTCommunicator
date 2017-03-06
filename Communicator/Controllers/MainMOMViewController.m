//
//  MainMOMViewController.m
//  Communicator
//
//  Created by mac on 13/06/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import "MainMOMViewController.h"
#import "Database.h"
#import "Mom.h"
#import "UIColor+CommunicatorColor.h"
#import "MomDetailViewController.h"

@interface MainMOMViewController ()
@property (strong, nonatomic) UISearchController *searchController;
@property (nonatomic, strong) NSArray *search;
@property(nonatomic, weak) id< UISearchControllerDelegate > delegate;
@property (strong, nonatomic) NSString *indexPath;

@end

@implementation MainMOMViewController
@synthesize search;
@synthesize searchController;

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    refreshControl = [[UIRefreshControl alloc]init];
    refreshControl.tag=1000;
    [self.tableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    [[Database shareddatabase] setMOMView];

    [self prepareSearchBar];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(get50MOM:) name:NOTIFICATION_MOM_LOAD_MORE_DATA
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadTable) name:NOTIFICATION_UPADTE_MOM_VIEW
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addMOMButton) name:NOTIFICATION_ADD_MOM_BUTTON
                                               object:nil];
     [self reloadTable];
    
}

-(void)refreshTable
{
    NSString* username = [[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"];
    NSString* password = [[NSUserDefaults standardUserDefaults] valueForKey:@"currentPassword"];
    
    NSString* companyId=[[Database shareddatabase] getCompanyId:username];
    //    NSString* userFeedback=[[Database shareddatabase] getUserIdFromUserName:username];
    NSString* userFrom,*userTo;
    if ([companyId isEqual:@"1"])
    {
        userFrom= [[Database shareddatabase] getAdminUserId];
        username=[[Database shareddatabase] getUserNameFromCompanyname:[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedCompany"]];
        userTo=[[Database shareddatabase] getUserIdFromUserNameWithRoll1:username];
        
    }
    
    else
    {
        userTo=[[Database shareddatabase] getAdminUserId];

        userFrom= [[Database shareddatabase] getUserIdFromUserNameWithRoll1:username];
    }
    
    NSMutableArray* feedbackIDsArray= [[Database shareddatabase] getMOMIds:userFrom userTo:userTo];
    
    NSMutableString* feedIdsString;
    if (feedbackIDsArray.count==0)
    {
        feedIdsString=[@"0" mutableCopy];
    }
    for (int i=0; i<feedbackIDsArray.count; i++)
    {
        if (i==0)
        {
            feedIdsString=[feedbackIDsArray objectAtIndex:i];
        }
        //        else
        //            if (i==feedbackIDsArray.count-1)
        //            {
        //                feedIdsString=[NSMutableString stringWithFormat:@"%@%@",feedIdsString,[feedbackIDsArray objectAtIndex:i]];
        //            }
        else
        {
            feedIdsString=[NSMutableString stringWithFormat:@"%@,%@",feedIdsString,[feedbackIDsArray objectAtIndex:i]];
        }
    }
    NSString* username1 = [[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"];
    
    //int feedbackType=  [[Database shareddatabase] getFeedbackIdFromFeedbackType:self.feedbackType];
    [[APIManager sharedManager] getLoadMoreMOMData:username1 password:password userFrom:userFrom userTo:userTo feedbackIdsArray:feedIdsString];
    [self.tableView reloadData];
}
-(void)reloadTable
{
    [[Database shareddatabase] setMOMView];
    [self prepareSearchBar];
    [self.tableView reloadData];

}
-(void)get50MOM:(NSNotification*)data
{
    [[Database shareddatabase] insertLoadMoreMOMNotificationData:data.object];
    [refreshControl endRefreshing];
}
-(void)viewWillAppear:(BOOL)animated
{
    //    self.navigationItem.title = @"New MOM";
    
    self.navigationController.navigationItem.title = @"Meeting Minutes";
    self.navigationController.navigationBar.backgroundColor = [UIColor communicatorColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.navigationBar.barTintColor = [UIColor communicatorColor];
    [self.navigationController.navigationBar setBarStyle:UIStatusBarStyleLightContent];
    
        [self.navigationItem setHidesBackButton:NO];
    self.navigationController.navigationItem.rightBarButtonItem=nil;

    // self.navigationController.navigationBar.barTintColor = [UIColor communicatorColor];
    self.navigationController.navigationItem.leftBarButtonItem.tintColor=[UIColor whiteColor];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(getLatestMOM:) name:NOTIFICATION_GETLATEST_MOM
//                                               object:nil];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SignOut"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController1)] ;
    //[[Database shareddatabase] setMOMView];
   
    [self.tableView reloadData];
    [self addMOMButton];
        
}

-(void)prepareSearchBar
{
    AppPreferences* app=[AppPreferences sharedAppPreferences];
    //feedTypeArray=[[NSMutableArray alloc]init];
    app.sampleMOMArray=[[NSMutableArray alloc]init];
    
    app.samplefMOMCopyForPredicate=[[NSMutableArray alloc]init];
    
    Mom* ft2=[Mom new];
    
    for (int i=0; i<app.allMomArray.count; i++)
    {
        
        ft2= [app.allMomArray objectAtIndex:i];
        
        [app.sampleMOMArray insertObject:ft2 atIndex:i];
        //[app.sampleFeedtypeArray insertObject:ft2.feedbackType atIndex:i];
        
        [app.samplefMOMCopyForPredicate insertObject:ft2 atIndex:i];
        
    }
    
    
    searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    searchController.searchResultsUpdater = self;
    searchController.searchBar.delegate = self;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES;
    self.searchController.obscuresBackgroundDuringPresentation = NO;
    self.searchController.hidesNavigationBarDuringPresentation=NO;     // default is YES
    

}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"subject CONTAINS [cd] %@", self.searchController.searchBar.text];
    NSArray *predicateResultArray;
    AppPreferences* app=[AppPreferences sharedAppPreferences];
    
    
    if ([self.searchController.searchBar.text isEqual:@""])
    {
        // FeedQueryCounter *ft2=[[FeedQueryCounter alloc]init];
        Mom* ft2=[Mom new];
        int i;
        app.sampleMOMArray=[[NSMutableArray alloc]init];
        for (i=0; i<app.allMomArray.count; i++)
        {
            ft2= [app.allMomArray objectAtIndex:i];
            //NSLog(@"%@",ft2.feedbackType);
            [app.sampleMOMArray insertObject:ft2 atIndex:i];
            
            [self.tableView reloadData];
        }
    }
    else
    {
        app.sampleMOMArray=[[NSMutableArray alloc]init];
        predicateResultArray=[[NSMutableArray alloc]init];
        predicateResultArray =[app.samplefMOMCopyForPredicate filteredArrayUsingPredicate:predicate];
        app.sampleMOMArray=[predicateResultArray mutableCopy];
        [self.tableView reloadData];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[[UIApplication sharedApplication].keyWindow viewWithTag:910] removeFromSuperview];

}
-(void)addMOMButton
{
    UIButton* addFeedbackButton=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+self.view.frame.size.width-50, self.view.frame.origin.y+self.view.frame.size.height-110, 40, 40)];
    [addFeedbackButton setBackgroundImage:[UIImage imageNamed:@"NewFeedbackOrQuery"] forState:UIControlStateNormal];
    addFeedbackButton.tag=910;
    [addFeedbackButton addTarget:self action:@selector(addNewMOMView) forControlEvents:UIControlEventTouchUpInside];
    [[UIApplication sharedApplication].keyWindow addSubview:addFeedbackButton];
    
}
//- (void)getLatestMOM:(NSNotification *)notificationData
//{
//    if ([[notificationData.object objectForKey:@"code"] isEqualToString:SUCCESS])
//    {
//        Database *db=[Database shareddatabase];
//        [db insertLatestRecordsForMOM:notificationData.object];
//        [db setMOMView];
//
//        
//        //hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//        //[hud hideAnimated:YES];
//    }
//}

-(void)popViewController1
{
    alertController = [UIAlertController alertControllerWithTitle:@"Logout?"
                                                          message:@"Are you sure to logout"
                                                   preferredStyle:UIAlertControllerStyleAlert];
    actionDelete = [UIAlertAction actionWithTitle:@"Yes"
                                            style:UIAlertActionStyleDefault
                                          handler:^(UIAlertAction * action)
                    {
                        [[AppPreferences sharedAppPreferences] logout];
                        NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
                        [defaults setObject:NULL forKey:@"userObject"];
                        [defaults setObject:NULL forKey:@"selectedCompany"];
                        UINavigationController *navController = self.navigationController;
                        UIViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
                        [navController presentViewController:vc animated:YES completion:nil];
                    }]; //You can use a block here to handle a press on this button
    [alertController addAction:actionDelete];
    
    
    actionCancel = [UIAlertAction actionWithTitle:@"Cancel"
                                            style:UIAlertActionStyleCancel
                                          handler:^(UIAlertAction * action)
                    {
                        [alertController dismissViewControllerAnimated:YES completion:nil];
                        
                    }]; //You can use a block here to handle a press on this button
    [alertController addAction:actionCancel];
    [self presentViewController:alertController animated:YES completion:nil];
    
   

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        AppPreferences* app=[AppPreferences sharedAppPreferences];
    //
   
    return app.sampleMOMArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    AppPreferences* app=[AppPreferences sharedAppPreferences];
    UILabel* subjectLabel=(UILabel*)[cell viewWithTag:10];
    UILabel* dateLabel=(UILabel*)[cell viewWithTag:11];

    UILabel* attendeeLabel=(UILabel*)[cell viewWithTag:12];
    UILabel* createdByLabel=(UILabel*)[cell viewWithTag:13];

    UILabel* dateTimeLabel=(UILabel*)[cell viewWithTag:14];
    UIImageView* starImageView=[cell viewWithTag:16];
    if (!(starImageView.image==NULL))
    {
        starImageView.image=NULL;
    }
    Mom* momObj= [app.sampleMOMArray objectAtIndex:indexPath.row];
    subjectLabel.text=momObj.subject;
    attendeeLabel.text=[NSString stringWithFormat:@"Attendees: %@",momObj.attendee];
    dateLabel.text=[NSString stringWithFormat:@"Date: %@",momObj.momDate];
   NSArray* dateTimeArray= [momObj.dateTime componentsSeparatedByString:@" "];
    dateTimeLabel.numberOfLines=2;
    dateTimeLabel.text=[NSString stringWithFormat:@"%@ \n %@",[dateTimeArray objectAtIndex:0],[dateTimeArray objectAtIndex:1]];

   NSString* name= [[Database shareddatabase] getFirstnameLastnameFromUserId:momObj.userfeedback];
    
    createdByLabel.text=[NSString stringWithFormat:@"Created by: %@",name];
    if (momObj.readStatus==1)
    {
        starImageView.image=[UIImage imageNamed:@"Star"];
    }
    // UILabel* soNoLabel=(UILabel*)[cell viewWithTag:12];
    // soNoLabel.text=@"So No";
       
    return cell;
    
}

- (IBAction)buttonClicked:(id)sender
{
//    UIViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateNewMOMViewController"];
//    
//    //[self.navigationController pushViewController:vc animated:YES];
//    [self.navigationController presentViewController:vc animated:YES completion:nil];
    
}
-(void)addNewMOMView
{
    UIViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateNewMOMViewController"];
    
    //[self.navigationController pushViewController:vc animated:YES];
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
//
//    MOMDetailTableViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MOMDetailTableViewController"];
//    
//    //[self.navigationController pushViewController:vc animated:YES];
//    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
//    UILabel* feedbackTypeLabel=(UILabel*)[selectedCell viewWithTag:12];
//[self.navigationController pushViewController:vc animated:YES];
////    [self.navigationController presentViewController:vc animated:YES completion:nil];
//    vc.momObj=[[AppPreferences sharedAppPreferences].sampleMOMArray objectAtIndex:indexPath.row];

    
    MomDetailViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MomDetailViewController"];
    
    //[self.navigationController pushViewController:vc animated:YES];
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    [self.navigationController pushViewController:vc animated:YES];
    //    [self.navigationController presentViewController:vc animated:YES completion:nil];
    vc.momObj=[[AppPreferences sharedAppPreferences].sampleMOMArray objectAtIndex:indexPath.row];


}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float endScrolling = scrollView.contentOffset.y + scrollView.frame.size.height;
    if (endScrolling >= scrollView.contentSize.height)
    {
        NSLog(@"Scroll End Called");
        [self refreshTable];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
