//
//  UserData.m
//  NoneCar
//
//  Created by DongSen on 2018/7/6.
//  Copyright © 2018年 董森森. All rights reserved.
//
#import "MJExtension.h"

#import "UserData.h"
static UserData* userData;
@implementation UserData

+ (UserData*)sharedUserData
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSDictionary * dic =[[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
        userData = [UserData mj_objectWithKeyValues:dic];
        if (!userData) {
            userData = [[super allocWithZone:NULL] init];
        }
    });
    return userData;
}

- (void)savedata{
    NSDictionary * dic = self.mj_keyValues;
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"User"];
    
}

@end
