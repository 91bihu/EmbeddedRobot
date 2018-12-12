//
//   BHAPIManager.m
//  EmbeddedRobot
//
//  Created by bihu_Mac on 2017/6/23.
//  Copyright © 2017年 initial. All rights reserved.
//

#import "BHAPIManager.h"
#import "AFNetworking.h"

#import <CommonCrypto/CommonCrypto.h>
#import "AFNetworkActivityIndicatorManager.h"
#import "KeychainItemWrapper.h"
//密钥
//55e8e155-bd5b-49da-93f1-ba8acd9e9448


@interface BHAPIManager()

@end

@implementation BHAPIManager

#pragma mark -
#pragma mark 初始化

- (instancetype)init{
    self=[super init];
    if (self) {
        _baseUrl=[NSURL URLWithString:@""];
        self.client = [[AFHTTPSessionManager alloc] initWithBaseURL:_baseUrl];
        AFHTTPRequestSerializer* serializer = [AFHTTPRequestSerializer serializer];
        self.client.requestSerializer = serializer;
    }
    return self;
}

+(instancetype)manager{
    static BHAPIManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[BHAPIManager alloc] init];
    });
    return manager;
}

-(void)setBaseUrl:(NSURL *)baseUrl{
    self.client = [[AFHTTPSessionManager alloc] initWithBaseURL:_baseUrl];
    AFHTTPRequestSerializer* serializer = [AFHTTPRequestSerializer serializer];
    self.client.requestSerializer = serializer;
    
}

#pragma mark -
#pragma mark 检查网络

-(void)checkNetwork{
    AFNetworkReachabilityManager *reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [reachabilityManager startMonitoring];
    
    [reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            //检查不到网络
        }
        if (status == AFNetworkReachabilityStatusNotReachable) {
            //网络无连接的提示
        }
        
        if (status == AFNetworkReachabilityStatusUnknown) {
            //网络位置
        }
        if (status == AFNetworkReachabilityStatusReachableViaWWAN) {
            //网络3G
        }
        if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
            //网络位置
            NSLog(@"WiFI");
        }
        
    }];
}

-(BOOL)isReachable{
    AFNetworkReachabilityManager *reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    return [reachabilityManager isReachable];
}

-(NSURLSessionDataTask *)LoginUser:(NSString*)Name  sucess:(void(^)(NSDictionary* dict))sucess failure:(void(^)(NSError *error))failure{
    
    //AgentId:顶级账号id
  //顶级账号的秘钥
    NSDictionary *temparameters = @{@"AgentId":@(102),@"ExpireTime":[self gerThreeTime],@"Timestamp":[self getTime],@"UniqueCode":[self getDeviceID],@"UserName": Name,@"SecretKey":@"60a78c69d89"};
        //SecretKey:  60a78c69d89
        //SecretKey:  gsb23np5npnhk26
    NSDictionary *parameters=[self refineUsrWithDic:temparameters];
    //http://192.168.5.54:9999
    //http://wx.91bihu.com
    NSString *url=[NSString stringWithFormat:@"%@",@"http://192.168.5.19:9094/api/unite/LoginAPP"];
    
    return [self requestWithMethod:BHRequestMethodJSONPOST
                         URLString:url
                        parameters:parameters
                              done:^(NSURLSessionDataTask *task, id responseObject) {

                           
                                sucess(responseObject);
                                
                                  
                              } fail:^(NSURLSessionDataTask *task,NSError *error) {
                                  failure(error);
                                  NSLog(@"登录失败:%@",error);
                              }];
    
}



//获取当前时间的时间戳
- (NSString *)getTime{
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval a=[dat timeIntervalSince1970];
    
    NSString *timeString = [NSString stringWithFormat:@"%0.f", a];
    
    return timeString;
}

//获取3个月后的时间戳
- (NSString *)gerThreeTime{
    
     NSDate* mydate = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *comps = nil;
    
    comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:mydate];
    
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    //年
    [adcomps setYear:0];
    //3个月
    [adcomps setMonth:3];
    //日
    [adcomps setDay:0];
    
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:mydate options:0];
   
    NSTimeInterval a=[newdate timeIntervalSince1970];
    
    NSString *timeString = [NSString stringWithFormat:@"%0.f", a];

    return timeString;
    
}


//获取设备号 唯一标识UniqueCode
-(NSString*) getDeviceID{
    
    KeychainItemWrapper *keyChain = [[KeychainItemWrapper alloc] initWithIdentifier:@"keyChainIdentifier" accessGroup:nil];
    NSString *  value = [keyChain objectForKey:(__bridge id)kSecAttrAccount];
    if (value == NULL || [value isEqual:@""])
    {
        [keyChain setObject:[self newGUID] forKey:(__bridge id)kSecAttrAccount];
        value = [keyChain objectForKey:(__bridge id)kSecAttrAccount];
    }
    
    return value;
}

-(NSString*) newGUID {
    
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString); return result;
}

@end
