//
//  CounterGraph.h
//  Communicator
//
//  Created by mac on 05/06/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CounterGraph : NSObject

@property(nonatomic,strong)UILabel* counterGraphlabel;
@property(nonatomic,strong)UILabel* counterGraphlabel1;
@property(nonatomic,strong)UIView* referenceForCounterGraphView;
@property(nonatomic)long count;
@property(nonatomic)long count1;
@property(nonatomic,strong)UIButton* selectAttendeeButton;

@property(nonatomic,strong)NSArray* attachmentArray;
@property(nonatomic,strong)UITableViewCell* cell;
@property(nonatomic)int selectedIndex;
@property(nonatomic)NSIndexPath* indexPath;
@property(nonatomic)UIWebView* webView;
@property(nonatomic)NSString* webViewValue;


@end
