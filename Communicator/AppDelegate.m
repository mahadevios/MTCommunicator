//
//  AppDelegate.m
//  Communicator
//
//  Created by mac on 19/03/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "MainTabBarViewController.h"
#import "Database.h"
#import "UIColor+CommunicatorColor.h"
#import "CompanyNamesViewController.h"
#import "Firebase.h"
#import <FirebaseAnalytics/FirebaseAnalytics.h>
@import FirebaseMessaging;

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize navController,feedcomCommunicationCounterValue,tappedOnNotification;

UIStoryboard *mainStoryboard;

UINavigationController *navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //---FCM---//
    
    AppPreferences* app=[AppPreferences sharedAppPreferences];
    
    [app startReachabilityNotifier];
    
    //[NSThread sleepForTimeInterval:5]  ;
    
    [FIRApp configure];
    
    NSString *refreshedToken = [[FIRInstanceID instanceID] token];
    
    [AppPreferences sharedAppPreferences].firebaseInstanceId=refreshedToken;
    
    //NSLog(@"InstanceID token: %@", refreshedToken);
    
    // Connect to FCM since connection may have failed when attempted before having a token.
    [self connectToFcm];
    
    //register for remote notification
    
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        // iOS 8 Notifications
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        
        //return YES;
        [application registerForRemoteNotifications];
    }
    else
    {
        // iOS < 8 Notifications
        [application registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    }

    //***FCM***//
    
    
    
    
    
    
    //---Check and copy DB---//
    
    NSLog(@"%@",NSHomeDirectory());
    
    [self checkAndCopyDatabase];     //install db if not alreay
    
    
//---check user object is null or not,if not(user not logged out)---//
    
    if (!([[NSUserDefaults standardUserDefaults] valueForKey:@"userObject"] ==NULL))
    {
        

        
        Database* db=[Database shareddatabase];

        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"userObject"];
        
        User* userObj = [NSKeyedUnarchiver unarchiveObjectWithData:data];

        NSString* companyName= [NSString stringWithFormat:@"%d",userObj.comanyId];
        
        NSString* company= [db getCompanyIdFromCompanyName:companyName];//for local use to find companyname from company id
        
        [db getFeedbackAndQueryCounterForCompany:company];//set counters
        
        //app.getFeedbackAndQueryTypesArray = [db getFeedbackAndQueryTypes];
        
        app.companynameOrIdArray= [db findPermittedCompaniesForUsername:userObj.username Password:userObj.password];//find permitted companies for un n pw

       
        
        if (!(userObj.comanyId==1))//if company id != 1,set root view=tabbar and navigate to tab bar
        {
            
            mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            
            
            MainTabBarViewController * vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"MainTabBarViewController"];
            [[UIApplication sharedApplication] keyWindow].rootViewController = nil;
            
            [self.window makeKeyAndVisible];//important

            [[[UIApplication sharedApplication] keyWindow] setRootViewController:vc];
            
            [vc setTabBars];
        }
        
        else//if company id == 1,present companynamesviewcontroller on existing root view controller
        {
          
            mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            
            CompanyNamesViewController *viewController = (CompanyNamesViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"CompanyNamesViewController"];
            
            [self.window makeKeyAndVisible];
            
            [self.window.rootViewController presentViewController:viewController
                                                         animated:NO
                                                       completion:nil];
        
        }
        
    }
    
    else//if object is null(user logged out),hence present login screen
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

            LoginViewController *viewController = (LoginViewController *)[storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        
            [self.window makeKeyAndVisible];
        
            [self.window.rootViewController presentViewController:viewController
                                                         animated:NO
                                                       completion:nil];

    
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenRefreshNotification:)
                                                 name:kFIRInstanceIDTokenRefreshNotification object:nil];//when firebase InstanceId get updated(for noti),update the token on server
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getNotificationData:) name:NOTIFICATION_GET_NOTIFICATION_DATA
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getReportNotificationData:) name:NOTIFICATION_REPORT_NOTI_DATA
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getDocumentNotificationData:) name:NOTIFICATION_DOCS_NOTI_DATA
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getMOMNotificationData:) name:NOTIFICATION_MOM_NOTI_DATA
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getLatestMOM:) name:NOTIFICATION_GETLATEST_MOM
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(get50Reports:) name:NOTIFICATION_GET_50REPORTS
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(get50Documents:) name:NOTIFICATION_GET_50DOCUMENTS
                                               object:nil];
    
    

    return YES;
}


- (void) checkAndCopyDatabase
{
    NSString *destpath=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Communicator_DB.sqlite"];
    
    NSString *sourcepath=[[NSBundle mainBundle]pathForResource:@"Communicator_DB" ofType:@"sqlite"];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:destpath])
    {
        [[NSFileManager defaultManager] copyItemAtPath:sourcepath toPath:destpath error:nil];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
       // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    

    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
//   
//   navigationController = (UINavigationController *)self.window.rootViewController;
//  mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
//    NSLog(@"%d",[[NSUserDefaults standardUserDefaults]boolForKey:@"rememberMe"]);
//    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"rememberMe"])
//    {
//        NSLog(@"inside");
//        LoginViewController *controller = (LoginViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"LoginViewController"];
//        [navigationController presentViewController:controller animated:YES completion:nil];
//    }
    
   // [[AppPreferences sharedAppPreferences] startReachabilityNotifier];

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSDictionary*)deviceToken
{

//    NSString * deviceTokenString = [[[[deviceToken description]
//                                      stringByReplacingOccurrencesOfString: @"<" withString: @""]
//                                     stringByReplacingOccurrencesOfString: @">" withString: @""]
//                                    stringByReplacingOccurrencesOfString: @" " withString: @""];
//    
//    NSLog(@"The generated device token string is : %@",deviceTokenString);
  //  [AppPreferences sharedAppPreferences].deviceToken=deviceTokenString;
//    NSLog(@"%@",deviceTokenString);
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{

    NSLog(@"%@",error);
}

-(void)start
{
    [[AppPreferences sharedAppPreferences] startReachabilityNotifier];

 
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification
        // Print message ID.
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
        if (networkStatus == NotReachable)
        {
        
           
         }
        else
        {
            
            [AppPreferences sharedAppPreferences].isReachable=YES;
    
        }
    //[NSThread sleepForTimeInterval:10];
    NSError* error;
    
    NSDictionary *notifMessageDict = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    NSString* feedcomCommunicationCounterString=[notifMessageDict valueForKey:@"body"];
    
    NSData *feedcomCommunicationCounterData = [feedcomCommunicationCounterString dataUsingEncoding:NSUTF8StringEncoding];
    
    feedcomCommunicationCounterValue = [NSJSONSerialization JSONObjectWithData:feedcomCommunicationCounterData
                                                                                     options:NSJSONReadingAllowFragments
                                                                                       error:&error];
    
    NSString* documentId,*reportId,*momId,*issueType,*SONumber,*companyFrom,*companyTo;
    if ([feedcomCommunicationCounterValue valueForKey:@"ReportId"] !=nil)
    {
        reportId=[feedcomCommunicationCounterValue valueForKey:@"ReportId"];
    }
    else if([feedcomCommunicationCounterValue valueForKey:@"DocumentId"] !=nil)
    {
        documentId=[feedcomCommunicationCounterValue valueForKey:@"DocumentId"];
    }
    else if([feedcomCommunicationCounterValue valueForKey:@"MomId"] !=nil)
    {
        momId=[feedcomCommunicationCounterValue valueForKey:@"MomId"];
    }
    else
    {
        issueType= [feedcomCommunicationCounterValue valueForKey:@"IssueType"];
        SONumber= [feedcomCommunicationCounterValue valueForKey:@"SoNumber"];
        companyFrom= [feedcomCommunicationCounterValue valueForKey:@"CompanyFrom"];
        companyTo= [feedcomCommunicationCounterValue valueForKey:@"CompanyTo"];
    }
    
    NSLog(@"%@", userInfo);
    
    NSLog(@"Message ID: %@", userInfo[@"gcm.message_id"]);
    
    if (application.applicationState== UIApplicationStateActive)
    {
   // NSString* sound=@"default.mp3";
        // Nothing to do if applicationState is Inactive, the iOS already displayed an alert view.
//        NSString *notifMessage = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
   
        //Define notifView as UIView in the header file
//        NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath],sound]];
//        
//        AVAudioPlayer *newAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
//        audioPlayer=newAudioPlayer;
//        //self.audioPlayer = newAudioPlayer;
//        audioPlayer.numberOfLoops = -1;
//        [audioPlayer play];
    
        AudioServicesPlaySystemSound(1315);
        [_notifView removeFromSuperview]; //If already existing
        
        _notifView = [[UIView alloc] initWithFrame:CGRectMake(0, -70, self.window.frame.size.width, 80)];
        [_notifView setBackgroundColor:[UIColor communicatorColor]];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,15,30,30)];
        imageView.image = [UIImage imageNamed:@"AppLogo"];
        
       UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 15, self.window.frame.size.width - 100 , 30)];
        myLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
        if (reportId !=nil)
        {
            myLabel.text = [NSString stringWithFormat:@"New report,ReportId:%@",reportId];
        }
        else if(documentId!=nil)
        {
            myLabel.text = [NSString stringWithFormat:@"New document,DocumentId:%@",documentId];
        }
        else if(momId !=nil)
        {
            myLabel.text=[NSString stringWithFormat:@"New MOM,MOMId:%@",momId];
        }
        else
        {
            myLabel.text = [NSString stringWithFormat:@"New Message,SO No:%@",SONumber];
        }
        [myLabel setTextColor:[UIColor whiteColor]];
        [myLabel setNumberOfLines:0];
        
        [_notifView setAlpha:0.95];
        
        //The Icon
        [_notifView addSubview:imageView];
        
        //The Text
        [_notifView addSubview:myLabel];
        
        //The View
        [self.window addSubview:_notifView];
        
        UITapGestureRecognizer *tapToDismissNotif = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(dismissNotifFromScreen1)];
        tapToDismissNotif.numberOfTapsRequired = 1;
        tapToDismissNotif.numberOfTouchesRequired = 1;
        
        [_notifView addGestureRecognizer:tapToDismissNotif];
        
        
        [UIView animateWithDuration:1.0 delay:.1 usingSpringWithDamping:0.5 initialSpringVelocity:0.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            [_notifView setFrame:CGRectMake(0, 0, self.window.frame.size.width, 60)];
            
        } completion:^(BOOL finished)
        {
//            if (tappedOnNotification==true)
//            {
            
                
//            }
//            else
//            {
//                [self performSelector:@selector(dismissNotifFromScreen) withObject:nil afterDelay:3.0];
//                
//            }

            
        }];
        
        
        //Remove from top view after 5 seconds
//        if (tappedOnNotification==true)
//        {
//            //tappedOnNotification=false;
//
//        }
//        else
//        {
            [self performSelector:@selector(dismissNotifFromScreen) withObject:nil afterDelay:3.0];
//            tappedOnNotification=false;
//  
//        }
//
    completionHandler(UIBackgroundFetchResultNewData);
    }
    
    else
    {
       
        //[NSThread sleepForTimeInterval:3];
        NSString* userFrom= [[NSUserDefaults standardUserDefaults] valueForKey:@"userFrom"];
        UITabBarController* tabBarController =[UIApplication sharedApplication].keyWindow.rootViewController;

        if ([feedcomCommunicationCounterValue valueForKey:@"ReportId"] !=nil)
        {
            if ([userFrom isEqual:@"1"])
            {
                [tabBarController setSelectedIndex:3];
            }
            else
            {
                [tabBarController setSelectedIndex:2];
            }

            reportId=[feedcomCommunicationCounterValue valueForKey:@"ReportId"];
            
            if (!([[NSUserDefaults standardUserDefaults] valueForKey:@"userObject"] ==NULL))
            {
            [[APIManager sharedManager] getReoprtForUsername:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"] andPassword:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentPassword"] reportId:reportId];
            }
            
        }
        else if([feedcomCommunicationCounterValue valueForKey:@"DocumentId"] !=nil)
        {
            if ([userFrom isEqual:@"1"])
            {
                [tabBarController setSelectedIndex:3];
            }
            else
            {
                [tabBarController setSelectedIndex:2];
            }

            documentId=[feedcomCommunicationCounterValue valueForKey:@"DocumentId"];
            [[APIManager sharedManager] getDocumentsForUsername:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"] andPassword:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentPassword"] documentId:documentId];
        }
        else if([feedcomCommunicationCounterValue valueForKey:@"MomId"] !=nil)
        {
            
            if ([userFrom isEqual:@"1"])
            {
                [tabBarController setSelectedIndex:2];
            }
            else
            {
                [tabBarController setSelectedIndex:1];
            }

            momId=[feedcomCommunicationCounterValue valueForKey:@"MomId"];
            [[APIManager sharedManager] getMOMForUsername:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"] andPassword:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentPassword"] momId:momId];
        }
        else
        {
            NSLog(@"%@",[UIApplication sharedApplication].keyWindow.rootViewController.tabBarController);
            
            [tabBarController setSelectedIndex:0];
            
            
            [[APIManager sharedManager] getNotificationDataForUsername:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"]  andPassword:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentPassword"] SONumber:SONumber feedbackType:issueType userFrom:companyFrom userTo:companyTo] ;
        }
        
    }
        return;

      
        // Pring full message.
//    NSLog(@"%@", userInfo);
//
}


// [END receive_message]
//If the user touches the view or to remove from view after 5 seconds
- (void)dismissNotifFromScreen{
    
    [UIView animateWithDuration:1.0 delay:.1 usingSpringWithDamping:0.5 initialSpringVelocity:0.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        [_notifView setFrame:CGRectMake(0, -70, self.window.frame.size.width, 60)];
        
        NSString* issueType= [feedcomCommunicationCounterValue valueForKey:@"IssueType"];
        NSString* SONumber= [feedcomCommunicationCounterValue valueForKey:@"SoNumber"];
        NSString* companyFrom= [feedcomCommunicationCounterValue valueForKey:@"CompanyFrom"];
        NSString* companyTo= [feedcomCommunicationCounterValue valueForKey:@"CompanyTo"];
        
        
        if ([feedcomCommunicationCounterValue valueForKey:@"ReportId"] !=nil)
        {
           NSString* reportId=[feedcomCommunicationCounterValue valueForKey:@"ReportId"];
            [[APIManager sharedManager] getReoprtForUsername:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"] andPassword:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentPassword"] reportId:reportId];
        }
        else if([feedcomCommunicationCounterValue valueForKey:@"DocumentId"] !=nil)
        {
           NSString*  documentId=[feedcomCommunicationCounterValue valueForKey:@"DocumentId"];
            [[APIManager sharedManager] getDocumentsForUsername:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"] andPassword:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentPassword"] documentId:documentId];
        }
        else if([feedcomCommunicationCounterValue valueForKey:@"MomId"] !=nil)
        {
           NSString*  momId=[feedcomCommunicationCounterValue valueForKey:@"MomId"];
            [[APIManager sharedManager] getMOMForUsername:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"] andPassword:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentPassword"] momId:momId];
        }
        else
        {
            [[APIManager sharedManager] getNotificationDataForUsername:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"]  andPassword:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentPassword"] SONumber:SONumber feedbackType:issueType userFrom:companyFrom userTo:companyTo] ;
        }

//        [[APIManager sharedManager] getNotificationDataForUsername:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"]  andPassword:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentPassword"] SONumber:SONumber feedbackType:issueType userFrom:companyFrom userTo:companyTo] ;
    } completion:^(BOOL finished) {
       // feedcomCommunicationCounterValue=nil;
        
    }];
    
    
}

- (void)dismissNotifFromScreen1
{
   // tappedOnNotification=true;
   // NSLog(@"tapped");
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        [_notifView setFrame:CGRectMake(0, -70, self.window.frame.size.width, 60)];
       // [_notifView setFrame:CGRectMake(0, -70, self.window.frame.size.width, 60)];
        
        NSString* documentId,*reportId,*momId,*issueType,*SONumber,*companyFrom,*companyTo;
        if ([feedcomCommunicationCounterValue valueForKey:@"ReportId"] !=nil)
        {
            reportId=[feedcomCommunicationCounterValue valueForKey:@"ReportId"];
        }
        else if([feedcomCommunicationCounterValue valueForKey:@"DocumentId"] !=nil)
        {
            documentId=[feedcomCommunicationCounterValue valueForKey:@"DocumentId"];
        }
        else if([feedcomCommunicationCounterValue valueForKey:@"MomId"] !=nil)
        {
            momId=[feedcomCommunicationCounterValue valueForKey:@"MomId"];
        }
        else
        {
            issueType= [feedcomCommunicationCounterValue valueForKey:@"IssueType"];
            SONumber= [feedcomCommunicationCounterValue valueForKey:@"SoNumber"];
            companyFrom= [feedcomCommunicationCounterValue valueForKey:@"CompanyFrom"];
            companyTo= [feedcomCommunicationCounterValue valueForKey:@"CompanyTo"];
        }

        UITabBarController* tabBarController =[UIApplication sharedApplication].keyWindow.rootViewController;
        NSString* userFrom= [[NSUserDefaults standardUserDefaults] valueForKey:@"userFrom"];

        if ([feedcomCommunicationCounterValue valueForKey:@"ReportId"] !=nil)
        {
           
                [tabBarController setSelectedIndex:1];
            
//            reportId=[feedcomCommunicationCounterValue valueForKey:@"ReportId"];
//            
//            if (!([[NSUserDefaults standardUserDefaults] valueForKey:@"userObject"] ==NULL))
//            {
//                [[APIManager sharedManager] getReoprtForUsername:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"] andPassword:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentPassword"] reportId:reportId];
//            }
            
        }
        else if([feedcomCommunicationCounterValue valueForKey:@"DocumentId"] !=nil)
        {
           
                [tabBarController setSelectedIndex:1];
            
//            documentId=[feedcomCommunicationCounterValue valueForKey:@"DocumentId"];
//            [[APIManager sharedManager] getDocumentsForUsername:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"] andPassword:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentPassword"] documentId:documentId];
        }
        else if([feedcomCommunicationCounterValue valueForKey:@"MomId"] !=nil)
        {
            
           
                [tabBarController setSelectedIndex:2];
                        
//            momId=[feedcomCommunicationCounterValue valueForKey:@"MomId"];
//            [[APIManager sharedManager] getMOMForUsername:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"] andPassword:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentPassword"] momId:momId];
        }
        else
        {
            NSLog(@"%@",[UIApplication sharedApplication].keyWindow.rootViewController.tabBarController);
            
            [tabBarController setSelectedIndex:0];
            
            
//            [[APIManager sharedManager] getNotificationDataForUsername:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"]  andPassword:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentPassword"] SONumber:SONumber feedbackType:issueType userFrom:companyFrom userTo:companyTo] ;
        }
        

//
//        NSString* issueType= [feedcomCommunicationCounterValue valueForKey:@"IssueType"];
//        NSString* SONumber= [feedcomCommunicationCounterValue valueForKey:@"SoNumber"];
//        NSString* companyFrom= [feedcomCommunicationCounterValue valueForKey:@"CompanyFrom"];
//        NSString* companyTo= [feedcomCommunicationCounterValue valueForKey:@"CompanyTo"];
//        [[APIManager sharedManager] getNotificationDataForUsername:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"]  andPassword:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentPassword"] SONumber:SONumber feedbackType:issueType userFrom:companyFrom userTo:companyTo] ;
       
    } completion:^(BOOL finished) {
        // feedcomCommunicationCounterValue=nil;
        
    }];
    
    
}

// [START refresh_token]
- (void)tokenRefreshNotification:(NSNotification *)notification {
    // Note that this callback will be fired everytime a new token is generated, including the first
    // time. So if you need to retrieve the token as soon as it is available this is where that
    // should be done.
    NSString *refreshedToken = [[FIRInstanceID instanceID] token];
    [AppPreferences sharedAppPreferences].firebaseInstanceId=refreshedToken;
    
    if (!([[NSUserDefaults standardUserDefaults] valueForKey:@"userObject"]==NULL))
    {
        [[APIManager sharedManager] updateDevieToken:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"] Password:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentPassword"] andDeviceId:refreshedToken];
    }
    
    NSLog(@"InstanceID token: %@", refreshedToken);
    
//    if (!(refreshedToken==NULL))
//    {
//        [[NSUserDefaults standardUserDefaults] setValue:refreshedToken forKey:@"deviceToken"];
//    }
    // Connect to FCM since connection may have failed when attempted before having a token.
    [self connectToFcm];
    
    // TODO: If necessary send token to appliation server.
}
// [END refresh_token]

// [START connect_to_fcm]
- (void)connectToFcm {
    [[FIRMessaging messaging] connectWithCompletion:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Unable to connect to FCM. %@", error);
        } else {
            NSLog(@"Connected to FCM.");
        }
    }];
}


// [END connect_to_fcm]
-(void)getNotificationData:(NSNotification*)data
{
    [[Database shareddatabase] insertFeedcomNotifiationData:data.object readStatusflag:true];
}
-(void)getReportNotificationData:(NSNotification*)data
{
    [[Database shareddatabase] insertReportNotificationData:data.object];
}
-(void)getDocumentNotificationData:(NSNotification*)data
{
    [[Database shareddatabase] insertDocumentNotificationData:data.object];
}
-(void)getMOMNotificationData:(NSNotification*)data
{
    [[Database shareddatabase] insertMOMNotificationData:data.object];
}

- (void)getLatestMOM:(NSNotification *)notificationData
{
    if ([[notificationData.object objectForKey:@"code"] isEqualToString:SUCCESS])
    {
        
        Database *db=[Database shareddatabase];
        [db insertLatestRecordsForMOM:notificationData.object];
        [db setMOMView];
        
    }
}

- (void)get50Reports:(NSNotification *)notificationData
{
    if ([[notificationData.object objectForKey:@"code"] isEqualToString:SUCCESS])
    {
        
        Database *db=[Database shareddatabase];
        [db insertReportData:notificationData.object];
        
    }
}
- (void)get50Documents:(NSNotification *)notificationData
{
    if ([[notificationData.object objectForKey:@"code"] isEqualToString:SUCCESS])
    {
        
        Database *db=[Database shareddatabase];
        [db insertDocumentsData:notificationData.object];
        
    }
}

@end
