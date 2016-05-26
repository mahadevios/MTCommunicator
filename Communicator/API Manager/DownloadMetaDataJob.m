//
//  DownloadMetaDataJob.m
//  Communicator
//
//  Created by mac on 05/04/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import "DownloadMetaDataJob.h"
#include <sys/xattr.h>
#import "AppDelegate.h"

/*================================================================================================================================================*/

@implementation DownloadMetaDataJob
@synthesize downLoadEntityJobName;
@synthesize requestParameter;
@synthesize downLoadResourcePath;
@synthesize downLoadJobDelegate;
@synthesize httpMethod;

@synthesize addTrintsAfterSomeTimeTimer;
@synthesize currentSaveTrintIndex;
@synthesize isNewMatchFound;

-(id) initWithdownLoadEntityJobName:(NSString *) jobName withRequestParameter:(id) localRequestParameter withResourcePath:(NSString *) resourcePath withHttpMethd:(NSString *) httpMethodParameter
{
    self = [super init];
    if (self)
    {
        self.downLoadResourcePath = resourcePath;
        self.requestParameter = localRequestParameter;
        self.downLoadEntityJobName = [[NSString alloc] initWithFormat:@"%@",jobName];
        self.httpMethod=httpMethodParameter;
        
        self.isNewMatchFound = [NSNumber numberWithInt:1];
    }
    return self;
}

/*================================================================================================================================================*/

#pragma mark -
#pragma mark StartMetaDataDownload
#pragma mark -

-(void)startMetaDataDownLoad
{
    [self sendRequestWithResourcePath:downLoadResourcePath withRequestParameter:requestParameter withJobName:downLoadEntityJobName withMethodType:httpMethod];
}


-(void) sendRequestWithResourcePath:(NSString *) resourcePath withRequestParameter:(NSDictionary *) dictionary withJobName:(NSString *)jobName withMethodType:(NSString *) httpMethodParameter
{
    responseData = [NSMutableData data];
    
    NSArray *params = [self.requestParameter objectForKey:REQUEST_PARAMETER];
    
    NSMutableString *parameter = [[NSMutableString alloc] init];
    for(NSString *strng in params)
    {
        if([[params objectAtIndex:0] isEqualToString:strng]) {
            [parameter appendFormat:@"%@", strng];
        } else {
            [parameter appendFormat:@"&%@", strng];
        }
    }
    
    NSString *webservicePath = [NSString stringWithFormat:@"%@/%@?%@",BASE_URL_PATH,resourcePath,parameter];
	NSURL *url = [[NSURL alloc] initWithString:[webservicePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120];
    [request setHTTPMethod:httpMethodParameter];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    
    NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    NSLog(@"%@",urlConnection);
}




/*================================================================================================================================================*/

#pragma mark -
#pragma mark - URL connection callbacks
#pragma mark -

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	[responseData setLength:0];
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
    statusCode = (int)[httpResponse statusCode];
    ////NSLog(@"Status code: %d",statusCode);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[responseData appendData:data];
}


- (NSString *)shortErrorFromError:(NSError *)error
{
    return [error localizedDescription];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    ////NSLog(@"Failed %@",error.description);
    ////NSLog(@"%@ Entity Job -",self.downLoadEntityJobName);
    
    if ([self.downLoadEntityJobName isEqualToString:USER_LOGIN_API])
    {
//        AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
//        [appDelegate hideIndefiniteProgressView];
        
        [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Error" withMessage:[self shortErrorFromError:error] withCancelText:nil withOkText:@"Ok" withAlertTag:1000];
        
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    ////NSLog(@"Success");
    
    //NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseData
                                                                 options:NSJSONReadingAllowFragments
                                                                   error:&error];
    
    //NSLog(@"Job Name = %@ Response %@",self.downLoadEntityJobName,response);
    //NSLog(@"%@",response);
    
    if ([self.downLoadEntityJobName isEqualToString:USER_LOGIN_API])
    {
        if (response != nil)
        {
            if ([[response objectForKey:@"code"] isEqualToString:SUCCESS])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_VALIDATE_USER object:response];
                
                
            }else
            {
                [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Error" withMessage:@"username or password is incorrect, please try again" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
            }
        }else
        {
            [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Error" withMessage:@"please try again" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
        }
    }
 
}





@end

/*================================================================================================================================================*/