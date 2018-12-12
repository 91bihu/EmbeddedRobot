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
@interface RootViewController ()<WKNavigationDelegate,WKScriptMessageHandler,UIScrollViewDelegate>

@property(nonatomic,strong) WKWebView *webView;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"机器人内嵌";
    
    UIButton *saveButton=[UIButton buttonWithType:(UIButtonTypeSystem)];
    // xiaoxi_weidu
    [saveButton setTitle:@"报价单" forState:UIControlStateNormal];
    
    [saveButton addTarget:self action:@selector(buttonPress) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setTintColor:[UIColor blackColor]];
    
    saveButton.frame=CGRectMake(0, 0, 60, 30);
    UIBarButtonItem *navRightButton = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
    [navRightButton setTintColor:[UIColor blackColor]];
    self.navigationItem.rightBarButtonItem = navRightButton;
    
    
    UIButton *leftButton=[UIButton buttonWithType:(UIButtonTypeCustom)];
    // xiaoxi_weidu
    [leftButton setTitle:@"清除" forState:UIControlStateNormal];
    
    [leftButton addTarget:self action:@selector(leftButton) forControlEvents:UIControlEventTouchUpInside];
    leftButton.frame=CGRectMake(0, 0, 40, 30);
    UIBarButtonItem *navLeftButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = navLeftButton;
    
    
    
    // 禁止选择CSS
    NSString *css = @"body{-webkit-user-select:none;-webkit-user-drag:none;}";
    
    // CSS选中样式取消
    NSMutableString *javascript = [NSMutableString string];
    [javascript appendString:@"var style = document.createElement('style');"];
    [javascript appendString:@"style.type = 'text/css';"];
    [javascript appendFormat:@"var cssContent = document.createTextNode('%@');", css];
    [javascript appendString:@"style.appendChild(cssContent);"];
    [javascript appendString:@"document.body.appendChild(style);"];
    
    // javascript注入
    WKUserScript *noneSelectScript = [[WKUserScript alloc] initWithSource:javascript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    
    WKUserContentController* userContent = [[WKUserContentController alloc] init];
    // 添加消息处理，注意：self指代的对象需要遵守WKScriptMessageHandler协议，结束时需要移除
    [userContent addUserScript:noneSelectScript];
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.userContentController = userContent;
    // 创建UserContentController（提供JavaScript向webView发送消息的方法）
    
    
    // 将UserConttentController设置到配置文件
    config.userContentController = userContent;
    
    _webView=[[WKWebView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) configuration:config];
    _webView.navigationDelegate=self;
    [self.view addSubview:_webView];
    
     if ([BHAPIBase getToken].length != 0) {
         _tokenString =[BHAPIBase getToken];
     }
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://wx.91bihu.com/home/index?token=%@",_tokenString]];//创建URL
    
    UserData * data = [UserData new];
    NSDictionary * properties = [[NSMutableDictionary alloc] init];
    NSString * userName = [NSString stringWithFormat:@"agentAccount_%@",data.topAgentId];
    NSString * loginStatus = [NSString stringWithFormat:@"s_LoginStatus_%@",data.topAgentId];
    NSString * agentId = [NSString stringWithFormat:@"agent_%@",data.topAgentId];
    NSString * RepeatQuote = [NSString stringWithFormat:@"isHavaLicenseno_%@",data.agentId];
    NSString * token = [NSString stringWithFormat:@"tx_login_token_%@",data.topAgentId];
    NSString * agentName = [NSString stringWithFormat:@"tx_login_agentname_%@",data.topAgentId];
    [properties setValue:@"fromagent" forKey:@"topAgent"];//kay
    [properties setValue:userName forKey:@"userName"];//value值
    [properties setValue:loginStatus forKey:@"loginStatus"];//kay
    [properties setValue:agentId forKey:@"agentId"];//kay
    [properties setValue:token forKey:@"token"];//kay
    [properties setValue:RepeatQuote forKey:@"RepeatQuote"];//
    [properties setValue:agentName forKey:@"agentName"];//kay
//    [properties setValue:[NSDate dateWithTimeIntervalSinceNow:60*60] forKey:NSHTTPCookieExpires];
    NSHTTPCookie *cookie = [[NSHTTPCookie alloc] initWithProperties:properties];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    [_webView loadRequest:request];//加载
}


- (void)buttonPress{
    

    
    QuotationListViewController *listVc = [[QuotationListViewController alloc] init];
    
    listVc.tokenStr = _tokenString;
    
    [self.navigationController pushViewController:listVc animated:YES];
    
    
}


- (void)leftButton{
    
        NSUserDefaults *defatluts = [NSUserDefaults standardUserDefaults];
        [defatluts removeObjectForKey:@"token"];
        [defatluts synchronize];
    
        BHLoginController *loginVc = [[BHLoginController alloc] init];
        UINavigationController *logNav=[[UINavigationController alloc]initWithRootViewController:loginVc];
        AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
        app.window.rootViewController = logNav;
    
}


#pragma mark -
#pragma mark WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"请稍等...";
    hud.label.font = [UIFont systemFontOfSize:14];
    NSLog(@"页面开始加载");
    
    
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"页面加载完成");

    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}
//加载出错的时间调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
 
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSLog(@"%@", @"页面加载出错！");
}


- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
}


-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    //打电话
    NSURL *URL = navigationAction.request.URL;
    NSString *scheme = [URL scheme];
    if(webView != _webView) {
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }
    UIApplication *app = [UIApplication sharedApplication];
    if ([scheme isEqualToString:@"tel"])
    {
        if ([app canOpenURL:URL])
        {
            [app openURL:URL];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
