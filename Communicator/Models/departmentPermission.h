//
//  departmentPermission.h
//  Communicator
//
//  Created by mac on 01/05/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface departmentPermission : NSObject

@property(nonatomic)int Id;
@property(nonatomic)int departmentId;
@property(nonatomic,strong)NSString* permission;

@end
