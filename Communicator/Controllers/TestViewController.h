//
//  TestViewController.h
//  Communicator
//
//  Created by mac on 15/11/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestViewController : UIViewController<UIWebViewDelegate,UIScrollViewDelegate>
{
    NSMutableArray* heightArray;
    NSMutableArray* webViewArray;
    NSMutableArray* cellArray;
    float rowHeight;
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@end
