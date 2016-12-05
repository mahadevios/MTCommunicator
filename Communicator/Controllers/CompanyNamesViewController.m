//
//  CompanyNamesViewController.m
//  Communicator
//
//  Created by mac on 12/05/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import "CompanyNamesViewController.h"
#import "MainTabBarViewController.h"
#import "HomeViewController.h"
#import "Database.h"
#import "ReportAndDocsViewController.h"
#import "MainMOMViewController.h"
#import "UIColor+CommunicatorColor.h"

@interface CompanyNamesViewController ()

@end

@implementation CompanyNamesViewController

@synthesize SelectComapnyHeaderLabel;

- (void)viewDidLoad

{
    [super viewDidLoad];
}


-(void)viewWillAppear:(BOOL)animated
{
    [self setNavigationBar];
}

#pragma mark:setNavigationBar

-(void)setNavigationBar
{
    self.navigationItem.hidesBackButton=YES;
    
    self.tabBarController.navigationItem.title = @"Select Company";
    
    self.navigationItem.title = @"Select Company";
    
    self.tabBarController.navigationItem.rightBarButtonItem=nil;
    
    SelectComapnyHeaderLabel.textColor=[UIColor communicatorColor];
    
}

#pragma mark:tableView delegates and dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    AppPreferences *app=[AppPreferences sharedAppPreferences];
    
    return app.companynameOrIdArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppPreferences *app=[AppPreferences sharedAppPreferences];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    UILabel* companyNameLabel=(UILabel*)[cell viewWithTag:101];
    
    companyNameLabel.text=[app.companynameOrIdArray objectAtIndex:indexPath.row];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Database* db=[Database shareddatabase];
    
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    
    UILabel* companyNameLabel=(UILabel*)[selectedCell viewWithTag:101];
    
    NSString* companyNameString=[NSString stringWithFormat:@"%@",companyNameLabel.text];
    
    alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@ selected",companyNameString]
                                                          message:@""
                                                   preferredStyle:UIAlertControllerStyleAlert];
    
    actionDelete = [UIAlertAction actionWithTitle:@"Ok"
                                            style:UIAlertActionStyleDefault
                                          handler:^(UIAlertAction * action)
                    {
                        
                        [[NSUserDefaults standardUserDefaults] setValue:companyNameString forKey:@"selectedCompany"];
                        
                        [db getFeedbackAndQueryCounterForCompany:companyNameString];
                        
                        HomeViewController* vc=[[HomeViewController alloc]init];
                        
                        NSString* userFrom;
                        
                        NSString* userTo;
                        
                        NSString* username = [[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"];
                        
                        NSString* companyId=[db getCompanyId:username];
                        
                        NSString* userFeedback=[db getUserIdFromUserName:username];
                        
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
                        
                        NSString* userCompanyId=  [db getCompanyIdFromCompanyName1:[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedCompany"]];

                        [[NSUserDefaults standardUserDefaults] setValue:userCompanyId forKey:@"clientCompanyId"];

                        [[NSUserDefaults standardUserDefaults] setValue:userFrom forKey:@"userFrom"];
                        
                        [[NSUserDefaults standardUserDefaults] setValue:userTo forKey:@"userTo"];
                        
                        [[NSUserDefaults standardUserDefaults] setValue:userFeedback forKey:@"userFeedback"];
                        
                        if (self.tabBarController.selectedViewController==self)
                        {
                            [vc feedbackAndQuerySearch];
                            
                            [self dismissViewControllerAnimated:YES completion:nil];
                            
                        }
                        
                        else
                        {
                            
                            MainTabBarViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabBarViewController"];
                            
                            [[[UIApplication sharedApplication] keyWindow] setRootViewController:vc];
                            
                            [vc setTabBars];
                            
                            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"dismiss"];
                            
                            [self dismissViewControllerAnimated:YES completion:nil];
                            
                            
                        }

                    }]; //You can use a block here to handle a press on this button
    
    [alertController addAction:actionDelete];
    
    
    actionCancel = [UIAlertAction actionWithTitle:@"Cancel"
                                            style:UIAlertActionStyleCancel
                                          handler:^(UIAlertAction * action)
                    {
                        [alertController dismissViewControllerAnimated:YES completion:nil];
                        
                    }]; //You can use a block here to handle a press on this button
    
    [alertController addAction:actionCancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    //self.tabBarController.selectedIndex=0;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
