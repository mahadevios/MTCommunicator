//
//  DetailChatingViewController.h
//  Communicator
//
//  Created by mac on 26/05/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <CFNetwork/CFNetwork.h>

@interface DetailChatingViewController : UIViewController<UITextFieldDelegate,NSStreamDelegate,NSURLSessionDelegate,NSURLSessionDownloadDelegate,NSURLSessionDataDelegate,UIDocumentInteractionControllerDelegate,UITextViewDelegate,UIWebViewDelegate,UIGestureRecognizerDelegate>
{
    AppPreferences* app;
    int movement;
    NSString* downloadableAttachmentName;
    UIRefreshControl* refreshControl;
    UIView* popUpView;
    NSMutableArray* userObjectsArray;
    NSMutableArray* userIdsArray;
    UIWebView* feedTextWebViewForHeight;
    NSMutableArray* heightArray;
    NSMutableArray* webViewArray;
    NSMutableArray* indexPathArray;
    BOOL reloaded;
    BOOL loadedFirstTime;

}

@property (nonatomic, assign, readonly ) BOOL              isReceiving;
@property (nonatomic, strong, readwrite) NSInputStream *   networkStream;
@property (nonatomic, copy,   readwrite) NSString *        filePath;
@property (nonatomic, strong, readwrite) NSOutputStream *  fileStream;
@property (nonatomic,strong)NSMutableArray* cellSelected;
@property (nonatomic,strong)NSMutableArray* indexPathArray;

@property (nonatomic) int historyFlag;
@property (weak, nonatomic) MBProgressHUD *hud;
@property (nonatomic)int numberOfLines;
//@property (weak, nonatomic) IBOutlet UITextField *sendFeedbackTextfield;
@property (weak, nonatomic) IBOutlet UITextView *sendTextView;

@property (weak, nonatomic) IBOutlet UITableView *popupTableView;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic) long totalRows;

- (IBAction)sendFeedbackButtonClicked:(id)sender;

- (IBAction)issueCloseButtonClicked:(id)sender;

- (IBAction)switchValueChanged:(id)sender;

- (IBAction)backButtonPressed:(id)sender;

- (IBAction)addReceipientsButtonClicked:(id)sender;

- (IBAction)cancelRecipientsButtonClicked:(id)sender;

- (IBAction)doneRecipientsButtonClicked:(id)sender;

- (IBAction)sendAttachment:(id)sender;

//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@end
