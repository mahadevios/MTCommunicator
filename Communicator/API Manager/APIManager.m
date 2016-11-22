//
//  APIManager.m
//  Communicator
//
//  Created by mac on 05/04/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import "APIManager.h"
#import "AppDelegate.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIColor+CommunicatorColor.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "NetworkManager.h"
#import <CFNetwork/CFNetwork.h>
#import <CommonCrypto/CommonCryptor.h>

@implementation APIManager
@synthesize hud;
static APIManager *singleton = nil;

// Shared method
+(APIManager *) sharedManager
{
    if (singleton == nil)
    {
        singleton = [[APIManager alloc] init];
        [[AppPreferences sharedAppPreferences] startReachabilityNotifier];
    }

    return singleton;
}

// Init method
-(id) init
{
    self = [super init];
    
    if (self)
    {
        
    }
    
    return self;
}

#pragma mark
#pragma mark ValidateUser API
#pragma mark

//-(void) validateUser:(NSString *) usernameString andPassword:(NSString *) passwordString
//{
//    if ([[AppPreferences sharedAppPreferences] isReachable])
//    {
//        NSArray *params = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"username=%@",usernameString], [NSString stringWithFormat:@"password=%@",passwordString] ,nil];
//        
//        NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:params,REQUEST_PARAMETER, nil];
//        
//        DownloadMetaDataJob *downloadmetadatajob=[[DownloadMetaDataJob alloc]initWithdownLoadEntityJobName:USER_LOGIN_API withRequestParameter:dictionary withResourcePath:USER_LOGIN_API withHttpMethd:POST];
//        [downloadmetadatajob startMetaDataDownLoad];
//    }
//    else
//    {
//        [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"No internet connection!" withMessage:@"Please turn on your inernet connection to access this feature" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
//    }
//}



-(void) validateUser:(NSString *) usernameString Password:(NSString *) passwordString andDeviceId:(NSString*)deviceToken

{
    if ([[AppPreferences sharedAppPreferences] isReachable])
    {
        NSArray *params = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"username=%@",usernameString], [NSString stringWithFormat:@"password=%@",passwordString] ,[NSString stringWithFormat:@"deviceToken=%@", [AppPreferences sharedAppPreferences].firebaseInstanceId],nil];
        
        NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:params,REQUEST_PARAMETER, nil];
        
        DownloadMetaDataJob *downloadmetadatajob=[[DownloadMetaDataJob alloc]initWithdownLoadEntityJobName:NEW_USER_LOGIN_API withRequestParameter:dictionary withResourcePath:NEW_USER_LOGIN_API withHttpMethd:POST];
        [downloadmetadatajob startMetaDataDownLoad];
    }
    else
    {
        [[[UIApplication sharedApplication].keyWindow viewWithTag:789] setHidden:YES];

        [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"No internet connection!" withMessage:@"Please turn on your inernet connection to access this feature" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
    }
}

-(void) updateDevieToken:(NSString *) usernameString Password:(NSString *) passwordString andDeviceId:(NSString*)DeviceToken;
{
    if ([[AppPreferences sharedAppPreferences] isReachable])
    {
        NSArray *params = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"username=%@",usernameString], [NSString stringWithFormat:@"password=%@",passwordString] ,[NSString stringWithFormat:@"deviceToken=%@", [AppPreferences sharedAppPreferences].firebaseInstanceId],nil];
        
        NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:params,REQUEST_PARAMETER, nil];
        
        DownloadMetaDataJob *downloadmetadatajob=[[DownloadMetaDataJob alloc]initWithdownLoadEntityJobName:UPDATE_DEVICE_TOKEN withRequestParameter:dictionary withResourcePath:UPDATE_DEVICE_TOKEN withHttpMethd:POST];
        [downloadmetadatajob startMetaDataDownLoad];
    }
    else
    {
        [[[UIApplication sharedApplication].keyWindow viewWithTag:789] setHidden:YES];
        
        [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"No internet connection!" withMessage:@"Please turn on your inernet connection to access this feature" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
    }

}
-(void) logout:(NSString *) usernameString Password:(NSString *) passwordString

{
    if ([[AppPreferences sharedAppPreferences] isReachable])
    {
        NSArray *params = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"username=%@",usernameString], [NSString stringWithFormat:@"password=%@",passwordString] ,nil];
        
        NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:params,REQUEST_PARAMETER, nil];
        
        DownloadMetaDataJob *downloadmetadatajob=[[DownloadMetaDataJob alloc]initWithdownLoadEntityJobName:LOGOUT_API withRequestParameter:dictionary withResourcePath:LOGOUT_API withHttpMethd:POST];
        [downloadmetadatajob startMetaDataDownLoad];
    }
    else
    {
        [hud hideAnimated:YES];
        
        [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"No internet connection!" withMessage:@"Please turn on your inernet connection to access this feature" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
    }
}
-(void) forgotPassword:(NSString *) email

{
    if ([[AppPreferences sharedAppPreferences] isReachable])
    {
        NSArray *params = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"email=%@",email] ,nil];
        
        NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:params,REQUEST_PARAMETER, nil];
        
        DownloadMetaDataJob *downloadmetadatajob=[[DownloadMetaDataJob alloc]initWithdownLoadEntityJobName:FORGOT_PASSWORD_API withRequestParameter:dictionary withResourcePath:FORGOT_PASSWORD_API withHttpMethd:POST];
        [downloadmetadatajob startMetaDataDownLoad];
    }
    else
    {
        [hud hideAnimated:YES];
        
        [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"No internet connection!" withMessage:@"Please turn on your inernet connection to access this feature" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
    }
}


-(void) findCountForUsername:(NSString*)usernameString andPassword:(NSString*)passwordString;
{
    if ([[AppPreferences sharedAppPreferences] isReachable])
    {
        
        NSArray *params = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"username=%@",usernameString], [NSString stringWithFormat:@"password=%@",passwordString] ,nil];
        
        NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:params,REQUEST_PARAMETER, nil];
        
        DownloadMetaDataJob *downloadcounterdatajob=[[DownloadMetaDataJob alloc]initWithdownLoadEntityJobName:FIND_COUNT_API withRequestParameter:dictionary withResourcePath:FIND_COUNT_API withHttpMethd:POST];
        [downloadcounterdatajob startMetaDataDownLoad];
    }
    else
    {
        NSLog(@"%d",[AppPreferences sharedAppPreferences].isReachable);
        [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"No internet connection!" withMessage:@"Please turn on your inernet connection to access this feature" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
    }

}


-(void) getLatestRecordsForUsername:(NSString*)usernameString andPassword:(NSString*)passwordString
{

    if ([[AppPreferences sharedAppPreferences] isReachable])
    {
        NSArray *params = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"username=%@",usernameString], [NSString stringWithFormat:@"password=%@",passwordString],nil];
        
        NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:params,REQUEST_PARAMETER, nil];
        
        DownloadMetaDataJob *downloadlatestrecordsjob=[[DownloadMetaDataJob alloc]initWithdownLoadEntityJobName:GET_LATEST_RECORDS withRequestParameter:dictionary withResourcePath:GET_LATEST_RECORDS withHttpMethd:POST];
        [downloadlatestrecordsjob startMetaDataDownLoad];
    }

    else
    {
        [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"No internet connection!" withMessage:@"Please turn on your inernet connection to access this feature" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
    }

}


-(void) sendUpdatedRecords:(NSString*)flag Dict:(NSDictionary*)feedcomDict username:(NSString*)username password:(NSString*)password
{
    
    if ([[AppPreferences sharedAppPreferences] isReachable])
    {
        NSArray *params = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"flag=%@",flag], [NSString stringWithFormat:@"feedcomDict=%@",feedcomDict],[NSString stringWithFormat:@"username=%@",username],[NSString stringWithFormat:@"password=%@",password],nil];
        
        NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:params,REQUEST_PARAMETER, nil];
        
        DownloadMetaDataJob *downloadlatestrecordsjob=[[DownloadMetaDataJob alloc]initWithdownLoadEntityJobName:SEND_UPDATED_RECORDS withRequestParameter:dictionary withResourcePath:SEND_UPDATED_RECORDS withHttpMethd:POST];
        [downloadlatestrecordsjob startMetaDataDownLoad];
    }
    
    else
    {
        [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"No internet connection!" withMessage:@"Please turn on your inernet connection to access this feature" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
    }
    
}



-(void) sendNewFeedback:(NSString*)flag Dict:(NSDictionary*)feedcomDict username:(NSString*)username password:(NSString*)password;
{
    
    if ([[AppPreferences sharedAppPreferences] isReachable])
    {
        NSArray *params = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"flag=%@",flag], [NSString stringWithFormat:@"feedcomDict=%@",feedcomDict],[NSString stringWithFormat:@"username=%@",username],[NSString stringWithFormat:@"password=%@",password],nil];
        
        NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:params,REQUEST_PARAMETER, nil];
        
        DownloadMetaDataJob *downloadlatestrecordsjob=[[DownloadMetaDataJob alloc]initWithdownLoadEntityJobName:SEND_NEW_FEEDBACK withRequestParameter:dictionary withResourcePath:SEND_NEW_FEEDBACK withHttpMethd:POST];
        [downloadlatestrecordsjob startMetaDataDownLoad];
    }
    
    else
    {
        [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"No internet connection!" withMessage:@"Please turn on your inernet connection to access this feature" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
    }
    
}

-(void) sendNewMOM:(NSString*)feedcomDict username:(NSString*)username password:(NSString*)password
{
    if ([[AppPreferences sharedAppPreferences] isReachable])
    {
        NSArray *params = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"MomDict=%@",feedcomDict],[NSString stringWithFormat:@"username=%@",username],[NSString stringWithFormat:@"password=%@",password],nil];
        
        NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:params,REQUEST_PARAMETER, nil];
        
        DownloadMetaDataJob *downloadlatestrecordsjob=[[DownloadMetaDataJob alloc]initWithdownLoadEntityJobName:SEND_NEW_MOM withRequestParameter:dictionary withResourcePath:SEND_NEW_MOM withHttpMethd:POST];
        [downloadlatestrecordsjob startMetaDataDownLoad];
    }
    
    else
    {
        [[[UIApplication sharedApplication].keyWindow viewWithTag:789] removeFromSuperview];

        [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"No internet connection!" withMessage:@"Please turn on your inernet connection to access this feature" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
    }



}
-(void) uploadFile:(NSString*)fileName andFileString:(NSString*)fileString
{
    
    if ([[AppPreferences sharedAppPreferences] isReachable])
    {
        NSArray *params = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"fileName=%@",fileName], [NSString stringWithFormat:@"file=%@",fileString], nil];
        
        NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:params,REQUEST_PARAMETER, nil];
        
        DownloadMetaDataJob *downloadlatestrecordsjob=[[DownloadMetaDataJob alloc]initWithdownLoadEntityJobName:UPLOAD_FILE withRequestParameter:dictionary withResourcePath:UPLOAD_FILE withHttpMethd:POST];
        [downloadlatestrecordsjob startMetaDataDownLoad];
    }
    
    else
    {
        [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"No internet connection!" withMessage:@"Please turn on your inernet connection to access this feature" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
    }
    
}

//get first 50 mom at login
-(void) getLatestMOMForUsername:(NSString*)usernameString andPassword:(NSString*)passwordString
{
    
    if ([[AppPreferences sharedAppPreferences] isReachable])
    {
        NSArray *params = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"username=%@",usernameString], [NSString stringWithFormat:@"password=%@",passwordString],nil];
        
        NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:params,REQUEST_PARAMETER, nil];
        
        DownloadMetaDataJob *downloadlatestrecordsjob=[[DownloadMetaDataJob alloc]initWithdownLoadEntityJobName:GET_LATEST_MOM withRequestParameter:dictionary withResourcePath:GET_LATEST_MOM withHttpMethd:POST];
        [downloadlatestrecordsjob startMetaDataDownLoad];
    }
    
    else
    {
        [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"No internet connection!" withMessage:@"Please turn on your inernet connection to access this feature" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
    }
    
}

//get first 50 report at login
-(void) get50ReoprtForUsername:(NSString*)usernameString andPassword:(NSString*)passwordString
{
    
    if ([[AppPreferences sharedAppPreferences] isReachable])
    {
        NSArray *params = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"username=%@",usernameString], [NSString stringWithFormat:@"password=%@",passwordString],nil];
        
        NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:params,REQUEST_PARAMETER, nil];
        
        DownloadMetaDataJob *downloadlatestrecordsjob=[[DownloadMetaDataJob alloc]initWithdownLoadEntityJobName:GET_50_REPORTS withRequestParameter:dictionary withResourcePath:GET_50_REPORTS withHttpMethd:POST];
        [downloadlatestrecordsjob startMetaDataDownLoad];
    }
    
    else
    {
        [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"No internet connection!" withMessage:@"Please turn on your inernet connection to access this feature" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
    }
    
}

//get first 50 docs at login
-(void) get50DocumentsForUsername:(NSString*)usernameString andPassword:(NSString*)passwordString
{
    
    if ([[AppPreferences sharedAppPreferences] isReachable])
    {
        NSArray *params = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"username=%@",usernameString], [NSString stringWithFormat:@"password=%@",passwordString],nil];
        
        NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:params,REQUEST_PARAMETER, nil];
        
        DownloadMetaDataJob *downloadlatestrecordsjob=[[DownloadMetaDataJob alloc]initWithdownLoadEntityJobName:GET_50_DOCUMENTS withRequestParameter:dictionary withResourcePath:GET_50_DOCUMENTS withHttpMethd:POST];
        [downloadlatestrecordsjob startMetaDataDownLoad];
    }
    
    else
    {
        [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"No internet connection!" withMessage:@"Please turn on your inernet connection to access this feature" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
    }
    
}

//get feedback notification data
-(void) getNotificationDataForUsername:(NSString*)usernameString andPassword:(NSString*)passwordString SONumber:(NSString*)SONumber feedbackType:(NSString*)feedbackType
                              userFrom:(NSString*)userFrom userTo:(NSString*)userTo{
    if ([[AppPreferences sharedAppPreferences] isReachable])
    {
        NSArray *params = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"username=%@",usernameString], [NSString stringWithFormat:@"password=%@",passwordString], [NSString stringWithFormat:@"soNumber=%@",SONumber], [NSString stringWithFormat:@"feedbackType=%@",feedbackType], [NSString stringWithFormat:@"userFrom=%@",userFrom], [NSString stringWithFormat:@"userTo=%@",userTo],nil];
        
        NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:params,REQUEST_PARAMETER, nil];
        
        DownloadMetaDataJob *downloadlatestrecordsjob=[[DownloadMetaDataJob alloc]initWithdownLoadEntityJobName:GET_NOTIFICATION_DATA withRequestParameter:dictionary withResourcePath:GET_NOTIFICATION_DATA withHttpMethd:POST];
        [downloadlatestrecordsjob startMetaDataDownLoad];
    }
    
    else
    {
        [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"No internet connection!" withMessage:@"Please turn on your inernet connection to access this feature" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
    }

}

//load more data from respective feedback type

-(void) getNotificationLoadMoreDataForUsername:(NSString*)usernameString andPassword:(NSString*)passwordString SONumber:(NSString*)SONumber feedbackType:(NSString*)feedbackType userFrom:(NSString*)userFrom userTo:(NSString*)userTo{
    if ([[AppPreferences sharedAppPreferences] isReachable])
    {
        NSArray *params = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"username=%@",usernameString], [NSString stringWithFormat:@"password=%@",passwordString], [NSString stringWithFormat:@"soNumber=%@",SONumber], [NSString stringWithFormat:@"feedbackType=%@",feedbackType], [NSString stringWithFormat:@"userFrom=%@",userFrom], [NSString stringWithFormat:@"userTo=%@",userTo],nil];
        
        NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:params,REQUEST_PARAMETER, nil];
        
        DownloadMetaDataJob *downloadlatestrecordsjob=[[DownloadMetaDataJob alloc]initWithdownLoadEntityJobName:GET_ALL_MSGS_LOAD_MORE_DATA1 withRequestParameter:dictionary withResourcePath:GET_ALL_MSGS_LOAD_MORE_DATA withHttpMethd:POST];
        [downloadlatestrecordsjob startMetaDataDownLoad];
    }
    
    else
    {
        [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"No internet connection!" withMessage:@"Please turn on your inernet connection to access this feature" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
    }
    
}

-(void)getNew50Records:(NSString*)username password:(NSString*)password userFrom:(NSString*)userFrom userTo:(NSString*)userTo feedbackType:(int)feedbackType feedbackIdsArray:(NSString*)feedbackIdsArray
{
    if ([[AppPreferences sharedAppPreferences] isReachable])
    {
        NSArray *params = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"username=%@",username], [NSString stringWithFormat:@"password=%@",password], [NSString stringWithFormat:@"Feedbacktype=%d",feedbackType],  [NSString stringWithFormat:@"userFrom=%@",userFrom], [NSString stringWithFormat:@"userTo=%@",userTo],[NSString stringWithFormat:@"listOfFeedbackId=%@",feedbackIdsArray],nil];
        
        NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:params,REQUEST_PARAMETER, nil];
        
        DownloadMetaDataJob *downloadlatestrecordsjob=[[DownloadMetaDataJob alloc]initWithdownLoadEntityJobName:GET_50_NEW_FEEDBACK_RECORDS withRequestParameter:dictionary withResourcePath:GET_50_NEW_FEEDBACK_RECORDS withHttpMethd:POST];
        [downloadlatestrecordsjob startMetaDataDownLoad];
    }
    
    else
    {
        [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"No internet connection!" withMessage:@"Please turn on your inernet connection to access this feature" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
    }


}
//get mom load more dtata
-(void)getLoadMoreMOMData:(NSString*)username password:(NSString*)password userFrom:(NSString*)userFrom userTo:(NSString*)userTo feedbackIdsArray:(NSString*)feedbackIdsArray
{
    if ([[AppPreferences sharedAppPreferences] isReachable])
    {
        NSArray *params = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"username=%@",username], [NSString stringWithFormat:@"password=%@",password],   [NSString stringWithFormat:@"userFrom=%@",userFrom], [NSString stringWithFormat:@"userTo=%@",userTo],[NSString stringWithFormat:@"listOfMomId=%@",feedbackIdsArray],nil];
        
        NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:params,REQUEST_PARAMETER, nil];
        
        DownloadMetaDataJob *downloadlatestrecordsjob=[[DownloadMetaDataJob alloc]initWithdownLoadEntityJobName:GET_50_MOM_LOAD_MORE_DATA withRequestParameter:dictionary withResourcePath:GET_50_MOM_LOAD_MORE_DATA withHttpMethd:POST];
        [downloadlatestrecordsjob startMetaDataDownLoad];
    }
    
    else
    {
        [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"No internet connection!" withMessage:@"Please turn on your inernet connection to access this feature" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
    }
    
    
}

-(void)getLoadMoreReportData:(NSString*)username password:(NSString*)password userFrom:(NSString*)userFrom userTo:(NSString*)userTo feedbackIdsArray:(NSString*)feedbackIdsArray
{
    if ([[AppPreferences sharedAppPreferences] isReachable])
    {
        NSArray *params = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"username=%@",username], [NSString stringWithFormat:@"password=%@",password],   [NSString stringWithFormat:@"userFrom=%@",userFrom], [NSString stringWithFormat:@"userTo=%@",userTo],[NSString stringWithFormat:@"listOfReportId=%@",feedbackIdsArray],nil];
        
        NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:params,REQUEST_PARAMETER, nil];
        
        DownloadMetaDataJob *downloadlatestrecordsjob=[[DownloadMetaDataJob alloc]initWithdownLoadEntityJobName:GET_50_REPORT_LOAD_MORE_DATA withRequestParameter:dictionary withResourcePath:GET_50_REPORT_LOAD_MORE_DATA withHttpMethd:POST];
        [downloadlatestrecordsjob startMetaDataDownLoad];
    }
    
    else
    {
        [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"No internet connection!" withMessage:@"Please turn on your inernet connection to access this feature" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
    }
    
    
}

-(void)getLoadMoreDocumentData:(NSString*)username password:(NSString*)password userFrom:(NSString*)userFrom userTo:(NSString*)userTo feedbackIdsArray:(NSString*)feedbackIdsArray
{
    if ([[AppPreferences sharedAppPreferences] isReachable])
    {
        NSArray *params = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"username=%@",username], [NSString stringWithFormat:@"password=%@",password],   [NSString stringWithFormat:@"userFrom=%@",userFrom], [NSString stringWithFormat:@"userTo=%@",userTo],[NSString stringWithFormat:@"listOfDocumentId=%@",feedbackIdsArray],nil];
        
        NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:params,REQUEST_PARAMETER, nil];
        
        DownloadMetaDataJob *downloadlatestrecordsjob=[[DownloadMetaDataJob alloc]initWithdownLoadEntityJobName:GET_50_DOCUMENT_LOAD_MORE_DATA withRequestParameter:dictionary withResourcePath:GET_50_DOCUMENT_LOAD_MORE_DATA withHttpMethd:POST];
        [downloadlatestrecordsjob startMetaDataDownLoad];
    }
    
    else
    {
        [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"No internet connection!" withMessage:@"Please turn on your inernet connection to access this feature" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
    }
    
    
}


//get report of notification
-(void) getReoprtForUsername:(NSString*)usernameString andPassword:(NSString*)passwordString reportId:(NSString*)reportId
{
    
    if ([[AppPreferences sharedAppPreferences] isReachable])
    {
        NSArray *params = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"username=%@",usernameString], [NSString stringWithFormat:@"password=%@",passwordString], [NSString stringWithFormat:@"reportId=%@",reportId],nil];
        
        NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:params,REQUEST_PARAMETER, nil];
        
        DownloadMetaDataJob *downloadlatestrecordsjob=[[DownloadMetaDataJob alloc]initWithdownLoadEntityJobName:GET_REPORT_NOTI_DATA withRequestParameter:dictionary withResourcePath:GET_REPORT_NOTI_DATA withHttpMethd:POST];
        [downloadlatestrecordsjob startMetaDataDownLoad];
    }
    
    else
    {
        [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"No internet connection!" withMessage:@"Please turn on your inernet connection to access this feature" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
    }
    
}
//get docs of notification
-(void) getDocumentsForUsername:(NSString*)usernameString andPassword:(NSString*)passwordString documentId:(NSString*)documentId
{
    
    if ([[AppPreferences sharedAppPreferences] isReachable])
    {
        NSArray *params = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"username=%@",usernameString], [NSString stringWithFormat:@"password=%@",passwordString], [NSString stringWithFormat:@"documentId=%@",documentId],nil];
        
        NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:params,REQUEST_PARAMETER, nil];
        
        DownloadMetaDataJob *downloadlatestrecordsjob=[[DownloadMetaDataJob alloc]initWithdownLoadEntityJobName:GET_DOCS_NOTI_DATA withRequestParameter:dictionary withResourcePath:GET_DOCS_NOTI_DATA withHttpMethd:POST];
        [downloadlatestrecordsjob startMetaDataDownLoad];
    }
    
    else
    {
        [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"No internet connection!" withMessage:@"Please turn on your inernet connection to access this feature" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
    }
    
}

//get mom noti data
-(void) getMOMForUsername:(NSString*)usernameString andPassword:(NSString*)passwordString momId:(NSString*)momId
{
    
    if ([[AppPreferences sharedAppPreferences] isReachable])
    {
        NSArray *params = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"username=%@",usernameString], [NSString stringWithFormat:@"password=%@",passwordString], [NSString stringWithFormat:@"MomId=%@",momId],nil];
        
        NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:params,REQUEST_PARAMETER, nil];
        
        DownloadMetaDataJob *downloadlatestrecordsjob=[[DownloadMetaDataJob alloc]initWithdownLoadEntityJobName:GET_MOM_NOTI_DATA withRequestParameter:dictionary withResourcePath:GET_MOM_NOTI_DATA withHttpMethd:POST];
        [downloadlatestrecordsjob startMetaDataDownLoad];
    }
    
    else
    {
        [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"No internet connection!" withMessage:@"Please turn on your inernet connection to access this feature" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
    }
    
}



-(NSString*) getDate
{
//    NSDate* sourceDate = [NSDate date];
//    
//    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
//    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
//    
//    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
//    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
//    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
 //   NSDate* destinationDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = DATE_TIME_FORMAT;
    NSString* recordCreatedDateString = [formatter stringFromDate:[NSDate date]];
    return recordCreatedDateString;
    
    //return destinationDate;
//    NSTimeInterval seconds = [destinationDate timeIntervalSince1970];
//    double milliseconds = seconds*1000;
//
//    return milliseconds;
}


-(void)uploadFileToServer

{
    AppPreferences* app=[AppPreferences sharedAppPreferences];
    
    
    // NSURL* url = [NSURL URLWithString:webStringURL];
    for (int i=0; i<app.imageFilesArray.count; i++)
    {
        NSError* error;
        NSData * data = UIImagePNGRepresentation([app.imageFilesArray objectAtIndex:i]);
        
//        NSString* fileLocation;
//        if ([AppPreferences sharedAppPreferences].fileLocation==@"Gallery")
//        {
//            fileLocation=@"Downloads";
//        }
//        else
//            if ([AppPreferences sharedAppPreferences].fileLocation==@"Reports")
//            {
//                fileLocation=@"Reports";
//            }
//        else
//            if ([AppPreferences sharedAppPreferences].fileLocation==@"Documents")
//            {
//                fileLocation=@"Documents";
//            }
        NSString *folderpath=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Downloads"];
        
        NSString *destpath=[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/Downloads/%@",[app.imageFileNamesArray objectAtIndex:i]]];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:folderpath])
            [[NSFileManager defaultManager] createDirectoryAtPath:folderpath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
        [data writeToFile:destpath atomically:YES];
        
        NSString* path = [NSHomeDirectory() stringByAppendingPathComponent:
                          [NSString stringWithFormat:@"Documents/Downloads/%@",[app.imageFileNamesArray objectAtIndex:i]] ];
        //--------------------------------------------------//
        NSString* fileName = [app.imageFileNamesArray objectAtIndex:i];
        
        
        //NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", @"http://192.168.3.170:8080/coreflex/feedcom", @"uploadFileFromMobile"]];
        
        // NSString *folderpath=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Downloads/test.png"];
        
        //"http://115.249.195.23:8080/Communicator/feedcom/
         NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", BASE_URL_PATH, @"uploadFileFromMobile"]];
        //NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", @"http://115.249.195.23:8080/Communicator/feedcom", @"uploadFileFromMobile"]];
        
        
        NSString *boundary = [self generateBoundaryString];
        
        //NSString *path = [[NSBundle mainBundle] pathForResource:@"AppIcon80x80" ofType:@"png"];
        
        // configure the request
        NSDictionary *params = @{@"filename"     : [app.imageFileNamesArray objectAtIndex:i],
                                 };
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        [request setHTTPMethod:@"POST"];
        
        // set content type
        
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
        [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        // create body
        
        NSData *httpBody = [self createBodyWithBoundary:boundary parameters:params paths:@[path] fieldName:fileName];
        
        request.HTTPBody = httpBody;
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (connectionError)
            {
                NSLog(@"error = %@", connectionError);
                dispatch_async(dispatch_get_main_queue(), ^{
                    // make some UI changes
                    [[[UIApplication sharedApplication].keyWindow viewWithTag:1122] removeFromSuperview];
                    
                });
[[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"" withMessage:@"File uploading failed!" withCancelText:@"Cancel" withOkText:@"Ok" withAlertTag:1000];
                return;
            }
            
            //  NSString* mainData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSError* error;
            result = [NSJSONSerialization JSONObjectWithData:data
                                                     options:NSJSONReadingAllowFragments
                                                       error:&error];
            
            if (app.uploadedFileNamesArray == nil)
            {
                app.uploadedFileNamesArray = [[NSMutableArray alloc] init];
            }
            NSString *uploadedFileNameString = [result valueForKey:@"fileName"];
            // uploadedFileNameString = [uploadedFileNameString stringByReplacingOccurrencesOfString:@"/" withString:@""];
            //uploadedFileNameString = [uploadedFileNameString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            
            //[app.uploadedFileNamesArray addObject:[result valueForKey:@"fileName"]];//add the uploaded file names to uploaded file names array to display on detail chating view controller
            
            NSString* returnCode= [result valueForKey:@"code"];
           
            if ([returnCode isEqual:@"1000"])
            {
                [app.uploadedFileNamesArray addObject:[result valueForKey:@"fileName"]];
                                                               //self.navigationItem.rightBarButtonItem.title=nil;
                                               [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"" withMessage:[NSString stringWithFormat:@"%@ uploaded successfully",[app.imageFileNamesArray objectAtIndex:0]] withCancelText:@"Cancel" withOkText:@"Ok" withAlertTag:1000];
                                               //[self.collectionView reloadData];
                                               //[self dismissViewControllerAnimated:YES completion:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    // make some UI changes
                    [[[UIApplication sharedApplication].keyWindow viewWithTag:1122] removeFromSuperview];
                    
                });

                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FILE_UPLOAD object:result];
               
                
                
               // [self presentViewController:alertController animated:YES completion:nil];
                
                //rightBarButton.title=nil;
                
                
            }
            
        }];
        
        
    }
    
    
    
}



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

-(void)uploadFileOfReportOrDocument:(NSDictionary*)dic flag:(NSString*)flag

{
    AppPreferences* app=[AppPreferences sharedAppPreferences];
    
    NSString *destpath1=[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@",[AppPreferences sharedAppPreferences].fileLocation,[app.imageFileNamesArray objectAtIndex:0]]];
    //NSData * data;
    // NSURL* url=[NSURL URLWithString:destpath];
    
    NSData* data=[NSData dataWithContentsOfFile:destpath1];
    // NSURL* url = [NSURL URLWithString:webStringURL];
//    for (int i=0; i<app.imageFilesArray.count; i++)
//    {
        NSError* error;
    if (app.imageFilesArray.count==0)
    {
        data = data;

    }
    else
         data = UIImagePNGRepresentation([app.imageFilesArray objectAtIndex:0]);
    
        NSString *folderpath=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Downloads"];
        
        NSString *destpath=[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/Downloads/%@",[app.imageFileNamesArray objectAtIndex:0]]];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:folderpath])
            [[NSFileManager defaultManager] createDirectoryAtPath:folderpath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
        [data writeToFile:destpath atomically:YES];
        
        NSString* path = [NSHomeDirectory() stringByAppendingPathComponent:
                          [NSString stringWithFormat:@"Documents/Downloads/%@",[app.imageFileNamesArray objectAtIndex:0]] ];
        //--------------------------------------------------//
        NSString* fileName = [app.imageFileNamesArray objectAtIndex:0];
        
        
        //NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", @"http://192.168.3.170:8080/coreflex/feedcom", @"uploadFileFromMobile"]];
        
        // NSString *folderpath=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Downloads/test.png"];
        
        //"http://115.249.195.23:8080/Communicator/feedcom/
       //  NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", @"http://localhost:9090/coreflex/feedcom", @"uploadFileFromMobile"]];
        NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", BASE_URL_PATH, SAVE_REPORT_DOCUMENT]];

        //NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", @"http://115.249.195.23:8080/Communicator/feedcom", @"uploadFileFromMobile"]];
        
        
        NSString *boundary = [self generateBoundaryString];
        
        //NSString *path = [[NSBundle mainBundle] pathForResource:@"AppIcon80x80" ofType:@"png"];
        
        // configure the request
        NSDictionary *params = @{
                                 @"username"     : [[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"],
                                 @"password"     : [[NSUserDefaults standardUserDefaults] valueForKey:@"currentPassword"],
                                 @"feedcomDict"  :dic,
                                 @"flag"         :flag,
};
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        [request setHTTPMethod:@"POST"];
        
        // set content type
        
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
        [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        // create body
        
        NSData *httpBody = [self createBodyWithBoundary:boundary parameters:params paths:@[path] fieldName:fileName];
        
        request.HTTPBody = httpBody;
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (connectionError)
            {
                NSLog(@"error = %@", connectionError);
                return;
            }
            
            //  NSString* mainData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSError* error;
            result = [NSJSONSerialization JSONObjectWithData:data
                                                     options:NSJSONReadingAllowFragments
                                                       error:&error];
            
            if (app.uploadedFileNamesArray == nil)
            {
                app.uploadedFileNamesArray = [[NSMutableArray alloc] init];
            }
//            NSString *uploadedFileNameString = [result valueForKey:@"fileName"];
            // uploadedFileNameString = [uploadedFileNameString stringByReplacingOccurrencesOfString:@"/" withString:@""];
            //uploadedFileNameString = [uploadedFileNameString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            
            //[app.uploadedFileNamesArray addObject:[result valueForKey:@"fileName"]];//add the uploaded file names to uploaded file names array to display on detail chating view controller
            
            NSString* returnCode= [result valueForKey:@"code"];
            
            if ([returnCode isEqual:@"1000"])
            {
                //[app.uploadedFileNamesArray addObject:[result valueForKey:@"fileName"]];
                //self.navigationItem.rightBarButtonItem.title=nil;
                [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"" withMessage:@"File uploaded successfully" withCancelText:@"Cancel" withOkText:@"Ok" withAlertTag:1000];
                
                NSString* fileLocation;
                if ([flag isEqual:@"1"])
                {
                    fileLocation=@"Reports";
                    NSData * data ;
                    if (app.imageFilesArray.count==0)
                    {
                        data=[NSData dataWithContentsOfFile:destpath1];
                    }
                    else
//                    data = UIImagePNGRepresentation([app.imageFilesArray objectAtIndex:0]);
//                    
//                    NSString* str=[NSString stringWithFormat:@"Documents/%@",fileLocation];
//                    //                NSString *folderpath=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Downloads"];
//                    NSString *folderpath=[NSHomeDirectory() stringByAppendingPathComponent:str];
//                    
//                    NSError* error;
//                    NSString*  companyIdMainDictForMOMString= [result valueForKey:@"response"];
//                    NSData *companyIdMainDictForMOMData = [companyIdMainDictForMOMString dataUsingEncoding:NSUTF8StringEncoding];
//                    
//                    NSDictionary *singleReportDict = [NSJSONSerialization JSONObjectWithData:companyIdMainDictForMOMData
//                                                                                     options:NSJSONReadingAllowFragments
//                                                                                       error:&error];
//                    
//                   
//                    NSString* originalFileName= [[singleReportDict valueForKey:@"name"] substringFromIndex:13];
//
//                    NSString *destpath=[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@",str,originalFileName]];
//                    
//                    if (![[NSFileManager defaultManager] fileExistsAtPath:folderpath])
//                        [[NSFileManager defaultManager] createDirectoryAtPath:folderpath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
//                    [data writeToFile:destpath atomically:YES];
                   [[Database shareddatabase] insertNewReportData:result];
                }
                else
                {
                 fileLocation=@"Documents";
                    NSData * data ;
                    if (app.imageFilesArray.count==0)
                    {
                        data=[NSData dataWithContentsOfFile:destpath1];
                    }
                    else
//                        data = UIImagePNGRepresentation([app.imageFilesArray objectAtIndex:0]);
//                    NSString* str=[NSString stringWithFormat:@"Documents/%@",fileLocation];
//                    //                NSString *folderpath=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Downloads"];
//                    NSString *folderpath=[NSHomeDirectory() stringByAppendingPathComponent:str];
//                    
//                    NSError* error;
//                    NSString*  companyIdMainDictForMOMString= [result valueForKey:@"response"];
//                    NSData *companyIdMainDictForMOMData = [companyIdMainDictForMOMString dataUsingEncoding:NSUTF8StringEncoding];
//                    
//                    NSDictionary *singleReportDict = [NSJSONSerialization JSONObjectWithData:companyIdMainDictForMOMData
//                                                                                     options:NSJSONReadingAllowFragments
//                                                                                       error:&error];
//                    
//                    
//                    NSString* originalFileName= [[singleReportDict valueForKey:@"name"] substringFromIndex:13];
//
//                    NSString *destpath=[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@",str,originalFileName]];
//                    if (![[NSFileManager defaultManager] fileExistsAtPath:folderpath])
//                        [[NSFileManager defaultManager] createDirectoryAtPath:folderpath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
//                    [data writeToFile:destpath atomically:YES];
                    [[Database shareddatabase] insertNewDocumentData:result];

                }
                
                //[self.collectionView reloadData];
                //[self dismissViewControllerAnimated:YES completion:nil];
                
                // [self presentViewController:alertController animated:YES completion:nil];
                
                //rightBarButton.title=nil;
                
                
            }
            
        }];
        
        
   // }
    
    
    
}


@end
