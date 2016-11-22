//
//  UploadFileViewController.m
//  Communicator
//
//  Created by mac on 21/06/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import "UploadFileViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIColor+CommunicatorColor.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "NetworkManager.h"
#import <CFNetwork/CFNetwork.h>
enum {
    kSendBufferSize = 32768
};

@interface UploadFileViewController ()

@end

@implementation UploadFileViewController
//{
//    uint8_t                     _buffer[kSendBufferSize];
//}

@synthesize rightBarButton,hud;
- (void)viewDidLoad
{
    [super viewDidLoad];
    AppPreferences* app=[AppPreferences sharedAppPreferences];
    app.imageFilesArray=[[NSMutableArray alloc]init];
    app.imageFileNamesArray=[[NSMutableArray alloc]init];
    rightBarButton.tintColor=[UIColor whiteColor];
    if (app.imageFilesArray.count==0) {
        rightBarButton.title=@"";
    }
    [self setNeedsStatusBarAppearanceUpdate];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.barTintColor = [UIColor communicatorColor];
    [self.navigationController.navigationBar setBarStyle:UIStatusBarStyleLightContent];//
    [[self.view viewWithTag:11] setHidden:YES];
    [[self.view viewWithTag:12] setHidden:YES];
    [[self.view viewWithTag:101] setHidden:YES];

    UILabel* fileNameLabel=[self.view viewWithTag:110];
    if ([AppPreferences sharedAppPreferences].imageFileNamesArray.count>0)
    {
        fileNameLabel.text=[[AppPreferences sharedAppPreferences].imageFileNamesArray objectAtIndex:0];
    }
    [[[UIApplication sharedApplication].keyWindow viewWithTag:901] removeFromSuperview];

//    self.tabBarController.navigationItem.title = @"Upload Files";

   // self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@""] style:UIBarButtonItemStylePlain target:self action:nil] ;
    
    //    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@""] style:UIBarButtonItemStylePlain target:self action:@selector(uploadFileToServer:)] ;
//    
   // self.navigationItem.rightBarButtonItem.title=@"Upload";
    
    
   // [self.tabBarController.tabBar setHidden:YES];
    self.navigationItem.title = @"Upload files";
    
    self.navigationItem.leftBarButtonItem.tintColor=[UIColor whiteColor];
    


}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (IBAction)disMissViewController:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)uploadFileButtonClciked:(id)sender
{
    alertController = [UIAlertController alertControllerWithTitle:@""
                                                          message:@"Are you sure to upload this file?"
                                                   preferredStyle:UIAlertControllerStyleAlert];
    actionDelete = [UIAlertAction actionWithTitle:@"Yes"
                                            style:UIAlertActionStyleDefault
                                          handler:^(UIAlertAction * action)
                    {
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            //Do background work
                            
                            if ([self.presentingViewController isKindOfClass:[UITabBarController class]])
                            {
                                UITabBarController* vc= self.presentingViewController;
                                //        long a=vc.selectedIndex;
                                NSString* username = [[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"];
                                NSString* companyId=[[Database shareddatabase] getCompanyId:username];
                                NSString* userFeedback=[[Database shareddatabase] getUserIdFromUserName:username];
                                NSString *userFrom,*userTo;
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
                                NSString* flag= [[NSUserDefaults standardUserDefaults]valueForKey:@"flag1"];
                                if ([flag isEqualToString:@"0"])
                                {
                                    flag=@"1";
                                }
                                else
                                {
                                    flag=@"2";
                                    
                                }
                                NSDictionary* dic=[NSDictionary dictionaryWithObjectsAndKeys:userFrom,@"userFrom",userTo,@"userTo",userFeedback,@"userFeedback" ,nil];
                                [[APIManager sharedManager] uploadFileOfReportOrDocument:dic flag:flag];
                                
                                
                                
                            }
                            else
                            {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    // make some UI changes
                                    // ...
                                    hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
                                    //hud = [MBProgressHUD new];

                                    [[UIApplication sharedApplication].keyWindow addSubview:hud];
                                    hud.tag=1122;
                                    hud.label.text = @"Uploading...";
                                    hud.detailsLabel.text=@" Please wait";
                                    hud.minSize = CGSizeMake(150.f, 100.f);
                                                                   });

                                
                                [[APIManager sharedManager] uploadFileToServer];
                            }                           //[self uploadFileToServer:@""];
                            
                            //[self startSend:@""];
                        });
                        [self dismissViewControllerAnimated:YES completion:nil];
                        
                        
                    }]; //You can use a block here to handle a press on this button
    [alertController addAction:actionDelete];
    
    
    actionCancel = [UIAlertAction actionWithTitle:@"No"
                                            style:UIAlertActionStyleCancel
                                          handler:^(UIAlertAction * action)
                    {
                        [alertController dismissViewControllerAnimated:YES completion:nil];
                        
                    }]; //You can use a block here to handle a press on this button
    [alertController addAction:actionCancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

//- (IBAction)uploadFile:(id)sender
//{
//  
//
//    alertController = [UIAlertController alertControllerWithTitle:@""
//                                                          message:@"Are you sure to upload this file?"
//                                                   preferredStyle:UIAlertControllerStyleAlert];
//    actionDelete = [UIAlertAction actionWithTitle:@"Yes"
//                                            style:UIAlertActionStyleDefault
//                                          handler:^(UIAlertAction * action)
//                    {
//                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                            //Do background work
//                            
//                            if ([self.presentingViewController isKindOfClass:[UITabBarController class]])
//                            {
//                                UITabBarController* vc= self.presentingViewController;
//                                //        long a=vc.selectedIndex;
//                                NSString* username = [[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"];
//                                NSString* companyId=[[Database shareddatabase] getCompanyId:username];
//                                NSString* userFeedback=[[Database shareddatabase] getUserIdFromUserName:username];
//                                NSString *userFrom,*userTo;
//                                if ([companyId isEqual:@"1"])
//                                {
//                                    userFrom= [[Database shareddatabase] getAdminUserId];
//                                    username=[[Database shareddatabase] getUserNameFromCompanyname:[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedCompany"]];
//                                    userTo=[[Database shareddatabase] getUserIdFromUserNameWithRoll1:username];
//                                    
//                                }
//                                
//                                else
//                                {
//                                    
//                                    userTo=[[Database shareddatabase] getAdminUserId];
//                                    userFrom= [[Database shareddatabase] getUserIdFromUserNameWithRoll1:username];
//                                    
//                                    
//                                }
//                               NSString* flag= [[NSUserDefaults standardUserDefaults]valueForKey:@"flag1"];
//                                if ([flag isEqualToString:@"0"])
//                                {
//                                    flag=@"1";
//                                }
//                                else
//                                {
//                                    flag=@"2";
//
//                                }
//                                NSDictionary* dic=[NSDictionary dictionaryWithObjectsAndKeys:userFrom,@"userFrom",userTo,@"userTo",userFeedback,@"userFeedback" ,nil];
//                                [[APIManager sharedManager] uploadFileOfReportOrDocument:dic flag:flag];
//
//                                
//                                
//                            }
//                            else
//                            {
//                                [[APIManager sharedManager] uploadFileToServer];
//                            }                           //[self uploadFileToServer:@""];
//
//                            //[self startSend:@""];
//                        });
//                        [self dismissViewControllerAnimated:YES completion:nil];
//
//                        
//                    }]; //You can use a block here to handle a press on this button
//    [alertController addAction:actionDelete];
//    
//    
//    actionCancel = [UIAlertAction actionWithTitle:@"No"
//                                            style:UIAlertActionStyleCancel
//                                          handler:^(UIAlertAction * action)
//                    {
//                        [alertController dismissViewControllerAnimated:YES completion:nil];
//                        
//                    }]; //You can use a block here to handle a press on this button
//    [alertController addAction:actionCancel];
//    
//    [self presentViewController:alertController animated:YES completion:nil];
// 
//}

- (IBAction)deleteButtonClicked:(id)sender
{
    UIButton *button = (UIButton *) sender;
    UIImageView* selectedImageView=[self.view viewWithTag:100];
    [[self.view viewWithTag:101] setHidden:YES];
    selectedImageView.image=nil;
    [[self.view viewWithTag:11] setHidden:YES];
    [[self.view viewWithTag:12] setHidden:YES];

//    [app.imageFilesArray removeObjectAtIndex:button.tag];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
     UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
     AppPreferences* app=[AppPreferences sharedAppPreferences];
    [app.imageFileNamesArray removeAllObjects];
    [app.imageFilesArray removeAllObjects];
    UIImageView* selectedImageView=[self.view viewWithTag:100];
   // selectedImageView.image=chosenImage;
    //[self.collectionView reloadData];
    [picker.view removeFromSuperview] ;
    [picker removeFromParentViewController] ;
    [[self.view viewWithTag:11] setHidden:NO];
    [[self.view viewWithTag:12] setHidden:NO];
    [[self.view viewWithTag:101] setHidden:NO];

    NSURL *refURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    
    // define the block to call when we get the asset based on the url (below)
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *imageAsset)
    {
        ALAssetRepresentation *imageRep = [imageAsset defaultRepresentation];
        UILabel* selectedImageNameLabel=[self.view viewWithTag:110];
        selectedImageNameLabel.text=[imageRep filename];
        NSLog(@"[imageRep filename] : %@", [imageRep filename]);
        
        [app.imageFileNamesArray addObject:[imageRep filename]];
        selectedImageNameLabel.text=[app.imageFileNamesArray objectAtIndex:0];
        [app.imageFilesArray addObject:chosenImage];
        [AppPreferences sharedAppPreferences].fileLocation=@"Gallery";
    };
    
    // get the asset library and fetch the asset based on the ref url (pass in block above)
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:refURL resultBlock:resultblock failureBlock:nil];
    
 /*   ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
    {
        ALAssetRepresentation *representation = [myasset defaultRepresentation];
        CGImageRef iref = [representation fullResolutionImage];

        NSString *fileName = [representation filename];
        AppPreferences* app=[AppPreferences sharedAppPreferences];
        
        //UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
        UIImage *myImage = [UIImage imageWithCGImage:iref scale:[representation scale] orientation:(UIImageOrientation)[representation orientation]];

        [app.imageFilesArray addObject:myImage];
        [app.imageFileNamesArray addObject:fileName];
        [self.collectionView reloadData];

        NSLog(@"%ld",app.imageFilesArray.count);
        NSLog(@"fileName : %@",fileName);
    };
    
    [picker.view removeFromSuperview] ;
    [picker removeFromParentViewController] ;
*/
    
//    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
//    [assetslibrary assetForURL:imageURL
//                   resultBlock:resultblock
//                  failureBlock:nil];
//    [picker dismissViewControllerAnimated:YES completion:nil];
    
//    [self.navigationController popViewControllerAnimated:YES];
//    [picker removeFromParentViewController];
//    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (IBAction)selectFileFromGallery:(id)sender
{
    UIImagePickerController *imagePickerController=[[UIImagePickerController alloc]init];
    //UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    //imagePickerController.allowsEditing=YES;
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    
    //[self.view addSubview:imagePickerController.cameraOverlayView];
    // UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:imagePickerController];
    [self addChildViewController:imagePickerController] ;
    
    [imagePickerController didMoveToParentViewController:self] ;
    
    [self.view addSubview:imagePickerController.view] ;
    //    [self.navigationController presentedViewController:imagePickerController];

}

- (IBAction)selectFileFromStorage:(id)sender
{
    UIViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DocumentDirectoryContentViewController"];
    
    [self presentViewController:vc animated:YES completion:nil];
}



- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    AppPreferences* app=[AppPreferences sharedAppPreferences];
    if (!(app.imageFilesArray.count==0)) {
//        rightBarButton.title=@"Upload";
        if (self.tabBarController == nil)
        {
            self.navigationItem.title = @"Upload Files";
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Upload" style:UIBarButtonItemStylePlain target:self action:@selector(uploadFileToServer:)];
        }
        else
        {
        self.tabBarController.navigationItem.title = @"Upload Files";
        self.tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Upload" style:UIBarButtonItemStylePlain target:self action:@selector(uploadFileToServer:)];
        }
    }
    else
    {
        if (self.tabBarController == nil)
        {
            self.navigationItem.title = @"Upload Files";
            self.navigationItem.rightBarButtonItem = nil;
        }
        else
        {
            self.tabBarController.navigationItem.title = @"Upload Files";
            self.tabBarController.navigationItem.rightBarButtonItem = nil;
        }

    }
    return app.imageFilesArray.count;
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
     AppPreferences* app=[AppPreferences sharedAppPreferences];
    UICollectionViewCell* cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
   
UIImageView* img=(UIImageView*)[cell viewWithTag:100];
    img.image=[app.imageFilesArray objectAtIndex:indexPath.item];
    
  UIButton* cancelImagebutton=  (UIButton*)[cell viewWithTag:101];
    //cancelImagebutton.tag=app.imageFilesArray.count;
    //cell.tag=indexPath.item;
    cancelImagebutton.tag=indexPath.item;
    [cancelImagebutton addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
   // [imageview addSubview:mybutton];
   // cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AppIcon"]];
    //[self.collectionView indexPathForRowAtPoint:]
         return cell;
    
}

//-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionViewCell* cell=[collectionView cellForItemAtIndexPath:indexPath];
//
//    //UIButton* cancelImagebutton=  (UIButton*)[cell viewWithTag:101];
//    UIButton* cancelImagebutto=  (UIButton*)[cell viewWithTag:101];
//
//    cancelImagebutto.tag=indexPath.item;    //cancelImagebutton.tag=app.imageFilesArray.count+0;
//    [cancelImagebutto addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
//
//
//
//}
-(void)delete:(id)sender
{
    UIButton *button = (UIButton *) sender;
    AppPreferences* app=[AppPreferences sharedAppPreferences];
    UIImageView* selectedImageView=[self.view viewWithTag:100];
    selectedImageView.image=nil;
           [app.imageFilesArray removeObjectAtIndex:button.tag];

   // [self.collectionView reloadData];
}



-(void)uploadFileToServer:(NSString*)str

{
    AppPreferences* app=[AppPreferences sharedAppPreferences];
    

   // NSURL* url = [NSURL URLWithString:webStringURL];
    for (int i=0; i<app.imageFilesArray.count; i++)
    {
        NSError* error;
    NSData * data = UIImagePNGRepresentation([app.imageFilesArray objectAtIndex:i]);
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
   // NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", @"http://localhost:9090/coreflex/feedcom", @"uploadFileFromMobile"]];
        NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", BASE_URL_PATH, @"uploadFileFromMobile"]];

     //   NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", @"http://115.249.195.23:8080/Communicator/feedcom", @"uploadFileFromMobile"]];


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
        uploadedFileNameString = [uploadedFileNameString stringByReplacingOccurrencesOfString:@"\"" withString:@""];

     [app.uploadedFileNamesArray addObject:[result valueForKey:@"fileName"]];//add the uploaded file names to uploaded file names array to display on detail chating view controller
        
        NSString* returnCode= [result valueForKey:@"code"];
       
        if ([returnCode isEqual:@"1000"])
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Upload message"
                                                                                     message:@"File(s) uploaded successfully"
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            //We add buttons to the alert controller by creating UIAlertActions:
            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction *action)
                                       {
                                           AppPreferences* app=[AppPreferences sharedAppPreferences];
                                           
                                           [app.imageFileNamesArray removeAllObjects];
                                           [app.imageFilesArray removeAllObjects];
                                           //self.navigationItem.rightBarButtonItem.title=nil;
                                           
                                           [self.collectionView reloadData];
                                           [self dismissViewControllerAnimated:YES completion:nil];
                                       }]; //You can use a block here to handle a press on this button
            [alertController addAction:actionOk];
            [self presentViewController:alertController animated:YES completion:nil];
           
                rightBarButton.title=nil;
           
            
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





//---------for FTP use only-----------------//


//- (void)sendDidStart
//{
//    //self.statusLabel.text = @"Sending";
//   // self.cancelButton.enabled = YES;
//   // [self.activityIndicator startAnimating];
//    [[NetworkManager sharedInstance] didStartNetworkOperation];
//}
//
//- (void)updateStatus:(NSString *)statusString
//{
//   // assert(statusString != nil);
//   // self.statusLabel.text = statusString;
//}
//
//- (void)sendDidStopWithStatus:(NSString *)statusString
//{
//    if (statusString == nil) {
//        statusString = @"Put succeeded";
//    }
//    //self.statusLabel.text = statusString;
//    //self.cancelButton.enabled = NO;
//    //[self.activityIndicator stopAnimating];
//    [[NetworkManager sharedInstance] didStopNetworkOperation];
//}
//
//#pragma mark * Core transfer code
//
//// This is the code that actually does the networking.
//
//// Because buffer is declared as an array, you have to use a custom getter.
//// A synthesised getter doesn't compile.
//
//- (uint8_t *)buffer
//{
//    return self->_buffer;
//}
//
//- (BOOL)isSending
//{
//    return (self.networkStream != nil);
//}
//
//- (void)startSend:(NSString *)filePath
//{
//    AppPreferences* app=[AppPreferences sharedAppPreferences];
//    NSError* error;
//        NSData * data = UIImagePNGRepresentation([app.imageFilesArray objectAtIndex:0]);
//        NSString *folderpath=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Downloads"];
//    
//        NSString *destpath=[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/Downloads/%@",[app.imageFileNamesArray objectAtIndex:0]]];
//    
//        if (![[NSFileManager defaultManager] fileExistsAtPath:folderpath])
//            [[NSFileManager defaultManager] createDirectoryAtPath:folderpath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
//        [data writeToFile:destpath atomically:YES];
//    
//       filePath = [NSHomeDirectory() stringByAppendingPathComponent:
//                          [NSString stringWithFormat:@"Documents/Downloads/%@",[app.imageFileNamesArray objectAtIndex:0]] ];
//        //--------------------------------------------------//
//       NSString* fileName = [app.imageFileNamesArray objectAtIndex:0];
//    //filePath=@"";
//    BOOL                    success;
//    NSURL *                 url;
//    
//    assert(filePath != nil);
//    assert([[NSFileManager defaultManager] fileExistsAtPath:filePath]);
//    assert( [filePath.pathExtension isEqual:@"png"] || [filePath.pathExtension isEqual:@"jpg"] );
//    
//    assert(self.networkStream == nil);      // don't tap send twice in a row!
//    assert(self.fileStream == nil);         // ditto
//    
//    // First get and check the URL.
//    
//    url = [[NetworkManager sharedInstance] smartURLForString:@"ftp.pantudantukids.com"];
//    success = (url != nil);
//    
//    if (success) {
//        // Add the last part of the file name to the end of the URL to form the final
//        // URL that we're going to put to.
//        
//        url = CFBridgingRelease(
//                                CFURLCreateCopyAppendingPathComponent(NULL, (__bridge CFURLRef) url, (__bridge CFStringRef) [filePath lastPathComponent], false)
//                                );
//        success = (url != nil);
//    }
//    
//    // If the URL is bogus, let the user know.  Otherwise kick off the connection.
//    
//    if ( ! success) {
//       // self.statusLabel.text = @"Invalid URL";
//    } else {
//        
//        // Open a stream for the file we're going to send.  We do not open this stream;
//        // NSURLConnection will do it for us.
//        
//        self.fileStream = [NSInputStream inputStreamWithFileAtPath:filePath];
//        assert(self.fileStream != nil);
//        
//        [self.fileStream open];
//        
//        // Open a CFFTPStream for the URL.
//        
//        self.networkStream = CFBridgingRelease(
//                                               CFWriteStreamCreateWithFTPURL(NULL, (__bridge CFURLRef) url)
//                                               );
//        assert(self.networkStream != nil);
//        
//        if ([@"demoFtp@pantudantukids.com" length] != 0) {
//            success = [self.networkStream setProperty:@"demoFtp@pantudantukids.com" forKey:(id)kCFStreamPropertyFTPUserName];
//            assert(success);
//            success = [self.networkStream setProperty:@"asdf@123" forKey:(id)kCFStreamPropertyFTPPassword];
//            assert(success);
//        }
//        
//        self.networkStream.delegate = self;
//        [self.networkStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
//        [self.networkStream open];
//        
//        // Tell the UI we're sending.
//        
//        [self sendDidStart];
//    }
//}
//
//- (void)stopSendWithStatus:(NSString *)statusString
//{
//    if (self.networkStream != nil) {
//        [self.networkStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
//        self.networkStream.delegate = nil;
//        [self.networkStream close];
//        self.networkStream = nil;
//    }
//    if (self.fileStream != nil) {
//        [self.fileStream close];
//        self.fileStream = nil;
//    }
//    [self sendDidStopWithStatus:statusString];
//}
//
//- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
//// An NSStream delegate callback that's called when events happen on our
//// network stream.
//{
//#pragma unused(aStream)
//    assert(aStream == self.networkStream);
//    
//    switch (eventCode) {
//        case NSStreamEventOpenCompleted: {
//            [self updateStatus:@"Opened connection"];
//        } break;
//        case NSStreamEventHasBytesAvailable: {
//            assert(NO);     // should never happen for the output stream
//        } break;
//        case NSStreamEventHasSpaceAvailable: {
//            [self updateStatus:@"Sending"];
//            
//            // If we don't have any data buffered, go read the next chunk of data.
//            
//            if (self.bufferOffset == self.bufferLimit) {
//                NSInteger   bytesRead;
//                
//                bytesRead = [self.fileStream read:self.buffer maxLength:kSendBufferSize];
//                
//                if (bytesRead == -1) {
//                    [self stopSendWithStatus:@"File read error"];
//                } else if (bytesRead == 0) {
//                    [self stopSendWithStatus:nil];
//                } else {
//                    self.bufferOffset = 0;
//                    self.bufferLimit  = bytesRead;
//                }
//            }
//            
//            // If we're not out of data completely, send the next chunk.
//            
//            if (self.bufferOffset != self.bufferLimit) {
//                NSInteger   bytesWritten;
//                bytesWritten = [self.networkStream write:&self.buffer[self.bufferOffset] maxLength:self.bufferLimit - self.bufferOffset];
//                assert(bytesWritten != 0);
//                if (bytesWritten == -1) {
//                    [self stopSendWithStatus:@"Network write error"];
//                } else {
//                    self.bufferOffset += bytesWritten;
//                }
//            }
//        } break;
//        case NSStreamEventErrorOccurred: {
//            [self stopSendWithStatus:@"Stream open error"];
//        } break;
//        case NSStreamEventEndEncountered: {
//            // ignore
//        } break;
//        default: {
//            assert(NO);
//        } break;
//    }
//}
//







@end
