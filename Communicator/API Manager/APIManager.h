//
//  APIManager.h
//  Communicator
//
//  Created by mac on 05/04/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadMetaDataJob.h"
#import "MBProgressHUD.h"
@interface APIManager : NSObject
{
    NSDictionary* result;

}

+(APIManager *) sharedManager;
@property(nonatomic,strong)MBProgressHUD * hud;

//-(void) validateUser:(NSString *) usernameString andPassword:(NSString *) passwordString;
-(void) validateUser:(NSString *) usernameString Password:(NSString *) passwordString andDeviceId:(NSString*)DeviceId;
-(void) logout:(NSString *) usernameString Password:(NSString *) passwordString;
-(void) forgotPassword:(NSString *) email;
-(void) findCountForUsername:(NSString*)username andPassword:(NSString*)password;
-(void) getLatestRecordsForUsername:(NSString*)username andPassword:(NSString*)password;
-(void) sendUpdatedRecords:(NSString*)flag Dict:(NSDictionary*)feedcomDict username:(NSString*)username password:(NSString*)password;
-(void) sendNewFeedback:(NSString*)flag Dict:(NSDictionary*)feedcomDict username:(NSString*)username password:(NSString*)password;
-(void) sendNewMOM:(NSString*)feedcomDict username:(NSString*)username password:(NSString*)password;

-(void)runMeTaskMobile:(NSString*)username andPassword:(NSString*)password;

-(void) uploadFile:(NSString*)fileName andFileString:(NSString*)fileString;
-(void) getLatestMOMForUsername:(NSString*)usernameString andPassword:(NSString*)passwordString;
-(void) get50ReoprtForUsername:(NSString*)usernameString andPassword:(NSString*)passwordString;
-(void) get50DocumentsForUsername:(NSString*)usernameString andPassword:(NSString*)passwordString;
-(void) updateDevieToken:(NSString *) usernameString Password:(NSString *) passwordString andDeviceId:(NSString*)DeviceToken;

//load more data

-(void)getNew50Records:(NSString*)username password:(NSString*)password userFrom:(NSString*)userFrom userTo:(NSString*)userTo feedbackType:(int)feedbackType feedbackIdsArray:(NSString*)feedbackIdsArray;
-(void)getLoadMoreMOMData:(NSString*)username password:(NSString*)password userFrom:(NSString*)userFrom userTo:(NSString*)userTo feedbackIdsArray:(NSString*)feedbackIdsArray;
-(void)getLoadMoreReportData:(NSString*)username password:(NSString*)password userFrom:(NSString*)userFrom userTo:(NSString*)userTo feedbackIdsArray:(NSString*)feedbackIdsArray;
-(void)getLoadMoreDocumentData:(NSString*)username password:(NSString*)password userFrom:(NSString*)userFrom userTo:(NSString*)userTo feedbackIdsArray:(NSString*)feedbackIdsArray;
-(void) getNotificationLoadMoreDataForUsername:(NSString*)usernameString andPassword:(NSString*)passwordString SONumber:(NSString*)SONumber feedbackType:(NSString*)feedbackType userFrom:(NSString*)userFrom userTo:(NSString*)userTo;

//noti data

-(void) getNotificationDataForUsername:(NSString*)usernameString andPassword:(NSString*)passwordString SONumber:(NSString*)SONumber feedbackType:(NSString*)feedbackType
userFrom:(NSString*)userFrom userTo:(NSString*)userTo;
-(void) getReoprtForUsername:(NSString*)usernameString andPassword:(NSString*)passwordString reportId:(NSString*)reportId;//get report noti data
-(void) getDocumentsForUsername:(NSString*)usernameString andPassword:(NSString*)passwordString documentId:(NSString*)documentId;//get docs noti data
-(void) getMOMForUsername:(NSString*)usernameString andPassword:(NSString*)passwordString momId:(NSString*)momId;//get mom noti data

-(void)getFile;

-(NSString*) getDate;
-(void)uploadFileToServer;
-(void)uploadFileOfReportOrDocument:(NSDictionary*)dic flag:(NSString*)flag;
@end
