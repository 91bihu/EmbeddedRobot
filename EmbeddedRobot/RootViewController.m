//
//  RootViewController.m
//  EmbeddedRobot
//
//  Created by bihu_Mac on 2017/6/23.
//  Copyright © 2017年 initial. All rights reserved.
//
#import "UserData.h"
#import "RootViewController.h"
#import <WebKit/WebKit.h>
#import "MBProgressHUD.h"
#import "BHAPIBase.h"
#import "BHLoginController.h"
#import "AppDelegate.h"
#import "QuotationListViewController.h"
static NSString *const  GoLogin = @"goLogin";
static NSString *const GoHome = @"goHome";

@interface RootViewController ()<WKNavigationDelegate,WKScriptMessageHandler,WKUIDelegate>

@property(nonatomic,strong) WKWebView *webView;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"预约爱推修";
    UIButton *backButton=[UIButton buttonWithType:(UIButtonTypeSystem)];
    // xiaoxi_weidu
    [backButton setImage:[UIImage imageNamed:@"leftArrow"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(leftButton) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTintColor:[UIColor blackColor]];
    backButton.frame=CGRectMake(0, 0, 40, 30);
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [leftBarButton setTintColor:[UIColor blackColor]];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    UserData * data = [UserData sharedUserData];
    NSURL * url = [NSURL URLWithString:@"http://192.168.5.19:7776"];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    NSMutableString *cookieValue = [NSMutableString stringWithFormat:@""];
    NSMutableDictionary * properties = [[NSMutableDictionary alloc] init];
    NSString * userName = [NSString stringWithFormat:@"agentAccount_%@",data.user.topAgentId];
    NSString * loginStatus = [NSString stringWithFormat:@"s_LoginStatus_%@",data.user.topAgentId];
    NSString * agentId = [NSString stringWithFormat:@"agent_%@",data.user.topAgentId];
    NSString * RepeatQuote = [NSString stringWithFormat:@"isHavaLicenseno_%@",data.user.agentId];
    NSString * token = [NSString stringWithFormat:@"tx_login_token_%@",data.user.topAgentId];
    NSString * agentName = [NSString stringWithFormat:@"tx_login_agentname_%@",data.user.topAgentId];
    NSString * s_token = [NSString stringWithFormat:@"s_token_%@",data.user.topAgentId];
    if (data.user.token.length>1){
        [properties setObject:data.user.topAgentId forKey:@"fromagent"];//
    }
        [properties setObject:data.user.userName forKey:userName];//
        [properties setObject:data.user.loginStatus forKey:loginStatus];//
        [properties setObject:data.user.agentId forKey:agentId];//
        [properties setObject:data.user.token forKey:token];//
        [properties setObject:data.user.RepeatQuote forKey:RepeatQuote];//
        [properties setObject:data.user.agentName forKey:agentName];//
        [properties setObject:data.user.token forKey:s_token];//
        [properties enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSString * appendString = [NSString stringWithFormat:@"document.cookie ='%@=%@';", key, obj];
            [cookieValue appendString:appendString];
        }];
    WKWebViewConfiguration * webConfig = [[WKWebViewConfiguration alloc] init];
    webConfig.preferences = [[WKPreferences alloc] init];
    // 默认为0
    webConfig.preferences.minimumFontSize = 10;
    // 默认认为YES
    webConfig.preferences.javaScriptEnabled = YES;
    // 在iOS上默认为NO，表示不能自动通过窗口打开
    webConfig.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    // web内容处理池
    webConfig.processPool = [[WKProcessPool alloc] init];
    WKUserContentController * userContentController = WKUserContentController.new;
    WKUserScript * cookieScript = [[WKUserScript alloc]
                                   initWithSource: cookieValue
                                   injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    [userContentController addUserScript:cookieScript];

    [userContentController addScriptMessageHandler:self name:GoLogin];
    [userContentController addScriptMessageHandler:self name:GoHome];
    webConfig.userContentController = userContentController;
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) configuration:webConfig];

    [self.view addSubview:_webView];
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    [_webView loadRequest:request];//加载
}

- (void)leftButton{
    if ([_webView canGoBack]) {
        [_webView evaluateJavaScript:@"goBack ()" completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        }];
    }
    else{
        [self backToLogin];
    }
}

- (void)openNewWindows{
    RootViewController *loginVc = [[RootViewController alloc] init];
    UINavigationController *logNav=[[UINavigationController alloc]initWithRootViewController:loginVc];
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    app.window.rootViewController = logNav;
}
- (void)backToLogin{
    UserData * data = [UserData sharedUserData];
    data.user = nil;
    [data savedata];
    if (self.navigationController.viewControllers.count>1){
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        BHLoginController *loginVc = [[BHLoginController alloc] init];
        UINavigationController *logNav=[[UINavigationController alloc]initWithRootViewController:loginVc];
        AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
        app.window.rootViewController = logNav;
    }
}
#pragma mark WKNavigationDelegate
//// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{

}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"页面加载完成");

//    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}


//加载出错的时间调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
//     [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSLog(@"%@", @"页面加载出错！");
}


- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{

    completionHandler();
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler
{
    completionHandler(NO);
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    if ([message.name isEqualToString:GoLogin]) {
        [self backToLogin];
    }
    if ([message.name isEqualToString:GoHome]) {
        [self openNewWindows];
    }
}


-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {

    decisionHandler(WKNavigationActionPolicyAllow);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [_webView.configuration.userContentController removeScriptMessageHandlerForName:@""];
    [_webView.configuration.userContentController removeScriptMessageHandlerForName:@""];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
