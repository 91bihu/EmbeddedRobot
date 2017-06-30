//
//   BHAPIManager.h
//  EmbeddedRobot
//
//  Created by bihu_Mac on 2017/6/23.
//  Copyright © 2017年 initial. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "BHAPIBase.h"

@class NSURLSessionDataTask;
@class BHDoWorkOrderModel;
@class BHDoWorkRecord;

@interface BHAPIManager : BHAPIBase

/**
 *  主域名
 */
@property(nonatomic,strong)NSURL *baseUrl;

/**
 *  API请求对象实例
 *
 *  @return ApI请求对象
 */
+(instancetype)manager;


/**
 *  检查网络
 */
-(void)checkNetwork;

/**
 *  检查是否有网
 *
 *  @return 如果无线或者WIFI返回YES
 */
-(BOOL)isReachable;

/**
 *  用户登录接口
 *参数说明
 | 参数名        | 描述    | 描述                                       |
 | ---------- | :---- | ---------------------------------------- |
 | AgentId    | 经纪人ID | 从壁虎平台获取的经纪人ID                            |
 | UserName   | 用户名   | 合作方内部系统登录的用户名                            |
 | Timestamp  | 时间戳   | 请求接口当前时间的时间戳(**unix时间戳**)                |
 | UniqueCode | 唯一标识  | APP 获取手机的机器码                             |
 | ExpireTime | 过期时间  | 比如合作伙伴的 APP 的过期时间三个月，从登录算起后退3个月的时间戳（**unix时间戳**）。 |
 | SecCode    | 加密串   | SecCode=(AgentId+UserName+Timestamp+UniqueCode+ExpireTime+SecretKey)按照首字母升序排列后进行 `MD5` 并且编码格式为UTF-8 |
 |SecretKey  |  顶级账号的秘钥
 */
-(NSURLSessionDataTask *)LoginUser:(NSString*)name  sucess:(void(^)(NSDictionary* dict))sucess failure:(void(^)(NSError *error))failure;


@end
