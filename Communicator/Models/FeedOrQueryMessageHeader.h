//
//  FeedOrQueryMessageHeader.h
//  Communicator
//
//  Created by mac on 06/05/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedOrQueryMessageHeader : NSObject

@property(nonatomic,strong)NSString* soNumber;
@property(nonatomic)int feedbackType;
@property(nonatomic,strong)NSString* feedText;
@property(nonatomic,strong)NSString* feedDate;
@property(nonatomic,strong)NSString* firstname;
@property(nonatomic,strong)NSString* lastname;
@property(nonatomic)int statusId;
@property(nonatomic)int readStatus;



@end
