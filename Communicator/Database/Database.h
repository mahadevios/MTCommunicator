//
//  Database.h
//  DbExample
//
//  Created by mac on 08/02/16.
//  Copyright © 2016 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "FeedbackType.h"
#import "User.h"
#import "Feedback.h"

@interface Database : NSObject

+(Database *)shareddatabase;

-(NSString *)getDatabasePath;

-(NSMutableArray *)getFeedbackAndQueryTypes;

//-(NSMutableArray *)getFeedbackAndQueryMessages;

@property (strong, nonatomic) NSDictionary *getFeedbackAndQueryMessages;
@property (strong, nonatomic) NSMutableArray *feedbackAndQueryTypeArray;
@property (strong, nonatomic) NSMutableArray *SONoArray;
@property (strong, nonatomic) NSMutableArray *DuplicateSONoArray;

@property (strong, nonatomic) NSMutableDictionary *getFeedbackAndQueryCounter;


//-(void)insertFeedbackData:(NSDictionary*)dic;
//-(void)insertQueryData:(NSDictionary*)dic;
//-(void)updateData:(NSString*)data;



//-------new methods--------//
//login web data insertion
-(void)insertCompanyRelatedFeedbackTypeAndUsers:(NSDictionary*)companyRelatedFeedbackAndUsersDict;

-(void)insertFeedQueryCounter:(NSDictionary*)dic;

-(void)getFeedbackAndQueryCounterForCompany:(NSString*)companyName;

-(void)insertLatestRecordsForFeedcom:(NSDictionary*)dic;

-(void)insertLatestRecordsForMOM:(NSDictionary*)dic;

-(void)insertReportData:(NSDictionary *)notificationData;

-(void)insertDocumentsData:(NSDictionary *)notificationData;

//data fetch for local  use

-(void)getDetailMessagesofFeedbackOrQuery:(int)feedType :(NSString*)SONumber;

//local user validation
-(BOOL)validateUserFromLocalDatabase:(NSString*)usernameString :(NSString*)passwordString;

//for home view
-(void)setDatabaseToCompressAndShowTotalQueryOrFeedback:(NSString*)feedbackType;

-(NSMutableArray*)findPermittedCompaniesForUsername:(NSString*)usernameString Password:(NSString*)passwordString;

-(User*)getUserUsername:(NSString*)username andPassword:(NSString*)pass;

-(NSString*)getCompanyIdFromCompanyName:(NSString*)CompanyId;

-(NSString*)getUserNameFromCompanyname:(NSString*)username;

-(NSString*)getCompanyId:(NSString*)username;

-(NSString*)getUserIdFromUserNameWithRoll1:(NSString*)username;

-(NSString*)getUserIdFromUserName:(NSString*)username;

-(NSString*)getUserNameFromUserId:(int)userId;

-(NSString*)getuserNameFromCompanyId:(NSString*)companyId;

-(NSMutableArray*)getMaxFeedIdAndCounter:(NSString*)soNumber :(int)feedtype;

-(NSMutableArray*)getFeedTypeIdAndMaxCounter:(NSString*)feedbackType;

-(NSMutableArray*)getAllUsersOfCompany:(NSString*)companyId andCompany:(NSString*)companyId1;

-(NSString*)getClosedByUserName:(int)feedbackType andsoNumber:(NSString*)soNumber;

-(NSMutableDictionary*)getAllOperaotorUsernames;

-(NSString*)getCompanyIdFromCompanyName1:(NSString*)CompanyName;

-(NSMutableArray*)getAllUsersFirstnameLastname:(NSString*)company1 company2:(NSString *)company2;

-(int)getFeedbackIdFromFeedbackType:(NSString*)feedbackType;

-(long)getFeedbackCounterFromSONumberAndFeedbackType:(NSString*)sonumber :(int)feedtype;

-(NSString*)getFirstnameLastnameFromUserId:(int)userID;

-(NSString*)getAdminUserId;
//local data insertion(self generated messages)
-(void)insertUpdatedRecordsForFeedcom:(NSDictionary*)recordDict;

-(void)insertNewFeedback:(NSDictionary*)oneMessageDict :(NSDictionary*)responseDict;

-(void)insertNewQuery:(NSDictionary*)responseDict;

-(void)insertNewMOM:(NSDictionary*)responseDict;

-(void)insertNewReportData:(NSDictionary* )notificationData;

-(void)insertNewDocumentData:(NSDictionary* )notificationData;

-(void)updateMom:(int)momId;


//set views

-(void)setMOMView;

-(void)setReportView;

-(void)setDocumentView;

//for logout
-(void)removeUserdata;

//set read status after reading the message
-(void)updateReadStatus:(NSString*)SONumber feedbackType:(NSString*)feedbackType;

//provide user ids to server to get data
-(NSMutableArray*)getFeedbackIDs:(NSString*)feedbackType userFrom:(NSString*)userFrom userTo:(NSString*)userTo;

-(NSMutableArray*)getMOMIds:(NSString*)userFrom userTo:(NSString*)userTo;

-(NSMutableArray*)getDocumentIds:(NSString*)userFrom userTo:(NSString*)userTo;

-(NSMutableArray*)getReportIds:(NSString*)userFrom userTo:(NSString*)userTo;

//load more data of resoective feedback type
-(void)getLoadMoreData:(NSDictionary*)notificationData;

-(void)insertLoadMoreMOMNotificationData:(NSDictionary*)notificationData;

-(void)insertLoadMoreReportNotificationData:(NSDictionary*)notificationData;

-(void)insertLoadMoreDocumentNotificationData:(NSDictionary*)notificationData;

//noti data insertion
-(void)insertFeedcomNotifiationData:(NSDictionary*)notificationDict readStatusflag:(BOOL) readStatusflag;

-(void)insertReportNotificationData:(NSDictionary *)notificationData;

-(void)insertDocumentNotificationData:(NSDictionary *)notificationData;

-(void)insertMOMNotificationData:(NSDictionary *)notificationData;
//-(void)insertUserReply:(Feedback*)feedObj;
//-(void)validateUser:(NSString*)usernameString Password:(NSString *)passwordString andDeviceId:(NSString *)DeviceId
@end
