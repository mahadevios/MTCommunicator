//
//  ViewController.m
//  Communicator
//
//  Created by mac on 19/03/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import "LoginViewController.h"
#import "MBProgressHUD.h"
//#import "SWRevealViewController.h"
#import "HomeViewController.h"
#import "UIColor+CommunicatorColor.h"
#import "FeedQueryCounter.h"
#import "Database.h"
#import "MainTabBarViewController.h"
#import "CompanyNamesViewController.h"
#import "User.h"
#import "MainMOMViewController.h"
#import "ReportAndDocsViewController.h"
#import "PopUpCustomView.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize rememberMeButton;
@synthesize remeberMeLabel;
@synthesize usenameTextField;
@synthesize passwordTextField;
//@synthesize buttonColor;
@synthesize hud;
@synthesize navigationView;
BOOL check;
UIAlertController *alertController1;
NSMutableArray* webFeedCountArray;
NSMutableArray* webFeedTypeArray;
- (void)viewDidLoad
{
    [super viewDidLoad];
    [rememberMeButton setSelected:NO];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rememberMeButtonClicked)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [remeberMeLabel addGestureRecognizer:tapGestureRecognizer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(validateUserResponse:) name:NOTIFICATION_VALIDATE_USER
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(validateCounter:) name:NOTIFICATION_VALIDATE_COUNTER
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getLatestRecords:) name:NOTIFICATION_GETLATEST_FEEDCOM
                                               object:nil];
    
        [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getForgotPasswordResponse:) name:NOTIFICATION_FORGOT_PASSWORD_API
                                               object:nil];
    

    usenameTextField.delegate=self;
    passwordTextField.delegate=self;
    

  
}

- (void)viewWillAppear:(BOOL)animated
{
  
    [self setView];
        [self setNeedsStatusBarAppearanceUpdate];


}

-(void)getForgotPasswordResponse:(NSNotification *)notificationData
{
    if ([[notificationData.object objectForKey:@"code"] isEqualToString:SUCCESS])
    {
        
        [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"" withMessage:@"Please check your mailbox for credentials." withCancelText:nil withOkText:@"Ok" withAlertTag:1001];
        
    }
    
    if ([[notificationData.object objectForKey:@"code"] isEqualToString:FAILURE])
    {
        
       [[AppPreferences sharedAppPreferences] showAlertViewWithTitle:@"" withMessage:@"Incorrect email id!" withCancelText:nil withOkText:@"Ok" withAlertTag:1001];

    }


}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)setView
{
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"LoginViewBackgroundImage"]];
    
    usenameTextField.layer.cornerRadius=0.0f;
    
    usenameTextField.layer.masksToBounds=YES;
    
    usenameTextField.layer.borderColor=[[UIColor grayColor]CGColor];
    
    usenameTextField.layer.borderWidth= 1.0f;
    
    passwordTextField.layer.cornerRadius=0.0f;
    
    passwordTextField.layer.masksToBounds=YES;
    
    passwordTextField.layer.borderColor=[[UIColor grayColor]CGColor];
    
    passwordTextField.layer.borderWidth= 1.0f;
    
    navigationView.backgroundColor=[UIColor communicatorColor];
    
    [rememberMeButton setSelected:NO];

}


#pragma mark:Notifications

//--------notification for NOTIFICATION_VALIDATE_USER-----//

- (void)validateUserResponse:(NSNotification *)notification
{

    if ([[notification.object objectForKey:@"code"] isEqualToString:SUCCESS])
    {
        Database *db=[Database shareddatabase];

        [db insertCompanyRelatedFeedbackTypeAndUsers:notification.object];
       
        [[APIManager sharedManager] findCountForUsername:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"] andPassword:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentPassword"]];
        
     }
    
}

//--------notification for NOTIFICATION_VALIDATE_COUNTER -----//

- (void)validateCounter:(NSNotification *)notification
{

    if ([[notification.object objectForKey:@"code"] isEqualToString:SUCCESS])
    {
        Database *db=[Database shareddatabase];
        
        [db insertFeedQueryCounter:notification.object];
        
        AppPreferences* app=[AppPreferences sharedAppPreferences];
       
        app.companynameOrIdArray= [db findPermittedCompaniesForUsername:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"] Password:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentPassword"]];

        [[APIManager sharedManager]getLatestRecordsForUsername:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"] andPassword:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentPassword"]];
       
     }
    
}

//-------- notification for NOTIFICATION_GETLATEST_RECORDS -----//

- (void)getLatestRecords:(NSNotification *)notificationData
{

    if ([[notificationData.object objectForKey:@"code"] isEqualToString:SUCCESS])
    {
        Database *db=[Database shareddatabase];
        
        [db insertLatestRecordsForFeedcom:notificationData.object];
        
        [hud hideAnimated:YES];

        AppPreferences *app=[AppPreferences sharedAppPreferences];
        
        app.companynameOrIdArray= [db findPermittedCompaniesForUsername:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"] Password:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentPassword"]];
        
        NSString* companyId= [db getCompanyId:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"]];
        
        [self performSelector:@selector(getReportDocAndMOMdata) withObject:nil afterDelay:0.0];
        
        if (!([companyId isEqual:@"1"]))
        {
            Database* db=[Database shareddatabase];
            
            NSString* companyName= [NSString stringWithFormat:@"%@",[app.companynameOrIdArray objectAtIndex:0]];
            
            [db getFeedbackAndQueryCounterForCompany:companyName];
            
            NSString* userFrom;
            
            NSString* userTo;
            
            [[NSUserDefaults standardUserDefaults] setValue:usenameTextField.text forKey:@"currentUser"];
            
            NSString* username = [[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"];
            
            NSString* companyId=[db getCompanyId:username];
            
            NSString* userFeedback=[db getUserIdFromUserName:username];
            
            [[NSUserDefaults standardUserDefaults] setValue:companyId forKey:@"clientCompanyId"];

            if ([companyId isEqual:@"1"])
            {
                userFrom=[[Database shareddatabase] getAdminUserId];
                
                username=[db getUserNameFromCompanyname:[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedCompany"]];
                
                userTo=[db getUserIdFromUserNameWithRoll1:username];
                
            }
            
            else
            {
                
                userTo=[[Database shareddatabase] getAdminUserId];
                
                userFrom= [db getUserIdFromUserNameWithRoll1:username];
                
                
            }
            [[NSUserDefaults standardUserDefaults] setValue:userFrom forKey:@"userFrom"];
            [[NSUserDefaults standardUserDefaults] setValue:userTo forKey:@"userTo"];
            [[NSUserDefaults standardUserDefaults] setValue:userFeedback forKey:@"userFeedback"];
            [self pushToHomeView];
            
          //  [self pushToCompanyView];

        }
        
        else
        {
            [self pushToCompanyView];
            
          //  [self pushToHomeView];

            
        }
        

        
       // app.getFeedbackAndQueryTypesArray = [db getFeedbackAndQueryTypes];
        
        
        
//        hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//        [hud hideAnimated:YES];
    }
}

-(void)getReportDocAndMOMdata
{

    [[APIManager sharedManager]get50ReoprtForUsername:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"] andPassword:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentPassword"]];
    
    [[APIManager sharedManager]get50DocumentsForUsername:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"] andPassword:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentPassword"]];
    
    [[APIManager sharedManager]getLatestMOMForUsername:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"] andPassword:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentPassword"]];
    
//    MainMOMViewController* momObj=[MainMOMViewController init];
//    ReportAndDocsViewController* obj=[[ReportAndDocsViewController alloc]init];
        


}

#pragma mark-texField delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==usenameTextField)
    {
        [passwordTextField becomeFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
    }
    return YES;
}


#pragma mark-UIButton actions

- (IBAction)rememberMeButtonTapped:(id)sender
{
    [self rememberMeButtonClicked];
}

- (IBAction)forgotPasswordButtonClicked:(id)sender
{
    CGRect rect= CGRectMake(self.view.center.x-130, self.view.center.y-150, 260, 180);
    //PopUpCustomView* obj= [[PopUpCustomView alloc]init];
    UIView* popupForgotPasswordView=[[PopUpCustomView alloc]initWithFrameForForgotPassword:rect sender:self];
    //-(UIView*)initWithFrameForForgotPassword:(CGRect)frame  sender:(id)sender

    [[[UIApplication sharedApplication] keyWindow] addSubview:popupForgotPasswordView];

}

- (void)rememberMeButtonClicked
{
    if ([rememberMeButton isSelected])
    {
        [rememberMeButton setSelected:NO];
    }
    
    else
    {
        [rememberMeButton setSelected:YES];
    }
}
-(void)cancel:(UIButton*)sender
{
    [[[UIApplication sharedApplication].keyWindow viewWithTag:121] removeFromSuperview];
    
}

-(void)save:(UIButton*)sender
{
    UIView* ovelay=[[UIApplication sharedApplication].keyWindow viewWithTag:121];
   UITextField* emailIdTextField= [ovelay viewWithTag:122];
    [[APIManager sharedManager] forgotPassword:emailIdTextField.text];;

    [[[UIApplication sharedApplication].keyWindow viewWithTag:121] removeFromSuperview];
    
}

- (IBAction)loginButtonTapped:(id)sender
{
    hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.tag=789;
    hud.label.text = @"Loading...";
    hud.detailsLabel.text=@" Please wait";
    hud.minSize = CGSizeMake(150.f, 100.f);

    if ([self.usenameTextField.text length] <= 0 || [self.passwordTextField.text length] <= 0)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Empty field"
                                                                                 message:@"Please enter valid username and password"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil]; //You can use a block here to handle a press on this button
        [alertController addAction:actionOk];
        [hud hideAnimated:YES];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        
        BOOL authorised=[[Database shareddatabase] validateUserFromLocalDatabase:self.usenameTextField.text :self.passwordTextField.text];
        NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
        [defaults setValue:self.usenameTextField.text forKey:@"currentUser"];
        [defaults setValue:self.passwordTextField.text forKey:@"currentPassword"];
        //    [AppPreferences sharedAppPreferences].firebaseInstanceId
        //if (!authorised)
       // {
        [passwordTextField resignFirstResponder];
            [[APIManager sharedManager] validateUser:self.usenameTextField.text Password:self.passwordTextField.text andDeviceId:[AppPreferences sharedAppPreferences].firebaseInstanceId];
      //  }
      //  else
      //  {
//            AppPreferences* app=[AppPreferences sharedAppPreferences];
//            Database* db=[Database shareddatabase];
//            app.companynameOrIdArray= [db findPermittedCompaniesForUsername:[defaults valueForKey:@"currentUser"] Password:[defaults valueForKey:@"currentPassword"]];
//            NSString* companyId= [db getCompanyId:self.usenameTextField.text];
            
            
            
           // [[APIManager sharedManager]getLatestRecordsForUsername:self.usenameTextField.text andPassword:self.passwordTextField.text];
            
//            if (!([companyId isEqual:@"1"]))
//            {
//                NSLog(@"%@",[app.companynameOrIdArray objectAtIndex:0]);
//                Database* db=[Database shareddatabase];
//                NSString* companyName= [NSString stringWithFormat:@"%@",[app.companynameOrIdArray objectAtIndex:0]];
//                
//                [db getFeedbackAndQueryCounterForCompany:companyName];
//                
//                [self pushToHomeView];
//            }
//            
//            else
//            {
//                [self pushToCompanyView];
//                
//            }
            
     //   }

      
    }
  
}


-(void)pushToHomeView
{
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"rememberMe"];
    
    Database* db=[Database shareddatabase];
    User* userObjForDefault=[[User alloc]init];
    User *userObj= [db getUserUsername:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"] andPassword:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentPassword"]];
    
    userObjForDefault.Id=userObj.Id;
    userObjForDefault.username=userObj.username;
    userObjForDefault.password=userObj.password;
    userObjForDefault.userRole=userObj.userRole;
    userObjForDefault.comanyId=userObj.comanyId;
    userObjForDefault.email=userObj.email;
    userObjForDefault.deviceToken=userObj.deviceToken;
    userObjForDefault.mobileNo=userObj.mobileNo;
    userObjForDefault.firstName=userObj.firstName;
    userObjForDefault.lastName=userObj.lastName;
    
    NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:userObjForDefault] forKey:@"userObject"];
    [[APIManager sharedManager] updateDevieToken:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"] Password:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentPassword"] andDeviceId:[AppPreferences sharedAppPreferences].firebaseInstanceId];
    if ([rememberMeButton isSelected])
    {
        //[[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"rememberMe"];
//        Database* db=[Database shareddatabase];
//        User* userObjForDefault=[[User alloc]init];
//        User *userObj= [db getUserUsername:self.usenameTextField.text andPassword:self.passwordTextField.text];
//        
//        userObjForDefault.Id=userObj.Id;
//        userObjForDefault.username=userObj.username;
//        userObjForDefault.password=userObj.password;
//        userObjForDefault.userRole=userObj.userRole;
//        userObjForDefault.comanyId=userObj.comanyId;
//        userObjForDefault.email=userObj.email;
//        userObjForDefault.deviceToken=userObj.deviceToken;
//        userObjForDefault.mobileNo=userObj.mobileNo;
//        userObjForDefault.firstName=userObj.firstName;
//        userObjForDefault.lastName=userObj.lastName;
//        
//        NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
//        [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:userObjForDefault] forKey:@"userObject"];
//
    
  

        
    }
    else
   {
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"rememberMe"];
   }

//   MainTabBarViewController* vc= [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabBarViewController"];
//
//    [self.navigationController pushViewController:vc animated:YES];
    MainTabBarViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabBarViewController"];
    // [[UIApplication sharedApplication] keyWindow].rootViewController = nil;
    
    //  [[[UIApplication sharedApplication] keyWindow] setRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewNavigationController"]];
    [[[UIApplication sharedApplication] keyWindow] setRootViewController:vc];
      [vc setTabBars];
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)pushToCompanyView
{
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"rememberMe"];
    
    Database* db=[Database shareddatabase];
    User* userObjForDefault=[[User alloc]init];
    User *userObj= [db getUserUsername:self.usenameTextField.text andPassword:self.passwordTextField.text];
    
    userObjForDefault.Id=userObj.Id;
    userObjForDefault.username=userObj.username;
    userObjForDefault.password=userObj.password;
    userObjForDefault.userRole=userObj.userRole;
    userObjForDefault.comanyId=userObj.comanyId;
    userObjForDefault.email=userObj.email;
    userObjForDefault.deviceToken=userObj.deviceToken;
    userObjForDefault.mobileNo=userObj.mobileNo;
    userObjForDefault.firstName=userObj.firstName;
    userObjForDefault.lastName=userObj.lastName;
    
    NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:userObjForDefault] forKey:@"userObject"];
    [[APIManager sharedManager] updateDevieToken:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"] Password:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentPassword"] andDeviceId:[AppPreferences sharedAppPreferences].firebaseInstanceId];
    if ([rememberMeButton isSelected])
    {
//        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"rememberMe"];
//        
//        Database* db=[Database shareddatabase];
//        User* userObjForDefault=[[User alloc]init];
//        User *userObj= [db getUserUsername:self.usenameTextField.text andPassword:self.passwordTextField.text];
//        
//        userObjForDefault.Id=userObj.Id;
//        userObjForDefault.username=userObj.username;
//        userObjForDefault.password=userObj.password;
//        userObjForDefault.userRole=userObj.userRole;
//        userObjForDefault.comanyId=userObj.comanyId;
//        userObjForDefault.email=userObj.email;
//        userObjForDefault.deviceToken=userObj.deviceToken;
//        userObjForDefault.mobileNo=userObj.mobileNo;
//        userObjForDefault.firstName=userObj.firstName;
//        userObjForDefault.lastName=userObj.lastName;
//        
//        NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
//        [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:userObjForDefault] forKey:@"userObject"];
        

        
    }
    else
    {
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"rememberMe"];
    }
    //CompanyNamesViewController * vc= [self.storyboard instantiateViewControllerWithIdentifier:@"CompanyNamesViewController"];
    
    //[self.navigationController pushViewController:vc animated:YES];
    [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"CompanyNamesViewController"] animated:NO completion:nil];



}



- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [hud hideAnimated:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_VALIDATE_USER object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_GETLATEST_FEEDCOM object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_VALIDATE_COUNTER object:nil];

    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end


