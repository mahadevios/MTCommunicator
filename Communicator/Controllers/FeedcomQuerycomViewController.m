//
//  FeedbackDetailViewController.m
//  Communicator
//
//  Created by mac on 29/03/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import "FeedcomQuerycomViewController.h"
#import "FeedOrQueryMessageHeader.h"
#import "HomeViewController.h"
#import "CreateNewFeedbackViewController.h"
#import "NSString+HTML.h"
#import "GTMNSString+HTML.h"


@interface FeedcomQuerycomViewController ()

@property (strong, nonatomic) UISearchController *searchController;
@property (nonatomic, strong) NSArray *search;
@property(nonatomic, weak) id< UISearchControllerDelegate > delegate;


@end

@implementation FeedcomQuerycomViewController
@synthesize results;
@synthesize searchController;
@synthesize feedTypeSONoArray;
@synthesize feedTypeSONoCopyForPredicate;
@synthesize cerateNewFeedbackOrQueryButton;
@synthesize window;
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [self setSearchController];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(reloadData) name:NOTIFICATION_UPDATE_TABLEVIEW
//                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadData) name:NOTIFICATION_NEW_DATA_UPDATE
                                               object:nil];
    //for web service response of load more data
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(insertNewData:) name:NOTIFICATION_50_NEW_FEEDBACK_RECORDS
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addFeedbackButton) name:NOTIFICATION_ADD_FEEDBACK_BUTTON
                                               object:nil];
    refreshControl = [[UIRefreshControl alloc]init];
    refreshControl.tag=1000;
    [self.tableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];

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
    
   NSMutableArray* feedbackIDsArray= [[Database shareddatabase] getFeedbackIDs:self.feedbackType userFrom:userFrom userTo:userTo];
    NSMutableString* feedIdsString;
    
    if (feedbackIDsArray.count==0)
    {
        feedIdsString=[@"1" mutableCopy];
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

  int feedbackType=  [[Database shareddatabase] getFeedbackIdFromFeedbackType:self.feedbackType];
    [[APIManager sharedManager] getNew50Records:username1 password:password userFrom:userFrom userTo:userTo feedbackType:feedbackType feedbackIdsArray:feedIdsString];
  // self.loading=false;

    [self.tableView reloadData];
}

-(void)insertNewData:(NSNotification*)dict
{
    [[Database shareddatabase] getLoadMoreData:dict.object];

    [refreshControl endRefreshing];
   // [[self.view viewWithTag:1000] removeFromSuperview];
}
-(void)setSearchController
{
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    searchController.searchResultsUpdater = self;
    searchController.searchBar.delegate = self;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES;
    self.searchController.obscuresBackgroundDuringPresentation = NO;
    self.searchController.hidesNavigationBarDuringPresentation=NO;
    self.definesPresentationContext = YES;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    [self setNavigationBar];
    [self prepareForSearchBar];
    [self addFeedbackButton];
     [[Database shareddatabase] getInitiatedByClosedBy:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentFeedbackType"]];
       //[self.view bringSubviewToFront:addFeedbackButton];

//    [[Database shareddatabase] setDatabaseToCompressAndShowTotalQueryOrFeedback:self.feedbackType];
//    [self.tableView reloadData];
//
//    UIWindow *window2 = [[UIWindow alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-60, self.view.bounds.size.height-100, 50, 50)];
//    window2.backgroundColor = [UIColor redColor];
//    window2.windowLevel = UIWindowLevelAlert;
//    self.window = window2;
//    [window2 makeKeyAndVisible];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [[[UIApplication sharedApplication].keyWindow viewWithTag:901] removeFromSuperview];
}

-(void)addFeedbackButton
{
    UIButton* addFeedbackButton=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+self.view.frame.size.width-50, self.view.frame.origin.y+self.view.frame.size.height-110, 40, 40)];
    [addFeedbackButton setBackgroundImage:[UIImage imageNamed:@"NewFeedbackOrQuery"] forState:UIControlStateNormal];
    addFeedbackButton.tag=901;
    [addFeedbackButton addTarget:self action:@selector(addNewFeedbackView) forControlEvents:UIControlEventTouchUpInside];
    [[UIApplication sharedApplication].keyWindow addSubview:addFeedbackButton];

}

-(void)reloadData
{
     [[Database shareddatabase] getInitiatedByClosedBy:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentFeedbackType"]];
    [[Database shareddatabase] setDatabaseToCompressAndShowTotalQueryOrFeedback:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentFeedbackType"]];

     [self prepareForSearchBar];
    [self.tableView reloadData];
}
//-(void)reloadDataFor
-(void)setNavigationBar
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BackArrow"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController)] ;
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem.tintColor=[UIColor whiteColor];
   // Database *db=[Database shareddatabase];
    //NSString* username = [[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"];
   // NSString* companyId=[db getCompanyId:username];
//    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"flag"] isEqual:@"0"])
//    {
        self.navigationItem.title = self.feedbackType;
   // }
//    
//    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"flag"] isEqual:@"1"])
//    {
//        self.tabBarController.navigationItem.title = @"QueryCom";
//    }
//    
//    if ([companyId isEqual:@"1"] && [[[NSUserDefaults standardUserDefaults] valueForKey:@"flag"] isEqual:@"0"])
//    {
//        [cerateNewFeedbackOrQueryButton setHidden:YES];
//    }
//    else
//    {
//        if (!([companyId isEqual:@"1"]) && [[[NSUserDefaults standardUserDefaults] valueForKey:@"flag"] isEqual:@"1"])
//        {
//            [cerateNewFeedbackOrQueryButton setHidden:YES];
//        }
//        else
//        [cerateNewFeedbackOrQueryButton setHidden:NO];
//    }

}

-(void)prepareForSearchBar
{
    arrayOfSeperatedSOArray=[[NSMutableArray alloc]init];
    AppPreferences* app=[AppPreferences sharedAppPreferences];
    feedTypeSONoArray=[[NSMutableArray alloc]init];
    feedTypeSONoCopyForPredicate=[[NSMutableArray alloc]init];
    for (int i=0; i<app.feedQueryMessageHeaderArray.count; i++)
    {
        FeedOrQueryMessageHeader *headerObj=[app.feedQueryMessageHeaderArray objectAtIndex:i];
        [feedTypeSONoArray addObject:headerObj];
        [feedTypeSONoCopyForPredicate addObject:headerObj];
    }
    
}
-(void)popViewController
{

    [self.navigationController popViewControllerAnimated:YES];
}


- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    if ([self.searchController.searchBar.text isEqual:@""])
    {
        FeedOrQueryMessageHeader *Obj1=[[FeedOrQueryMessageHeader alloc]init];
        int i,j;
        feedTypeSONoArray=[[NSMutableArray alloc]init];
        for (i=0,j=0; i<feedTypeSONoCopyForPredicate.count; i++,j=j+2)
        {
            Obj1= [feedTypeSONoCopyForPredicate objectAtIndex:i];
            [feedTypeSONoArray insertObject:Obj1 atIndex:i];
            [self.tableView reloadData];
        }
    }
    else
    {
        feedTypeSONoArray=[[NSMutableArray alloc]init];
        NSArray *predicateResultArray =[[NSMutableArray alloc]init];
        
        NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"soNumber CONTAINS [cd] %@", self.searchController.searchBar.text];
        NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"feedText CONTAINS [cd] %@", self.searchController.searchBar.text];

        NSPredicate *mainPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[predicate1, predicate2]];

        predicateResultArray =[feedTypeSONoCopyForPredicate filteredArrayUsingPredicate:mainPredicate];
        
        feedTypeSONoArray= [NSMutableArray arrayWithArray:predicateResultArray];
        [self.tableView reloadData];
    }
}

#pragma mark - table view data source and delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return feedTypeSONoArray.count;
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return NULL;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        FeedOrQueryMessageHeader *headerObj1=[feedTypeSONoArray objectAtIndex:indexPath.row];
        NSString* soNumber= headerObj1.soNumber;
        NSArray* separatedSO=[soNumber componentsSeparatedByString:@"#@"];
        UILabel* soNoLabel=(UILabel*)[cell viewWithTag:12];
        soNoLabel.text=[NSString stringWithFormat:@"SO No.%@ \nAvaya Id:%@ \nDocument Id:%@",[separatedSO objectAtIndex:0],[separatedSO objectAtIndex:1],[separatedSO objectAtIndex:2]];
        UIWebView* feedTextWebView=(UIWebView*)[cell viewWithTag:15];
    //feedTextWebView.delegate=self;
    feedTextWebView.backgroundColor=[UIColor clearColor];
    [feedTextWebView setOpaque:NO];
    feedTextWebView.scrollView.scrollEnabled = NO;
    feedTextWebView.scrollView.bounces = NO;
//        NSString *feedBackString =  [self stringByStrippingHTML:headerObj1.feedText];
//        feedbackLabel.text= feedBackString;
        NSString *feedBackString =  [headerObj1.feedText stringByDecodingHTMLEntities];
        [feedTextWebView loadHTMLString:feedBackString baseURL:nil];
        NSArray *components1 = [headerObj1.feedDate componentsSeparatedByString:@"+"];
        NSArray* dateAndTimeArray= [components1[0] componentsSeparatedByString:@" "];
        UILabel* createdByLabel=(UILabel*)[cell viewWithTag:13];
    
    //createdByLabel.text= [[AppPreferences sharedAppPreferences].initatedByClosedByArray objectAtIndex:indexPath.row];
        createdByLabel.text=    [NSString stringWithFormat:@"Initiated by: %@ %@",headerObj1.firstname,headerObj1.lastname];
    
   
        UILabel* dateAndTimeLabel=(UILabel*)[cell viewWithTag:16];
    dateAndTimeLabel.numberOfLines=2;
    dateAndTimeLabel.text=[NSString stringWithFormat:@"%@\n%@",dateAndTimeArray[0],dateAndTimeArray[1]];


        UILabel* closedByLabel=(UILabel*)[cell viewWithTag:17];
    closedByLabel.text=    [NSString stringWithFormat:@"Closed by: %@ %@",headerObj1.firstname,headerObj1.lastname];

    UIImageView* imageView= [cell viewWithTag:212];
    if (imageView.image!=NULL)
    {
        imageView.image=NULL;
    }
    UIImageView* readStatusImageView= [cell viewWithTag:211];
    if (headerObj1.readStatus>1 || headerObj1.readStatus==1)
    {
//        UIImageView* starImageView=[[UIImageView alloc]initWithFrame:readStatusImageView.frame];
//        starImageView.tag=212;
        readStatusImageView.image=[UIImage imageNamed:@"Star"];
        //[cell addSubview:starImageView];
      //  NSLog(@"");

    }
    else
    {
        readStatusImageView.image=NULL;

    }

    if (headerObj1.statusId==2)
    {
       // closedByLabel.text=[NSString stringWithFormat:@"Closed by: %@ %@",headerObj1.firstname,headerObj1.lastname];
        //Database* db=[Database shareddatabase];
      // NSString* firstNameLastName =[db getClosedByUserName:headerObj1.feedbackType andsoNumber:headerObj1.soNumber];
    }
    else
        closedByLabel.text=@"";
  
    
        return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Database *db=[Database shareddatabase];

    FeedOrQueryMessageHeader *headerObj1=[feedTypeSONoArray objectAtIndex:indexPath.row];
    int feedType=headerObj1.feedbackType;
    NSString* SONumber=headerObj1.soNumber;
    
    [db getDetailMessagesofFeedbackOrQuery:feedType :SONumber];
    
   UIViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailChatingViewController"];
 //   UIViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TestViewController"];
    
   [self presentViewController:vc animated:YES completion:nil];

}

-(NSString *) stringByStrippingHTML:(NSString *) stringWithHtmlTags
{
    NSRange r;
    while ((r = [stringWithHtmlTags rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        stringWithHtmlTags = [stringWithHtmlTags stringByReplacingCharactersInRange:r withString:@""];
    return stringWithHtmlTags;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (IBAction)buttonClicked:(id)sender
{
//    CreateNewFeedbackViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateNewFeedbackViewController"];
//   // NSArray* arr=   vc.childViewControllers;
//    //CreateNewFeedbackViewController* vcc=   [arr objectAtIndex:0];
//    vc.feedbackType=self.feedbackType;
//    [self.navigationController presentViewController:vc animated:YES completion:nil];
    [self addNewFeedbackView];
}

-(void)addNewFeedbackView
{
    CreateNewFeedbackViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateNewFeedbackViewController"];
    // NSArray* arr=   vc.childViewControllers;
    //CreateNewFeedbackViewController* vcc=   [arr objectAtIndex:0];
    vc.feedbackType=self.feedbackType;
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    //CGSize size = [UIScreen mainScreen].bounds.size;
   // NSLog(@"width=%f height=%f",size.width,size.height);
    //UIInterfaceOrientationPortrait
// if(fromInterfaceOrientation ==UIInterfaceOrientationPortrait)
//    {
//        UIWindow *window2 = [[UIWindow alloc] initWithFrame:CGRectMake(size.width-60, size.height-100, 50, 50)];
//        window2.backgroundColor = [UIColor redColor];
//        window2.windowLevel = UIWindowLevelAlert;
//        window2.hidden=NO;
//        self.window = window2;
//        [window2 makeKeyAndVisible];
//
//    }
   }
//- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
//{
//    CGPoint offset = aScrollView.contentOffset;
//    CGRect bounds = aScrollView.bounds;
//    CGSize size = aScrollView.contentSize;
//    UIEdgeInsets inset = aScrollView.contentInset;
//    float y = offset.y + bounds.size.height - inset.bottom;
//    float h = size.height;
//    // NSLog(@"offset: %f", offset.y);
//    // NSLog(@"content.height: %f", size.height);
//    // NSLog(@"bounds.height: %f", bounds.size.height);
//    // NSLog(@"inset.top: %f", inset.top);
//    // NSLog(@"inset.bottom: %f", inset.bottom);
//    // NSLog(@"pos: %f of %f", y, h);
//    
//    float reload_distance = 10;
//    if(y > h + reload_distance)
//    {
//        if (!self.loading)
//        {
//           self.loading=true;
//            [self refreshTable];
//            NSLog(@"load more rows");
//
//        }
//    }
//}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float endScrolling = scrollView.contentOffset.y + scrollView.frame.size.height;
    if (endScrolling >= scrollView.contentSize.height)
    {
        NSLog(@"Scroll End Called");
        [self refreshTable];
    
    }
}
@end
