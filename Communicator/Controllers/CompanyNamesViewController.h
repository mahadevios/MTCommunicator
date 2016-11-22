//
//  CompanyNamesViewController.h
//  Communicator
//
//  Created by mac on 12/05/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompanyNamesViewController : UIViewController

{
    UIAlertController *alertController;
    UIAlertAction *actionDelete;
    UIAlertAction *actionCancel;

}
@property (weak, nonatomic) IBOutlet UILabel *SelectComapnyHeaderLabel;


@end
