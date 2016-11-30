//http://localhost:9090/coreflex/resources/CfsFiles/1466172700295Download-3X.png
//146617501944601 Soch Na Sake - Version 1 Airlift (Arijit Singh) 190Kbps.mp3
//  ReportAndDocsViewController.m
//  Communicator
//
//  Created by mac on 24/05/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import "ReportAndDocsViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "Database.h"
#import "Report.h"
#import "UIColor+CommunicatorColor.h"
@interface ReportAndDocsViewController ()
//@property(nonatomic,strong) UIDocumentInteractionController* documentInteractionController;
@end

@implementation ReportAndDocsViewController
@synthesize hud;
@synthesize reportButton;
@synthesize reportButtonUnderlineView;
@synthesize documentButton;
@synthesize documentButtonUnderlineView,search,searchController;


- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self setSelectedButton:reportButton];
    documentButtonUnderlineView.hidden=YES;
    // Do any additional setup after loading the view.
    arrayForBool=[[NSMutableArray alloc]init];
    refreshControl = [[UIRefreshControl alloc]init];
    refreshControl.tag=1000;
    [self.tableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(get50Report:) name:NOTIFICATION_REPORT_LOAD_MORE_DATA
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(get50Document:) name:NOTIFICATION_DOCUMENT_LOAD_MORE_DATA
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadData) name:NOTIFICATION_UPADTE_REPORT_DOCS_VIEW
                                               object:nil];

    fileNameUserArray=[[NSMutableArray alloc]init];
//    sectionTitleArray=[[NSArray alloc]initWithObjects:
//                       @"Date 1",
//                       @"Date 2",
//                       @"Date 3",
//                       @"Date 4",
//                       @"Date 5",
//                       @"Date 5",
//                       @"Date 6",
//                       @"Date 7",
//                       nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(reloadData) name:NOTIFICATION_REPORT_NOTI_DATA
//                                               object:nil];
   
}
-(void)get50Report:(NSNotification*)data
{
    [[Database shareddatabase] insertLoadMoreReportNotificationData:data.object];
    [refreshControl endRefreshing];
}
-(void)get50Document:(NSNotification*)data
{
    [[Database shareddatabase] insertLoadMoreDocumentNotificationData:data.object];

    [refreshControl endRefreshing];

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
    NSMutableArray* feedbackIDsArray;
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"flag1"]isEqualToString:@"0"])
    {
       feedbackIDsArray= [[Database shareddatabase] getReportIds:userFrom userTo:userTo];

    }
    else
    {
        feedbackIDsArray= [[Database shareddatabase] getDocumentIds:userFrom userTo:userTo];

    }
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
    
    //int feedbackType=  [[Database shareddatabase] getFeedbackIdFromFeedbackType:self.feedbackType];
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"flag1"]isEqualToString:@"0"])
    {
        [[APIManager sharedManager] getLoadMoreReportData:username1 password:password userFrom:userFrom userTo:userTo feedbackIdsArray:feedIdsString];

    }
    else
    {
        [[APIManager sharedManager] getLoadMoreDocumentData:username1 password:password userFrom:userFrom userTo:userTo feedbackIdsArray:feedIdsString];

    }
    [self.tableView reloadData];
}

-(void)popViewController1
{
    //UINavigationController *navController = self.navigationController;
//    NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
//    [[APIManager sharedManager] logout:[defaults valueForKey:@"currentUser"] Password:[defaults valueForKey:@"currentPassword"]];
//
//    [defaults setObject:NULL forKey:@"userObject"];
//    [defaults setObject:NULL forKey:@"selectedCompany"];
//    
//    [defaults setValue:NULL forKey:@"currentUser"];
//    [defaults setValue:NULL forKey:@"currentPassword"];
    alertController = [UIAlertController alertControllerWithTitle:@"Logout?"
                                                          message:@"Are you sure to logout"
                                                   preferredStyle:UIAlertControllerStyleAlert];
    actionDelete = [UIAlertAction actionWithTitle:@"Yes"
                                            style:UIAlertActionStyleDefault
                                          handler:^(UIAlertAction * action)
                    {
                        [[AppPreferences sharedAppPreferences] logout];
                        UIViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
                        [[[UIApplication sharedApplication]keyWindow].rootViewController presentViewController:vc animated:NO completion:nil];
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
   
  //  [navController presentViewController:vc animated:YES completion:nil];
    
}

//-(void)uploadFileToServer
//{
//
//
//
//
//}-
-(void)reloadData
{
    Database *db=[Database shareddatabase];
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"flag1"]isEqualToString:@"0"])
    {
        [db setReportView];
    }
    else
    {
        [db setDocumentView];

    }
    [self setFilesDateWise];
    [self.tableView reloadData];
}
-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.navigationItem.title = @"Reports & Docs";
     //self.tabBarController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(popViewController1)] ;
    self.navigationController.navigationBar.backgroundColor = [UIColor communicatorColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
//    self.navigationController.navigationBar.barTintColor = [UIColor communicatorColor];
    [self.navigationController.navigationBar setBarStyle:UIStatusBarStyleLightContent];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SignOut"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController1)] ;
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Upload"] style:UIBarButtonItemStylePlain target:self action:@selector(selectFileToUpload:)] ;
    [self.navigationItem setHidesBackButton:NO];
    self.navigationController.navigationBar.barTintColor = [UIColor communicatorColor];
    self.navigationItem.leftBarButtonItem.tintColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem.tintColor=[UIColor whiteColor];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(get50Reports:) name:NOTIFICATION_GET_50REPORTS
//                                               object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(get50Documents:) name:NOTIFICATION_GET_50DOCUMENTS
//                                               object:nil];
//
    
    searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    searchController.searchResultsUpdater = self;
    searchController.searchBar.delegate = self;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES;
    //self.searchController.obscuresBackgroundDuringPresentation = NO;
    self.searchController.hidesNavigationBarDuringPresentation=NO;     // default is YES


    Database *db=[Database shareddatabase];
    [db setReportView];
    [self setFilesDateWise];
    [self setSelectedButton:reportButton];
    [self prepareSearchBar];

    
}

-(void)prepareSearchBar
{
    //feedTypeArray=[[NSMutableArray alloc]init];
   // sampleSectionTitleArray=[[NSMutableArray alloc]init];
    
  // samplePredicateSectionTitleArray=[[NSMutableArray alloc]init];
    
  //  Mom* ft2=[Mom new];
  //  [sampleSectionTitleArray addObjectsFromArray:sectionTitleArray];
  //  [samplePredicateSectionTitleArray addObjectsFromArray:sectionTitleArray];

    
    
    searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    searchController.searchResultsUpdater = self;
    searchController.searchBar.delegate = self;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES;
    //self.searchController.obscuresBackgroundDuringPresentation = NO;
    self.searchController.hidesNavigationBarDuringPresentation=NO;     // default is YES
    
    
}
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
   
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"name CONTAINS [cd] %@", self.searchController.searchBar.text];
    NSArray *predicateResultArray;
    
    
    if ([self.searchController.searchBar.text isEqual:@""])
    {
        // FeedQueryCounter *ft2=[[FeedQueryCounter alloc]init];
       // sampleSectionTitleArray=[[NSMutableArray alloc]init];
        
        //    [sampleSectionTitleArray addObjectsFromArray:sectionTitleArray];
        NSMutableArray* sampleArray=[NSMutableArray new];

        for (int i=0; i<fileNameUserArray.count; i++)
        {
            sampleArray= [fileNameUserArray objectAtIndex:i];
            [[AppPreferences sharedAppPreferences].reportFileNamesDictCopy setObject:[NSKeyedArchiver archivedDataWithRootObject:sampleArray] forKey:[sectionTitleArray objectAtIndex:i]];
        }

        [AppPreferences sharedAppPreferences].reportFileNamesDictCopy=[AppPreferences sharedAppPreferences].reportFileNamesDict;
            [self.tableView reloadData];
       
    }
    
    
    else
    {
       // sampleSectionTitleArray=[[NSMutableArray alloc]init];
        NSMutableArray* sampleArray=[NSMutableArray new];
        predicateResultArray=[[NSMutableArray alloc]init];
        for (int i=0; i<fileNameUserArray.count; i++)
        {
           sampleArray= [fileNameUserArray objectAtIndex:i];
            predicateResultArray =[sampleArray filteredArrayUsingPredicate:predicate];
            [[AppPreferences sharedAppPreferences].reportFileNamesDictCopy setObject:[NSKeyedArchiver archivedDataWithRootObject:predicateResultArray] forKey:[sectionTitleArray objectAtIndex:i]];
        }
        
        
        [self.tableView reloadData];
    }
}

-(void)selectFileToUpload:(NSString*)para
{
    UIViewController* vc= [self.storyboard instantiateViewControllerWithIdentifier:@"UploadFileViewController"];
    [self presentViewController:vc animated:YES completion:nil];

}

-(void)setFilesDateWise
{
    AppPreferences *app=[AppPreferences sharedAppPreferences];
    sectionTitleArray=[[NSMutableArray alloc]init];
    app.reportFileNamesDictCopy=app.reportFileNamesDict;
    sectionTitleArray= [NSMutableArray arrayWithArray:[app.reportFileNamesDictCopy allKeys]];
    NSString* temp;
    NSComparisonResult result;

//    for (int i=0; i<demoArray.count; i++)
//    {
//        NSString *strCurrentDate =[demoArray objectAtIndex:i];
//        NSString *strServerDate =[demoArray objectAtIndex:i+1];
    
    for (int i=0; i<sectionTitleArray.count; i++)
    {
        for (int j=1; j<sectionTitleArray.count-i; j++)
        {
            result=[[sectionTitleArray objectAtIndex:j-1] compare:[sectionTitleArray objectAtIndex:j]];
            if (result==NSOrderedAscending)
            {
                temp=[sectionTitleArray objectAtIndex:j-1];
                [sectionTitleArray replaceObjectAtIndex:j-1 withObject:[sectionTitleArray objectAtIndex:j]];
                [sectionTitleArray replaceObjectAtIndex:j withObject:temp];

            }
        }
    }
    
    
        //        NSComparisonResult result;
        
//        result = [currentDate compare:serverDate]; // comparing two dates
//        
//        if(result == NSOrderedAscending)
//            NSLog(@"current date is less");
//        else if(result == NSOrderedDescending)
//        {
//            NSLog(@"server date is less");
//
//        }
//        else if(result == NSOrderedSame)
//            NSLog(@"Both dates are same");
//        else
//            NSLog(@"Date cannot be compared");
   // }
    fileNameUserArray=nil;
    fileNameUserArray=[NSMutableArray new];

    for (int i=0; i<sectionTitleArray.count; i++)
    {
        
        NSString *encodedObjec= [sectionTitleArray objectAtIndex:i];
        NSData *encodedObject=[app.reportFileNamesDictCopy valueForKey:encodedObjec];
       // fileNameUserArray=[NSKeyedUnarchiver unarchiveObjectWithData:encodedObject] ;
                [fileNameUserArray addObject:[NSKeyedUnarchiver unarchiveObjectWithData:encodedObject]];
    }
    
    for (int i=0; i<[sectionTitleArray count]; i++)
    {
        [arrayForBool addObject:[NSNumber numberWithBool:NO]];
    }
    [self.tableView reloadData];


}


//- (void)get50Reports:(NSNotification *)notificationData
//{
//    if ([[notificationData.object objectForKey:@"code"] isEqualToString:SUCCESS])
//    {
//        NSLog(@"in noti");
//        Database *db=[Database shareddatabase];
//        [db insertReportData:notificationData.object];
//       // AppPreferences *app=[AppPreferences sharedAppPreferences];
//        
//    }
//}
//- (void)get50Documents:(NSNotification *)notificationData
//{
//    if ([[notificationData.object objectForKey:@"code"] isEqualToString:SUCCESS])
//    {
//        NSLog(@"in noti");
//        Database *db=[Database shareddatabase];
//        [db insertDocumentsData:notificationData.object];
//       // AppPreferences *app=[AppPreferences sharedAppPreferences];
//        
//    }
//}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [sectionTitleArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    AppPreferences* app=[AppPreferences sharedAppPreferences];
    if ([[arrayForBool objectAtIndex:section] boolValue])
    {
        NSString *encodedObjec= [sectionTitleArray objectAtIndex:section];
        NSData *encodedObject=[app.reportFileNamesDictCopy valueForKey:encodedObjec];
        NSMutableArray* file = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
        return file.count;
    }
    else
        return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 280,40)];
    sectionView.backgroundColor=[UIColor whiteColor];
    UILabel *fileCountLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.tableView.frame.size.width-120, 5, 110, 40)];
    fileCountLabel.textAlignment=NSTextAlignmentRight;
    //UIImage* fileClosed=[UIImage imageNamed:@"Fileclosed"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 35, 35)];
    if ([[arrayForBool objectAtIndex:section] boolValue])
    {
        
        imageView.image=[UIImage imageNamed:@"FileOpened"];
        [fileCountLabel removeFromSuperview];

    }
    else
    {
        AppPreferences* app=[AppPreferences sharedAppPreferences];

        NSString *encodedObjec= [sectionTitleArray objectAtIndex:section];
        NSData *encodedObject=[app.reportFileNamesDictCopy valueForKey:encodedObjec];
        NSMutableArray* file = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
        imageView.image=[UIImage imageNamed:@"Fileclosed"];
        fileCountLabel.text=[NSString stringWithFormat:@"%ld File(s)",file.count];
        [sectionView addSubview:fileCountLabel];
    }
        
    [sectionView addSubview:imageView];
    sectionView.tag=section;
    
   // UILabel* label=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 50, 40)];
    //UILabel* label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];

    UILabel *fileSectionLabel=[[UILabel alloc]initWithFrame:CGRectMake(imageView.frame.origin.x+imageView.frame.size.width+10, 5, self.tableView.frame.size.width*0.3, 40)];
    //label.text=@"hello";
    fileSectionLabel.backgroundColor=[UIColor clearColor];
    fileSectionLabel.textColor=[UIColor blackColor];
    fileSectionLabel.font=[UIFont systemFontOfSize:15];
    fileSectionLabel.text=[NSString stringWithFormat:@"%@",[sectionTitleArray objectAtIndex:section]];
    [sectionView addSubview:fileSectionLabel];
    
    
    /********** Add UITapGestureRecognizer to SectionView   **************/
    
    UITapGestureRecognizer  *headerTapped   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderTapped:)];
    [sectionView addGestureRecognizer:headerTapped];
    
    return  sectionView;
    
    
}

- (void)sectionHeaderTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:gestureRecognizer.view.tag];
    
    if (indexPath.row == 0)
    {
        BOOL collapsed  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
        for (int i=0; i<[sectionTitleArray count]; i++)
        {
            if (indexPath.section==i)
            {
                [arrayForBool replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:!collapsed]];
            }
        }
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:gestureRecognizer.view.tag] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    //cell.imageView.image=[UIImage imageNamed:@"Fileclosed"];
    AppPreferences* app=[AppPreferences sharedAppPreferences];
    BOOL manyCells  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
    NSString* filePath;
    /********** If the section supposed to be closed *******************/
    if(!manyCells)
    {
        cell.backgroundColor=[UIColor clearColor];
        
        cell.textLabel.text=@"";
    }
    /********** If the section supposed to be Opened *******************/
    else
    {
        UILabel* fileNameLabel=(UILabel*)[cell viewWithTag:101];
        NSString *encodedObjec= [sectionTitleArray objectAtIndex:indexPath.section];
        NSData *encodedObject=[app.reportFileNamesDictCopy valueForKey:encodedObjec];
       NSMutableArray* file = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
        
                   Report *obj= [file objectAtIndex:indexPath.row];
       

       UIButton* downloadButton=(UIButton*)[cell viewWithTag:103];
        downloadButton.titleLabel.text=obj.name;
        downloadButton.titleLabel.textColor=[UIColor clearColor];
        [downloadButton addTarget:self action:@selector(showFilePreviewOrDownload:) forControlEvents:UIControlEventTouchUpInside];

       // fileNameLabel.text=[NSString stringWithFormat:@"%@",obj.name];
        fileNameLabel.text= [obj.name substringFromIndex:13];

        fileNameLabel.font=[UIFont systemFontOfSize:15.0f];
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"flag1"]isEqualToString:@"0"])
        filePath=[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/Reports/%@",obj.name]];
    
        else
        filePath=[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/Documents/%@",obj.name]];
        UIImageView* fileDownloadImageView=(UIImageView*)[cell viewWithTag:102];
        fileDownloadImageView.contentMode=UIViewContentModeScaleAspectFit;
        if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
       {
        fileDownloadImageView.image=[UIImage imageNamed:@"FileDownload"];
       }
       else
       {
         fileDownloadImageView.image=[UIImage imageNamed:@"ViewAttachment"];
           
       }
       // cell.imageView.image=[UIImage imageNamed:@"point.png"];
       // cell.selectionStyle=UITableViewCellSelectionStyleNone ;
    }
    //cell.textLabel.textColor=[UIColor blackColor];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[arrayForBool objectAtIndex:indexPath.section] boolValue])
    {
        return 40;
    }
    return 0;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    
    UILabel* fileNameLabel=(UILabel*)[selectedCell viewWithTag:101];
    
    NSString* filenameString=fileNameLabel.text;

    //[self showFilePreviewOrDownload:filenameString];
    
}

-(void)showFilePreviewOrDownload:(UIButton*)sender
{
    NSString* folderName;
    NSError* error;
    NSString *destpath;
   // NSString* stringURL = [NSString stringWithFormat:@"http://localhost:9090/coreflex/resources/CfsFiles/%@",filenameString];
   // NSString* stringURL = [NSString stringWithFormat:@"%@%@",HTTP_UPLOAD_PATH,filenameString];

   // NSString* webStringURL = [stringURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
   // NSURL* url = [NSURL URLWithString:webStringURL];
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"flag1"]isEqualToString:@"0"])
    {
        folderName=@"Reports";
    }
    else
        folderName=@"Documents";
    
    //filenameString=@"1469363039819Untitled.png";
    destpath=[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@",folderName,sender.titleLabel.text]];
    
    NSString* filePath=[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",folderName]];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:destpath])
    {
      if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
            [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
        [self startReceive:sender];
      
    }
    else
    {
        NSString* fileURL=[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@",folderName,sender.titleLabel.text]];
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
      // NSString* fileName=@"1469363039819Untitled.png";
    //NSString* fileName=sender.titleLabel.text;
    downloadableAttachmentName=sender.titleLabel.text;

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
    
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error
{
    NSLog(@"errors %@",error.debugDescription);
}
- (void)URLSession:(nonnull NSURLSession *)session task:(nonnull NSURLSessionTask *)task didReceiveChallenge:(nonnull NSURLAuthenticationChallenge *)challenge completionHandler:(nonnull void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * __nullable))completionHandler
{
    
}
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSString* folderName;
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"flag1"]isEqualToString:@"0"])
    {
        folderName=@"Reports";
    }
    else
        folderName=@"Documents";

    NSData *data = [NSData dataWithContentsOfURL:location];
    NSString* destpath=[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@",folderName,downloadableAttachmentName]];
    
    [data writeToFile:destpath atomically:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [hud setHidden:YES];
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
        
        hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        [hud hideAnimated:YES];
        
        hud.label.text = NSLocalizedString(progressPercent, @"HUD Loading title");
        hud.minSize = CGSizeMake(150.f, 100.f);
        //[self.progressView setProgress:progress];
    });
}

- (UIViewController *) documentInteractionControllerViewControllerForPreview: (UIDocumentInteractionController *) controller
{
    return self;
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.tableView reloadData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//-(void)uploadFileToServer:(NSString *)fileName
//
//{
//    fileName = @"AppIcon80x80.png";
//    
//    
//    // NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", @"http://192.168.3.170:8080/coreflex/feedcom", @"uploadFileFromMobile"]];
//    
//  //  NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", @"http://localhost:9090/coreflex/feedcom", @"uploadFileFromMobile"]];
//    NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", BASE_URL_PATH, @"uploadFileFromMobile"]];
//
//    
//    NSString *boundary = [self generateBoundaryString];
//    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"AppIcon80x80" ofType:@"png"];
//    
//    // configure the request
//    NSDictionary *params = @{@"filename"     : @"AppIcon80x80.png",
//                             };
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
//    [request setHTTPMethod:@"POST"];
//    
//    // set content type
//    
//    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
//    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
//    
//    // create body
//    
//    NSData *httpBody = [self createBodyWithBoundary:boundary parameters:params paths:@[path] fieldName:fileName];
//    
//    request.HTTPBody = httpBody;
//    
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        if (connectionError)
//        {
//            NSLog(@"error = %@", connectionError);
//            return;
//        }
//        
//        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    }];
//    
//    
//    
//    
//    
//}



- (NSData *)createBodyWithBoundary:(NSString *)boundary
                        parameters:(NSDictionary *)parameters
                             paths:(NSArray *)paths
                         fieldName:(NSString *)fieldName
{
    NSMutableData *httpBody = [NSMutableData data];
    
    // add params (all params are strings)
    
    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *parameterKey, NSString *parameterValue, BOOL *stop) {
        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", parameterKey] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"%@\r\n", parameterValue] dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    
    // add image data
    
    for (NSString *path in paths)
    {
        NSString *filename  = [path lastPathComponent];
        NSData   *data      = [NSData dataWithContentsOfFile:path];
        NSString *mimetype  = [self mimeTypeForPath:path];
        
        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", fieldName, filename] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", mimetype] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:data];
        [httpBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [httpBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    return httpBody;
}


- (NSString *)mimeTypeForPath:(NSString *)path
{
    // get a mime type for an extension using MobileCoreServices.framework
    
    CFStringRef extension = (__bridge CFStringRef)[path pathExtension];
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, extension, NULL);
    assert(UTI != NULL);
    
    NSString *mimetype = CFBridgingRelease(UTTypeCopyPreferredTagWithClass(UTI, kUTTagClassMIMEType));
    assert(mimetype != NULL);
    
    CFRelease(UTI);
    
    return mimetype;
}


- (NSString *)generateBoundaryString
{
    return [NSString stringWithFormat:@"Boundary-%@", [[NSUUID UUID] UUIDString]];
}



-(void)setSelectedButton:(id)sender
{
    
    if (sender==reportButton)
    {
        Database *db=[Database shareddatabase];
        [db setReportView];
       [self setFilesDateWise];
                documentButtonUnderlineView.hidden=YES;
        reportButtonUnderlineView.hidden=NO;
        
        [documentButton setSelected:NO];
        [sender setSelected: YES];
        [sender setTitleColor:[UIColor colorWithRed:10/255.0 green:32/255.0 blue:47/255.0 alpha:1] forState:UIControlStateSelected];
        
        NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
        [defaults setValue:@"0" forKey:@"flag1"];
        [self.tableView reloadData];
        
    }
    
    if (sender==documentButton)
    {
        
        Database *db=[Database shareddatabase];
        [db setDocumentView];
        [self setFilesDateWise];

        reportButtonUnderlineView.hidden=YES;
        documentButtonUnderlineView.hidden=NO;
        
        [reportButton setSelected:NO];
        [sender setSelected: YES];
        [sender setTitleColor:[UIColor colorWithRed:9/255.0 green:45/255.0 blue:61/255.0 alpha:1] forState:UIControlStateSelected];
        
        NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
        [defaults setValue:@"1" forKey:@"flag1"];
        [self.tableView reloadData];
        
        
    }
    
}

- (IBAction)buttonClicked:(id)sender
{
    [self setSelectedButton:sender];
}

@end
