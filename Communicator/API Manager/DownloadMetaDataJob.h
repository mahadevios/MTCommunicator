//
//  DownloadMetaDataJob.h
//  Communicator
//
//  Created by mac on 05/04/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//
/*================================================================================================================================================*/

#import <Foundation/Foundation.h>
#import "SBJson4.h"
#import "objc/runtime.h"
#import "MBProgressHUD.h"

@protocol DownloadMetaDataJobDelegate;

@interface DownloadMetaDataJob : NSObject
{
    NSString        *downLoadEntityJobName;
    NSString        *downLoadResourcePath;
    NSString        *httpMethod;
   
    NSMutableData   *responseData;
    
    NSDictionary      *requestParameter;
    
    float				bytesReceived;
	long long			expectedBytes;
    float               percentComplete;
    float               progress;
    
    id<DownloadMetaDataJobDelegate> downLoadJobDelegate;
    
    NSDate          *startDate;
    
    int             statusCode;
}

/*================================================================================================================================================*/
@property(nonatomic,strong)MBProgressHUD * hud;

@property (nonatomic,strong)  NSString              *downLoadEntityJobName;
@property (nonatomic,strong)  UIWindow              *window;

@property (nonatomic,strong)  NSString              *downLoadResourcePath;
@property (nonatomic,strong)  NSDictionary          *requestParameter;
@property (nonatomic,strong)  NSString              *httpMethod;
@property (nonatomic,strong)  id<DownloadMetaDataJobDelegate> downLoadJobDelegate;

@property (nonatomic,strong)  NSTimer               *addTrintsAfterSomeTimeTimer;

@property (nonatomic,assign)  int                   currentSaveTrintIndex;
@property (nonatomic,assign)  NSNumber              *isNewMatchFound;

-(id) initWithdownLoadEntityJobName:(NSString *) jobName withRequestParameter:(id) localRequestParameter withResourcePath:(NSString *) resourcePath withHttpMethd:(NSString *) httpMethodParameter;
-(void) startMetaDataDownLoad;
-(void)startCounterDownLoad;
-(void)startGetLatestRecordsDownLoad;
-(void)startSendUpdatedRecords;


@end

/*================================================================================================================================================*/

@protocol DownloadMetaDataJobDelegate

- (void) messageSentResponseDidReceived:(NSDictionary *) responseDic;

@end

/*================================================================================================================================================*/
