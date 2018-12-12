//
//  UserData.h
//  NoneCar
//
//  Created by DongSen on 2018/7/6.
//  Copyright © 2018年 董森森. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserData : NSObject

@property(nonatomic,strong) NSString * RepeatQuote; //登录状态
@property(nonatomic,strong) NSString * agentId; //登录状态
@property(nonatomic,strong) NSString * agentName; //登录状态
@property(nonatomic,strong) NSString * code; //登录状态
@property(nonatomic,strong) NSString * loginStatus; //登录状态
@property(nonatomic,strong) NSString * token; //登录状态
@property(nonatomic,strong) NSString * topAgentId; //登录状态
@property(nonatomic,strong) NSString * userName; //登录状态

+ (UserData*)sharedUserData;// 初始化内部使用单例方法为必须调用 如果调用alloc 则会出现问题

- (void)savedata;
@end
