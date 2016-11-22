////
////  DetailChatingViewController.m
////  Communicator
////
////  Created by mac on 26/05/16.
////  Copyright © 2016 Xanadutec. All rights reserved.
////
//
//#import "DetailChatingViewController.h"
//#import "FeedcomQuerycomViewController.h"
//#import "FeedbackChatingCounter.h"
//#import "QueryChatingCounter.h"
//#import "Database.h"
//#import "Feedback.h"
//#import <MobileCoreServices/MobileCoreServices.h>
//#import "CounterGraph.h"
//#import "MBProgressHUD.h"
//#include <CFNetwork/CFNetwork.h>
//#import "NetworkManager.h"
//#import "NSString+HTML.h"
//#import "GTMNSString+HTML.h"
//#import "PopUpCustomView.h"
//enum {
//    kSendBufferSize = 32768
//};
//@interface DetailChatingViewController ()
//
//@end
//
//@implementation DetailChatingViewController
//@synthesize tableview;
//@synthesize sendTextView;
//@synthesize hud,historyFlag;
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillShow:)
//                                                 name:UIKeyboardWillShowNotification
//                                               object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillHide:)
//                                                 name:UIKeyboardWillHideNotification
//                                               object:nil];
//    sendTextView.delegate=self;
//    
//    refreshControl = [[UIRefreshControl alloc]init];
//    refreshControl.tag=1000;
//    [self.tableview addSubview:refreshControl];
//    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
//    [self preferredStatusBarStyle];
//    self.cellSelected=[NSMutableArray new];
//
//    // Do any additional setup after loading the view.
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(insertLoadMoreData:) name:NOTIFICATION_GET_ALL_MSGS_LOAD_MORE_DATA
//                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(reloadData) name:NOTIFICATION_NEW_DATA_UPDATE
//                                               object:nil];
//    
//    UIView* navigationView=[self.view viewWithTag:1001];
//    NSString* currentFeedbackType= [[NSUserDefaults standardUserDefaults] valueForKey:@"currentFeedbackType"];
//
//    UILabel* navigationTitleLabel=[navigationView viewWithTag:444];
//    navigationTitleLabel.text=[NSString stringWithFormat:@"%@/Feedback Communication",currentFeedbackType];
//    heightArray=[[NSMutableArray alloc] init];
//    
//    
//    for (int i=0; i<[AppPreferences sharedAppPreferences].FeedbackOrQueryDetailChatingObjectsArray.count; i++)
//    {
//        [heightArray addObject:[NSString stringWithFormat:@"%d",40]];
//    }
//}
//
//#pragma mark:UI
//
//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:YES];
//    [[self.view viewWithTag:2001] setHidden:YES];
//
//    [[self.view viewWithTag:2001] setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.2]];
//
//    //[self setNavigationItems:@"Close"];
//    [self setHeaderForTableView];
//    
//    sendTextView.layer.cornerRadius=4.0f;
//    sendTextView.layer.borderColor=[UIColor grayColor].CGColor;
//    sendTextView.layer.borderWidth=1.0f;
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(getLatestRecord:) name:NOTIFICATION_SEND_UPDATED_RECORDS
//                                               object:nil];
//    [tableview reloadData];
//    long lastRowNumber = [tableview numberOfRowsInSection:0] - 1;
//    NSIndexPath* ip = [NSIndexPath indexPathForRow:lastRowNumber inSection:0];
//    [tableview scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:NO];
//    FeedbackChatingCounter* feedObject= [app.FeedbackOrQueryDetailChatingObjectsArray objectAtIndex:0];
//    [[Database shareddatabase] updateReadStatus:feedObject.soNumber feedbackType:[NSString stringWithFormat:@"%d",feedObject.feedbackType]];
//    
//    historyFlag=2;
//    
////    sendTextView.text = @"Reply";
////    sendTextView.textColor = [UIColor lightGrayColor];
////    sendTextView.delegate = self;
//
//    //to update previous view
//    //    [[Database shareddatabase] setDatabaseToCompressAndShowTotalQueryOrFeedback:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentFeedbackType"]];
//    // [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPDATE_TABLEVIEW object:nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_NEW_DATA_UPDATE object:nil];//messages read,now update prev 2 views
//    
//}
//
//-(void)setHeaderForTableView
//{
//    sendTextView.delegate=self;
//    UILabel* subjectLabel=(UILabel*)[self.view viewWithTag:100];
//    UILabel* SONumberLabel=(UILabel*)[self.view viewWithTag:101];
//    UILabel* dateOfFeedLabel=(UILabel*)[self.view viewWithTag:102];
//    
//    app=[AppPreferences sharedAppPreferences];
//    NSArray* separatedSO=[[NSMutableArray alloc]init];
//    FeedbackChatingCounter *allMessageObj=[app.FeedbackOrQueryDetailChatingObjectsArray lastObject];
//    //-----------setSubject---------//
//    subjectLabel.text=allMessageObj.emailSubject;
//    
//    //------setSONumber----------------//
//    NSString* soNumber= allMessageObj.soNumber;
//    separatedSO=[soNumber componentsSeparatedByString:@"#@"];
//    NSString* soNumr=[separatedSO objectAtIndex:0];
//    NSString* avaya=[separatedSO objectAtIndex:1];
//    NSString* Doc=[separatedSO objectAtIndex:2];
//    
//    SONumberLabel.text=[NSString stringWithFormat:@"SO No:%@\nAvaya Id:%@\nDocument Id:%@",soNumr,avaya,Doc];
//    
//    //------setDate----------------//
//    
//    NSString* dd=allMessageObj.dateOfFeed;
//    NSArray *components = [dd componentsSeparatedByString:@" "];
//    NSString *date = components[0];
//    NSString *time = components[1];
//    
//    dateOfFeedLabel.text=[NSString stringWithFormat:@"%@\n%@",date,time];
//    
//}
//
//#pragma mark:Data insertion and reload
//
////pull down to fetch data from server
//-(void)refreshTable
//{
//   NSString* userFrom= [[NSUserDefaults standardUserDefaults] valueForKey:@"userFrom"];
//  NSString* userTo=   [[NSUserDefaults standardUserDefaults] valueForKey:@"userTo"];
//    FeedbackChatingCounter* feedObject= [app.FeedbackOrQueryDetailChatingObjectsArray objectAtIndex:0];
//    if (feedObject!=NULL)
//    {
//         [[APIManager sharedManager] getNotificationLoadMoreDataForUsername:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"]  andPassword:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentPassword"] SONumber:feedObject.soNumber feedbackType:[NSString stringWithFormat:@"%d",feedObject.feedbackType] userFrom:userFrom userTo:userTo] ;
//    }
//
//}
//
////reload data from DB after getting notified
//-(void)reloadData
//{
//    FeedbackChatingCounter* feedObject= [app.FeedbackOrQueryDetailChatingObjectsArray lastObject];
//
//    if (feedObject.statusId==2)
//    {
//        [self.view viewWithTag:202].userInteractionEnabled=NO;
//        UILabel* statusLabel= [self.view viewWithTag:201];
//        statusLabel.textColor=[UIColor redColor];
//        statusLabel.text=@"Closed";
//    }
//    
//   
//    [[Database shareddatabase] getDetailMessagesofFeedbackOrQuery:feedObject.feedbackType :feedObject.soNumber];
//    
//    heightArray=nil;
//    heightArray=[[NSMutableArray alloc] init];
//    
//    
//    for (int i=0; i<[AppPreferences sharedAppPreferences].FeedbackOrQueryDetailChatingObjectsArray.count; i++)
//    {
//        [heightArray addObject:[NSString stringWithFormat:@"%d",40]];
//    }
//    [refreshControl endRefreshing];
//    sendTextView.text=nil;
//    [self.tableview reloadData];
//}
//
////insert fetched data into db after getting response
//-(void)insertLoadMoreData:(NSNotification*)data
//{
//    [[Database shareddatabase] insertFeedcomNotifiationData:data.object readStatusflag:false];
//
//}
//
//#pragma mark:TableView bottom position
//
////to go at bottom of tableview
//- (void)keyboardWillShow:(NSNotification *)notification
//{
//    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//    
//    UIEdgeInsets contentInsets;
//    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
//        contentInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize.height), 0.0);
//    } else {
//        contentInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize.width), 0.0);
//    }
//    
//    tableview.contentInset = contentInsets;
//    tableview.scrollIndicatorInsets = contentInsets;
//    //[tableview scrollToRowAtIndexPath:self.editingIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
//    
//    long lastRowNumber = [tableview numberOfRowsInSection:0] - 1;
//    NSIndexPath* ip = [NSIndexPath indexPathForRow:lastRowNumber inSection:0];
//    [tableview scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:NO];
//
//}
//
//- (void)keyboardWillHide:(NSNotification *)notification
//{
//    tableview.contentInset = UIEdgeInsetsZero;
//    tableview.scrollIndicatorInsets = UIEdgeInsetsZero;
//}
//
////-(void)setNavigationItems:(NSString*)rightBarItemTitle
////{
////    self.navigationItem.title = @"Feedback communication";
////    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BackArrow"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController)] ;
////    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:rightBarItemTitle style:UIBarButtonItemStylePlain target:self action:@selector(closeIssue)];
////    self.navigationItem.rightBarButtonItem.tintColor=[UIColor whiteColor];
////    self.navigationItem.leftBarButtonItem.tintColor=[UIColor whiteColor];
////    [self preferredStatusBarStyle];
////
////}
//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//}
//
//-(void)popViewController
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}
//
//#pragma mark:close issue
////-(void)closeIssue
////{
////           UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Close Issue?"
////                                                                                 message:@"Are you sure to close this issue"
////                                                                          preferredStyle:UIAlertControllerStyleAlert];
////        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
////                                                           style:UIAlertActionStyleDefault
////                                                         handler:^(UIAlertAction * action)
////                                   {
////                                       //[self closeIssueConfirmed];
////                                       
////                                   }];
////    
////    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Cancel"
////                                                       style:UIAlertActionStyleDefault
////                                                         handler:nil];
////        [alertController addAction:actionOk];
////        [alertController addAction:actionCancel];
////
////        [self presentViewController:alertController animated:YES completion:nil];
////  
////}
//
////-(void)closeIssueConfirmed
////{
////    NSString* userFrom,* userTo;
////
////    Database* db=[Database shareddatabase];
////    FeedbackChatingCounter* feedObject= [app.FeedbackOrQueryDetailChatingObjectsArray objectAtIndex:0];
////    
////    NSString* username = [[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"];
////    NSString* companyId=[db getCompanyId:username];
////    NSString* userFeedback=[db getUserIdFromUserName:username];
////    NSMutableArray* maxFeedIdAndCounterArray=[db getMaxFeedIdAndCounter:feedObject.soNumber :feedObject.feedbackType];
////    if ([companyId isEqual:@"1"])
////    {
////        userFrom=[[Database shareddatabase] getAdminUserId];
////        username=[db getUserNameFromCompanyname:[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedCompany"]];
////        userTo=[db getUserIdFromUserNameWithRoll1:username];
////        
////    }
////    
////    else
////    {
////        userTo=[[Database shareddatabase] getAdminUserId];
////        userFrom= [db getUserIdFromUserNameWithRoll1:username];
////    }
////    
////    Feedback* feedObj=[[Feedback alloc]init];
////    feedObj.soNumber = feedObject.soNumber;
////    feedObj.emailSubject = feedObject.emailSubject;
////    feedObj.feedbackType = feedObject.feedbackType;
////    feedObj.userFrom=[userFrom intValue];
////    feedObj.userTo=[userTo intValue];
////    feedObj.userFeedback=[userFeedback intValue];
////    feedObj.feedbackText = sendTextView.text;
////    feedObj.dateOfFeed=[[APIManager sharedManager] getDate];
////    feedObj.feedbackText=@"Issue closed";
////    feedObj.feedbackCounter=[[NSString stringWithFormat:@"%@",[maxFeedIdAndCounterArray objectAtIndex:1]]intValue];
////    feedObj.feedbackId=[[NSString stringWithFormat:@"%@",[maxFeedIdAndCounterArray objectAtIndex:0]]intValue];
////    feedObj.attachment=@"";
////
////   
////    feedObj.statusId=[[NSString stringWithFormat:@"%@",[maxFeedIdAndCounterArray objectAtIndex:2]]intValue];
////    feedObj.operatorId=[[NSString stringWithFormat:@"%@",[maxFeedIdAndCounterArray objectAtIndex:3]]intValue];
////    
////    NSArray* keys=[NSArray arrayWithObjects:@"soNumber",@"userFrom",@"userTo",@"userFeedback",@"feedText",@"feedbackType",@"statusId",@"operatorId",@"emailSubject",@"attachment", nil];
////    
////    
////    NSArray* values=@[feedObj.soNumber,[NSString stringWithFormat:@"%d",feedObj.userFrom],[NSString stringWithFormat:@"%d",feedObj.userTo],[NSString stringWithFormat:@"%d",feedObj.userFeedback],feedObj.feedbackText,[NSString stringWithFormat:@"%d",feedObj.feedbackType],[NSString stringWithFormat:@"%d",2],[NSString stringWithFormat:@"%d",feedObj.operatorId],feedObj.emailSubject,feedObj.attachment];
////    
////    NSDictionary* dic=[NSDictionary dictionaryWithObjects:values forKeys:keys];
////    
////    
////    
////    
////    
////    
////    [[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"];
////    [[NSUserDefaults standardUserDefaults] valueForKey:@"currentPassword"];
////    
////    
////    
////    [[APIManager sharedManager] sendUpdatedRecords:[[NSUserDefaults standardUserDefaults] valueForKey:@"flag"] Dict:dic username:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"] password:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentPassword"]];
////}
//
//
////get latest records and insert in db after sending our text
//- (void)getLatestRecord:(NSNotification *)notificationData
//{
//    if ([[notificationData.object objectForKey:@"code"] isEqualToString:SUCCESS])
//    {
//        Database *db=[Database shareddatabase];
//        //AppPreferences *app=[AppPreferences sharedAppPreferences];
//        FeedbackChatingCounter* feedObject= [app.FeedbackOrQueryDetailChatingObjectsArray objectAtIndex:0];
//        
////        NSString* str=[[NSUserDefaults standardUserDefaults] valueForKey:@"flag"] ;
////        if ([str isEqualToString:@"0"])
////        {
//            [db insertUpdatedRecordsForFeedcom:notificationData.object];                          //insert response date
//            [db getDetailMessagesofFeedbackOrQuery:feedObject.feedbackType :feedObject.soNumber]; //fetch updated data after inserting response data
////            sendTextView.text=@"";
//        
//        feedObject= [app.FeedbackOrQueryDetailChatingObjectsArray lastObject];
//        
//        if (feedObject.statusId==2)
//        {
//            [self.view viewWithTag:202].userInteractionEnabled=NO;
//            UILabel* statusLabel= [self.view viewWithTag:201];
//            statusLabel.textColor=[UIColor redColor];
//
//            statusLabel.text=@"Closed";
//        }
//        [self keyboardWillShow:nil];
//
//           // [tableview reloadData];
////        }
////        else
////        {
////            [db insertUpdatedRecordsForQueryCom:notificationData.object];
////            [db getDetailMessagesofFeedbackOrQuery:feedObject.feedbackType :feedObject.soNumber];
////            sendFeedbackTextfield.text=@"";
////
////            [tableview reloadData];
////         }
//    
//        
//    }
//}
//
//
//#pragma mark:tableView delegates
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
//
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    if (tableView==tableview)
//    {
//        return app.FeedbackOrQueryDetailChatingObjectsArray.count;
//
//    }
//    else
//    {
//        Database* db=[Database shareddatabase];
//        NSString* username = [[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"];
//        NSString* companyId=[[Database shareddatabase] getCompanyId:username];
//        NSString* companyId1;
//        NSString* selectedCompany;
//        if ([companyId isEqual:@"1"])
//        {
//            selectedCompany= [[NSUserDefaults standardUserDefaults] valueForKey:@"selectedCompany"];
//            companyId1= [[Database shareddatabase] getCompanyIdFromCompanyName1:selectedCompany];
//        }
//        else
//        {
//            companyId1=@"1";
//        }
//        
//        //NSString* companyId= [db getCompanyId:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentUsername"]];
//        userObjectsArray= [db getAllUsersFirstnameLastname:companyId company2:companyId1];
//        
//        
//        return userObjectsArray.count;
//
//    }
//}
//
////- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
////{
////    if (tableView==self.popupTableView)
////    {
////    
////    UIView* sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,self.popupTableView.frame.size.width,50)];
////    sectionView.backgroundColor=[UIColor grayColor];
////    
////    UISwitch* historySwitch=[[UISwitch alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
////    
////    //    setAttendeeList
////    UILabel* historyLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.popupTableView.frame.size.width/2, 10, self.popupTableView.frame.size.width/2, 20)];
////historyLabel.text=@"Without history";
////    [sectionView addSubview:historySwitch];
////    [sectionView addSubview:historyLabel];
////
////    //UILabel *fileCountLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.tableView.frame.size.width-60, 5, 50, 40)];
////    return  sectionView;
////    }
////    else
////    {
////        return nil;
////    }
////    
////}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    if (tableView==self.tableview)
//    {
//    
//    //UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
//    //    [cell1 setHidden:YES];
//     // UILabel* attachmentLabel=  [cell1 viewWithTag:53];
//    //    UILabel* weVLabel=  [cell1 viewWithTag:51];
//
//        UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, tableview.frame.size.width, tableview.frame.size.height)];
//        UILabel* nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 5, tableview.frame.size.width/2, 10)];
//        [nameLabel setFont:[UIFont systemFontOfSize:13]];
//        UILabel* dateLabel=[[UILabel alloc] initWithFrame:CGRectMake(tableview.frame.size.width/2, 5, tableview.frame.size.width/2, 10)];
//        
//        [dateLabel setTextAlignment:NSTextAlignmentRight];
//        [dateLabel setFont:[UIFont systemFontOfSize:13]];
//
//        UILabel* attachmentLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, nameLabel.frame.origin.y+nameLabel.frame.size.height+10, tableview.frame.size.width/2, 10)];
//    FeedbackChatingCounter* feedObject= [app.FeedbackOrQueryDetailChatingObjectsArray objectAtIndex:indexPath.row];
//
//        UIWebView* feedTextWebView=[[UIWebView alloc] initWithFrame:CGRectMake(0, attachmentLabel.frame.origin.y+attachmentLabel.frame.size.height+10, tableview.frame.size.width, 12)];
//
//        
//    Database* db=[Database shareddatabase];
//    NSString* userRole=[db getUserIdFromUserNameWithRoll1:feedObject.userTo];
//    if (cell!=nil)
//    {
//        cell.contentView.backgroundColor=[UIColor grayColor];
//        if ([userRole isEqualToString:@"1"])
//        {
//            cell.contentView.backgroundColor=[UIColor colorWithRed:202.0/255 green:229.0/255 blue:159.0/255 alpha:1];
//            
//        }
//    }
//    
//    if (feedObject.statusId==2)
//    {
//        //[self setNavigationItems:@""];
//    }
//    //UILabel* userName= (UILabel*)[cell viewWithTag:50];
//    nameLabel.text=feedObject.userFrom;
//    
////    UILabel* feedText= (UILabel*)[cell viewWithTag:51];
////    UIWebView* feedTextWebView1= (UIWebView*)[cell viewWithTag:51];
////   UIWebView* feedTextWebView= [[UIWebView alloc]initWithFrame:CGRectMake(feedTextWebView1.frame.origin.x, feedTextWebView1.frame.origin.y, feedTextWebView1.frame.size.width, feedTextWebView1.frame.size.height)];
////    
////    //feedTextWebView.frame=feedTextWebView.frame;
////    feedTextWebView1.delegate=self;
////    feedTextWebView1.backgroundColor=[UIColor clearColor];
////    [feedTextWebView1 setOpaque:NO];
////    feedTextWebView1.scrollView.scrollEnabled = NO;
////    feedTextWebView1.scrollView.bounces = NO;
////        feedTextWebView1.scrollView.delegate=self;
////
//        [feedTextWebView.scrollView setShowsVerticalScrollIndicator:NO];
//
//    feedTextWebView.delegate=self;
//        feedTextWebView.scrollView.delegate=self;
//    feedTextWebView.backgroundColor=[UIColor clearColor];
//    [feedTextWebView setOpaque:NO];
//        feedTextWebView.scrollView.bounces = NO;
//        
//    feedTextWebView.scrollView.scrollEnabled = NO;
//    feedTextWebView.scrollView.bounces = NO;
//        feedTextWebView.tag=indexPath.row;
//        // NSString* detailMessage=[self stringByStrippingHTML:feedObject.detailMessage];
//   //NSString* detailMessage=[feedObject.detailMessage stringByEncodingHTMLEntities];
//    NSString* detailMessage=feedObject.detailMessage;
//
//    detailMessage = [detailMessage stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"];
//    detailMessage=[detailMessage stringByDecodingHTMLEntities];
//       // detailMessage = [detailMessage stringByReplacingOccurrencesOfString:@"\n" withString:@"%0A"];
//
//   // NSString* detailMessage=feedObject.detailMessage;
//        CGSize goodSize = [feedTextWebView sizeThatFits:CGSizeMake(feedTextWebView.frame.size.width,feedTextWebView.frame.size.height)];
//        NSLog(@"%f",cell.frame.size.height);
//        NSLog(@"%f",goodSize.height);
//
//     //   [feedTextWebView loadData:[detailMessage dataUsingEncoding:NSUTF8StringEncoding] MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:nil];
//   // [feedTextWebView loadHTMLString:detailMessage baseURL:nil];
//        NSData *data = [detailMessage dataUsingEncoding:NSNonLossyASCIIStringEncoding];
//        NSString *valueUnicode = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        
//        
//        NSData *dataa = [valueUnicode dataUsingEncoding:NSUTF8StringEncoding];
//        NSString *valueEmoj = [[NSString alloc] initWithData:dataa encoding:NSNonLossyASCIIStringEncoding];
//    
//        // _lbl.text = valueEmoj;
////        valueEmoj =
////        [NSString stringWithFormat:@"<font face='HelveticaNeue'>%@", valueEmoj];
//        [feedTextWebView loadHTMLString:valueEmoj baseURL:nil];
//    //UILabel* feedTime= (UILabel*)[cell viewWithTag:52];
//    NSString* dd=feedObject.dateOfFeed;
//    NSArray *components = [dd componentsSeparatedByString:@" "];
//    NSString *date = components[0];
//    NSString *time = components[1];
//    dateLabel.text=[NSString stringWithFormat:@"%@   %@",date,time];
//    
//   // UILabel* attachmentLabel= (UILabel*)[cell viewWithTag:53];
//    NSString* allAttachmentsNamesString=[self stringByStrippingHTML:feedObject.attachments];
//    NSArray* attachmentsNamesArray=[allAttachmentsNamesString componentsSeparatedByString:@"#@$"];
//   
//    
//    
//    NSString *attachmentString = @"";
//    if (attachmentsNamesArray.count > 0)
//    {
//        attachmentString = attachmentsNamesArray[0];
//    }
//    
//    UIView *subView = [cell viewWithTag:10000];
//    if (subView != nil)
//    {
//        [subView removeFromSuperview];
//    }
//    cell.tag = indexPath.row;
//    if (attachmentString.length > 0)
//    {
//        if (attachmentsNamesArray.count>0)
//        {
//            CounterGraph* counterGraphObj=[[CounterGraph alloc]init];
//            counterGraphObj.counterGraphlabel=attachmentLabel;
//            counterGraphObj.attachmentArray=[NSArray arrayWithArray:attachmentsNamesArray];
//            counterGraphObj.cell=cell;
//            counterGraphObj.selectedIndex = (int)indexPath.row;
//            [self performSelector:@selector(setCounterGraphLabel:) withObject:counterGraphObj afterDelay:0.0005];
//        }
//    }
//    
//        
//        
//        [cell addSubview:nameLabel];
//        [cell addSubview:dateLabel];
//        [cell addSubview:attachmentLabel];
//
//    [cell addSubview:feedTextWebView];
//    return cell;
//        
//    }
//    else
//    {
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
//        if ([self.cellSelected containsObject:[NSString stringWithFormat:@"%ld",indexPath.row]])
//        {
//            cell.accessoryType = UITableViewCellAccessoryCheckmark;
//        }
//        else
//        {
//            cell.accessoryType = UITableViewCellAccessoryNone;
//            
//        }
//        cell.tag=indexPath.row;
//        UILabel* attendeeNameLabel= [cell viewWithTag:97];
//        
//        
//        User* userObject= [userObjectsArray objectAtIndex:indexPath.row];
//        attendeeNameLabel.text=[NSString stringWithFormat:@"%@ %@",userObject.firstName,userObject.lastName];
//        
//        return cell;
//
//    }
//}
////-(void)scrollViewDidScroll:(UIScrollView *)scrollView
////{
////    if ([scrollView.superview isKindOfClass:[UIWebView class]])
////    {
////        if (scrollView.contentOffset.y > 0  ||  scrollView.contentOffset.y < 0 )
////            scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
////    }
////    
////}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (tableView==self.tableview)
//    {
//       FeedbackChatingCounter* feedObject= [app.FeedbackOrQueryDetailChatingObjectsArray objectAtIndex:indexPath.row];
//    
//    UILabel* feedTextLbl= [[UILabel alloc]initWithFrame:CGRectMake(5.0f, 10.0f, self.view.frame.size.width - 20.0f, 30.0f)];
//    UILabel* feedTextLbl1= [[UILabel alloc]initWithFrame:CGRectMake(5.0f, 10.0f, self.view.frame.size.width - 20.0f, 30.0f)];
//
////        UIWebView* feedTextWebView= [[UIWebView alloc]initWithFrame:CGRectMake(10, 10, self.view.frame.size.width-20, 23)];
////        [feedTextWebView loadHTMLString:feedObject.detailMessage baseURL:nil];
//        
//    feedTextLbl.text=feedObject.detailMessage;
//    feedTextLbl1.text=feedObject.attachments;
//        feedTextLbl.text= [feedTextLbl.text stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
//
//    [feedTextLbl setFont:[UIFont systemFontOfSize:14.0f]];
//    [feedTextLbl1 setFont:[UIFont systemFontOfSize:12.0f]];
//
//    feedTextLbl.lineBreakMode = UILineBreakModeWordWrap;
//    feedTextLbl.numberOfLines = 10000000;
////    
//    CGRect newFrame= [self getFrameSize:feedObject label:feedTextLbl];
//    CGRect newFrame2= [self getFrame:feedObject label:feedTextLbl1];
//
//        
//      //  float h1= [self getFrameSize:feedObject label:feedTextLbl];
//     //   float h2= [self getFrame:feedObject label:feedTextLbl1];
//        //NSLog(@"%f",feedTextWebView.frame.size.height);
//        //NSLog(@"%@",feedObject.detailMessage);
//        NSString* height=  [heightArray objectAtIndex:indexPath.row];
//        return [height intValue]+60;
//        
//        return 60+newFrame.size.height+newFrame2.size.height;
//
//       // return 60+newFrame.size.height+newFrame1.size.height;
//       //return 60 + h1+h2;
//   //     NSLog(@"%f",feedTextWebView.frame.size.height);
//        
//    }
//    
//    else
//    {
//        return 50;
//    }
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (tableView==self.popupTableView)
//    {
//    
//    if ([self.cellSelected containsObject:[NSString stringWithFormat:@"%ld",indexPath.row]])
//    {
//        
//        [self.cellSelected removeObject:[NSString stringWithFormat:@"%ld",indexPath.row]];
//    }
//    else
//    {
//        [self.cellSelected addObject:[NSString stringWithFormat:@"%ld",indexPath.row]];
//    }
//    
//    [self.popupTableView reloadData];
//    }
//}
//
//- (void)webViewDidFinishLoad:(UIWebView *)aWebView
//{
////    [tableview beginUpdates];
////    [tableview endUpdates];
//    CGRect frame = aWebView.frame;
//    frame.size.height = 1;
//    aWebView.frame = frame;
//    CGSize fittingSize = [aWebView sizeThatFits:CGSizeZero];
//    frame.size = fittingSize;
//    aWebView.frame = frame;
////    CGRect frame = aWebView.frame;
////    frame.size.height = 1;
////    aWebView.frame = frame;
////    CGSize fittingSize = [aWebView sizeThatFits:CGSizeZero];
////    frame.size = fittingSize;
////    aWebView.frame = frame;
//   // self.cellSize = fittingSize.height;
//    
//   // [self.tableview beginUpdates];
//   // [self.tableview endUpdates];
//    //NSString *output = [webView stringByEvaluatingJavaScriptFromString:@"document.body. scrollHeight;"];
////    feedTextWebViewForHeight=aWebView;
//    int height1=  aWebView.scrollView.contentSize.height;
//
//    [heightArray replaceObjectAtIndex:aWebView.tag withObject:[NSString stringWithFormat:@"%d",height1]];
//    [tableview beginUpdates];
//    [tableview endUpdates];
//    float sourcesWebViewHeight = [[aWebView stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollHeight"] floatValue];
//    
//    NSLog(@"%f", sourcesWebViewHeight);
//    
//}
//#pragma mark:height for cell;supporting methods
//
//-(void)setCounterGraphLabel:(CounterGraph*)counterGraphObj
//{
//    UIView *subView = [counterGraphObj.cell viewWithTag:10000];
//    
//    if (subView != nil)
//    {
//        [subView removeFromSuperview];
//    }
//    
//    if (counterGraphObj.selectedIndex != counterGraphObj.cell.tag)
//    {
//        return;
//    }
//    
//                         UIView* attachmentSubView=[[UIView alloc]init];
//                         attachmentSubView.tag=10000;
//                         float yPosOfLbl = 10.0f;
//                         for (int i=0,j=0; i<counterGraphObj.attachmentArray.count; i++)
//                         {
//                             
//                             if (![[counterGraphObj.attachmentArray objectAtIndex:i]  isEqual:@""] )
//                             {
//                             
//                             [attachmentSubView setFrame:CGRectMake(counterGraphObj.counterGraphlabel.frame.origin.x, counterGraphObj.counterGraphlabel.frame.origin.y+(2*i), 320, 34*(counterGraphObj.attachmentArray.count))];
//                           
//
//                             UILabel* label=[[UILabel alloc]init];
//                             //label.tag=10000;
//                             label.font=[UIFont systemFontOfSize:12];
//                             [label setFrame:CGRectMake(counterGraphObj.counterGraphlabel.frame.origin.x, (yPosOfLbl*i*4), 200, counterGraphObj.counterGraphlabel.frame.size.height)];
//                             label.text=[counterGraphObj.attachmentArray objectAtIndex:i];
//                             if (label.text.length>12)
//                             {
//                                 label.text= [label.text substringFromIndex:13];
//                                 
//                             }
//
//                             
//
//                             
//                             NSString* filePath=[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/Attachments/%@",[counterGraphObj.attachmentArray objectAtIndex:i]]];
//                             
//                             UIImageView* attachmentDownloadImageView=[[UIImageView alloc]init];
////attachmentDownloadImageView.
//                             attachmentDownloadImageView.contentMode = UIViewContentModeScaleAspectFit;
//                             if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
//                             {
//                                 attachmentDownloadImageView.image=[UIImage imageNamed:@"FileDownload"];
//                                 [attachmentDownloadImageView setFrame:CGRectMake(205, (yPosOfLbl*i*4),20, 20)];
//                             }
//                             else
//                             {
//                                 attachmentDownloadImageView.image=[UIImage imageNamed:@"ViewAttachment"];
//                                 [attachmentDownloadImageView setFrame:CGRectMake(205, (yPosOfLbl*i*4),20, 20)];
//                             }
//
//                             
//                            
//                             
//                             UIButton* attachmentDownloadButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
//                             [attachmentDownloadButton setFrame:CGRectMake(counterGraphObj.counterGraphlabel.frame.origin.x, (yPosOfLbl*i*4), 300, counterGraphObj.counterGraphlabel.frame.size.height)];
//                             //attachmentDownloadButton.backgroundColor=[UIColor redColor];
//                             attachmentDownloadButton.titleLabel.text=[counterGraphObj.attachmentArray objectAtIndex:i];
////                             attachmentDownloadButton.userInteractionEnabled=YES;
//                             [attachmentDownloadButton addTarget:self action:@selector(downloadFileUsingFTP:) forControlEvents:UIControlEventTouchUpInside];
//
//                             
//                             
//                             [attachmentSubView addSubview:label];
//                             [attachmentSubView addSubview:attachmentDownloadImageView];
//                             [attachmentSubView addSubview:attachmentDownloadButton];
//                             
//                              attachmentSubView.userInteractionEnabled=YES;
//
//                             
//
//                             [counterGraphObj.cell addSubview:attachmentSubView];
//                             }
//                            
//                         }
//
//    
//
//    
//}
//
////-(void)showFilePreviewOrDownload:(UIButton*)sender
////{
////    
////    NSError* error;
////    NSString *destpath;
////    //NSString* stringURL = [NSString stringWithFormat:@"http://localhost:9090/coreflex/resources/CfsFiles/%@",sender.titleLabel.text];
////    //NSString* stringURL = [NSString stringWithFormat:@"http://localhost:8080/coreflex/resources/CfsFiles/%@",sender.titleLabel.text];
////    NSString* stringURL = [NSString stringWithFormat:@"%@%@",HTTP_UPLOAD_PATH,sender.titleLabel.text];
////
////    NSString* webStringURL = [stringURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
////    NSURL* url = [NSURL URLWithString:webStringURL];
//////    hud.label.text = NSLocalizedString(@"Please wait...", @"HUD Loading title");
//////    hud.minSize = CGSizeMake(150.f, 100.f);
//////    hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//// //   [hud hideAnimated:YES];
////
////    destpath=[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/Attachments/%@",sender.titleLabel.text]];
////    
////    NSString* filePath=[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/Attachments"]];
////    
////    if (![[NSFileManager defaultManager] fileExistsAtPath:destpath])
////    {
////        if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
////            [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
////        
////        
////            NSData * data = [NSData dataWithContentsOfURL:url];
////            [data writeToFile:destpath atomically:YES];
////            [self.tableview reloadData];
////        
////        
////    }
////    
////    else
////    {
////        NSString* fileURL=[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/Attachments/%@",sender.titleLabel.text]];
////        NSURL* file = [NSURL fileURLWithPath:fileURL];
////        
////        UIDocumentInteractionController* documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:file];
////        
////        
////        [documentInteractionController setDelegate:self];
////        [documentInteractionController presentOpenInMenuFromRect:self.view.frame inView:self.view animated:YES];
////
////        [documentInteractionController presentPreviewAnimated:YES];
////        
////    }
////    
////    
////    
////}
//
//- (UIViewController *) documentInteractionControllerViewControllerForPreview: (UIDocumentInteractionController *) controller
//{
//    return self;
//}
//-(CGRect)getFrame:(FeedbackChatingCounter*)feedObject label:(UILabel*)feedTextLbl
//{
//    NSString* attachmentString= feedObject.attachments;
//   NSArray* allAttachmentArray= [attachmentString componentsSeparatedByString:@"|"];
//    NSString* attachmentName;
//    for (int i=0; i<allAttachmentArray.count; i++)
//    {
//      attachmentName=  [allAttachmentArray objectAtIndex:i];
//    }
//    CGSize maximumLabelSize = CGSizeMake(96, 100);
//    
//       CGSize expectedLabelSize = [attachmentName sizeWithFont:feedTextLbl.font constrainedToSize:maximumLabelSize lineBreakMode:feedTextLbl.lineBreakMode];
//    
//    //adjust the label the the new height.
//    CGRect newFrame = feedTextLbl.frame;
//    newFrame.size.height = expectedLabelSize.height*allAttachmentArray.count;
//    
//    
////    
////    CGSize constrainedSize = CGSizeMake(feedTextLbl.frame.size.width  , 9999);
////    
////    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
////                                          [UIFont fontWithName:@"HelveticaNeue" size:14.0], NSFontAttributeName,
////                                          nil];
////    
////    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:attachmentName attributes:attributesDictionary];
////    
////    CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
////    
////    if (requiredHeight.size.width > feedTextLbl.frame.size.width) {
////        requiredHeight = CGRectMake(0,0, feedTextLbl.frame.size.width, requiredHeight.size.height);
////    }
////    CGRect newFrame = feedTextLbl.frame;
////    newFrame.size.height = requiredHeight.size.height;
////    feedTextLbl.frame = newFrame;
//    
//    if (attachmentName==NULL)
//    {
//        newFrame.size.height = 10.0f;
//        
//    }
//else
//    if (newFrame.size.height < 20)
//    {
//        newFrame.size.height = 20.0f;
//    }
//    
//    //return newFrame.size.height;
//    return newFrame;
//    
//}
//-(CGRect)getFrameSize:(FeedbackChatingCounter*)feedObject label:(UILabel*)feedTextLbl
//{
//    CGSize maximumLabelSize = CGSizeMake(feedTextLbl.frame.size.width, MAXFLOAT);
//    
//    CGSize expectedLabelSize = [feedObject.detailMessage sizeWithFont:feedTextLbl.font constrainedToSize:maximumLabelSize lineBreakMode:feedTextLbl.lineBreakMode];
//    
//    //adjust the label the the new height.
//    CGRect newFrame = feedTextLbl.frame;
//    newFrame.size.height = expectedLabelSize.height;
//    if (newFrame.size.height < 20)
//    {
//        newFrame.size.height = 20.0f;
//    }
//    
//    
//    
//    
//    
//    
////    CGSize constrainedSize = CGSizeMake(self.view.frame.size.width-20  , 99999);
////    
////    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
////                                          [UIFont fontWithName:@"HelveticaNeue" size:14.0], NSFontAttributeName,
////                                          nil];
////    
////
////    
////    NSString* htmlString=feedObject.detailMessage;
////
////    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:htmlString attributes:attributesDictionary];
////    
////    CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
////    
////
////    CGRect newFrame = feedTextLbl.frame;
////    newFrame.size.height = requiredHeight.size.height;
////    feedTextLbl.frame = newFrame;
//    
//
//    //return requiredHeight.size.height;
//    return newFrame;
//
//}
//
//#pragma mark:remove html tags
//
//-(NSString *) stringByStrippingHTML:(NSString *) stringWithHtmlTags {
//    NSRange r;
//    while ((r = [stringWithHtmlTags rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
//        stringWithHtmlTags = [stringWithHtmlTags stringByReplacingCharactersInRange:r withString:@""];
//    return stringWithHtmlTags;
//}
//
//
//#pragma mark:image picker delegates
//- (void)imagePickerController:(UIImagePickerController *)picker
//        didFinishPickingImage:(UIImage *)image
//                  editingInfo:(NSDictionary *)editingInfo
//{
//    
//       [self dismissViewControllerAnimated:YES completion:NULL];
//}
//
//#pragma mark:self view action methods
//
//- (IBAction)sendFeedbackButtonClicked:(id)sender
//{
//    NSString* userFrom,* userTo;
//    if ([sendTextView.text length] <= 0)
//    {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Empty message!" message:@"Please enter some message and try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
//        [alertView show];
//    }
//    
//    else
//    {
//        [sendTextView resignFirstResponder];
//        Database* db=[Database shareddatabase];
//        FeedbackChatingCounter* feedObject= [app.FeedbackOrQueryDetailChatingObjectsArray objectAtIndex:0];
//        FeedbackChatingCounter *lastFeedObj=[app.FeedbackOrQueryDetailChatingObjectsArray lastObject];
//
//        long maxFeedCounterOfCurrentSoNoAndType= lastFeedObj.feedbackCounter;
//        NSString* username = [[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"];
//        NSString* companyId=[db getCompanyId:username];
//        NSString* userFeedback=[db getUserIdFromUserName:username];
//        NSMutableArray* maxFeedIdAndCounterArray=[db getMaxFeedIdAndCounter:feedObject.soNumber :feedObject.feedbackType];
//        if ([companyId isEqual:@"1"])
//        {
//           userFrom= [[Database shareddatabase] getAdminUserId];
//            username=[db getUserNameFromCompanyname:[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedCompany"]];
//            userTo=[db getUserIdFromUserNameWithRoll1:username];
//
//        }
//        
//        else
//        {
//            userTo=[[Database shareddatabase] getAdminUserId];
//           userFrom= [db getUserIdFromUserNameWithRoll1:username];
//        }
//        
//        Feedback* feedObj=[[Feedback alloc]init];
//        feedObj.soNumber = feedObject.soNumber;
//        feedObj.emailSubject = feedObject.emailSubject;
//        feedObj.feedbackType = feedObject.feedbackType;
//        feedObj.userFrom=[userFrom intValue];
//        feedObj.userTo=[userTo intValue];
//        feedObj.userFeedback=[userFeedback intValue];
//
//
//        NSString* feedText = sendTextView.text;
//        /*
//        NSDictionary *documentAttributes = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
//        NSData *htmlData = [feedText dataFromRange:NSMakeRange(0, feedText.length) documentAttributes:documentAttributes error:NULL];
//        
//        NSString *htmlString = [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding];
//        */
//        //feedObj.feedbackText =[feedObj.feedbackText stringByDecodingHTMLEntities];
//       // feedObj.feedbackText=[feedText stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
//       // feedObj.feedbackText = [sendTextView.text stringByReplacingOccurrencesOfString: @"\n" withString: @"\\n"];
//      
//       
////       htmlString=[htmlString stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
////
//        //feedText= [feedText stringByEncodingHTMLEntities];
//       // feedObj.feedbackText =htmlString;
//        //   feedObj.feedbackText= [feedText stringByReplacingOccurrencesOfString:@"&" withString:@"\u0026"];
//        // [NSString stringWithFormat:@"%C",@"\u0026"];
//        // feedObj.feedbackText= [feedText gtm_stringByEscapingForAsciiHTML];
//        //        NSData *data = [@"&" dataUsingEncoding:NSASCIIStringEncoding];
//        //        NSString* converted=  [[NSString alloc] initWithData:data encoding:NSNonLossyASCIIStringEncoding];
//        //        feedObj.feedbackText=[feedText stringByReplacingOccurrencesOfString: @"&" withString: converted];
//        //feedObj.feedbackText=[feedText stringByEncodingHTMLEntities];
//
//       feedObj.feedbackText= [feedText stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
//
//        feedObj.feedbackText=[feedObj.feedbackText stringByReplacingOccurrencesOfString: @"&" withString: @"and"];
//        feedObj.dateOfFeed=[[APIManager sharedManager] getDate];
//        feedObj.feedbackCounter=[[NSString stringWithFormat:@"%@",[maxFeedIdAndCounterArray objectAtIndex:1]]longLongValue];
//        feedObj.feedbackId=[[NSString stringWithFormat:@"%@",[maxFeedIdAndCounterArray objectAtIndex:0]]longLongValue];
//        
//        
//        NSString *uploadedFileNamesString = @"";
//        if (app.uploadedFileNamesArray.count==1)
//        {
//            uploadedFileNamesString = [NSString stringWithFormat:@"%@", [app.uploadedFileNamesArray objectAtIndex:0]];
//        }
//        else
//            
//            if (app.uploadedFileNamesArray.count>1)
//            {
//                for (int i = 0; i<app.uploadedFileNamesArray.count; i++)
//                {
//        
//                    if (i == 0)
//                    {
//                        uploadedFileNamesString = [NSString stringWithFormat:@"%@", [app.uploadedFileNamesArray objectAtIndex:i]];
//
//                    }
//                    else
//                    {
//                        uploadedFileNamesString=[uploadedFileNamesString stringByAppendingString:[NSString stringWithFormat:@"%@",[app.uploadedFileNamesArray objectAtIndex:i]]];
//            
//                    }
//
//        
//                }
//
//    
//            }
//        
//        
//        uploadedFileNamesString = [uploadedFileNamesString stringByReplacingOccurrencesOfString:@"/" withString:@""];
//        uploadedFileNamesString = [uploadedFileNamesString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
//        feedObj.attachment = uploadedFileNamesString;
//        if (app.uploadedFileNamesArray != nil)
//        {
//            [app.uploadedFileNamesArray removeAllObjects];
//        }
//        
//      //feedObj.statusId=[[NSString stringWithFormat:@"%@",[maxFeedIdAndCounterArray objectAtIndex:2]]intValue];
//        
//        UILabel* statusLabel= [self.view viewWithTag:201];
//
//        if ([statusLabel.text isEqual:@"Open"])
//        {
//            feedObj.statusId=1;
//        }
//        else
//        {
//            feedObj.statusId=2;
//
//        }
//        feedObj.operatorId=[[NSString stringWithFormat:@"%@",[maxFeedIdAndCounterArray objectAtIndex:3]]intValue];
//        
//        //to make array as string
//        
//        NSMutableString* userIdsString=[[NSMutableString alloc]init];
//        
//        for (int i=0; i<userIdsArray.count; i++)
//        {
//            if ([userIdsString isEqualToString:@""])
//            {
//                userIdsString =[NSMutableString stringWithFormat:@"%@",[userIdsArray objectAtIndex:i]];
//                
//            }
//            else
//                userIdsString =[NSMutableString stringWithFormat:@"%@,%@",userIdsString,[userIdsArray objectAtIndex:i]];
//        }
//
//        
//        
//        NSArray* keys=[NSArray arrayWithObjects:@"soNumber",@"userFrom",@"userTo",@"userFeedback",@"feedText",@"feedbackType",@"statusId",@"operatorId",@"emailSubject",@"attachment",@"userIds",@"historyFlag",@"maxCounter", nil];
//
//        
//        NSArray* values=@[feedObj.soNumber,[NSString stringWithFormat:@"%d",feedObj.userFrom],[NSString stringWithFormat:@"%d",feedObj.userTo],[NSString stringWithFormat:@"%d",feedObj.userFeedback],feedObj.feedbackText,[NSString stringWithFormat:@"%d",feedObj.feedbackType],[NSString stringWithFormat:@"%d",feedObj.statusId],[NSString stringWithFormat:@"%d",feedObj.operatorId],feedObj.emailSubject,feedObj.attachment,userIdsString,[NSString stringWithFormat:@"%d",historyFlag],[NSString stringWithFormat:@"%ld",maxFeedCounterOfCurrentSoNoAndType] ];
//        
//        NSDictionary* dic=[NSDictionary dictionaryWithObjects:values forKeys:keys];
//        
//        
//        
//
//        
//        
//        [[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"];
//        [[NSUserDefaults standardUserDefaults] valueForKey:@"currentPassword"];
//
//
// sendTextView.text=@"";
//        [self cancelReceipients];
//        [[APIManager sharedManager] sendUpdatedRecords:[[NSUserDefaults standardUserDefaults] valueForKey:@"flag"] Dict:dic username:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"] password:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentPassword"]];
//      // [db insertUserReply:feedObj];
//        
//        
//        
//    
//    }
//
//}
//
//#pragma mark:texfield delegates
//- (void)textViewDidBeginEditing:(UITextView *)textView
//{
//    [self moveViewUp:YES];
// 
//}
//- (void)textViewDidEndEditing:(UITextView *)textView
//{
//    [self moveViewUp:NO];
//
//}
////- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
////{
////    sendTextView.text = @"";
////    sendTextView.textColor = [UIColor blackColor];
////    return YES;
////}
////
////-(void) textViewDidChange:(UITextView *)textView
////{
////    
////    if(sendTextView.text.length == 0){
////        sendTextView.textColor = [UIColor lightGrayColor];
////        sendTextView.text = @"Reply";
////        [sendTextView resignFirstResponder];
////    
////    }
////}
////- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
////    if ([text isEqualToString:@"\n"]) {
////        NSLog(@"Return pressed, do whatever you like here");
////        return NO; // or true, whetever you's like
////    }
////    
////    return YES;
////}
////-(BOOL)textFieldShouldReturn:(UITextField *)textField
////{
////    [textField resignFirstResponder];
////    return YES;
////}
////
////-(void)textFieldDidBeginEditing:(UITextField *)textField
////{
////    [self moveViewUp:YES];
////}
////
////-(void)textFieldDidEndEditing:(UITextField *)textField
////{
////    [self moveViewUp:NO];
////}
//
//- (void) moveViewUp: (BOOL) isUp
//{
//    const int movementDistance = 230; // tweak as needed
//    const float movementDuration = 0.3f; // tweak as needed
//    
//        if (isUp)
//        {
////            movementDistance=totalMovement;
////            totalMovement=0;
//            long lastRowNumber = [tableview numberOfRowsInSection:0] - 1;
//            NSIndexPath* ip = [NSIndexPath indexPathForRow:lastRowNumber inSection:0];
//            [tableview scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:NO];
//
//        }
//    
//    movement = (isUp ? -movementDistance : movementDistance);
//    
//    [UIView beginAnimations: @"anim" context: nil];
//    [UIView setAnimationBeginsFromCurrentState: YES];
//    [UIView setAnimationDuration: movementDuration];
////    self.tableview.frame = CGRectOffset(self.tableview.frame, 0, -(2*movement));
// //   [tableview setContentInset:UIEdgeInsetsMake(0.f, 0.f, self.tableview.frame.size.width, self.tableview.frame.size.height/2)];
////    _tableViewHeight.constant=100;
//    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
//
//    [UIView commitAnimations];
//}
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//
//- (IBAction)switchValueChanged:(UISwitch*)sender
//{
//    UIView* mainView=  [self.view viewWithTag:2001];
//    UIView* subView=  [mainView viewWithTag:2005];
//    UILabel* historyLabel=  [subView viewWithTag:2007];
//    if (sender.isOn)
//    {
//        historyFlag=1;
//     
//        historyLabel.text=@"With history";
//    }
//    else
//    {
//        historyFlag=2;
//        historyLabel.text=@"Without history";
//    }
//}
//
//- (IBAction)backButtonPressed:(id)sender
//{
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
//
//- (IBAction)addReceipientsButtonClicked:(id)sender
//{
//    UIView* popupView=[self.view viewWithTag:2001];
//    [popupView setHidden:NO];
//    
//    [self stopUserInteraction];
//     [self addIds];
//}
//-(void)stopUserInteraction
//{
//    [self.view viewWithTag:1001].userInteractionEnabled=NO;
//    [self.view viewWithTag:4001].userInteractionEnabled=NO;
//    [self.view viewWithTag:202].userInteractionEnabled=NO;
//
//}
//-(void)startUserInteraction
//{
//    [self.view viewWithTag:1001].userInteractionEnabled=YES;
//    [self.view viewWithTag:4001].userInteractionEnabled=YES;
//    [self.view viewWithTag:202].userInteractionEnabled=YES;
// 
//}
//- (IBAction)cancelRecipientsButtonClicked:(id)sender
//{
//    [self cancelReceipients];
//}
//
//-(void)cancelReceipients
//{
//    UIView* popupView=[self.view viewWithTag:2001];
//    [popupView setHidden:YES];
//    
//    self.cellSelected=nil;
//    //self.attendiesTextView.text=nil;
//    userIdsArray=nil;
//    //serNamesArray=nil;
//    self.cellSelected=[[NSMutableArray alloc]init];
//    [self.popupTableView reloadData];
//    [self startUserInteraction];
//    //    userNamesArray=nil;
//    //    userIdsArray=nil;
//    // self.scrollview.userInteractionEnabled = YES;
//    // [self.tableView setHidden:YES];
//
//}
//
//- (IBAction)doneRecipientsButtonClicked:(id)sender
//{
//    UIView* popupView=[self.view viewWithTag:2001];
//    [popupView setHidden:YES];
//    
//    
//    userIdsArray=[NSMutableArray new];
//   // userNamesArray=[NSMutableArray new];
//    for (int i=0; i<self.cellSelected.count; i++)
//    {
//        NSString* k=[self.cellSelected objectAtIndex:i];
//        User* userobject= [userObjectsArray objectAtIndex:[k intValue]];
//        //[userNamesArray addObject:[NSString stringWithFormat:@"%@ %@",userobject.firstName,userobject.lastName]];
//        [userIdsArray addObject:[NSString stringWithFormat:@"%d",userobject.Id]];
//        
//    }
//    
//   // [self.tableView setHidden:YES];
////    for (int j=0; j<userNamesArray.count; j++)
////    {
////        if (j==0)
////        {
////            attendiesTextView.text=[userNamesArray objectAtIndex:j];
////            
////        }
////        else
////            attendiesTextView.text=[NSString stringWithFormat:@"%@,%@",attendiesTextView.text,[userNamesArray objectAtIndex:j]];
////    }
////    if (userNamesArray.count==0)
////    {
////        attendiesTextView.text=@"";
////    }
//
//    [self startUserInteraction];
//
//}
//
//- (IBAction)sendAttachment:(id)sender
//{
//    
//   // UIViewController* vc= [self.storyboard instantiateViewControllerWithIdentifier:@"UploadFileViewController"];
//    [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"UploadFileViewController"] animated:YES completion:nil];
//}
//
//
//
////----------------------for FTP use only-----------
//
//-(void)downloadFileUsingFTP:(UIButton*)sender
//{
//    NSString* folderName;
//    NSError* error;
//    NSString *destpath;
////    hud.minSize = CGSizeMake(150.f, 100.f);
////    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
////    hud.mode = MBProgressHUDModeIndeterminate;
////    hud.label.text = @"Downloading..";
////    hud.detailsLabel.text = @"Please wait";
//    folderName=@"Attachments";
//    
//    destpath=[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@",folderName,sender.titleLabel.text]];
//    //destpath=[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@",folderName,sender.titleLabel.text]];
//
//    NSString* filePath=[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",folderName]];
//    
//    if (![[NSFileManager defaultManager] fileExistsAtPath:destpath])
//    {
//        if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
//            [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
//        [self startReceive:sender];
//
//    }
//    else
//    {
//        
//        //NSString* fileURL=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Attachments/1469363039819Untitled.png"];
//        NSString* fileURL=[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/Attachments/%@",sender.titleLabel.text]];
//
//        NSURL* file = [NSURL fileURLWithPath:fileURL];
//        
//        UIDocumentInteractionController* documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:file];
//        
//        
//        [documentInteractionController setDelegate:self];
//        [documentInteractionController presentOpenInMenuFromRect:self.view.frame inView:self.view animated:YES];
//        
//        
//        //documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:file];
//        [documentInteractionController presentPreviewAnimated:YES];
//        
//    }
//
//
//}
//
//
//-(void)startReceive:(UIButton*)sender
//{
////   NSURL *url = [NSURL URLWithString:@"ftp://ftp.funet.fi/pub/standards/RFC/rfc959.txt"];
//    downloadableAttachmentName=sender.titleLabel.text;
//   // NSString* fileName=sender.titleLabel.text;
//    //NSString* fileName=sender.titleLabel.text;
//
//   NSString* username = [FTPUsername stringByReplacingOccurrencesOfString:@"@"
//                                         withString:@"%40"];
//    
//   NSString* password = [FTPPassword stringByReplacingOccurrencesOfString:@"@"
//                                                   withString:@"%40"];
//    
//    
//    
//    NSString* urlString=[NSString stringWithFormat:@"ftp://%@:%@%@%@%@",username,password,FTPHostName,FTPFilesFolderName,downloadableAttachmentName];
//    
//   // NSURL *url = [NSURL URLWithString:@"ftp://demoFtp%40pantudantukids.com:asdf123@pantudantukids.com:21/TEST/1469363039819Untitled.png"];
//    NSURL *url = [NSURL URLWithString:urlString];
//
//    
//    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    //sessionConfiguration.URLCredentialStorage = cred_storage;
//    sessionConfiguration.allowsCellularAccess = YES;
//  
//    
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
//    
//    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:url];
//    [downloadTask resume];
//    
//    [self performSelectorOnMainThread:@selector(showHud) withObject:nil waitUntilDone:NO];
//
//}
//
//
//- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
//didCompleteWithError:(nullable NSError *)error
//{
//    [self performSelectorOnMainThread:@selector(hideHud) withObject:nil waitUntilDone:NO];
//    NSLog(@"errors %@",error.debugDescription);
//}
//- (void)URLSession:(nonnull NSURLSession *)session task:(nonnull NSURLSessionTask *)task didReceiveChallenge:(nonnull NSURLAuthenticationChallenge *)challenge completionHandler:(nonnull void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * __nullable))completionHandler
//{
//   
//}
//- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
//{
//    NSData *data = [NSData dataWithContentsOfURL:location];
//    NSString* destpath=[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/Attachments/%@",downloadableAttachmentName]];
//
//    [data writeToFile:destpath atomically:YES];
//    //[hud hideAnimated:YES];
//    //[self performSelectorOnMainThread:@selector(hideHud) withObject:nil waitUntilDone:NO];
//
//    dispatch_async(dispatch_get_main_queue(), ^{
//        
//        //[self.progressView setHidden:YES];
//        //[self.imageView setImage:[UIImage imageWithData:data]];
//    });
//}
//- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
//{
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//}
//- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
//{
//    float progress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
//    NSLog(@"progress %f",progress);
//    NSString* progressPercent= [NSString stringWithFormat:@"Downloading..%f",progress*100];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        
//        
//        if (progress==1)
//        {
//            [hud hideAnimated:YES];
//        }
////        hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
////        [hud hideAnimated:YES];
////        
////        hud.label.text = NSLocalizedString(progressPercent, @"HUD Loading title");
////        hud.minSize = CGSizeMake(150.f, 100.f);
//        //[self.progressView setProgress:progress];
//    });
//}
//-(void)hideHud
//{
//    [self.tableview reloadData];
//    [hud hideAnimated:YES];
//}
//-(void)showHud
//{
//    hud.minSize = CGSizeMake(150.f, 100.f);
//    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.mode = MBProgressHUDModeIndeterminate;
//    //hud.label.text = [NSString stringWithFormat:@"Downloading(%f%%)",progress*100];
//    hud.label.text = [NSString stringWithFormat:@"Downloading.."];
//    
//    hud.detailsLabel.text = @"Please wait";
//}
//- (IBAction)issueCloseButtonClicked:(id)sender
//{
//    NSArray* subViewArray=[NSArray arrayWithObjects:@"Open",@"Close", nil];
//    popUpView=[[PopUpCustomView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+self.view.frame.size.width-175, self.view.frame.origin.y+100, 160, 80) andSubViews:subViewArray :self];
//    [[[UIApplication sharedApplication] keyWindow] addSubview:popUpView];
//   
//   // [self closeIssue];
//}
//-(void)addIds
//{
//    [self.popupTableView reloadData];
//    
//    [[self.view viewWithTag:2001] setHidden:NO];
//   // self.view.userInteractionEnabled = NO;
//}
//
//-(void)dismissPopView:(id)sender
//{
//    
//    UIView* overlay= [[[UIApplication sharedApplication] keyWindow] viewWithTag:111];
//    if ([overlay isKindOfClass:[UIView class]])
//    {
//        [[[[UIApplication sharedApplication] keyWindow] viewWithTag:111] removeFromSuperview];
//    }
//    
//}
//
//-(void)Open
//{
//    [[[[UIApplication sharedApplication] keyWindow] viewWithTag:111] removeFromSuperview];
//    UILabel* statusLabel= [self.view viewWithTag:201];
//
//    statusLabel.text=@"Open";
//
//}
//
//-(void)Close
//{
//    [[[[UIApplication sharedApplication] keyWindow] viewWithTag:111] removeFromSuperview];
//    UILabel* statusLabel= [self.view viewWithTag:201];
//    statusLabel.text=@"Close";
//
//}
//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//   UIView* whitePopupView= [popUpView viewWithTag:561];
//    if ([touch.view isDescendantOfView:whitePopupView])
//    {
//        
//        return NO;
//    }
//    
//    return YES; // handle the touch
//}
//
//
//-(void)viewWillDisappear:(BOOL)animated
//{
//    //FeedcomQuerycomViewController* vc=[[FeedcomQuerycomViewController alloc]init];
//    //[vc prepareForSearchBar];
//    //[vc reloadData];
//    //
//    [[[UIApplication sharedApplication].keyWindow viewWithTag:901] removeFromSuperview];
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ADD_FEEDBACK_BUTTON object:nil];
//}
//
////- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
////{
////    float endScrolling = scrollView.contentOffset.y + scrollView.frame.size.height;
////    if (endScrolling >= scrollView.contentSize.height)
////    {
////        NSLog(@"Scroll End Called");
////        [self refreshTable];
////        
////    }
////}
//@end
//
//
//





//load the tableview with reusable cell with cellheight=content height(wp considering webview height)



 //
 //  DetailChatingViewController.m
 //  Communicator
 //
 //  Created by mac on 26/05/16.
 //  Copyright © 2016 Xanadutec. All rights reserved.
 //
 
 #import "DetailChatingViewController.h"
 #import "FeedcomQuerycomViewController.h"
 #import "FeedbackChatingCounter.h"
 #import "QueryChatingCounter.h"
 #import "Database.h"
 #import "Feedback.h"
 #import <MobileCoreServices/MobileCoreServices.h>
 #import "CounterGraph.h"
 #import "MBProgressHUD.h"
 #include <CFNetwork/CFNetwork.h>
 #import "NetworkManager.h"
 #import "NSString+HTML.h"
 #import "GTMNSString+HTML.h"
 #import "PopUpCustomView.h"
 enum {
 kSendBufferSize = 32768
 };
 @interface DetailChatingViewController ()
 
 @end
 
 @implementation DetailChatingViewController
 @synthesize tableview;
 @synthesize sendTextView;
 @synthesize hud,historyFlag;
 - (void)viewDidLoad
 {
 [super viewDidLoad];
 [[NSNotificationCenter defaultCenter] addObserver:self
 selector:@selector(keyboardWillShow:)
 name:UIKeyboardWillShowNotification
 object:nil];
 
 [[NSNotificationCenter defaultCenter] addObserver:self
 selector:@selector(keyboardWillHide:)
 name:UIKeyboardWillHideNotification
 object:nil];
 sendTextView.delegate=self;
 
 refreshControl = [[UIRefreshControl alloc]init];
 refreshControl.tag=1000;
 [self.tableview addSubview:refreshControl];
 [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
 [self preferredStatusBarStyle];
 self.cellSelected=[NSMutableArray new];
 
 // Do any additional setup after loading the view.
 [[NSNotificationCenter defaultCenter] addObserver:self
 selector:@selector(insertLoadMoreData:) name:NOTIFICATION_GET_ALL_MSGS_LOAD_MORE_DATA
 object:nil];
 [[NSNotificationCenter defaultCenter] addObserver:self
 selector:@selector(reloadData) name:NOTIFICATION_NEW_DATA_UPDATE
 object:nil];
 
 UIView* navigationView=[self.view viewWithTag:1001];
 NSString* currentFeedbackType= [[NSUserDefaults standardUserDefaults] valueForKey:@"currentFeedbackType"];
 
 UILabel* navigationTitleLabel=[navigationView viewWithTag:444];
 navigationTitleLabel.text=[NSString stringWithFormat:@"%@/Feedback Communication",currentFeedbackType];
     
//     dispatch_async(dispatch_get_main_queue(), ^{
//         // make some UI changes
//        sendTextView.text = @"Reply";
//         sendTextView.textColor = [UIColor lightGrayColor];
//     });
 }
 
 #pragma mark:UI
 
 -(void)viewWillAppear:(BOOL)animated
 {
 [super viewWillAppear:YES];
 [[self.view viewWithTag:2001] setHidden:YES];
 
 [[self.view viewWithTag:2001] setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.2]];
 
 //[self setNavigationItems:@"Close"];
 [self setHeaderForTableView];
 
 sendTextView.layer.cornerRadius=4.0f;
 sendTextView.layer.borderColor=[UIColor grayColor].CGColor;
 sendTextView.layer.borderWidth=1.0f;
 [[NSNotificationCenter defaultCenter] addObserver:self
 selector:@selector(getLatestRecord:) name:NOTIFICATION_SEND_UPDATED_RECORDS
 object:nil];
 [tableview reloadData];
// long lastRowNumber = [tableview numberOfRowsInSection:0] - 1;
// NSIndexPath* ip = [NSIndexPath indexPathForRow:lastRowNumber inSection:0];
// [tableview scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:NO];
 FeedbackChatingCounter* feedObject= [app.FeedbackOrQueryDetailChatingObjectsArray objectAtIndex:0];
 [[Database shareddatabase] updateReadStatus:feedObject.soNumber feedbackType:[NSString stringWithFormat:@"%d",feedObject.feedbackType]];
 
 historyFlag=2;
 
 //    sendTextView.text = @"Reply";
 //    sendTextView.textColor = [UIColor lightGrayColor];
 //    sendTextView.delegate = self;
 
 //to update previous view
 //    [[Database shareddatabase] setDatabaseToCompressAndShowTotalQueryOrFeedback:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentFeedbackType"]];
 // [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPDATE_TABLEVIEW object:nil];
     
     self.numberOfLines=1;
 [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_NEW_DATA_UPDATE object:nil];//messages read,now update prev 2 views
 
 }
 
 -(void)setHeaderForTableView
 {
 sendTextView.delegate=self;
 UILabel* subjectLabel=(UILabel*)[self.view viewWithTag:100];
 UILabel* SONumberLabel=(UILabel*)[self.view viewWithTag:101];
 UILabel* dateOfFeedLabel=(UILabel*)[self.view viewWithTag:102];
 
 app=[AppPreferences sharedAppPreferences];
 NSArray* separatedSO=[[NSMutableArray alloc]init];
 FeedbackChatingCounter *allMessageObj=[app.FeedbackOrQueryDetailChatingObjectsArray lastObject];
 //-----------setSubject---------//
 subjectLabel.text=allMessageObj.emailSubject;
 
 //------setSONumber----------------//
 NSString* soNumber= allMessageObj.soNumber;
 separatedSO=[soNumber componentsSeparatedByString:@"#@"];
 NSString* soNumr=[separatedSO objectAtIndex:0];
 NSString* avaya=[separatedSO objectAtIndex:1];
 NSString* Doc=[separatedSO objectAtIndex:2];
 
 SONumberLabel.text=[NSString stringWithFormat:@"SO No:%@\nAvaya Id:%@\nDocument Id:%@",soNumr,avaya,Doc];
 
 //------setDate----------------//
 
 NSString* dd=allMessageObj.dateOfFeed;
 NSArray *components = [dd componentsSeparatedByString:@" "];
 NSString *date = components[0];
 NSString *time = components[1];
 
 dateOfFeedLabel.text=[NSString stringWithFormat:@"%@\n%@",date,time];
 
 }
 
 #pragma mark:Data insertion and reload
 
 //pull down to fetch data from server
 -(void)refreshTable
 {
 NSString* userFrom= [[NSUserDefaults standardUserDefaults] valueForKey:@"userFrom"];
 NSString* userTo=   [[NSUserDefaults standardUserDefaults] valueForKey:@"userTo"];
 FeedbackChatingCounter* feedObject= [app.FeedbackOrQueryDetailChatingObjectsArray objectAtIndex:0];
 if (feedObject!=NULL)
 {
 [[APIManager sharedManager] getNotificationLoadMoreDataForUsername:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"]  andPassword:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentPassword"] SONumber:feedObject.soNumber feedbackType:[NSString stringWithFormat:@"%d",feedObject.feedbackType] userFrom:userFrom userTo:userTo] ;
 }
 
 }
 
 //reload data from DB after getting notified
 -(void)reloadData
 {
 FeedbackChatingCounter* feedObject= [app.FeedbackOrQueryDetailChatingObjectsArray lastObject];
 
 if (feedObject.statusId==2)
 {
 [self.view viewWithTag:202].userInteractionEnabled=NO;
 UILabel* statusLabel= [self.view viewWithTag:201];
 statusLabel.textColor=[UIColor redColor];
 statusLabel.text=@"Closed";
 }
 [[Database shareddatabase] getDetailMessagesofFeedbackOrQuery:feedObject.feedbackType :feedObject.soNumber];
 [refreshControl endRefreshing];
 sendTextView.text=@"Reply";
     sendTextView.textColor=[UIColor lightGrayColor];
 [self.tableview reloadData];
 }
 
 //insert fetched data into db after getting response
 -(void)insertLoadMoreData:(NSNotification*)data
 {
 [[Database shareddatabase] insertFeedcomNotifiationData:data.object readStatusflag:false];
 
 }
 
 #pragma mark:TableView bottom position
 
 //to go at bottom of tableview
 - (void)keyboardWillShow:(NSNotification *)notification
 {
 CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
 
 UIEdgeInsets contentInsets;
 if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
 contentInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize.height), 0.0);
 } else {
 contentInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize.width), 0.0);
 }
 
 tableview.contentInset = contentInsets;
 tableview.scrollIndicatorInsets = contentInsets;
 //[tableview scrollToRowAtIndexPath:self.editingIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
 
 long lastRowNumber = [tableview numberOfRowsInSection:0] - 1;
 NSIndexPath* ip = [NSIndexPath indexPathForRow:lastRowNumber inSection:0];
 [tableview scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:NO];
 
 }
 
 - (void)keyboardWillHide:(NSNotification *)notification
 {
 tableview.contentInset = UIEdgeInsetsZero;
 tableview.scrollIndicatorInsets = UIEdgeInsetsZero;
 }
 
 //-(void)setNavigationItems:(NSString*)rightBarItemTitle
 //{
 //    self.navigationItem.title = @"Feedback communication";
 //    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BackArrow"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController)] ;
 //    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:rightBarItemTitle style:UIBarButtonItemStylePlain target:self action:@selector(closeIssue)];
 //    self.navigationItem.rightBarButtonItem.tintColor=[UIColor whiteColor];
 //    self.navigationItem.leftBarButtonItem.tintColor=[UIColor whiteColor];
 //    [self preferredStatusBarStyle];
 //
 //}
 - (UIStatusBarStyle)preferredStatusBarStyle
 {
 return UIStatusBarStyleLightContent;
 }
 
 -(void)popViewController
 {
 [self.navigationController popViewControllerAnimated:YES];
 }
 
 #pragma mark:close issue
 //-(void)closeIssue
 //{
 //           UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Close Issue?"
 //                                                                                 message:@"Are you sure to close this issue"
 //                                                                          preferredStyle:UIAlertControllerStyleAlert];
 //        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
 //                                                           style:UIAlertActionStyleDefault
 //                                                         handler:^(UIAlertAction * action)
 //                                   {
 //                                       //[self closeIssueConfirmed];
 //
 //                                   }];
 //
 //    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Cancel"
 //                                                       style:UIAlertActionStyleDefault
 //                                                         handler:nil];
 //        [alertController addAction:actionOk];
 //        [alertController addAction:actionCancel];
 //
 //        [self presentViewController:alertController animated:YES completion:nil];
 //
 //}
 
 //-(void)closeIssueConfirmed
 //{
 //    NSString* userFrom,* userTo;
 //
 //    Database* db=[Database shareddatabase];
 //    FeedbackChatingCounter* feedObject= [app.FeedbackOrQueryDetailChatingObjectsArray objectAtIndex:0];
 //
 //    NSString* username = [[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"];
 //    NSString* companyId=[db getCompanyId:username];
 //    NSString* userFeedback=[db getUserIdFromUserName:username];
 //    NSMutableArray* maxFeedIdAndCounterArray=[db getMaxFeedIdAndCounter:feedObject.soNumber :feedObject.feedbackType];
 //    if ([companyId isEqual:@"1"])
 //    {
 //        userFrom=[[Database shareddatabase] getAdminUserId];
 //        username=[db getUserNameFromCompanyname:[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedCompany"]];
 //        userTo=[db getUserIdFromUserNameWithRoll1:username];
 //
 //    }
 //
 //    else
 //    {
 //        userTo=[[Database shareddatabase] getAdminUserId];
 //        userFrom= [db getUserIdFromUserNameWithRoll1:username];
 //    }
 //
 //    Feedback* feedObj=[[Feedback alloc]init];
 //    feedObj.soNumber = feedObject.soNumber;
 //    feedObj.emailSubject = feedObject.emailSubject;
 //    feedObj.feedbackType = feedObject.feedbackType;
 //    feedObj.userFrom=[userFrom intValue];
 //    feedObj.userTo=[userTo intValue];
 //    feedObj.userFeedback=[userFeedback intValue];
 //    feedObj.feedbackText = sendTextView.text;
 //    feedObj.dateOfFeed=[[APIManager sharedManager] getDate];
 //    feedObj.feedbackText=@"Issue closed";
 //    feedObj.feedbackCounter=[[NSString stringWithFormat:@"%@",[maxFeedIdAndCounterArray objectAtIndex:1]]intValue];
 //    feedObj.feedbackId=[[NSString stringWithFormat:@"%@",[maxFeedIdAndCounterArray objectAtIndex:0]]intValue];
 //    feedObj.attachment=@"";
 //
 //
 //    feedObj.statusId=[[NSString stringWithFormat:@"%@",[maxFeedIdAndCounterArray objectAtIndex:2]]intValue];
 //    feedObj.operatorId=[[NSString stringWithFormat:@"%@",[maxFeedIdAndCounterArray objectAtIndex:3]]intValue];
 //
 //    NSArray* keys=[NSArray arrayWithObjects:@"soNumber",@"userFrom",@"userTo",@"userFeedback",@"feedText",@"feedbackType",@"statusId",@"operatorId",@"emailSubject",@"attachment", nil];
 //
 //
 //    NSArray* values=@[feedObj.soNumber,[NSString stringWithFormat:@"%d",feedObj.userFrom],[NSString stringWithFormat:@"%d",feedObj.userTo],[NSString stringWithFormat:@"%d",feedObj.userFeedback],feedObj.feedbackText,[NSString stringWithFormat:@"%d",feedObj.feedbackType],[NSString stringWithFormat:@"%d",2],[NSString stringWithFormat:@"%d",feedObj.operatorId],feedObj.emailSubject,feedObj.attachment];
 //
 //    NSDictionary* dic=[NSDictionary dictionaryWithObjects:values forKeys:keys];
 //
 //
 //
 //
 //
 //
 //    [[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"];
 //    [[NSUserDefaults standardUserDefaults] valueForKey:@"currentPassword"];
 //
 //
 //
 //    [[APIManager sharedManager] sendUpdatedRecords:[[NSUserDefaults standardUserDefaults] valueForKey:@"flag"] Dict:dic username:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"] password:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentPassword"]];
 //}
 
 
 //get latest records and insert in db after sending our text
 - (void)getLatestRecord:(NSNotification *)notificationData
 {
 if ([[notificationData.object objectForKey:@"code"] isEqualToString:SUCCESS])
 {
 Database *db=[Database shareddatabase];
 //AppPreferences *app=[AppPreferences sharedAppPreferences];
 FeedbackChatingCounter* feedObject= [app.FeedbackOrQueryDetailChatingObjectsArray objectAtIndex:0];
 
 //        NSString* str=[[NSUserDefaults standardUserDefaults] valueForKey:@"flag"] ;
 //        if ([str isEqualToString:@"0"])
 //        {
 [db insertUpdatedRecordsForFeedcom:notificationData.object];                          //insert response date
 [db getDetailMessagesofFeedbackOrQuery:feedObject.feedbackType :feedObject.soNumber]; //fetch updated data after inserting response data
 //            sendTextView.text=@"";
 
 feedObject= [app.FeedbackOrQueryDetailChatingObjectsArray lastObject];
 
 if (feedObject.statusId==2)
 {
 [self.view viewWithTag:202].userInteractionEnabled=NO;
 UILabel* statusLabel= [self.view viewWithTag:201];
 statusLabel.textColor=[UIColor redColor];
 
 statusLabel.text=@"Closed";
 }
 [self keyboardWillShow:nil];
 
 // [tableview reloadData];
 //        }
 //        else
 //        {
 //            [db insertUpdatedRecordsForQueryCom:notificationData.object];
 //            [db getDetailMessagesofFeedbackOrQuery:feedObject.feedbackType :feedObject.soNumber];
 //            sendFeedbackTextfield.text=@"";
 //
 //            [tableview reloadData];
 //         }
 
 
 }
 }
 
 
 #pragma mark:tableView delegates
 
 - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
 {
 return 1;
 }
 
 
 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
 {
 if (tableView==tableview)
 {
 return app.FeedbackOrQueryDetailChatingObjectsArray.count;
 
 }
 else
 {
 Database* db=[Database shareddatabase];
 NSString* username = [[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"];
 NSString* companyId=[[Database shareddatabase] getCompanyId:username];
 NSString* companyId1;
 NSString* selectedCompany;
 if ([companyId isEqual:@"1"])
 {
 selectedCompany= [[NSUserDefaults standardUserDefaults] valueForKey:@"selectedCompany"];
 companyId1= [[Database shareddatabase] getCompanyIdFromCompanyName1:selectedCompany];
 }
 else
 {
 companyId1=@"1";
 }
 
 //NSString* companyId= [db getCompanyId:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentUsername"]];
 userObjectsArray= [db getAllUsersFirstnameLastname:companyId company2:companyId1];
 
 
 return userObjectsArray.count;
 
 }
 }
 
 //- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
 //{
 //    if (tableView==self.popupTableView)
 //    {
 //
 //    UIView* sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,self.popupTableView.frame.size.width,50)];
 //    sectionView.backgroundColor=[UIColor grayColor];
 //
 //    UISwitch* historySwitch=[[UISwitch alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
 //
 //    //    setAttendeeList
 //    UILabel* historyLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.popupTableView.frame.size.width/2, 10, self.popupTableView.frame.size.width/2, 20)];
 //historyLabel.text=@"Without history";
 //    [sectionView addSubview:historySwitch];
 //    [sectionView addSubview:historyLabel];
 //
 //    //UILabel *fileCountLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.tableView.frame.size.width-60, 5, 50, 40)];
 //    return  sectionView;
 //    }
 //    else
 //    {
 //        return nil;
 //    }
 //
 //}
 
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 
 if (tableView==self.tableview)
 {
 
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
 FeedbackChatingCounter* feedObject= [app.FeedbackOrQueryDetailChatingObjectsArray objectAtIndex:indexPath.row];
 
 
 Database* db=[Database shareddatabase];
 NSString* userRole=[db getUserIdFromUserNameWithRoll1:feedObject.userTo];
 if (cell!=nil)
 {
 cell.contentView.backgroundColor=[UIColor grayColor];
 if ([userRole isEqualToString:@"1"])
 {
 cell.contentView.backgroundColor=[UIColor colorWithRed:202.0/255 green:229.0/255 blue:159.0/255 alpha:1];
 
 }
 }
 
 if (feedObject.statusId==2)
 {
 //[self setNavigationItems:@""];
 }
 UILabel* userName= (UILabel*)[cell viewWithTag:50];
 userName.text=feedObject.userFrom;
 
 //    UILabel* feedText= (UILabel*)[cell viewWithTag:51];
 UIWebView* feedTextWebView1= (UIWebView*)[cell viewWithTag:51];
 UIWebView* feedTextWebView= [[UIWebView alloc]initWithFrame:CGRectMake(feedTextWebView1.frame.origin.x, feedTextWebView1.frame.origin.y, feedTextWebView1.frame.size.width, feedTextWebView1.frame.size.height)];
 
 //feedTextWebView.frame=feedTextWebView.frame;
 feedTextWebView1.delegate=self;
 feedTextWebView1.backgroundColor=[UIColor clearColor];
 [feedTextWebView1 setOpaque:NO];
 feedTextWebView1.scrollView.scrollEnabled = NO;
 feedTextWebView1.scrollView.bounces = NO;
 feedTextWebView1.scrollView.delegate=self;
 
 [feedTextWebView.scrollView setShowsVerticalScrollIndicator:NO];
 
 feedTextWebView.delegate=self;
 feedTextWebView.scrollView.delegate=self;
 feedTextWebView.backgroundColor=[UIColor clearColor];
 [feedTextWebView setOpaque:NO];
 feedTextWebView.scrollView.bounces = NO;
 
 feedTextWebView.scrollView.scrollEnabled = NO;
 feedTextWebView.scrollView.bounces = NO;   // NSString* detailMessage=[self stringByStrippingHTML:feedObject.detailMessage];
 //NSString* detailMessage=[feedObject.detailMessage stringByEncodingHTMLEntities];
 NSString* detailMessage=feedObject.detailMessage;
 
 detailMessage = [detailMessage stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"];
 detailMessage=[detailMessage stringByDecodingHTMLEntities];
 // detailMessage = [detailMessage stringByReplacingOccurrencesOfString:@"\n" withString:@"%0A"];
 
 // NSString* detailMessage=feedObject.detailMessage;
 CGSize goodSize = [feedTextWebView sizeThatFits:CGSizeMake(feedTextWebView.frame.size.width,feedTextWebView.frame.size.height)];
 NSLog(@"%f",cell.frame.size.height);
 NSLog(@"%f",goodSize.height);
 
 //   [feedTextWebView loadData:[detailMessage dataUsingEncoding:NSUTF8StringEncoding] MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:nil];
 // [feedTextWebView loadHTMLString:detailMessage baseURL:nil];
 NSData *data = [detailMessage dataUsingEncoding:NSNonLossyASCIIStringEncoding];
 NSString *valueUnicode = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
 
 
 NSData *dataa = [valueUnicode dataUsingEncoding:NSUTF8StringEncoding];
 NSString *valueEmoj = [[NSString alloc] initWithData:dataa encoding:NSNonLossyASCIIStringEncoding];
 
 // _lbl.text = valueEmoj;
 //        valueEmoj =
 //        [NSString stringWithFormat:@"<font face='HelveticaNeue'>%@", valueEmoj];
 [feedTextWebView loadHTMLString:valueEmoj baseURL:nil];
 UILabel* feedTime= (UILabel*)[cell viewWithTag:52];
 NSString* dd=feedObject.dateOfFeed;
 NSArray *components = [dd componentsSeparatedByString:@" "];
 NSString *date = components[0];
 NSString *time = components[1];
 feedTime.text=[NSString stringWithFormat:@"%@   %@",date,time];
 
 UILabel* attachmentLabel= (UILabel*)[cell viewWithTag:53];
 NSString* allAttachmentsNamesString=[self stringByStrippingHTML:feedObject.attachments];
 NSArray* attachmentsNamesArray=[allAttachmentsNamesString componentsSeparatedByString:@"#@$"];
 
 
 
 NSString *attachmentString = @"";
 if (attachmentsNamesArray.count > 0)
 {
 attachmentString = attachmentsNamesArray[0];
 }
 
 UIView *subView = [cell viewWithTag:10000];
 if (subView != nil)
 {
 [subView removeFromSuperview];
 }
 cell.tag = indexPath.row;
 if (attachmentString.length > 0)
 {
 if (attachmentsNamesArray.count>0)
 {
 CounterGraph* counterGraphObj=[[CounterGraph alloc]init];
 counterGraphObj.counterGraphlabel=attachmentLabel;
 counterGraphObj.attachmentArray=[NSArray arrayWithArray:attachmentsNamesArray];
 counterGraphObj.cell=cell;
 counterGraphObj.selectedIndex = (int)indexPath.row;
 [self performSelector:@selector(setCounterGraphLabel:) withObject:counterGraphObj afterDelay:0.0005];
 }
 }
 
 CGSize maximumLabelSize = CGSizeMake(96, FLT_MAX);
 
 //    CGSize expectedLabelSize = [feedObject.detailMessage sizeWithFont:feedText.font constrainedToSize:maximumLabelSize lineBreakMode:feedText.lineBreakMode];
 CGSize expectedLabelSize = [feedObject.detailMessage sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:maximumLabelSize lineBreakMode:UILineBreakModeWordWrap];
 
 CGRect newFrame = feedTextWebView.frame;
 newFrame.size.height = expectedLabelSize.height;
 feedTextWebView.frame = newFrame;
 feedTextWebView.tag=96;
 
 
 
 //        CGSize constrainedSize = CGSizeMake(self.view.frame.size.width-20  , 99999);
 //
 //        NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
 //                                              [UIFont fontWithName:@"HelveticaNeue" size:14.0], NSFontAttributeName,
 //                                              nil];
 //
 //                NSString* htmlString=feedObject.detailMessage;
 //
 //
 //        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:htmlString attributes:attributesDictionary];
 //
 //        CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
 //
 //
 //        CGRect newFrame1 = feedTextWebView.frame;
 //        newFrame1.size.height = requiredHeight.size.height;
 //        feedTextWebView.frame = newFrame;
 //
 
 if ([cell viewWithTag:96] !=NULL)
 {
 [[cell viewWithTag:96] removeFromSuperview];
 }
 //feedTextWebViewForHeight=feedTextWebView;
 // cell.frame.size.height=feedTextWebView.frame.size.height;
 [cell addSubview:feedTextWebView];
 return cell;
 
 }
 else
 {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
 if ([self.cellSelected containsObject:[NSString stringWithFormat:@"%ld",indexPath.row]])
 {
 cell.accessoryType = UITableViewCellAccessoryCheckmark;
 }
 else
 {
 cell.accessoryType = UITableViewCellAccessoryNone;
 
 }
 cell.tag=indexPath.row;
 UILabel* attendeeNameLabel= [cell viewWithTag:97];
 
 
 User* userObject= [userObjectsArray objectAtIndex:indexPath.row];
 attendeeNameLabel.text=[NSString stringWithFormat:@"%@ %@",userObject.firstName,userObject.lastName];
 
 return cell;
 
 }
 }
 //-(void)scrollViewDidScroll:(UIScrollView *)scrollView
 //{
 //    if ([scrollView.superview isKindOfClass:[UIWebView class]])
 //    {
 //        if (scrollView.contentOffset.y > 0  ||  scrollView.contentOffset.y < 0 )
 //            scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
 //    }
 //
 //}
 - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (tableView==self.tableview)
 {
 FeedbackChatingCounter* feedObject= [app.FeedbackOrQueryDetailChatingObjectsArray objectAtIndex:indexPath.row];
 
 UILabel* feedTextLbl= [[UILabel alloc]initWithFrame:CGRectMake(5.0f, 10.0f, self.view.frame.size.width - 20.0f, 30.0f)];
 UILabel* feedTextLbl1= [[UILabel alloc]initWithFrame:CGRectMake(5.0f, 10.0f, self.view.frame.size.width - 20.0f, 30.0f)];
 
 //        UIWebView* feedTextWebView= [[UIWebView alloc]initWithFrame:CGRectMake(10, 10, self.view.frame.size.width-20, 23)];
 //        [feedTextWebView loadHTMLString:feedObject.detailMessage baseURL:nil];
 
 feedTextLbl.text=feedObject.detailMessage;
 feedTextLbl1.text=feedObject.attachments;
 feedTextLbl.text= [feedTextLbl.text stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
 
 [feedTextLbl setFont:[UIFont systemFontOfSize:14.0f]];
 [feedTextLbl1 setFont:[UIFont systemFontOfSize:12.0f]];
 
 feedTextLbl.lineBreakMode = UILineBreakModeWordWrap;
 feedTextLbl.numberOfLines = 10000000;
 //
 CGRect newFrame= [self getFrameSize:feedObject label:feedTextLbl];
 CGRect newFrame2= [self getFrame:feedObject label:feedTextLbl1];
 
 
 //  float h1= [self getFrameSize:feedObject label:feedTextLbl];
 //   float h2= [self getFrame:feedObject label:feedTextLbl1];
 //NSLog(@"%f",feedTextWebView.frame.size.height);
 //NSLog(@"%@",feedObject.detailMessage);
 
     if (newFrame.size.height<100)
     {
         return 60+newFrame.size.height+newFrame2.size.height;

     }
     else
         if (newFrame.size.height>100 && newFrame.size.height<200)
         {
             return 200+newFrame.size.height+newFrame2.size.height;

         }
     else
     {
         return 300+newFrame.size.height+newFrame2.size.height;

     }
 
 // return 60+newFrame.size.height+newFrame1.size.height;
 //return 60 + h1+h2;
 //     NSLog(@"%f",feedTextWebView.frame.size.height);
 
 }
 
 else
 {
 return 50;
 }
 }
 
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (tableView==self.popupTableView)
 {
 
 if ([self.cellSelected containsObject:[NSString stringWithFormat:@"%ld",indexPath.row]])
 {
 
 [self.cellSelected removeObject:[NSString stringWithFormat:@"%ld",indexPath.row]];
 }
 else
 {
 [self.cellSelected addObject:[NSString stringWithFormat:@"%ld",indexPath.row]];
 }
 
 [self.popupTableView reloadData];
 }
 }
 
 - (void)webViewDidFinishLoad:(UIWebView *)aWebView
 {
 //    [tableview beginUpdates];
 //    [tableview endUpdates];
 CGRect frame = aWebView.frame;
 frame.size.height = 1;
 aWebView.frame = frame;
 CGSize fittingSize = [aWebView sizeThatFits:CGSizeZero];
 frame.size = fittingSize;
 aWebView.frame = frame;
 //    CGRect frame = aWebView.frame;
 //    frame.size.height = 1;
 //    aWebView.frame = frame;
 //    CGSize fittingSize = [aWebView sizeThatFits:CGSizeZero];
 //    frame.size = fittingSize;
 //    aWebView.frame = frame;
 // self.cellSize = fittingSize.height;
 
 // [self.tableview beginUpdates];
 // [self.tableview endUpdates];
 //NSString *output = [webView stringByEvaluatingJavaScriptFromString:@"document.body. scrollHeight;"];
 //    feedTextWebViewForHeight=aWebView;
 float sourcesWebViewHeight = [[aWebView stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollHeight"] floatValue];
 
 NSLog(@"%f", sourcesWebViewHeight);
 
 }
 #pragma mark:height for cell;supporting methods
 
 -(void)setCounterGraphLabel:(CounterGraph*)counterGraphObj
 {
 UIView *subView = [counterGraphObj.cell viewWithTag:10000];
 
 if (subView != nil)
 {
 [subView removeFromSuperview];
 }
 
 if (counterGraphObj.selectedIndex != counterGraphObj.cell.tag)
 {
 return;
 }
 
 UIView* attachmentSubView=[[UIView alloc]init];
 attachmentSubView.tag=10000;
 float yPosOfLbl = 10.0f;
 for (int i=0,j=0,k=1; i<counterGraphObj.attachmentArray.count; i++,k++)
 {
 
 if (![[counterGraphObj.attachmentArray objectAtIndex:i]  isEqual:@""] )
 {
 
 [attachmentSubView setFrame:CGRectMake(counterGraphObj.counterGraphlabel.frame.origin.x, counterGraphObj.cell.frame.size.height-(50*k), 320, 34*(counterGraphObj.attachmentArray.count))];
 
 
 UILabel* label=[[UILabel alloc]init];
 //label.tag=10000;
 label.font=[UIFont systemFontOfSize:12];
 [label setFrame:CGRectMake(counterGraphObj.counterGraphlabel.frame.origin.x, (yPosOfLbl*i*4), 200, counterGraphObj.counterGraphlabel.frame.size.height)];
 label.text=[counterGraphObj.attachmentArray objectAtIndex:i];
 if (label.text.length>12)
 {
 label.text= [label.text substringFromIndex:13];
 
 }
 
 
 
 
 NSString* filePath=[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/Attachments/%@",[counterGraphObj.attachmentArray objectAtIndex:i]]];
 
 UIImageView* attachmentDownloadImageView=[[UIImageView alloc]init];
 //attachmentDownloadImageView.
 attachmentDownloadImageView.contentMode = UIViewContentModeScaleAspectFit;
 if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
 {
 attachmentDownloadImageView.image=[UIImage imageNamed:@"FileDownload"];
 [attachmentDownloadImageView setFrame:CGRectMake(205, (yPosOfLbl*i*4),20, 20)];
 }
 else
 {
 attachmentDownloadImageView.image=[UIImage imageNamed:@"ViewAttachment"];
 [attachmentDownloadImageView setFrame:CGRectMake(205, (yPosOfLbl*i*4),20, 20)];
 }
 
 
 
 
 UIButton* attachmentDownloadButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
 [attachmentDownloadButton setFrame:CGRectMake(counterGraphObj.counterGraphlabel.frame.origin.x, (yPosOfLbl*i*4), 300, counterGraphObj.counterGraphlabel.frame.size.height)];
 //attachmentDownloadButton.backgroundColor=[UIColor redColor];
 attachmentDownloadButton.titleLabel.text=[counterGraphObj.attachmentArray objectAtIndex:i];
 //                             attachmentDownloadButton.userInteractionEnabled=YES;
 [attachmentDownloadButton addTarget:self action:@selector(downloadFileUsingFTP:) forControlEvents:UIControlEventTouchUpInside];
 
 
 
 [attachmentSubView addSubview:label];
 [attachmentSubView addSubview:attachmentDownloadImageView];
 [attachmentSubView addSubview:attachmentDownloadButton];
 
 attachmentSubView.userInteractionEnabled=YES;
 
 
 
 [counterGraphObj.cell addSubview:attachmentSubView];
 }
 
 }
 
 
 
 
 }
 
 //-(void)showFilePreviewOrDownload:(UIButton*)sender
 //{
 //
 //    NSError* error;
 //    NSString *destpath;
 //    //NSString* stringURL = [NSString stringWithFormat:@"http://localhost:9090/coreflex/resources/CfsFiles/%@",sender.titleLabel.text];
 //    //NSString* stringURL = [NSString stringWithFormat:@"http://localhost:8080/coreflex/resources/CfsFiles/%@",sender.titleLabel.text];
 //    NSString* stringURL = [NSString stringWithFormat:@"%@%@",HTTP_UPLOAD_PATH,sender.titleLabel.text];
 //
 //    NSString* webStringURL = [stringURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
 //    NSURL* url = [NSURL URLWithString:webStringURL];
 ////    hud.label.text = NSLocalizedString(@"Please wait...", @"HUD Loading title");
 ////    hud.minSize = CGSizeMake(150.f, 100.f);
 ////    hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
 // //   [hud hideAnimated:YES];
 //
 //    destpath=[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/Attachments/%@",sender.titleLabel.text]];
 //
 //    NSString* filePath=[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/Attachments"]];
 //
 //    if (![[NSFileManager defaultManager] fileExistsAtPath:destpath])
 //    {
 //        if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
 //            [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
 //
 //
 //            NSData * data = [NSData dataWithContentsOfURL:url];
 //            [data writeToFile:destpath atomically:YES];
 //            [self.tableview reloadData];
 //
 //
 //    }
 //
 //    else
 //    {
 //        NSString* fileURL=[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/Attachments/%@",sender.titleLabel.text]];
 //        NSURL* file = [NSURL fileURLWithPath:fileURL];
 //
 //        UIDocumentInteractionController* documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:file];
 //
 //
 //        [documentInteractionController setDelegate:self];
 //        [documentInteractionController presentOpenInMenuFromRect:self.view.frame inView:self.view animated:YES];
 //
 //        [documentInteractionController presentPreviewAnimated:YES];
 //
 //    }
 //
 //
 //
 //}
 
 - (UIViewController *) documentInteractionControllerViewControllerForPreview: (UIDocumentInteractionController *) controller
 {
 return self;
 }
 -(CGRect)getFrame:(FeedbackChatingCounter*)feedObject label:(UILabel*)feedTextLbl
 {
 NSString* attachmentString= feedObject.attachments;
 NSArray* allAttachmentArray= [attachmentString componentsSeparatedByString:@"|"];
 NSString* attachmentName;
 for (int i=0; i<allAttachmentArray.count; i++)
 {
 attachmentName=  [allAttachmentArray objectAtIndex:i];
 }
 CGSize maximumLabelSize = CGSizeMake(96, 100);
 
 CGSize expectedLabelSize = [attachmentName sizeWithFont:feedTextLbl.font constrainedToSize:maximumLabelSize lineBreakMode:feedTextLbl.lineBreakMode];
 
 //adjust the label the the new height.
 CGRect newFrame = feedTextLbl.frame;
 newFrame.size.height = expectedLabelSize.height*allAttachmentArray.count;
 
 
 //
 //    CGSize constrainedSize = CGSizeMake(feedTextLbl.frame.size.width  , 9999);
 //
 //    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
 //                                          [UIFont fontWithName:@"HelveticaNeue" size:14.0], NSFontAttributeName,
 //                                          nil];
 //
 //    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:attachmentName attributes:attributesDictionary];
 //
 //    CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
 //
 //    if (requiredHeight.size.width > feedTextLbl.frame.size.width) {
 //        requiredHeight = CGRectMake(0,0, feedTextLbl.frame.size.width, requiredHeight.size.height);
 //    }
 //    CGRect newFrame = feedTextLbl.frame;
 //    newFrame.size.height = requiredHeight.size.height;
 //    feedTextLbl.frame = newFrame;
 
 if (attachmentName==NULL)
 {
 newFrame.size.height = 10.0f;
 
 }
 else
 if (newFrame.size.height < 20)
 {
 newFrame.size.height = 20.0f;
 }
 
 //return newFrame.size.height;
 return newFrame;
 
 }
 -(CGRect)getFrameSize:(FeedbackChatingCounter*)feedObject label:(UILabel*)feedTextLbl
 {
 CGSize maximumLabelSize = CGSizeMake(feedTextLbl.frame.size.width, MAXFLOAT);
 
 CGSize expectedLabelSize = [feedObject.detailMessage sizeWithFont:feedTextLbl.font constrainedToSize:maximumLabelSize lineBreakMode:feedTextLbl.lineBreakMode];
 
 //adjust the label the the new height.
 CGRect newFrame = feedTextLbl.frame;
 newFrame.size.height = expectedLabelSize.height;
 if (newFrame.size.height < 20)
 {
 newFrame.size.height = 20.0f;
 }
 
 
 
 
 
 
 //    CGSize constrainedSize = CGSizeMake(self.view.frame.size.width-20  , 99999);
 //
 //    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
 //                                          [UIFont fontWithName:@"HelveticaNeue" size:14.0], NSFontAttributeName,
 //                                          nil];
 //
 //
 //
 //    NSString* htmlString=feedObject.detailMessage;
 //
 //    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:htmlString attributes:attributesDictionary];
 //
 //    CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
 //
 //
 //    CGRect newFrame = feedTextLbl.frame;
 //    newFrame.size.height = requiredHeight.size.height;
 //    feedTextLbl.frame = newFrame;
 
 
 //return requiredHeight.size.height;
 return newFrame;
 
 }
 
 #pragma mark:remove html tags
 
 -(NSString *) stringByStrippingHTML:(NSString *) stringWithHtmlTags {
 NSRange r;
 while ((r = [stringWithHtmlTags rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
 stringWithHtmlTags = [stringWithHtmlTags stringByReplacingCharactersInRange:r withString:@""];
 return stringWithHtmlTags;
 }
 
 
 #pragma mark:image picker delegates
 - (void)imagePickerController:(UIImagePickerController *)picker
 didFinishPickingImage:(UIImage *)image
 editingInfo:(NSDictionary *)editingInfo
 {
 
 [self dismissViewControllerAnimated:YES completion:NULL];
 }
 
 #pragma mark:self view action methods
 
 - (IBAction)sendFeedbackButtonClicked:(id)sender
 {
 NSString* userFrom,* userTo;
 if ([sendTextView.text length] <= 0)
 {
 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Empty message!" message:@"Please enter some message and try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
 [alertView show];
 }
 
 else
 {
 [sendTextView resignFirstResponder];
 Database* db=[Database shareddatabase];
 FeedbackChatingCounter* feedObject= [app.FeedbackOrQueryDetailChatingObjectsArray objectAtIndex:0];
 FeedbackChatingCounter *lastFeedObj=[app.FeedbackOrQueryDetailChatingObjectsArray lastObject];
 
 long maxFeedCounterOfCurrentSoNoAndType= lastFeedObj.feedbackCounter;
 NSString* username = [[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"];
 NSString* companyId=[db getCompanyId:username];
 NSString* userFeedback=[db getUserIdFromUserName:username];
 NSMutableArray* maxFeedIdAndCounterArray=[db getMaxFeedIdAndCounter:feedObject.soNumber :feedObject.feedbackType];
 if ([companyId isEqual:@"1"])
 {
 userFrom= [[Database shareddatabase] getAdminUserId];
 username=[db getUserNameFromCompanyname:[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedCompany"]];
 userTo=[db getUserIdFromUserNameWithRoll1:username];
 
 }
 
 else
 {
 userTo=[[Database shareddatabase] getAdminUserId];
 userFrom= [db getUserIdFromUserNameWithRoll1:username];
 }
 
 Feedback* feedObj=[[Feedback alloc]init];
 feedObj.soNumber = feedObject.soNumber;
 feedObj.emailSubject = feedObject.emailSubject;
 feedObj.feedbackType = feedObject.feedbackType;
 feedObj.userFrom=[userFrom intValue];
 feedObj.userTo=[userTo intValue];
 feedObj.userFeedback=[userFeedback intValue];
 
 
 NSString* feedText = sendTextView.text;
 /*
 NSDictionary *documentAttributes = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
 NSData *htmlData = [feedText dataFromRange:NSMakeRange(0, feedText.length) documentAttributes:documentAttributes error:NULL];
 
 NSString *htmlString = [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding];
 */
//feedObj.feedbackText =[feedObj.feedbackText stringByDecodingHTMLEntities];
// feedObj.feedbackText=[feedText stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
// feedObj.feedbackText = [sendTextView.text stringByReplacingOccurrencesOfString: @"\n" withString: @"\\n"];


//       htmlString=[htmlString stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
//
//feedText= [feedText stringByEncodingHTMLEntities];
// feedObj.feedbackText =htmlString;
//   feedObj.feedbackText= [feedText stringByReplacingOccurrencesOfString:@"&" withString:@"\u0026"];
// [NSString stringWithFormat:@"%C",@"\u0026"];
// feedObj.feedbackText= [feedText gtm_stringByEscapingForAsciiHTML];
//        NSData *data = [@"&" dataUsingEncoding:NSASCIIStringEncoding];
//        NSString* converted=  [[NSString alloc] initWithData:data encoding:NSNonLossyASCIIStringEncoding];
//        feedObj.feedbackText=[feedText stringByReplacingOccurrencesOfString: @"&" withString: converted];
//feedObj.feedbackText=[feedText stringByEncodingHTMLEntities];

feedObj.feedbackText= [feedText stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];

feedObj.feedbackText=[feedObj.feedbackText stringByReplacingOccurrencesOfString: @"&" withString: @"and"];
feedObj.dateOfFeed=[[APIManager sharedManager] getDate];
feedObj.feedbackCounter=[[NSString stringWithFormat:@"%@",[maxFeedIdAndCounterArray objectAtIndex:1]]longLongValue];
feedObj.feedbackId=[[NSString stringWithFormat:@"%@",[maxFeedIdAndCounterArray objectAtIndex:0]]longLongValue];


NSString *uploadedFileNamesString = @"";
if (app.uploadedFileNamesArray.count==1)
{
    uploadedFileNamesString = [NSString stringWithFormat:@"%@", [app.uploadedFileNamesArray objectAtIndex:0]];
}
else

if (app.uploadedFileNamesArray.count>1)
{
    for (int i = 0; i<app.uploadedFileNamesArray.count; i++)
    {
        
        if (i == 0)
        {
            uploadedFileNamesString = [NSString stringWithFormat:@"%@", [app.uploadedFileNamesArray objectAtIndex:i]];
            
        }
        else
        {
            uploadedFileNamesString=[uploadedFileNamesString stringByAppendingString:[NSString stringWithFormat:@"%@",[app.uploadedFileNamesArray objectAtIndex:i]]];
            
        }
        
        
    }
    
    
}


uploadedFileNamesString = [uploadedFileNamesString stringByReplacingOccurrencesOfString:@"/" withString:@""];
uploadedFileNamesString = [uploadedFileNamesString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
feedObj.attachment = uploadedFileNamesString;
if (app.uploadedFileNamesArray != nil)
{
    [app.uploadedFileNamesArray removeAllObjects];
}

//feedObj.statusId=[[NSString stringWithFormat:@"%@",[maxFeedIdAndCounterArray objectAtIndex:2]]intValue];

UILabel* statusLabel= [self.view viewWithTag:201];

if ([statusLabel.text isEqual:@"Open"])
{
    feedObj.statusId=1;
}
else
{
    feedObj.statusId=2;
    
}
feedObj.operatorId=[[NSString stringWithFormat:@"%@",[maxFeedIdAndCounterArray objectAtIndex:3]]intValue];

//to make array as string

NSMutableString* userIdsString=[[NSMutableString alloc]init];

for (int i=0; i<userIdsArray.count; i++)
{
    if ([userIdsString isEqualToString:@""])
    {
        userIdsString =[NSMutableString stringWithFormat:@"%@",[userIdsArray objectAtIndex:i]];
        
    }
    else
        userIdsString =[NSMutableString stringWithFormat:@"%@,%@",userIdsString,[userIdsArray objectAtIndex:i]];
        }



NSArray* keys=[NSArray arrayWithObjects:@"soNumber",@"userFrom",@"userTo",@"userFeedback",@"feedText",@"feedbackType",@"statusId",@"operatorId",@"emailSubject",@"attachment",@"userIds",@"historyFlag",@"maxCounter", nil];


NSArray* values=@[feedObj.soNumber,[NSString stringWithFormat:@"%d",feedObj.userFrom],[NSString stringWithFormat:@"%d",feedObj.userTo],[NSString stringWithFormat:@"%d",feedObj.userFeedback],feedObj.feedbackText,[NSString stringWithFormat:@"%d",feedObj.feedbackType],[NSString stringWithFormat:@"%d",feedObj.statusId],[NSString stringWithFormat:@"%d",feedObj.operatorId],feedObj.emailSubject,feedObj.attachment,userIdsString,[NSString stringWithFormat:@"%d",historyFlag],[NSString stringWithFormat:@"%ld",maxFeedCounterOfCurrentSoNoAndType] ];

NSDictionary* dic=[NSDictionary dictionaryWithObjects:values forKeys:keys];






[[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"];
[[NSUserDefaults standardUserDefaults] valueForKey:@"currentPassword"];


sendTextView.text=@"";
[self cancelReceipients];
[[APIManager sharedManager] sendUpdatedRecords:[[NSUserDefaults standardUserDefaults] valueForKey:@"flag"] Dict:dic username:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"] password:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentPassword"]];
// [db insertUserReply:feedObj];




}

}

#pragma mark:texfield delegates
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self moveViewUp:YES];
    
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self moveViewUp:NO];
    
}
- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    sendTextView.text = @"";
    sendTextView.textColor = [UIColor blackColor];
    return YES;
}
//
-(void) textViewDidChange:(UITextView *)textView
{

    if(sendTextView.text.length == 0){
        sendTextView.textColor = [UIColor lightGrayColor];
        sendTextView.text = @"Reply";
        
        [sendTextView resignFirstResponder];

    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    int numLines = textView.contentSize.height / textView.font.lineHeight;
    if (numLines > self.numberOfLines)
    {
        self.numberOfLines = numLines;
        textView.text = [NSString stringWithFormat:@"%@\n",textView.text];

        //numLinesInTextView is an instance variable
        //then do whatever you need to do on line change
    }
//    NSLog(@"%d",numLines);
//    if ([text isEqualToString:@"\n"]) {
//        textView.text = [NSString stringWithFormat:@"%@\n",textView.text];
//        NSLog(@"Return pressed, do whatever you like here");
//        return NO; // or true, whetever you's like
//    }

    return YES;
}
//-(BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    [textField resignFirstResponder];
//    return YES;
//}
//
//-(void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    [self moveViewUp:YES];
//}
//
//-(void)textFieldDidEndEditing:(UITextField *)textField
//{
//    [self moveViewUp:NO];
//}

- (void) moveViewUp: (BOOL) isUp
{
    const int movementDistance = 230; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    if (isUp)
    {
        //            movementDistance=totalMovement;
        //            totalMovement=0;
        long lastRowNumber = [tableview numberOfRowsInSection:0] - 1;
        NSIndexPath* ip = [NSIndexPath indexPathForRow:lastRowNumber inSection:0];
        [tableview scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:NO];
        
    }
    
    movement = (isUp ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    //    self.tableview.frame = CGRectOffset(self.tableview.frame, 0, -(2*movement));
    //   [tableview setContentInset:UIEdgeInsetsMake(0.f, 0.f, self.tableview.frame.size.width, self.tableview.frame.size.height/2)];
    //    _tableViewHeight.constant=100;
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    
    [UIView commitAnimations];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)switchValueChanged:(UISwitch*)sender
{
    UIView* mainView=  [self.view viewWithTag:2001];
    UIView* subView=  [mainView viewWithTag:2005];
    UILabel* historyLabel=  [subView viewWithTag:2007];
    if (sender.isOn)
    {
        historyFlag=1;
        
        historyLabel.text=@"With history";
    }
    else
    {
        historyFlag=2;
        historyLabel.text=@"Without history";
    }
}

- (IBAction)backButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addReceipientsButtonClicked:(id)sender
{
    UIView* popupView=[self.view viewWithTag:2001];
    [popupView setHidden:NO];
    
    [self stopUserInteraction];
    [self addIds];
}
-(void)stopUserInteraction
{
    [self.view viewWithTag:1001].userInteractionEnabled=NO;
    [self.view viewWithTag:4001].userInteractionEnabled=NO;
    [self.view viewWithTag:202].userInteractionEnabled=NO;
    
}
-(void)startUserInteraction
{
    [self.view viewWithTag:1001].userInteractionEnabled=YES;
    [self.view viewWithTag:4001].userInteractionEnabled=YES;
    [self.view viewWithTag:202].userInteractionEnabled=YES;
    
}
- (IBAction)cancelRecipientsButtonClicked:(id)sender
{
    [self cancelReceipients];
}

-(void)cancelReceipients
{
    UIView* popupView=[self.view viewWithTag:2001];
    [popupView setHidden:YES];
    
    self.cellSelected=nil;
    //self.attendiesTextView.text=nil;
    userIdsArray=nil;
    //serNamesArray=nil;
    self.cellSelected=[[NSMutableArray alloc]init];
    [self.popupTableView reloadData];
    [self startUserInteraction];
    //    userNamesArray=nil;
    //    userIdsArray=nil;
    // self.scrollview.userInteractionEnabled = YES;
    // [self.tableView setHidden:YES];
    
}

- (IBAction)doneRecipientsButtonClicked:(id)sender
{
    UIView* popupView=[self.view viewWithTag:2001];
    [popupView setHidden:YES];
    
    
    userIdsArray=[NSMutableArray new];
    // userNamesArray=[NSMutableArray new];
    for (int i=0; i<self.cellSelected.count; i++)
    {
        NSString* k=[self.cellSelected objectAtIndex:i];
        User* userobject= [userObjectsArray objectAtIndex:[k intValue]];
        //[userNamesArray addObject:[NSString stringWithFormat:@"%@ %@",userobject.firstName,userobject.lastName]];
        [userIdsArray addObject:[NSString stringWithFormat:@"%d",userobject.Id]];
        
    }
    
    // [self.tableView setHidden:YES];
    //    for (int j=0; j<userNamesArray.count; j++)
    //    {
    //        if (j==0)
    //        {
    //            attendiesTextView.text=[userNamesArray objectAtIndex:j];
    //
    //        }
    //        else
    //            attendiesTextView.text=[NSString stringWithFormat:@"%@,%@",attendiesTextView.text,[userNamesArray objectAtIndex:j]];
    //    }
    //    if (userNamesArray.count==0)
    //    {
    //        attendiesTextView.text=@"";
    //    }
    
    [self startUserInteraction];
    
}

- (IBAction)sendAttachment:(id)sender
{
    
    // UIViewController* vc= [self.storyboard instantiateViewControllerWithIdentifier:@"UploadFileViewController"];
    [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"UploadFileViewController"] animated:YES completion:nil];
}



//----------------------for FTP use only-----------

-(void)downloadFileUsingFTP:(UIButton*)sender
{
    NSString* folderName;
    NSError* error;
    NSString *destpath;
    //    hud.minSize = CGSizeMake(150.f, 100.f);
    //    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    hud.mode = MBProgressHUDModeIndeterminate;
    //    hud.label.text = @"Downloading..";
    //    hud.detailsLabel.text = @"Please wait";
    folderName=@"Attachments";
    
    destpath=[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@",folderName,sender.titleLabel.text]];
    //destpath=[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@",folderName,sender.titleLabel.text]];
    
    NSString* filePath=[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",folderName]];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:destpath])
    {
        if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
            [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
        [self startReceive:sender];
        
    }
    else
    {
        
        //NSString* fileURL=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Attachments/1469363039819Untitled.png"];
        NSString* fileURL=[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/Attachments/%@",sender.titleLabel.text]];
        
        NSURL* file = [NSURL fileURLWithPath:fileURL];
        
        UIDocumentInteractionController* documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:file];
        
        
        [documentInteractionController setDelegate:self];
        [documentInteractionController presentOpenInMenuFromRect:self.view.frame inView:self.view animated:YES];
        
        
        //documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:file];
        [documentInteractionController presentPreviewAnimated:YES];
        
    }
    
    
}


-(void)startReceive:(UIButton*)sender
{
    //   NSURL *url = [NSURL URLWithString:@"ftp://ftp.funet.fi/pub/standards/RFC/rfc959.txt"];
    downloadableAttachmentName=sender.titleLabel.text;
    // NSString* fileName=sender.titleLabel.text;
    //NSString* fileName=sender.titleLabel.text;
    
    NSString* username = [FTPUsername stringByReplacingOccurrencesOfString:@"@"
                                                                withString:@"%40"];
    
    NSString* password = [FTPPassword stringByReplacingOccurrencesOfString:@"@"
                                                                withString:@"%40"];
    
    
    
    NSString* urlString=[NSString stringWithFormat:@"ftp://%@:%@%@%@%@",username,password,FTPHostName,FTPFilesFolderName,downloadableAttachmentName];
    
    // NSURL *url = [NSURL URLWithString:@"ftp://demoFtp%40pantudantukids.com:asdf123@pantudantukids.com:21/TEST/1469363039819Untitled.png"];
    NSURL *url = [NSURL URLWithString:urlString];
    
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    //sessionConfiguration.URLCredentialStorage = cred_storage;
    sessionConfiguration.allowsCellularAccess = YES;
    
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
    
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:url];
    [downloadTask resume];
    
    [self performSelectorOnMainThread:@selector(showHud) withObject:nil waitUntilDone:NO];
    
}


- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error
{
    [self performSelectorOnMainThread:@selector(hideHud) withObject:nil waitUntilDone:NO];
    NSLog(@"errors %@",error.debugDescription);
}
- (void)URLSession:(nonnull NSURLSession *)session task:(nonnull NSURLSessionTask *)task didReceiveChallenge:(nonnull NSURLAuthenticationChallenge *)challenge completionHandler:(nonnull void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * __nullable))completionHandler
{
    
}
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSData *data = [NSData dataWithContentsOfURL:location];
    NSString* destpath=[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/Attachments/%@",downloadableAttachmentName]];
    
    [data writeToFile:destpath atomically:YES];
    //[hud hideAnimated:YES];
    //[self performSelectorOnMainThread:@selector(hideHud) withObject:nil waitUntilDone:NO];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //[self.progressView setHidden:YES];
        //[self.imageView setImage:[UIImage imageWithData:data]];
    });
}
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    float progress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
    NSLog(@"progress %f",progress);
    NSString* progressPercent= [NSString stringWithFormat:@"Downloading..%f",progress*100];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        if (progress==1)
        {
            [hud hideAnimated:YES];
        }
        //        hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        //        [hud hideAnimated:YES];
        //
        //        hud.label.text = NSLocalizedString(progressPercent, @"HUD Loading title");
        //        hud.minSize = CGSizeMake(150.f, 100.f);
        //[self.progressView setProgress:progress];
    });
}
-(void)hideHud
{
    [self.tableview reloadData];
    [hud hideAnimated:YES];
}
-(void)showHud
{
    hud.minSize = CGSizeMake(150.f, 100.f);
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    //hud.label.text = [NSString stringWithFormat:@"Downloading(%f%%)",progress*100];
    hud.label.text = [NSString stringWithFormat:@"Downloading.."];
    
    hud.detailsLabel.text = @"Please wait";
}
- (IBAction)issueCloseButtonClicked:(id)sender
{
    NSArray* subViewArray=[NSArray arrayWithObjects:@"Open",@"Close", nil];
    popUpView=[[PopUpCustomView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+self.view.frame.size.width-175, self.view.frame.origin.y+100, 160, 80) andSubViews:subViewArray :self];
    [[[UIApplication sharedApplication] keyWindow] addSubview:popUpView];
    
    // [self closeIssue];
}
-(void)addIds
{
    [self.popupTableView reloadData];
    
    [[self.view viewWithTag:2001] setHidden:NO];
    // self.view.userInteractionEnabled = NO;
}

-(void)dismissPopView:(id)sender
{
    
    UIView* overlay= [[[UIApplication sharedApplication] keyWindow] viewWithTag:111];
    if ([overlay isKindOfClass:[UIView class]])
    {
        [[[[UIApplication sharedApplication] keyWindow] viewWithTag:111] removeFromSuperview];
    }
    
}

-(void)Open
{
    [[[[UIApplication sharedApplication] keyWindow] viewWithTag:111] removeFromSuperview];
    UILabel* statusLabel= [self.view viewWithTag:201];
    
    statusLabel.text=@"Open";
    
}

-(void)Close
{
    [[[[UIApplication sharedApplication] keyWindow] viewWithTag:111] removeFromSuperview];
    UILabel* statusLabel= [self.view viewWithTag:201];
    statusLabel.text=@"Close";
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    UIView* whitePopupView= [popUpView viewWithTag:561];
    if ([touch.view isDescendantOfView:whitePopupView])
    {
        
        return NO;
    }
    
    return YES; // handle the touch
}


-(void)viewWillDisappear:(BOOL)animated
{
    //FeedcomQuerycomViewController* vc=[[FeedcomQuerycomViewController alloc]init];
    //[vc prepareForSearchBar];
    //[vc reloadData];
    //
    [[[UIApplication sharedApplication].keyWindow viewWithTag:901] removeFromSuperview];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ADD_FEEDBACK_BUTTON object:nil];
}

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    float endScrolling = scrollView.contentOffset.y + scrollView.frame.size.height;
//    if (endScrolling >= scrollView.contentSize.height)
//    {
//        NSLog(@"Scroll End Called");
//        [self refreshTable];
//
//    }
//}
@end



