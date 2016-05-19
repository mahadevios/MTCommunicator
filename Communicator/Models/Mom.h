//
//  Mom.h
//  Communicator
//
//  Created by mac on 01/05/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Mom : NSObject

@property(nonatomic)int Id;
@property(nonatomic)int userFrom;
@property(nonatomic)int userTo;
@property(nonatomic,strong)NSString* attendee;
@property(nonatomic,strong)NSString* keyPoints;
@property(nonatomic,strong)NSString* subject;
@property(nonatomic,strong)NSDate* momDate;


@end
