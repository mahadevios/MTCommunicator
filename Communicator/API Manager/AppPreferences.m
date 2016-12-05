//
//  AppPreferences.m
//  Communicator
//
//  Created by mac on 05/04/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import "AppPreferences.h"
#include <sys/xattr.h>
#import "AppDelegate.h"

@implementation AppPreferences
@synthesize currentSelectedItem;
@synthesize alertDelegate;
@synthesize isReachable;
@synthesize companynameOrIdArray;
@synthesize feedTypeWithFeedCounterDict;
@synthesize feedTypeWithQueryCounterDict;
@synthesize feedQueryCounterDictsWithTypeArray;
@synthesize getFeedbackAndQueryTypesArray;
@synthesize sampleFeedtypeArray;
@synthesize samplefeedTypeCopyForPredicate;
@synthesize allMomArray;
@synthesize reportFileNamesDict;
@synthesize imageFilesArray, uploadedFileNamesArray;
@synthesize sampleReportDateCopyForPredicate;
@synthesize sampleReportDateDict;
static AppPreferences *singleton = nil;

// Shared method
+(AppPreferences *) sharedAppPreferences
{
    if (singleton == nil)
    {
        singleton = [[AppPreferences alloc] init];
    }
    
    return singleton;
}


// Init method
-(id) init
{
    self = [super init];
    
    if (self)
    {
        self.currentSelectedItem = 0;
        //[self startReachabilityNotifier];
    }
    
    return self;
}


/*================================================================================================================================================*/


-(void) startReachabilityNotifier
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    reach.reachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           //NSLog(@"Reachable");
                           isReachable = YES;
                       });
    };
    
    reach.unreachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           //NSLog(@"Not Reachable");
                           isReachable = NO;
                           
                       });
    };
    
    [reach startNotifier];
}

/*================================================================================================================================================*/

-(void)reachabilityChanged:(NSNotification*)note
{
    Reachability * reach = [note object];
    
    if([reach isReachable])
    {
        //NSLog(@"Reachable");
        isReachable = YES;
    }
    else
    {
        //NSLog(@"Not Reachable");
        isReachable = NO;
        
        //[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(showNoInternetMessage) userInfo:nil repeats:NO];
        [self showNoInternetMessage];
    }
}

-(void) showNoInternetMessage
{
    if (![self isReachable])
    {
        [self showAlertViewWithTitle:@"No internet connection" withMessage:@"Please turn on your inernet connection to access this feature" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
    }
}

/*=================================================================================================================================================*/


-(void) showAlertViewWithTitle:(NSString *) title withMessage:(NSString *) message withCancelText:(NSString *) cancelText withOkText:(NSString *) okText withAlertTag:(int) tag
{
    
    dispatch_queue_t currentQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(currentQueue, ^
                   {
                       __block UIAlertView *alertView  = nil;
                       
                       dispatch_sync(currentQueue, ^
                                     {
                                         alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelText otherButtonTitles:okText, nil];
                                         alertView.tag = tag;
                                         
                                     });
                       
                       dispatch_sync(dispatch_get_main_queue(), ^
                                     {
                                         [alertView show];

                                     });
                   });
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.alertDelegate appPreferencesAlertButtonWithIndex:(int)buttonIndex withAlertTag:alertView.tag];
}



- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    const char* filePath = [[URL path] fileSystemRepresentation];
    
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    return result == 0;
}


-(void)logout
{
//    alertController = [UIAlertController alertControllerWithTitle:@"Logout?"
//                                                          message:@"Are you sure to logout"
//                                                   preferredStyle:UIAlertControllerStyleAlert];
//    actionDelete = [UIAlertAction actionWithTitle:@"Ok"
//                                            style:UIAlertActionStyleDefault
//                                          handler:^(UIAlertAction * action)
//                    {
//                                                
//                    }]; //You can use a block here to handle a press on this button
//    [alertController addAction:actionDelete];
//    
//    
//    actionCancel = [UIAlertAction actionWithTitle:@"Cancel"
//                                            style:UIAlertActionStyleCancel
//                                          handler:^(UIAlertAction * action)
//                    {
//                        [alertController dismissViewControllerAnimated:YES completion:nil];
//                        
//                    }]; //You can use a block here to handle a press on this button
//    [alertController addAction:actionCancel];
//    [self presentViewController:alertController animated:YES completion:nil];
    

    NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
    [[APIManager sharedManager] logout:[defaults valueForKey:@"currentUser"] Password:[defaults valueForKey:@"currentPassword"]];
    
    [defaults setObject:NULL forKey:@"userObject"];
    [defaults setObject:NULL forKey:@"selectedCompany"];
    [defaults setValue:NULL forKey:@"selectedCompany"];
    [defaults setValue:NULL forKey:@"currentUser"];
    [defaults setValue:NULL forKey:@"currentPassword"];
    
    [[Database shareddatabase] removeUserdata];
}

-(void)refreshAllViewData
{
    NSString* username = [[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"];
    NSString* companyId=[[Database shareddatabase] getCompanyId:username];
    NSString* selectedCompany;
    if ([companyId isEqual:@"1"])
    {
        selectedCompany= [[NSUserDefaults standardUserDefaults] valueForKey:@"selectedCompany"];
        //companyId= [[Database shareddatabase] getCompanyIdFromCompanyName1:selectedCompany];
    }
    else
    {
        selectedCompany= [[Database shareddatabase] getCompanyIdFromCompanyName:companyId];
    }
    
    [[Database shareddatabase] getFeedbackAndQueryCounterForCompany:selectedCompany];
}





@end
