//
//  CreateNewMOMViewController.h
//  Communicator
//
//  Created by mac on 19/05/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateNewMOMViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    BOOL gotResponse;
    int movement,j;
    NSMutableArray* userObjectsArray;
    NSMutableArray* userObjectsArrayForEmailIds;

    NSMutableDictionary* isSelectedDict;
    NSMutableArray* userIdsArray;
    NSMutableArray* userIdsEmailArray;
    NSMutableArray* userEmailNamesArray;
    NSMutableArray* userNamesArray;
}
- (IBAction)sendNewMom:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)selectAttendeeButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *subjectTextField;
@property (weak, nonatomic) IBOutlet UITextField *dateTextField;
@property (weak, nonatomic) IBOutlet UITextView *attendiesTextview;
@property (weak, nonatomic) IBOutlet UITextView *keyPointstextView;
@property (weak, nonatomic) IBOutlet UIView *insideView;
@property (weak, nonatomic) IBOutlet UITableView *popupTableView;
@property (weak, nonatomic) IBOutlet UIButton *attendeeButton;
@property (nonatomic,strong)NSMutableArray* cellSelected;
@property (nonatomic,strong)NSMutableArray* cellSelectedForEmailIds;
@property (weak, nonatomic) MBProgressHUD *hud;

- (IBAction)addAttendees:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)backButtonPressed:(id)sender;
- (IBAction)addEmailIds:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *emailITextViewds;
@end
