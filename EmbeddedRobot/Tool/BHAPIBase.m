

//
//   BHAPIBase.m
//  EmbeddedRobot
//
//  Created by bihu_Mac on 2017/6/23.
//  Copyright © 2017年 initial. All rights reserved.
//

#import "BHAPIBase.h"
#import "AFNetworking.h"

#import "AFNetworkActivityIndicatorManager.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation BHAPIBase

#pragma mark -
#pragma mark 共有访问方法封装

- (NSURLSessionDataTask *)requestWithMethod:(BHRequestMethod)method
                                  URLString:(NSString *)URLString
                                 parameters:(NSDictionary *)parameters
                                       done:(void (^)(NSURLSessionDataTask *task, id responseObject))done
                                       fail:(void (^)(NSURLSessionDataTask *task,NSError *error))fail{
    //开启网络加载
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    self.client.responseSerializer =  [AFHTTPResponseSerializer serializer];
    //用于对成功后的处理
    void (^responseHandleBlock)(NSURLSessionDataTask *task, id responseObject) = ^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"URL:\n%@", [task.currentRequest URL].absoluteString);
        
        done(task, responseObject);
        
    };
    
    //对失败后结果处理
    void (^responseHandleFail)(NSURLSessionDataTask *task, NSError *error)=^(NSURLSessionDataTask *task, NSError *error){
        fail(task,error);
        NSLog(@"URL:\n%@", [task.currentRequest URL].absoluteString);
    };
    
    
    // Create HTTPSession
    NSURLSessionDataTask *task = nil;
    
    [self.client.requestSerializer clearAuthorizationHeader];

    //超时时间
    self.client.requestSerializer.timeoutInterval=180;
    self.client.responseSerializer = [AFJSONResponseSerializer serializer]; //返回的数据格式是json的
    self.client.requestSerializer=[AFJSONRequestSerializer serializer]; //申明请求的数据是json类型
    
    if(method==BHRequestMethodJSONGET||method==BHRequestMethodJSONPOST){
        
        self.client.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        
    }
    
    if(method==BHRequestMethodJSONPOST){
        AFHTTPResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
        self.client.responseSerializer = responseSerializer;
        task = [self.client  POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            responseHandleBlock(task,responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            responseHandleFail(task,error);
        }];
    }
    
    if(method==BHRequestMethodHTTPPOST){
        
        AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
        self.client.responseSerializer=responseSerializer;
        
        task = [self.client  POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            responseHandleBlock(task,responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            responseHandleFail(task,error);
        }];
    }
    
    
    
    
    return task;
    
    
}


//加密
-(NSDictionary *)refineUsrWithDic:(NSDictionary *)parmDic{
    
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    [dic addEntriesFromDictionary:parmDic];
    
    NSMutableDictionary *parameters=[NSMutableDictionary dictionary];
    [parameters addEntriesFromDictionary:dic];
    NSString *_sckode=[[self dictionaryUsrToMD5 :dic] lowercaseString];
    [parameters setValue:_sckode forKey:@"secCode"];
    
    return parameters;
}

-(NSString *)dictionaryUsrToMD5:(NSDictionary *)dict{
    
    NSDictionary *temDic=[NSDictionary dictionaryWithDictionary:dict];
    NSMutableString *queryStr=[NSMutableString string];
    
    NSArray *sortedKeys = [[temDic allKeys] sortedArrayUsingSelector: @selector(compare:)];
    
    for (NSString *aKey in sortedKeys) {
        [queryStr appendFormat:@"%@=%@",aKey,[dict objectForKey:aKey] ];
        [queryStr appendString:@"&"];
    }
    NSRange range = NSMakeRange(0,([queryStr length]-1));
    NSString *_tem= [queryStr substringWithRange:range];
    //    NSLog(@"去掉&的串:%@",_tem);
    return [self md5:_tem];
}




#pragma mark MD5计算


- (NSString *)md5:(NSString *)str{
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02X", digest[i]];
    }
    
    return result;
}


/**
*  存储投保地区对应的简称
*/
+ (void)setToken:(NSString *_Nullable)token{
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 * 获取获取投保地区对应的简称
 */
+ (NSString *_Nullable)getToken{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
}


@end
