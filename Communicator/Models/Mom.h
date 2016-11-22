//
//  Mom.h
//  Communicator
//
//  Created by mac on 01/05/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Mom : NSObject

@property(nonatomic)long Id;
@property(nonatomic)int userFrom;
@property(nonatomic)int userTo;
@property(nonatomic,strong)NSString* attendee;
@property(nonatomic,strong)NSString* keyPoints;
@property(nonatomic,strong)NSString* subject;
@property(nonatomic,strong)NSString* momDate;
@property(nonatomic,strong)NSString* dateTime;
@property(nonatomic)int userfeedback;
@property(nonatomic,strong)NSMutableArray* userIds;
@property(nonatomic)int readStatus;
@end
