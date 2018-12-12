//
//  UserInfo.m
//  NoneCar
//
//  Created by DongSen on 2018/7/13.
//  Copyright © 2018年 董森森. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo
- (NSString *)RepeatQuote{
    return _RepeatQuote?_RepeatQuote:@"";
}
- (NSString *)agentId{
    return _agentId?_agentId:@"";
}
- (NSString *)agentName{
    return _agentName?_agentName:@"";
}
- (NSString *)code{
    return _code?_code:@"";
}
- (NSString *)loginStatus{
    return _loginStatus?_loginStatus:@"";
}
- (NSString *)token{
    return _token?_token:@"";
}
- (NSString *)topAgentId{
    return _topAgentId?_topAgentId:@"";
}
- (NSString *)userName{
    return _userName?_userName:@"";
}
@end
