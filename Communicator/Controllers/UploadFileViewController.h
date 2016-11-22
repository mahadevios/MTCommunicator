//
//  UploadFileViewController.h
//  Communicator
//
//  Created by mac on 21/06/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UploadFileViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    NSDictionary* result;
    UIAlertController *alertController;
    UIAlertAction *actionDelete;
    UIAlertAction *actionCancel;

}
- (IBAction)selectFileFromGallery:(id)sender;
- (IBAction)selectFileFromStorage:(id)sender;


@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
- (IBAction)barbuttonClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightBarButton;
@property (weak, nonatomic) MBProgressHUD *hud;

@property (nonatomic)BOOL isFromImagePicker;

//for FTP use only---------//

@property (nonatomic, assign, readonly ) BOOL              isSending;
@property (nonatomic, strong, readwrite) NSOutputStream *  networkStream;
@property (nonatomic, strong, readwrite) NSInputStream *   fileStream;
@property (nonatomic, assign, readonly ) uint8_t *         buffer;
@property (nonatomic, assign, readwrite) size_t            bufferOffset;
@property (nonatomic, assign, readwrite) size_t            bufferLimit;
- (IBAction)disMissViewController:(id)sender;
- (IBAction)uploadFile:(id)sender;

- (IBAction)deleteButtonClicked:(id)sender;
@end
