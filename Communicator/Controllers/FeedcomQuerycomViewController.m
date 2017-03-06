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
@synthesize results,searchController,feedTypeSONoArray,cerateNewFeedbackOrQueryButton,window,feedTypeSONoCopyForPredicate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    [self setSearchController];

    //view update after noti data
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

    //NSString* companyId=[[Database shareddatabase] getCompanyId:username];
    
    NSString* userFrom,*userTo;
    
//    if ([companyId isEqual:@"1"])
//    {
//        userFrom= [[Database shareddatabase] getAdminUserId];
//        
//        username=[[Database shareddatabase] getUserNameFromCompanyname:[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedCompany"]];
//        
//        userTo=[[Database shareddatabase] getUserIdFromUserNameWithRoll1:username];
//        
//    }
//    else
//    {
//        userTo=[[Database shareddatabase] getAdminUserId];
//        
//        userFrom= [[Database shareddatabase] getUserIdFromUserNameWithRoll1:username];
//    }
     userFrom= [[NSUserDefaults standardUserDefaults] valueForKey:@"userFrom"];
    
     userTo=[[NSUserDefaults standardUserDefaults] valueForKey:@"userTo"];
    
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
        else
        {
        feedIdsString=[NSMutableString stringWithFormat:@"%@,%@",feedIdsString,[feedbackIDsArray objectAtIndex:i]];
        }
     }
    
     NSString* username1 = [[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"];

     int feedbackType=  [[Database shareddatabase] getFeedbackIdFromFeedbackType:self.feedbackType];
    
     [[APIManager sharedManager] getNew50Records:username1 password:password userFrom:userFrom userTo:userTo feedbackType:feedbackType feedbackIdsArray:feedIdsString];

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

        self.navigationItem.title = self.feedbackType;

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
 NSPredicate *predicate3 = [NSPredicate predicateWithFormat:@"subject CONTAINS [cd] %@", self.searchController.searchBar.text];
        NSPredicate *mainPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[predicate1, predicate2,predicate3]];

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
    UILabel* avayaIdLabel=(UILabel*)[cell viewWithTag:85];
    UILabel* documentIdLabel=(UILabel*)[cell viewWithTag:86];
    avayaIdLabel.text=[NSString stringWithFormat:@"Avaya Id:%@",[separatedSO objectAtIndex:1]];
    documentIdLabel.text=[NSString stringWithFormat:@"Document Id:%@",[separatedSO objectAtIndex:2]];

    soNoLabel.text=[NSString stringWithFormat:@"SO No.: %@",[separatedSO objectAtIndex:0]];
//        soNoLabel.text=[NSString stringWithFormat:@"SO No.%@ \nAvaya Id:%@ \nDocument Id:%@",[separatedSO objectAtIndex:0],[separatedSO objectAtIndex:1],[separatedSO objectAtIndex:2]];
        UIWebView* feedTextWebView=(UIWebView*)[cell viewWithTag:15];
    //feedTextWebView.delegate=self;
    feedTextWebView.backgroundColor=[UIColor clearColor];
    [feedTextWebView setOpaque:NO];
    feedTextWebView.scrollView.scrollEnabled = NO;
    feedTextWebView.scrollView.bounces = NO;
//        NSString *feedBackString =  [self stringByStrippingHTML:headerObj1.feedText];
//        feedbackLabel.text= feedBackString;
        NSString *feedBackString =  [headerObj1.subject stringByDecodingHTMLEntities];
        [feedTextWebView loadHTMLString:feedBackString baseURL:nil];
        NSArray *components1 = [headerObj1.feedDate componentsSeparatedByString:@"+"];
        NSArray* dateAndTimeArray= [components1[0] componentsSeparatedByString:@" "];
        UILabel* createdByLabel=(UILabel*)[cell viewWithTag:13];
    
    //createdByLabel.text= [[AppPreferences sharedAppPreferences].initatedByClosedByArray objectAtIndex:indexPath.row];
        createdByLabel.text=    [NSString stringWithFormat:@"Init by: %@ %@",headerObj1.firstname,headerObj1.lastname];
    
   
        UILabel* dateAndTimeLabel=(UILabel*)[cell viewWithTag:16];
    dateAndTimeLabel.numberOfLines=2;
    dateAndTimeLabel.text=[NSString stringWithFormat:@"%@ %@",dateAndTimeArray[0],dateAndTimeArray[1]];


        UILabel* closedByLabel=(UILabel*)[cell viewWithTag:17];
    closedByLabel.text=    [NSString stringWithFormat:@"Closed by: %@ %@",headerObj1.firstname,headerObj1.lastname];

    UIImageView* imageView= [cell viewWithTag:212];
    if (imageView.image!=NULL)
    {
        imageView.image=NULL;
    }
//    UIImageView* readStatusImageView= [cell viewWithTag:211];
//    if (headerObj1.readStatus>1 || headerObj1.readStatus==1)
//    {
////        UIImageView* starImageView=[[UIImageView alloc]initWithFrame:readStatusImageView.frame];
////        starImageView.tag=212;
//        readStatusImageView.image=[UIImage imageNamed:@"Star"];
//        //[cell addSubview:starImageView];
//      //  NSLog(@"");
//
//    }
//    else
//    {
//        readStatusImageView.image=NULL;
//
//    }

   // NSArray *components1 = [headerObj1.feedDate componentsSeparatedByString:@"+"];
    //NSArray* dateAndTimeArray= [components1[0] componentsSeparatedByString:@" "];
    
    if (dateAndTimeArray.count>1)
    {
        dateAndTimeLabel.text=[NSString stringWithFormat:@"%@ %@",dateAndTimeArray[0],dateAndTimeArray[1]];
        
    }
    
    createdByLabel.text=[NSString stringWithFormat:@"Init. by: %@ %@",headerObj1.firstname,headerObj1.lastname];
    
    //to show is message came today?
    NSString* todaysDateAndTime=  [[APIManager sharedManager] getDate];
    
    NSArray* todaysDateAndTimeArray=[todaysDateAndTime componentsSeparatedByString:@" "];
    
    NSString* todaysDate =[todaysDateAndTimeArray objectAtIndex:0];
    
    NSString* messageDate=dateAndTimeArray[0];
    
    //to show message came yesterday
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormatter dateFromString:todaysDate];
    NSDate *dateFromString1 = [[NSDate alloc] init];
    dateFromString1 = [dateFormatter dateFromString:messageDate];
    
    CGFloat minuteDifference = [dateFromString timeIntervalSinceDate:dateFromString1] / 60.0;
    
    if (minuteDifference>1439 && minuteDifference<2880)
    {
        dateAndTimeLabel.text=[NSString stringWithFormat:@"Yesterday %@",dateAndTimeArray[1]];
        
    }
    
    if (minuteDifference==0)
    {
        dateAndTimeLabel.text=[NSString stringWithFormat:@"Today %@",dateAndTimeArray[1]];
    }
    
    UIView* circleReferenceview=[cell viewWithTag:500];
    
    UILabel* messageCountLabel=[circleReferenceview viewWithTag:501];
    if (!circleReferenceview.isHidden)
    {
        [circleReferenceview setHidden:YES];
    }
    
    if (headerObj1.readStatus>1 ||headerObj1.readStatus==1)
    {
        circleReferenceview.layer.cornerRadius = 18 / 2.0;
        messageCountLabel.text=[NSString stringWithFormat:@"%d",headerObj1.readStatus];
        
        dateAndTimeLabel.textColor=[UIColor colorWithRed:52/255.0 green:175/255.0 blue:35/255.0 alpha:1];
        circleReferenceview.backgroundColor=[UIColor colorWithRed:52/255.0 green:175/255.0 blue:35/255.0 alpha:1];
        
        [circleReferenceview setHidden:NO];
    }
    else
    {
        dateAndTimeLabel.textColor=[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
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
    return 100;
    
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
