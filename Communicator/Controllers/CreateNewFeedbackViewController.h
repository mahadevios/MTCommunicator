//
//  CreateNewFeedbackViewController.h
//  Communicator
//
//  Created by mac on 19/05/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateNewFeedbackViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

{
    int movement;
    int totalMovement;
    BOOL gotResponse;
    NSMutableDictionary* allOperatorUsernamesDict;
    UIPickerView* picker;
    NSMutableArray* userObjectsArray;
    NSMutableArray* userObjectsArrayForEmailIds;
    
    NSMutableDictionary* isSelectedDict;
    NSMutableArray* userIdsArray;
    NSMutableArray* userIdsEmailArray;
    NSMutableArray* userEmailNamesArray;
    NSMutableArray* userNamesArray;

}
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UITextField *SONumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *AvayaIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *DocumentIdTextField;
@property (weak, nonatomic) IBOutlet UITextView *SubjectTextView;
@property (weak, nonatomic) IBOutlet UITextField *OperatorTextField;
@property (weak, nonatomic) IBOutlet UITextView *DescriptionTextView;
@property (nonatomic,strong)NSString* feedbackType;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray* cellSelected;
@property (weak, nonatomic) MBProgressHUD *hud;
@property(nonatomic,strong)NSString* compositeSONumber;

- (IBAction)attachmentButtonClicked:(id)sender;

- (IBAction)dismissViewController:(id)sender;
- (IBAction)sendNewFeedback:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UIView *insideView;
- (IBAction)addAttendees:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *attendiesTextView;

@end
