//
//  MainMOMViewController.h
//  Communicator
//
//  Created by mac on 13/06/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainMOMViewController : UIViewController<UISearchBarDelegate,UISearchResultsUpdating>
{
    UIRefreshControl* refreshControl;
    UIAlertController *alertController;
    UIAlertAction *actionDelete;
    UIAlertAction *actionCancel;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
