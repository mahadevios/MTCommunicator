//
//  ViewController.h
//  Communicator
//
//  Created by mac on 19/03/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Database.h"
@interface LoginViewController : UIViewController<UITextFieldDelegate>
{
   
    UILabel *loadingLabel;
    int flag;
    
}

@property (weak, nonatomic) MBProgressHUD *hud;

@property (weak, nonatomic) IBOutlet UITextField *usenameTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UIButton *rememberMeButton;

@property (weak, nonatomic) IBOutlet UILabel *remeberMeLabel;

//@property (weak, nonatomic) IBOutlet UIView *subView;

@property (weak, nonatomic) IBOutlet UIView *navigationView;


- (IBAction)loginButtonTapped:(id)sender;

- (IBAction)rememberMeButtonTapped:(id)sender;

- (IBAction)forgotPasswordButtonClicked:(id)sender;

//@property (weak, nonatomic) IBOutlet UIButton *buttonColor;

@end

