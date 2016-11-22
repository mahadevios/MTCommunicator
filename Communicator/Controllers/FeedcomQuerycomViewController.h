//
//  FeedbackDetailViewController.h
//  Communicator
//
//  Created by mac on 29/03/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
//#import "TableViewSearchController.h"
@interface FeedcomQuerycomViewController : UIViewController<UISearchBarDelegate, UISearchResultsUpdating>
{
    FeedcomQuerycomViewController *searchResults;
    UIBarButtonItem* menuBarButton;
    NSMutableArray* arrayOfSeperatedSOArray;
    NSMutableArray* feedHeaderArray;
    UIRefreshControl* refreshControl;

}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic)NSMutableArray *feedTypeSONoArray;

@property (strong, nonatomic)NSMutableArray *feedTypeSONoCopyForPredicate;

@property (strong, nonatomic) NSArray *results;

@property (strong, nonatomic) NSString *feedbackType;
@property (weak, nonatomic) IBOutlet UIButton *cerateNewFeedbackOrQueryButton;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic)BOOL loading;
- (IBAction)buttonClicked:(id)sender;
-(void)popViewController;
-(void)reloadData;
-(void)prepareForSearchBar;

@end
