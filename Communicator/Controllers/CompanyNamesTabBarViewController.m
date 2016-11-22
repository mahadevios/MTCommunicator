//
//  CompanyNamesTabBarViewController.m
//  Communicator
//
//  Created by mac on 19/10/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import "CompanyNamesTabBarViewController.h"
#import "CompanyNamesViewController.h"
@interface CompanyNamesTabBarViewController ()

@end

@implementation CompanyNamesTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
   // [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"dismiss"]
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"dismiss"])
    {
        UIViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CompanyNamesViewController"];
        [self presentViewController:vc animated:YES completion:nil];
    }
    else
    {
        self.tabBarController.selectedIndex=0;
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
