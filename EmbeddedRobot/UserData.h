//
//  UserData.h
//  NoneCar
//
//  Created by DongSen on 2018/7/6.
//  Copyright © 2018年 董森森. All rights reserved.
//

#import "UserInfo.h"
#import <Foundation/Foundation.h>

@interface UserData : NSObject

@property(nonatomic,strong)UserInfo * user;

+ (UserData*)sharedUserData;//

- (void)savedata;

@end
