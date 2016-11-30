//
//  ViewController.h
//  Communicator
//
//  Created by mac on 26/03/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "Database.h"
#import "FeedbackType.h"
#import "LoginViewController.h"

@interface HomeViewController : UIViewController<UISearchBarDelegate, UISearchResultsUpdating>

{
   // NSMutableArray* getFeedbackAndQueryTypesArray;
    NSMutableArray* labelArray;
    UIBarButtonItem* menuBarButton;
       UILabel* label1;
    CGFloat width;
    int selectedFeedbackType;
    long counter,totalCounter,closedCounter;
    UIAlertController *alertController;
    UIAlertAction *actionDelete;
    UIAlertAction *actionCancel;
}



@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic)NSMutableArray *feedTypeArray;

@property (strong, nonatomic)NSMutableArray *feedTypeCopyForPredicate;


@property (strong, nonatomic) NSIndexPath *data;
@property (strong, nonatomic)NSMutableArray *demoCountArray;
@property (nonatomic) UILabel* counterGraphLabel;
@property (nonatomic) UILabel* counterGraphLabel1;

@property (nonatomic) UIView* referenceViewForCounterGraph;





-(void)feedbackAndQuerySearch;



@end
