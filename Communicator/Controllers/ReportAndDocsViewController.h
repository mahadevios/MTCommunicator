//
//  ReportAndDocsViewController.h
//  Communicator
//
//  Created by mac on 24/05/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportAndDocsViewController : UIViewController<UIDocumentInteractionControllerDelegate,UISearchBarDelegate,UISearchResultsUpdating>
{
    NSMutableArray* arrayForBool;
    NSMutableArray* sectionTitleArray;
    UIView *sectionView;
    NSMutableArray * fileNameUserArray;
    NSMutableData* responseData;
    int statusCode;
    NSString* downloadableAttachmentName;
    UIRefreshControl* refreshControl;
    NSMutableArray* sampleSectionTitleArray;
    NSMutableArray* samplePredicateSectionTitleArray;
    UIAlertController *alertController;
    UIAlertAction *actionDelete;
    UIAlertAction *actionCancel;

}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *reportButton;
@property (weak, nonatomic) IBOutlet UIButton *documentButton;
@property (weak, nonatomic) IBOutlet UIView *reportButtonUnderlineView;
@property (weak, nonatomic) IBOutlet UIView *documentButtonUnderlineView;
@property (weak, nonatomic) MBProgressHUD *hud;

- (IBAction)buttonClicked:(id)sender;

@property (strong, nonatomic) UISearchController *searchController;
@property (nonatomic, strong) NSArray *search;
@property(nonatomic, weak) id< UISearchControllerDelegate > delegate;
@property (strong, nonatomic) NSString *indexPath;
@end
