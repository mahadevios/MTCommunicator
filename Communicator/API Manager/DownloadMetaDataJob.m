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
#import "LoginViewController.h"
/*================================================================================================================================================*/

@implementation DownloadMetaDataJob
@synthesize downLoadEntityJobName,hud;
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
        //[self sendRequestWithResourcePath:downLoadResourcePath withRequestParameter:requestParameter withJobName:downLoadEntityJobName withMethodType:httpMethod];
    [self sendNewRequestWithResourcePath:downLoadResourcePath withRequestParameter:requestParameter withJobName:downLoadEntityJobName withMethodType:httpMethod];
}
//-(void)startCounterDownLoad
//{
//    //[self sendRequestWithResourcePath:downLoadResourcePath withRequestParameter:requestParameter withJobName:downLoadEntityJobName withMethodType:httpMethod];
//    [self sendFindCounterRequestWithResourcePath:downLoadResourcePath withRequestParameter:requestParameter withJobName:downLoadEntityJobName withMethodType:httpMethod];
//}
//-(void)startGetLatestRecordsDownLoad
//{
//    //[self sendRequestWithResourcePath:downLoadResourcePath withRequestParameter:requestParameter withJobName:downLoadEntityJobName withMethodType:httpMethod];
//    [self sendNewRequestWithResourcePath:downLoadResourcePath withRequestParameter:requestParameter withJobName:downLoadEntityJobName withMethodType:httpMethod];
//
//}
//-(void)startSendUpdatedRecords
//{
//    //[self sendRequestWithResourcePath:downLoadResourcePath withRequestParameter:requestParameter withJobName:downLoadEntityJobName withMethodType:httpMethod];
//    [self sendNewRequestWithResourcePath:downLoadResourcePath withRequestParameter:requestParameter withJobName:downLoadEntityJobName withMethodType:httpMethod];
//}




//-(void) sendRequestWithResourcePath:(NSString *) resourcePath withRequestParameter:(NSDictionary *) dictionary withJobName:(NSString *)jobName withMethodType:(NSString *) httpMethodParameter
//{
//    responseData = [NSMutableData data];
//    
//    NSArray *params = [self.requestParameter objectForKey:REQUEST_PARAMETER];
//    
//    NSMutableString *parameter = [[NSMutableString alloc] init];
//    for(NSString *strng in params)
//    {
//        if([[params objectAtIndex:0] isEqualToString:strng]) {
//            [parameter appendFormat:@"%@", strng];
//        } else {
//            [parameter appendFormat:@"&%@", strng];
//        }
//    }
//    
//    NSString *webservicePath = [NSString stringWithFormat:@"%@/%@?%@",BASE_URL_PATH,resourcePath,parameter];
//	NSURL *url = [[NSURL alloc] initWithString:[webservicePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120];
//    [request setHTTPMethod:httpMethodParameter];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    
//    
//    NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//    NSLog(@"%@",urlConnection);
//}


-(void) sendNewRequestWithResourcePath:(NSString *) resourcePath withRequestParameter:(NSDictionary *) dictionary withJobName:(NSString *)jobName withMethodType:(NSString *) httpMethodParameter
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

//-(void) sendFindCounterRequestWithResourcePath:(NSString *) resourcePath withRequestParameter:(NSDictionary *) dictionary withJobName:(NSString *)jobName withMethodType:(NSString *) httpMethodParameter
//{
//    responseData = [NSMutableData data];
//    
//    NSArray *params = [self.requestParameter objectForKey:REQUEST_PARAMETER];
//    
//    NSMutableString *parameter = [[NSMutableString alloc] init];
//    for(NSString *strng in params)
//    {
//        if([[params objectAtIndex:0] isEqualToString:strng]) {
//            [parameter appendFormat:@"%@", strng];
//        } else {
//            [parameter appendFormat:@"&%@", strng];
//        }
//    }
//    
//    NSString *webservicePath = [NSString stringWithFormat:@"%@/%@",BASE_URL_PATH,resourcePath];
//    NSURL *url = [[NSURL alloc] initWithString:[webservicePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120];
//    [request setHTTPMethod:httpMethodParameter];
// //   [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//   // [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    
//    
//    NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//    NSLog(@"%@",urlConnection);
//
//
//}
//
//
//-(void) sendGetLatestRecordsRequestWithResourcePath:(NSString *) resourcePath withRequestParameter:(NSDictionary *) dictionary withJobName:(NSString *)jobName withMethodType:(NSString *) httpMethodParameter
//{
//    responseData = [NSMutableData data];
//    
//    NSArray *params = [self.requestParameter objectForKey:REQUEST_PARAMETER];
//    
//    NSMutableString *parameter = [[NSMutableString alloc] init];
//    for(NSString *strng in params)
//    {
//        if([[params objectAtIndex:0] isEqualToString:strng]) {
//            [parameter appendFormat:@"%@", strng];
//        } else {
//            [parameter appendFormat:@"&%@", strng];
//        }
//    }
//    
//    NSString *webservicePath = [NSString stringWithFormat:@"%@/%@?%@",BASE_URL_PATH,resourcePath,parameter];
//    NSURL *url = [[NSURL alloc] initWithString:[webservicePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120];
//    [request setHTTPMethod:httpMethodParameter];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    
//    
//    NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//    NSLog(@"%@",urlConnection);
//    
//    
//}
//
//
//
//
//-(void) sendUpdatedRecordsRequestWithResourcePath:(NSString *) resourcePath withRequestParameter:(NSDictionary *) dictionary withJobName:(NSString *)jobName withMethodType:(NSString *) httpMethodParameter
//{
//    responseData = [NSMutableData data];
//    
//    NSArray *params = [self.requestParameter objectForKey:REQUEST_PARAMETER];
//    
//    NSMutableString *parameter = [[NSMutableString alloc] init];
//    for(NSString *strng in params)
//    {
//        if([[params objectAtIndex:0] isEqualToString:strng]) {
//            [parameter appendFormat:@"%@", strng];
//        } else {
//            [parameter appendFormat:@"&%@", strng];
//        }
//    }
//    
//    NSString *webservicePath = [NSString stringWithFormat:@"%@/%@?%@",BASE_URL_PATH,resourcePath,parameter];
//    NSURL *url = [[NSURL alloc] initWithString:[webservicePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120];
//    [request setHTTPMethod:httpMethodParameter];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    
//    
//    NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//    NSLog(@"%@",urlConnection);
//    
//    
//}
//
//

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
    
//    if ([self.downLoadEntityJobName isEqualToString:USER_LOGIN_API])
//    {
////        AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
////        [appDelegate hideIndefiniteProgressView];
//        
//        [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Error" withMessage:[self shortErrorFromError:error] withCancelText:nil withOkText:@"Ok" withAlertTag:1000];
//        
//    }
    [hud hideAnimated:YES];

    if ([self.downLoadEntityJobName isEqualToString:NEW_USER_LOGIN_API])
    {
        //        AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        //        [appDelegate hideIndefiniteProgressView];
        [[[UIApplication sharedApplication].keyWindow viewWithTag:789] removeFromSuperview];
        [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Error" withMessage:[self shortErrorFromError:error] withCancelText:nil withOkText:@"Ok" withAlertTag:1000];
        
    }
    
    if ([self.downLoadEntityJobName isEqualToString:FIND_COUNT_API])
    {
        //        AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        //        [appDelegate hideIndefiniteProgressView];
        [[[UIApplication sharedApplication].keyWindow viewWithTag:789] removeFromSuperview];

        [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Error" withMessage:[self shortErrorFromError:error] withCancelText:nil withOkText:@"Ok" withAlertTag:1000];
        
    }
    if ([self.downLoadEntityJobName isEqualToString:LOGOUT_API])
    {
        //        AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        //        [appDelegate hideIndefiniteProgressView];
        [[[UIApplication sharedApplication].keyWindow viewWithTag:789] removeFromSuperview];
        
        [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Error" withMessage:[self shortErrorFromError:error] withCancelText:nil withOkText:@"Ok" withAlertTag:1000];
        
    }

    if ([self.downLoadEntityJobName isEqualToString:FORGOT_PASSWORD_API])
    {
        //        AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        //        [appDelegate hideIndefiniteProgressView];
        [[[UIApplication sharedApplication].keyWindow viewWithTag:789] removeFromSuperview];
        
        [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Error" withMessage:[self shortErrorFromError:error] withCancelText:nil withOkText:@"Ok" withAlertTag:1000];
        
    }

    if ([self.downLoadEntityJobName isEqualToString:GET_LATEST_RECORDS])
    {
        //        AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        //        [appDelegate hideIndefiniteProgressView];
        [[[UIApplication sharedApplication].keyWindow viewWithTag:789] removeFromSuperview];

        [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Error" withMessage:[self shortErrorFromError:error] withCancelText:nil withOkText:@"Ok" withAlertTag:1000];
        
    }

    if ([self.downLoadEntityJobName isEqualToString:GET_LATEST_MOM])
    {
        //        AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        //        [appDelegate hideIndefiniteProgressView];
        
        [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Error" withMessage:[self shortErrorFromError:error] withCancelText:nil withOkText:@"Ok" withAlertTag:1000];
        
    }
    
    if ([self.downLoadEntityJobName isEqualToString:GET_50_REPORTS])
    {
        //        AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        //        [appDelegate hideIndefiniteProgressView];
        
        [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Error" withMessage:[self shortErrorFromError:error] withCancelText:nil withOkText:@"Ok" withAlertTag:1000];
        
    }
    if ([self.downLoadEntityJobName isEqualToString:GET_50_DOCUMENTS])
    {
        //        AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        //        [appDelegate hideIndefiniteProgressView];
        
        [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Error" withMessage:[self shortErrorFromError:error] withCancelText:nil withOkText:@"Ok" withAlertTag:1000];
        
    }
    
    if ([self.downLoadEntityJobName isEqualToString:SEND_NEW_FEEDBACK])
    {
        //        AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        //        [appDelegate hideIndefiniteProgressView];
        [[[UIApplication sharedApplication].keyWindow viewWithTag:789] removeFromSuperview];

        [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Error" withMessage:[self shortErrorFromError:error] withCancelText:nil withOkText:@"Ok" withAlertTag:1000];
        
    }
    if ([self.downLoadEntityJobName isEqualToString:SEND_NEW_MOM])
    {
        //        AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        //        [appDelegate hideIndefiniteProgressView];
        [[[UIApplication sharedApplication].keyWindow viewWithTag:789] removeFromSuperview];

        [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Error" withMessage:[self shortErrorFromError:error] withCancelText:nil withOkText:@"Ok" withAlertTag:1000];
        
    }
    if ([self.downLoadEntityJobName isEqualToString:SEND_UPDATED_RECORDS])
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
    
//    if ([self.downLoadEntityJobName isEqualToString:USER_LOGIN_API])
//    {
//        if (response != nil)
//        {
//            if ([[response objectForKey:@"code"] isEqualToString:SUCCESS])
//            {
//                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_VALIDATE_USER object:response];
//                
//                
//            }else
//            {
//                [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Error" withMessage:@"username or password is incorrect, please try again" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
//            }
//        }else
//        {
//            [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Error" withMessage:@"please try again" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
//        }
//    }
 
    
    
    
    if ([self.downLoadEntityJobName isEqualToString:NEW_USER_LOGIN_API])
    {
        
        if (response != nil)
        {
            
            if ([[response objectForKey:@"code"] isEqualToString:SUCCESS])
            {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_VALIDATE_USER object:response];
                
                
            }else
            {
                [[[UIApplication sharedApplication].keyWindow viewWithTag:789] removeFromSuperview];

                [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Error" withMessage:@"username or password is incorrect, please try again" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
            }
        }else
        {
            [[[UIApplication sharedApplication].keyWindow viewWithTag:789] removeFromSuperview];
            [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Error" withMessage:@"please try again" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
        }
    }
    if ([self.downLoadEntityJobName isEqualToString:RUN_ME_TASK])
    {
        
        if (response != nil)
        {
            
                }

    }
    if ([self.downLoadEntityJobName isEqualToString:UPDATE_DEVICE_TOKEN])
    {
        
        if (response != nil)
        {
            
            if ([[response objectForKey:@"code"] isEqualToString:SUCCESS])
            {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPDATE_DEVICE_TOKEN object:response];
                
                
            }else
            {
              //  [[[UIApplication sharedApplication].keyWindow viewWithTag:789] removeFromSuperview];
                
              //  [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Error" withMessage:@"username or password is incorrect, please try again" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
            }
        }else
        {
            //[[[UIApplication sharedApplication].keyWindow viewWithTag:789] removeFromSuperview];
            //[[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Error" withMessage:@"please try again" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
        }
    }

    if ([self.downLoadEntityJobName isEqualToString:FORGOT_PASSWORD_API])
    {
        
        if (response != nil)
        {
            
            if ([[response objectForKey:@"code"] isEqualToString:SUCCESS])
            {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FORGOT_PASSWORD_API object:response];
                
                
            }else
            {
                //  [[[UIApplication sharedApplication].keyWindow viewWithTag:789] removeFromSuperview];
                
                  [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"" withMessage:@"Incorrect email id" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
            }
        }else
        {
            //[[[UIApplication sharedApplication].keyWindow viewWithTag:789] removeFromSuperview];
            //[[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Error" withMessage:@"please try again" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
        }
    }

    
    
    if ([self.downLoadEntityJobName isEqualToString:FIND_COUNT_API])
    {
        
        if (response != nil)
        {
            
            if ([[response objectForKey:@"code"] isEqualToString:SUCCESS])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_VALIDATE_COUNTER object:response];
                
                
            }else
            {
                [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Error" withMessage:@"username or password is incorrect, please try again" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
            }
        }else
        {
            [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Error" withMessage:@"please try again" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
        }
    }
    
    
    if ([self.downLoadEntityJobName isEqualToString:GET_LATEST_RECORDS])
    {
        
        if (response != nil)
        {
            
            if ([[response objectForKey:@"code"] isEqualToString:SUCCESS])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GETLATEST_FEEDCOM object:response];
                
                
            }else
            {
                [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Error" withMessage:@"username or password is incorrect, please try again" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
            }
        }else
        {
            [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Error" withMessage:@"please try again" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
        }
    }
    
    if ([self.downLoadEntityJobName isEqualToString:GET_LATEST_MOM])
    {
        
        if (response != nil)
        {
            
            if ([[response objectForKey:@"code"] isEqualToString:SUCCESS])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GETLATEST_MOM object:response];
                
                
            }else
            {
                [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Error" withMessage:@"username or password is incorrect, please try again" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
            }
        }else
        {
            [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Error" withMessage:@"please try again" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
        }
    }
    
    
    if ([self.downLoadEntityJobName isEqualToString:GET_50_REPORTS])
    {
        
        if (response != nil)
        {
            
            if ([[response objectForKey:@"code"] isEqualToString:SUCCESS])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GET_50REPORTS object:response];
                
                
            }else
            {
                [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Error" withMessage:@"username or password is incorrect, please try again" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
            }
        }else
        {
            [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Error" withMessage:@"please try again" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
        }
    }


    if ([self.downLoadEntityJobName isEqualToString:GET_50_DOCUMENTS])
    {
        
        if (response != nil)
        {
            
            if ([[response objectForKey:@"code"] isEqualToString:SUCCESS])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GET_50DOCUMENTS object:response];
                
                
            }else
            {
                [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Error" withMessage:@"username or password is incorrect, please try again" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
            }
        }else
        {
            [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Error" withMessage:@"please try again" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
        }
    }
    
    if ([self.downLoadEntityJobName isEqualToString:SEND_NEW_FEEDBACK])
    {
        
        if (response != nil)
        {
            
            if ([[response objectForKey:@"code"] isEqualToString:SUCCESS])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SEND_NEWFEEDBACK object:response];
                
                
            }else
            {
                [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Error" withMessage:@"username or password is incorrect, please try again" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
            }
        }else
        {
            [[[UIApplication sharedApplication].keyWindow viewWithTag:789] removeFromSuperview];

            [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Error" withMessage:@"please try again" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
        }
    }

    if ([self.downLoadEntityJobName isEqualToString:SEND_NEW_MOM])
    {
        
        if (response != nil)
        {
            
            if ([[response objectForKey:@"code"] isEqualToString:SUCCESS])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SEND_MOM object:response];
                
                
            }else
            {
                [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Error" withMessage:@"username or password is incorrect, please try again" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
            }
        }else
        {
            [[[UIApplication sharedApplication].keyWindow viewWithTag:789] removeFromSuperview];

            [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Error" withMessage:@"please try again" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
        }
    }

    if ([self.downLoadEntityJobName isEqualToString:SEND_UPDATED_RECORDS])
    {
        
        if (response != nil)
        {
            
            if ([[response objectForKey:@"code"] isEqualToString:SUCCESS])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SEND_UPDATED_RECORDS object:response];
                
                
            }else
            {
                [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Error" withMessage:@"username or password is incorrect, please try again" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
            }
        }else
        {
            [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Error" withMessage:@"please try again" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
        }
    }

    
    if ([self.downLoadEntityJobName isEqualToString:GET_NOTIFICATION_DATA])
    {
        
        if (response != nil)
        {
            
            if ([[response objectForKey:@"code"] isEqualToString:SUCCESS])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GET_NOTIFICATION_DATA object:response];
                
                
            }else
            {
                [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Error" withMessage:@"username or password is incorrect, please try again" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
            }
        }else
        {
            [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Error" withMessage:@"please try again" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
        }
    }
    
    if ([self.downLoadEntityJobName isEqualToString:GET_ALL_MSGS_LOAD_MORE_DATA1])
    {
        
        if (response != nil)
        {
            
            if ([[response objectForKey:@"code"] isEqualToString:SUCCESS])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GET_ALL_MSGS_LOAD_MORE_DATA object:response];
                
                
            }else
            {
                [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Error" withMessage:@"username or password is incorrect, please try again" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
            }
        }else
        {
            [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Error" withMessage:@"please try again" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
        }
    }


    if ([self.downLoadEntityJobName isEqualToString:GET_50_NEW_FEEDBACK_RECORDS])
    {
        
        if (response != nil)
        {
            
            if ([[response objectForKey:@"code"] isEqualToString:SUCCESS])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_50_NEW_FEEDBACK_RECORDS object:response];
                
                
            }else
            {
                [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Error" withMessage:@"username or password is incorrect, please try again" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
            }
        }else
        {
            [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Error" withMessage:@"please try again" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
        }
    }

    
    if ([self.downLoadEntityJobName isEqualToString:GET_REPORT_NOTI_DATA])
    {
        
        if (response != nil)
        {
            
            if ([[response objectForKey:@"code"] isEqualToString:SUCCESS])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REPORT_NOTI_DATA object:response];
                
                
            }else
            {
                [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Error" withMessage:@"username or password is incorrect, please try again" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
            }
        }else
        {
            [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Error" withMessage:@"please try again" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
        }
    }

    if ([self.downLoadEntityJobName isEqualToString:GET_DOCS_NOTI_DATA])
    {
        
        if (response != nil)
        {
            
            if ([[response objectForKey:@"code"] isEqualToString:SUCCESS])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DOCS_NOTI_DATA object:response];
                
                
            }else
            {
                [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Error" withMessage:@"username or password is incorrect, please try again" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
            }
        }else
        {
            [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Error" withMessage:@"please try again" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
        }
    }

    if ([self.downLoadEntityJobName isEqualToString:GET_MOM_NOTI_DATA])
    {
        
        if (response != nil)
        {
            
            if ([[response objectForKey:@"code"] isEqualToString:SUCCESS])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_MOM_NOTI_DATA object:response];
                
                
            }else
            {
                [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Error" withMessage:@"username or password is incorrect, please try again" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
            }
        }else
        {
            [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Error" withMessage:@"please try again" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
        }
    }
    
    if ([self.downLoadEntityJobName isEqualToString:GET_50_MOM_LOAD_MORE_DATA])
    {
        
        if (response != nil)
        {
            
            if ([[response objectForKey:@"code"] isEqualToString:SUCCESS])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_MOM_LOAD_MORE_DATA object:response];
                
                
            }else
            {
                [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Error" withMessage:@"username or password is incorrect, please try again" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
            }
        }else
        {
            [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Error" withMessage:@"please try again" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
        }
    }

    if ([self.downLoadEntityJobName isEqualToString:GET_50_REPORT_LOAD_MORE_DATA])
    {
        
        if (response != nil)
        {
            
            if ([[response objectForKey:@"code"] isEqualToString:SUCCESS])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REPORT_LOAD_MORE_DATA object:response];
                
                
            }else
            {
                [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Error" withMessage:@"username or password is incorrect, please try again" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
            }
        }else
        {
            [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"Error" withMessage:@"please try again" withCancelText:nil withOkText:@"OK" withAlertTag:1000];
        }
    }
    if ([self.downLoadEntityJobName isEqualToString:GET_50_DOCUMENT_LOAD_MORE_DATA])
    {
        
        if (response != nil)
        {
            
            if ([[response objectForKey:@"code"] isEqualToString:SUCCESS])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DOCUMENT_LOAD_MORE_DATA object:response];
                
                
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
