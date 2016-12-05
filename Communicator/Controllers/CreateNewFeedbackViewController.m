//
//  CreateNewFeedbackViewController.m
//  Communicator
//
//  Created by mac on 19/05/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import "CreateNewFeedbackViewController.h"
#import "UIColor+CommunicatorColor.h"
#import "Feedback.h"
#import "Database.h"
#import "HomeViewController.h"
#import "FeedQueryCounter.h"
@interface CreateNewFeedbackViewController ()

@end

@implementation CreateNewFeedbackViewController

@synthesize SONumberTextField;
@synthesize AvayaIdTextField;
@synthesize DocumentIdTextField,hud;
@synthesize SubjectTextView;
@synthesize OperatorTextField;
@synthesize DescriptionTextView;
@synthesize scrollview,submitButton;
@synthesize insideView,tableView,attendiesTextView,compositeSONumber;

- (void)viewDidLoad
{
    [super viewDidLoad];
    Database* db=[Database shareddatabase];
    allOperatorUsernamesDict= [db getAllOperaotorUsernames];
    [self setNeedsStatusBarAppearanceUpdate];
    self.cellSelected=[NSMutableArray new];
    attendiesTextView.delegate=self;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addAttachmentName:) name:NOTIFICATION_FILE_UPLOAD
                                               object:nil];
//    attendiesTextView.editable=NO;
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    OperatorTextField.delegate=self;
    DescriptionTextView.delegate=self;
    SONumberTextField.delegate=self;
    AvayaIdTextField.delegate=self;
    DocumentIdTextField.delegate=self;
    SubjectTextView.delegate=self;
    submitButton.layer.cornerRadius=4.0f;
    self.navigationController.navigationBar.barTintColor = [UIColor communicatorColor];
    [self.navigationController.navigationBar setBarStyle:UIStatusBarStyleLightContent];// to set carrier,time and battery color in white color

 
       [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(validateUserResponse:) name:NOTIFICATION_SEND_NEWFEEDBACK
                                               object:nil];
    [self.tableView setHidden:YES];
    NSArray* arr=  [allOperatorUsernamesDict allKeys];
    if (arr.count>0)
    {
        OperatorTextField.text=  [arr objectAtIndex:0];

    }
    
//
//    AvayaIdTextField.tag=0;
//    DocumentIdTextField.tag=0;
//    OperatorTextField.tag=0;
}
-(void)addAttachmentName:(NSNotification*)noti
{
    [[[UIApplication sharedApplication].keyWindow viewWithTag:1122] removeFromSuperview];

    NSDictionary* dic= noti.object;
    NSString *uploadedFileNameString = [dic valueForKey:@"fileName"];
    
    NSArray* array=[uploadedFileNameString componentsSeparatedByString:@"#@$"];
    
    if (array.count>0)
    {
        uploadedFileNameString=[array objectAtIndex:0];

    }
    UIView* scrollView=[self.view viewWithTag:1210];
    UIView* insidView=[scrollView viewWithTag:1211];
    UILabel* attachmentLabel=[insidView viewWithTag:1212];
    if (uploadedFileNameString.length>14)
    {
      attachmentLabel.text=  [uploadedFileNameString substringFromIndex:14];

    }
    else

    attachmentLabel.text=uploadedFileNameString;
    //[[UIApplication sharedApplication].keyWindow viewWithTag:1212];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ADD_FEEDBACK_BUTTON object:nil];
    
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)validateUserResponse:(NSNotification *)notification
{
    if ([[notification.object objectForKey:@"Status"] isEqualToString:@"AlreadyAvailable"])
    {
        [[[UIApplication sharedApplication].keyWindow viewWithTag:789] removeFromSuperview];

        [[AppPreferences alloc] showAlertViewWithTitle:@"Alert" withMessage:@"Issue with entered SO number,Avaya id,Document Id is already available" withCancelText:@"Cancel" withOkText:@"Ok" withAlertTag:123];
    }
    else
    if ([[notification.object objectForKey:@"code"] isEqualToString:SUCCESS])
    {
        gotResponse=TRUE;
        NSString* companyFeedbackTypeAsscociationString=[notification.object objectForKey:@"feedbackCounterId"];
        
        
       
        [self sendNewFeedbackOrSaveResponse:notification.object];
    }
}

#pragma mark:UIPickerViewDataSource,UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
   
    return allOperatorUsernamesDict.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
  NSArray* arr=  [allOperatorUsernamesDict allKeys];
    NSString * title = [arr objectAtIndex:row];
        return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSArray* arr=  [allOperatorUsernamesDict allKeys];

    OperatorTextField.text=  [arr objectAtIndex:row];
}

-(void)doneBtnPressToGetValue:(id)sender
{
    [OperatorTextField resignFirstResponder];
    [self removePickerToolBar];
}
#pragma mark-texField delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==SONumberTextField)
    {
        [AvayaIdTextField becomeFirstResponder];
    }
    if (textField==AvayaIdTextField)
    {
        [DocumentIdTextField becomeFirstResponder];
       // [self moveViewUp:YES];

    }
    if (textField==DocumentIdTextField)
    {
        [SubjectTextView becomeFirstResponder];
       // [self moveViewUp:YES];

    }
    if (textField==OperatorTextField)
    {
        [DescriptionTextView becomeFirstResponder];
        
    }

    return YES;
}


- (void) addPickerToolBar
{
    if ([self.view viewWithTag:10001]==nil)
    {
    
    picker=[[UIPickerView alloc]init];
    picker.tag=10001;
    picker.frame = CGRectMake(0.0f, self.view.frame.size.height - 216.0f, self.view.frame.size.width, 216.0f);
    picker.delegate = self;
    picker.dataSource = self;
    picker.showsSelectionIndicator = YES;
    [self.view addSubview:picker];
    picker.userInteractionEnabled = true;
    picker.backgroundColor = [UIColor lightGrayColor];
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneBtnPressToGetValue:)];
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, picker.frame.origin.y - 40.0f, self.view.frame.size.width, 40.0f)];
    toolBar.tag = 10000;
    [toolBar setItems:[NSArray arrayWithObject:btn]];
    [self.view addSubview:toolBar];
   //     OperatorTextField.inputAccessoryView=toolBar;
    }
}

- (void) removePickerToolBar
{
    [picker removeFromSuperview];
    UIView *toolBar = (UIView *)[self.view viewWithTag:10000];
    if (toolBar != NULL)
    {
        [toolBar removeFromSuperview];
    }
   // [DescriptionTextView becomeFirstResponder];

}

#pragma mark-texView delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"])
    {
        if(textView==SubjectTextView)
        {
            [self.SubjectTextView resignFirstResponder];
            //[self.view endEditing:true];
           // [self moveViewUp:YES];
            //[self.OperatorTextField becomeFirstResponder];

            //[self performSelector:@selector(addPickerToolBar) withObject:nil afterDelay:0.5];

        }
        else
            [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
//-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
//    if (textField==OperatorTextField)
//    {
//        [self.OperatorTextField resignFirstResponder];
//        [self.AvayaIdTextField resignFirstResponder];
//        [self.DocumentIdTextField resignFirstResponder];
//        [self.SONumberTextField resignFirstResponder];
//        [self.DescriptionTextView resignFirstResponder];
//        [self.SubjectTextView resignFirstResponder];
//
//        return YES;
//    }
//    return YES;
//
//}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField==OperatorTextField)
    {

        dispatch_async(dispatch_get_main_queue(), ^{
            // make some UI changes
            // ...
            // show actionSheet for example
            NSArray* arr=  [allOperatorUsernamesDict allKeys];
            
            OperatorTextField.text=  [arr objectAtIndex:0];
            [self.OperatorTextField resignFirstResponder];
            [self.AvayaIdTextField resignFirstResponder];
            [self.DocumentIdTextField resignFirstResponder];
            [self.SONumberTextField resignFirstResponder];
            [self.DescriptionTextView resignFirstResponder];
            [self.SubjectTextView resignFirstResponder];
        });
        
        [self addPickerToolBar];
       // [self performSelector:@selector(addPickerToolBar) withObject:nil afterDelay:0.0];
        

    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField==SONumberTextField)
    {
        [SONumberTextField resignFirstResponder];
    }
    if (textField==AvayaIdTextField)
    {
        [AvayaIdTextField resignFirstResponder];
    }
    if (textField==DocumentIdTextField)
    {
        [DocumentIdTextField resignFirstResponder];
    }
   
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if (textView== attendiesTextView)
    {
        [OperatorTextField resignFirstResponder];
        [self removePickerToolBar];
        [self addIds];
    }
    if (textView== DescriptionTextView)
    {
        [OperatorTextField resignFirstResponder];
        [self removePickerToolBar];
    }

    //[self moveViewUp:YES];
    
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView==DescriptionTextView)
    {
        [DescriptionTextView resignFirstResponder];
       // [self moveViewUp:NO];

    }
    if (textView==SubjectTextView)
    {
        [SubjectTextView resignFirstResponder];
        // [self moveViewUp:NO];
        
    }

    
}


//- (void) moveViewUp: (BOOL) isUp
//{
//   const int movementDistance = 80; // tweak as needed
//    const float movementDuration = 0.3f; // tweak as needed
//    if (isUp)
//    {
//        totalMovement=totalMovement+70;
//    }
//    movement = (isUp ? -movementDistance : movementDistance);
//    
//    [UIView beginAnimations: @"anim" context: nil];
//    [UIView setAnimationBeginsFromCurrentState: YES];
//    [UIView setAnimationDuration: movementDuration];
//    insideView.frame = CGRectOffset(insideView.frame, 0, movement);
//    [UIView commitAnimations];
//}
//


- (IBAction)attachmentButtonClicked:(id)sender
{
    [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"UploadFileViewController"] animated:YES completion:nil];

}

- (IBAction)dismissViewController:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)sendNewFeedback:(id)sender
{
    [self sendNewFeedbackOrSaveResponse:nil];
}

-(void)sendNewFeedbackOrSaveResponse:(NSDictionary*)reponseDict
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert"
                                                                             message:@"Please select the operator"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    //We add buttons to the alert controller by creating UIAlertActions:
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action)
                               {
                                   
                                   [alertController dismissViewControllerAnimated:YES completion:nil];
                               }]; //You can use a block here to handle a press on this button
    [alertController addAction:actionOk];
//    if(!(SONumberTextField.text.length==0) || !(AvayaIdTextField.text.length==0) || !(DocumentIdTextField.text.length==0))
//    {
        if (SubjectTextView.text.length!=0)
        {
            if (OperatorTextField.text!=nil)
            {
               if (DescriptionTextView.text.length!=0)
               {
                NSString* userFrom;
                NSString* userTo;
                
                Database *db=[Database shareddatabase];
                NSString* username = [[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"];
                NSString* companyId=[db getCompanyId:username];
                NSString* userFeedback=[db getUserIdFromUserName:username];
                NSMutableArray* feedidCounterAndFeedbackTypeArray=[db getFeedTypeIdAndMaxCounter:self.feedbackType];
                
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
                
                
                NSDate* date= [NSDate new];
                NSTimeInterval seconds = [date timeIntervalSince1970];
                double milliseconds = seconds*1000;
                
                Feedback* feedObj=[[Feedback alloc]init];
                   NSString* soNumber= SONumberTextField.text;
                   NSString* avayaId=AvayaIdTextField.text;
                   NSString* documentId=DocumentIdTextField.text;
                   
//                   if (SONumberTextField.text.length <=0)
//                   {
//                       SONumberTextField.text=@"0";
//                   }
//                   if (AvayaIdTextField.text.length <=0)
//                   {
//                       AvayaIdTextField.text=@"0";
//                       
//                   }
//                   if (DocumentIdTextField.text.length <=0)
//                   {
//                       DocumentIdTextField.text=@"0";
//                   }

                   feedObj.soNumber=[NSString stringWithFormat:@"%@#@%@#@%@",soNumber,avayaId,documentId];
                   
                    if (soNumber.length <=0 && avayaId.length <=0 && documentId.length <=0 && !gotResponse)
                   {
                       
                       
                      

                       NSDate *date = [[NSDate alloc] init];
                       NSTimeInterval seconds = [date timeIntervalSinceReferenceDate];
                       long milliseconds = seconds*10000;
                       NSString* temp=[NSString stringWithFormat:@"%d-%ld",0,milliseconds];
                       compositeSONumber=[NSString stringWithFormat:@"%@#@%@#@%@",temp,@"0",@"0"];
                       
                   }
                   else
                       if (soNumber.length <=0 && avayaId.length <=0 && !gotResponse)
                       {
                           compositeSONumber=[NSString stringWithFormat:@"%@#@%@#@%@",@"0",@"0",documentId];
 
                       }
                       else
                           if (soNumber.length <=0 && documentId.length <=0 && !gotResponse)
                           {
                               compositeSONumber=[NSString stringWithFormat:@"%@#@%@#@%@",@"0",avayaId,@"0"];
                               
                           }
                           else
                               if (avayaId.length <=0 && documentId.length <=0 && !gotResponse)
                               {
                                   compositeSONumber=[NSString stringWithFormat:@"%@#@%@#@%@",soNumber,@"0",@"0"];
                                   
                               }
                               else
                                   if (soNumber.length <=0  && !gotResponse)
                                   {
                                       compositeSONumber=[NSString stringWithFormat:@"%@#@%@#@%@",@"0",avayaId,documentId];
                                       
                                   }
                                   else
                                       if (avayaId.length <=0  && !gotResponse)
                                       {
                                           compositeSONumber=[NSString stringWithFormat:@"%@#@%@#@%@",soNumber,@"0",documentId];
                                           
                                       }
                                       else
                                           if (documentId.length <=0  && !gotResponse)
                                           {
                                               compositeSONumber=[NSString stringWithFormat:@"%@#@%@#@%@",soNumber,avayaId,@"0"];
                                               
                                           }
                   else
                       if (!gotResponse)
                       {
                           compositeSONumber=feedObj.soNumber;

                       }
                   
                   

                feedObj.emailSubject=[NSString stringWithFormat:@"%@ %ld",SubjectTextView.text,(long)milliseconds];
                feedObj.operatorId=[[allOperatorUsernamesDict valueForKey:OperatorTextField.text]intValue];
                feedObj.feedbackText=DescriptionTextView.text;
                feedObj.userFrom=[userFrom intValue];
                feedObj.userTo=[userTo intValue];
                feedObj.userFeedback=[userFeedback intValue];
                
                NSString* dts=[[APIManager sharedManager] getDate];
                NSArray* dt= [dts componentsSeparatedByString:@" "];
                feedObj.dateOfFeed=[NSString stringWithFormat:@"%@"@" "@"%@",[dt objectAtIndex:0],[dt objectAtIndex:1]];
                //feedObj.dateOfFeed=[NSString stringWithFormat:@"%@",[[APIManager sharedManager] getDate]];
                feedObj.feedbackType=[[feedidCounterAndFeedbackTypeArray objectAtIndex:2]intValue];
                feedObj.feedbackId=[[feedidCounterAndFeedbackTypeArray objectAtIndex:0]intValue];
                feedObj.feedbackCounter=[[feedidCounterAndFeedbackTypeArray objectAtIndex:1]intValue];
                   
                   
                   NSString *uploadedFileNamesString = @"";
                   AppPreferences* app=[AppPreferences sharedAppPreferences];
                   
                   if (app.uploadedFileNamesArray.count==1)
                   {
                       uploadedFileNamesString = [NSString stringWithFormat:@"%@", [app.uploadedFileNamesArray objectAtIndex:0]];
                   }
                   else
                       
                       if (app.uploadedFileNamesArray.count>1)
                       {
                           for (int i = 0; i<app.uploadedFileNamesArray.count; i++)
                           {
                               
                               if (i == 0)
                               {
                                   uploadedFileNamesString = [NSString stringWithFormat:@"%@", [app.uploadedFileNamesArray objectAtIndex:i]];
                                   
                               }
                               else
                               {
                                   uploadedFileNamesString=[uploadedFileNamesString stringByAppendingString:[NSString stringWithFormat:@"%@",[app.uploadedFileNamesArray objectAtIndex:i]]];
                                   
                               }
                               
                               
                           }
                           
                           
                       }
                   
                   
                   uploadedFileNamesString = [uploadedFileNamesString stringByReplacingOccurrencesOfString:@"/" withString:@""];
                   uploadedFileNamesString = [uploadedFileNamesString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                   feedObj.attachment = uploadedFileNamesString;
                   

                //feedObj.attachment=@"";
                feedObj.statusId=1;
                
                NSMutableString* userIdsString=[[NSMutableString alloc]init];
                
                for (int i=0; i<userIdsArray.count; i++)
                {
                    if ([userIdsString isEqualToString:@""])
                    {
                        userIdsString =[NSMutableString stringWithFormat:@"%@",[userIdsArray objectAtIndex:i]];
                        
                    }
                    else
                        userIdsString =[NSMutableString stringWithFormat:@"%@,%@",userIdsString,[userIdsArray objectAtIndex:i]];
                }
                

               
                
                
                NSArray* keys=[NSArray arrayWithObjects:@"feedbackId",@"soNumber",@"subject",@"userFrom",@"userTo",@"userFeedback",@"feedText",@"feedbackType",@"feedbackCounter",@"operatorId",@"dateOfFeed",@"statusId",@"attachment",@"userIds",nil];
               
                NSArray* values=@[[NSString stringWithFormat:@"%ld",feedObj.feedbackId+1],compositeSONumber,feedObj.emailSubject,[NSString stringWithFormat:@"%d",feedObj.userFrom],[NSString stringWithFormat:@"%d",feedObj.userTo],[NSString stringWithFormat:@"%d",feedObj.userFeedback],feedObj.feedbackText,[NSString stringWithFormat:@"%d",feedObj.feedbackType],[NSString stringWithFormat:@"%ld",feedObj.feedbackCounter+1],[NSString stringWithFormat:@"%d",feedObj.operatorId],feedObj.dateOfFeed,[NSString stringWithFormat:@"%d",feedObj.statusId],feedObj.attachment,userIdsString];
                NSDictionary* dic=[NSDictionary dictionaryWithObjects:values forKeys:keys];
                
                [[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"];
                [[NSUserDefaults standardUserDefaults] valueForKey:@"currentPassword"];
                
                if (gotResponse)
                {
                    Database *db=[Database shareddatabase];
                    if (app.uploadedFileNamesArray != nil)
                    {
                        [app.uploadedFileNamesArray removeAllObjects];
                    }
                    keys=[NSArray arrayWithObjects:@"feedbackId",@"soNumber",@"subject",@"userFrom",@"userTo",@"userFeedback",@"feedText",@"feedbackType",@"feedbackCounter",@"operatorId",@"dateOfFeed",@"statusId",@"attachment",nil];
                    
                    values=@[[reponseDict objectForKey:@"feedbackCounterId"],compositeSONumber,feedObj.emailSubject,[NSString stringWithFormat:@"%d",feedObj.userFrom],[NSString stringWithFormat:@"%d",feedObj.userTo],[NSString stringWithFormat:@"%d",feedObj.userFeedback],feedObj.feedbackText,[NSString stringWithFormat:@"%d",feedObj.feedbackType],[reponseDict objectForKey:@"feedbackCount"],[NSString stringWithFormat:@"%d",feedObj.operatorId],feedObj.dateOfFeed,[NSString stringWithFormat:@"%d",feedObj.statusId],feedObj.attachment];

                    dic=[NSDictionary dictionaryWithObjects:values forKeys:keys];
                    
                    //NSString* str=[[NSUserDefaults standardUserDefaults] valueForKey:@"flag"] ;
                    //if ([str isEqualToString:@"0"])
                    //{
                    [db insertNewFeedback:dic :reponseDict];
                    //}
                    //else
                    //{
                    //    [db insertNewQuery:dic];
                    //}
                    
                        gotResponse=FALSE;
                    HomeViewController * vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
                    NSString* alertMessage=@"Feedback generated successfully";

                    [[[UIApplication sharedApplication].keyWindow viewWithTag:789] removeFromSuperview];
                    if ([companyId isEqual:@"1"])
                    {
                      NSString* companyNameString=[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedCompany"];
                        [db getFeedbackAndQueryCounterForCompany:companyNameString];

                    }
                    
                    else
                    {
                        NSString* companyNameString= [db getCompanyIdFromCompanyName:companyId];
                        [db getFeedbackAndQueryCounterForCompany:companyNameString];
                    }
                    [vc1 feedbackAndQuerySearch];

                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert"
                                                                                             message:alertMessage
                                                                                      preferredStyle:UIAlertControllerStyleAlert];
                    //We add buttons to the alert controller by creating UIAlertActions:
                    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                       style:UIAlertActionStyleDefault
                                                                     handler:^(UIAlertAction *action)
                                               {
                                                   
                                                   [self dismissViewControllerAnimated:YES completion:nil];
                                               }]; //You can use a block here to handle a press on this button
                    [alertController addAction:actionOk];
                    [self presentViewController:alertController animated:YES completion:nil];
                    

                
                    
                    

             }
                else
                {
                    hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
                    hud.tag=789;
                    hud.label.text = @"Sending...";
                    hud.detailsLabel.text=@" Please wait";
                    hud.minSize = CGSizeMake(150.f, 100.f);
                [[APIManager sharedManager] sendNewFeedback:@"0" Dict:dic username:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"] password:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentPassword"]];
               
                }
                
            }
               else
               {
                   alertController.message=@"Please enter the description";
                   [self presentViewController:alertController animated:YES completion:nil];
               }
  
            }
            
            else
            {
            alertController.message=@"Please select the operator";
            [self presentViewController:alertController animated:YES completion:nil];
            }
        }
        else
        {
            alertController.message=@"Please enter the subject";
            [self presentViewController:alertController animated:YES completion:nil];
        }
//    }
//    else
//    {
//    alertController.message=@"Please enter one of the field";
//
//    [self presentViewController:alertController animated:YES completion:nil];
//    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView* sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,self.tableView.frame.size.width,80)];
    sectionView.backgroundColor=[UIColor grayColor];
    UIButton* doneButton=[[UIButton alloc]initWithFrame:CGRectMake(tableView.frame.size.width-80, 10, 70,30)];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    doneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [doneButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [sectionView addSubview:doneButton];
    [doneButton addTarget:self action:@selector(setAttendeeList:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton* cancelButton=[[UIButton alloc]initWithFrame:CGRectMake(10, 10, 70,30)];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [cancelButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [sectionView addSubview:cancelButton];
    [cancelButton addTarget:self action:@selector(cancelAttendeeList:) forControlEvents:UIControlEventTouchUpInside];
    
    //    setAttendeeList
    
    //UILabel *fileCountLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.tableView.frame.size.width-60, 5, 50, 40)];
    return  sectionView;
    
    
}

-(void)setAttendeeList:(UIButton*)doneButton
{
    
        self.scrollview.userInteractionEnabled = YES;
        
        
        
        userIdsArray=[NSMutableArray new];
        userNamesArray=[NSMutableArray new];
        for (int i=0; i<self.cellSelected.count; i++)
        {
            NSString* k=[self.cellSelected objectAtIndex:i];
            User* userobject= [userObjectsArray objectAtIndex:[k intValue]];
            [userNamesArray addObject:[NSString stringWithFormat:@"%@ %@",userobject.firstName,userobject.lastName]];
            [userIdsArray addObject:[NSString stringWithFormat:@"%d",userobject.Id]];
            
        }
        
        [self.tableView setHidden:YES];
        for (int j=0; j<userNamesArray.count; j++)
        {
            if (j==0)
            {
                attendiesTextView.text=[userNamesArray objectAtIndex:j];
                
            }
            else
                attendiesTextView.text=[NSString stringWithFormat:@"%@,%@",attendiesTextView.text,[userNamesArray objectAtIndex:j]];
        }
        if (userNamesArray.count==0)
        {
            attendiesTextView.text=@"";
        }
        
    
   
}

-(void)cancelAttendeeList:(UIButton*)sender
{
   
        self.cellSelected=nil;
        self.attendiesTextView.text=nil;
        userIdsArray=nil;
        userNamesArray=nil;
        self.cellSelected=[[NSMutableArray alloc]init];
        [self.tableView reloadData];
        //    userNamesArray=nil;
        //    userIdsArray=nil;
        self.scrollview.userInteractionEnabled = YES;
        [self.tableView setHidden:YES];
   
    
   }


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    Database* db=[Database shareddatabase];
    NSString* username = [[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"];
    NSString* companyId=[[Database shareddatabase] getCompanyId:username];
    NSString* companyId1;
    NSString* selectedCompany;
    if ([companyId isEqual:@"1"])
    {
        selectedCompany= [[NSUserDefaults standardUserDefaults] valueForKey:@"selectedCompany"];
        companyId1= [[Database shareddatabase] getCompanyIdFromCompanyName1:selectedCompany];
    }
    else
    {
     companyId1=@"1";
    }
    
    //NSString* companyId= [db getCompanyId:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentUsername"]];
    userObjectsArray= [db getAllUsersFirstnameLastname:companyId company2:companyId1];
    

    return userObjectsArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        if ([self.cellSelected containsObject:[NSString stringWithFormat:@"%ld",indexPath.row]])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
            
        }
        cell.tag=indexPath.row;
        UILabel* attendeeNameLabel= [cell viewWithTag:97];
        
        
        User* userObject= [userObjectsArray objectAtIndex:indexPath.row];
        attendeeNameLabel.text=[NSString stringWithFormat:@"%@ %@",userObject.firstName,userObject.lastName];
        return cell;
        
  
   
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        if ([self.cellSelected containsObject:[NSString stringWithFormat:@"%ld",indexPath.row]])
        {
            
            [self.cellSelected removeObject:[NSString stringWithFormat:@"%ld",indexPath.row]];
        }
        else
        {
            [self.cellSelected addObject:[NSString stringWithFormat:@"%ld",indexPath.row]];
        }
   
        [self.tableView reloadData];
    
}


-(void)setAttende:(UIButton*)selectAttendeeButton
{
    if([selectAttendeeButton isSelected])
    {
        [selectAttendeeButton setSelected:NO];
        [isSelectedDict setObject:[NSNumber numberWithBool:FALSE] forKey:[NSString stringWithFormat:@"%ld",(long)selectAttendeeButton.tag]];
        
        
    }
    else
    {
        [isSelectedDict setObject:[NSNumber numberWithBool:TRUE] forKey:[NSString stringWithFormat:@"%ld",(long)selectAttendeeButton.tag]];
        
        [selectAttendeeButton setSelected:YES];
    }
    
}

- (IBAction)addAttendees:(id)sender
{
//    [self.tableView reloadData];
//    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"attendies"];
//   // [dateTextField resignFirstResponder];
//    [self.tableView setHidden:NO];
//    self.scrollview.userInteractionEnabled = NO;
    
    [self addIds];
    // self.scrollView.alpha = 0.3f;
    //[self.view addSubview:popupTableView];
    
}

-(void)addIds
{
    [self.tableView reloadData];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"attendies"];
    dispatch_async(dispatch_get_main_queue(), ^{
        // make some UI changes
        // ...
        // show actionSheet for example
        [attendiesTextView resignFirstResponder];

    });

    [self.tableView setHidden:NO];
    self.scrollview.userInteractionEnabled = NO;
}
@end
