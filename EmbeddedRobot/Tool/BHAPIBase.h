
//
//   BHAPIBase.h
//  EmbeddedRobot
//
//  Created by bihu_Mac on 2017/6/23.
//  Copyright © 2017年 initial. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, BHRequestMethod) {
    BHRequestMethodJSONGET    = 1,
    BHRequestMethodHTTPPOST   = 2,
    BHRequestMethodHTTPGET    = 3,
    BHRequestMethodJSONPOST  = 4
    
};

@class AFHTTPSessionManager;

@interface BHAPIBase : NSObject

/**
 * http请求管理状态
 */
@property (nonatomic, strong,nonnull) AFHTTPSessionManager *client;


- (nullable NSURLSessionDataTask *)requestWithMethod:(BHRequestMethod)method
                                           URLString:(nonnull NSString *)URLString
                                          parameters:(nonnull NSDictionary *)parameters
                                                done:(void (^_Nonnull)(NSURLSessionDataTask  * _Nonnull task , __nullable id responseObject))done
                                                fail:(void (^_Nonnull)(NSURLSessionDataTask * _Nonnull task ,NSError * _Nonnull error))fail;




-( NSDictionary * _Nullable )refineUsrWithDic:(NSDictionary * _Nonnull)parmDic;


-(NSString *_Nullable)dictionaryUsrToMD5:(NSDictionary * _Nonnull)dict;


-(NSString * _Nullable) md5:(NSString * _Nonnull)str;


/**
 *  存储token
 */
+ (void)setToken:(NSString *_Nullable)token;

/**
 * 获取token
 */
+ (NSString *_Nullable)getToken;

@end
