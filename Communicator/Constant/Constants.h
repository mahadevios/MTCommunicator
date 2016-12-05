//
//  Constants.h
//  Communicator
//
//  Created by mac on 23/04/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

//http://localhost:9090/coreflex/
//http://115.249.195.23:8080/Xanadu_MT/

#define  BASE_URL_PATH                  @"http://192.168.3.80:9090/coreflex/feedcom"
//#define  BASE_URL_PATH                  @"http://115.249.195.23:8080/Xanadu_MT/feedcom"


//#define  BASE_URL_PATH                  @"http://192.168.3.75:9091/coreflex/feedcom"

//#define HTTP_UPLOAD_PATH                @"http://localhost:9090/coreflex/resources/CfsFiles/" //local server
//#define HTTP_UPLOAD_PATH                @"http://115.249.195.23:8080/Xanadu_MT/resources/CfsFiles/" //local server
//http://115.249.195.23:8080/Communicator
//#define  BASE_URL_PATH                  @"http://115.249.195.23:8080/Communicator/feedcom"  //live server

//#define  BASE_URL_PATH                  @"http://192.168.3.170:8080/coreflex/feedcom"
//#define HTTP_UPLOAD_PATH                @"http://192.168.3.170:8080/coreflex/resources/CfsFiles/"  //nikhil sir server

#define FTPHostName                     @"@pantudantukids.com"
#define FTPFilesFolderName              @"/TEST/"
#define FTPUsername                     @"demoFtp%40pantudantukids.com"
#define FTPPassword                     @"asdf123"

#define  POST                           @"POST"
#define  GET                            @"GET"
#define  PUT                            @"PUT"
#define  REQUEST_PARAMETER              @"requestParameter"
#define  SUCCESS                        @"1000"
#define  FAILURE                        @"1001"
#define DATE_TIME_FORMAT                       @"yyyy-MM-dd HH:mm:ss"

// API List
//#define  USER_LOGIN_API                @"getListOfFeedcomAndQueryComForCommunication"
#define NEW_USER_LOGIN_API             @"login"
#define LOGOUT_API                     @"logout"
#define FORGOT_PASSWORD_API            @"forgotPassword"
//at login
#define FIND_COUNT_API                 @"getcommunicationCounterForFeedComQueryCom"
#define GET_LATEST_RECORDS             @"getListOfFeedcomAndQueryComForCommunication"
#define GET_50_REPORTS                 @"getListOf50Reports"
#define GET_50_DOCUMENTS               @"getListOf50Documents"
#define GET_LATEST_MOM                 @"getListOf50MOM"
#define RUN_ME_TASK                    @"runMeTaskMobile"  

//get notification data
#define GET_NOTIFICATION_DATA          @"IssueTypeFcmNotification"
#define GET_REPORT_NOTI_DATA           @"reportFcmNotification"
#define GET_DOCS_NOTI_DATA             @"documentFcmNotification"
#define GET_MOM_NOTI_DATA              @"MomFcmNotification"
#define GET_ALL_MSGS_LOAD_MORE_DATA1   @"IssueTypeFcmNotification1"//proxy for load more data to avoid post noti in app delegate

//load more data
#define GET_50_NEW_FEEDBACK_RECORDS    @"readNew50Feedback"
#define GET_50_MOM_LOAD_MORE_DATA      @"readNew50Mom"
#define GET_50_REPORT_LOAD_MORE_DATA   @"readNew50Report"
#define GET_50_DOCUMENT_LOAD_MORE_DATA @"readNew50Document"
#define GET_ALL_MSGS_LOAD_MORE_DATA    @"IssueTypeFcmNotification"

//send data
#define SEND_UPDATED_RECORDS           @"updatedMobileFeedcomCommunication"
#define SEND_NEW_FEEDBACK              @"newMobileFeedcomCommunication"
#define SEND_NEW_MOM                   @"newMobileMOM"
#define UPLOAD_FILE                    @"uploadFileFromMobile"
#define UPDATE_DEVICE_TOKEN            @"UpdateDeviceToken"


#define FILEPATH                       @"146617501944601 Soch Na Sake - Version 1 Airlift (Arijit Singh) 190Kbps.mp3"
#define GET_OLD_RECORDS                @"getListOfFeedcomForOldDataCommunication"
#define SAVE_REPORT_DOCUMENT           @"saveNewReportAndDocument"
//getListOfFeedcomForCommunication

//NSNOTIFICATION

//at login web services constants
#define NOTIFICATION_VALIDATE_USER                  @"notificationForValidationOfUser"
#define NOTIFICATION_FORGOT_PASSWORD_API             @"notificationForgotPassword"

#define NOTIFICATION_VALIDATE_COUNTER               @"notificationForValidationOfCounter"
#define NOTIFICATION_GETLATEST_FEEDCOM              @"notificationForLatestFeedcom"
#define NOTIFICATION_GETLATEST_MOM                  @"notificationForLatestMOM"
#define NOTIFICATION_GET_50REPORTS                  @"notificationFor50Reports"
#define NOTIFICATION_GET_50DOCUMENTS                @"notificationFor50Documents"


#define FILEPATHNOTI                                @"filepath"

//load more data constants
#define NOTIFICATION_50_NEW_FEEDBACK_RECORDS        @"notification50newrecords"
#define NOTIFICATION_MOM_LOAD_MORE_DATA             @"loadMoreMOMData"
#define NOTIFICATION_REPORT_LOAD_MORE_DATA          @"loadMoreReportData"
#define NOTIFICATION_DOCUMENT_LOAD_MORE_DATA        @"loadMoreDocumentData"
#define NOTIFICATION_GET_ALL_MSGS_LOAD_MORE_DATA    @"loadMoreMSGsData"

//local data update constants
#define NOTIFICATION_NEW_DATA_UPDATE                @"notificationNewDataUpdate"
#define NOTIFICATION_UPDATE_TABLEVIEW               @"notificationUpdateTableView"
#define NOTIFICATION_UPADTE_MOM_VIEW                @"notificationUpdateMOMView"
#define NOTIFICATION_UPADTE_REPORT_DOCS_VIEW        @"notificationUpdateReportDocsView"
#define NOTIFICATION_ADD_FEEDBACK_BUTTON            @"notificationAddFeedbackButton"
#define NOTIFICATION_ADD_MOM_BUTTON                 @"notificationAddMOMButton"
#define NOTIFICATION_UPDATE_DEVICE_TOKEN            @"updateDeviceToken"
#define NOTIFICATION_FILE_UPLOAD                    @"fileUpload"

//send data constants
#define NOTIFICATION_SEND_NEWFEEDBACK               @"notificationForNewFeedback"
#define NOTIFICATION_SEND_MOM                       @"notificationForNewMOM"
#define NOTIFICATION_SEND_UPDATED_RECORDS           @"notificationForUpdatedRecords"

//get notification data constants(when user touch on noti)
#define NOTIFICATION_GET_NOTIFICATION_DATA          @"notificationData"
#define NOTIFICATION_REPORT_NOTI_DATA               @"reportData"
#define NOTIFICATION_DOCS_NOTI_DATA                 @"docsData"
#define NOTIFICATION_MOM_NOTI_DATA                  @"momData"



#endif /* Constants_h */
