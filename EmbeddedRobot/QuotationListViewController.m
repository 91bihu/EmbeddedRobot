//
//  QuotationListViewController.m
//  EmbeddedRobot
//
//  Created by bihu_Mac on 2017/6/29.
//  Copyright © 2017年 initial. All rights reserved.
//

#import "QuotationListViewController.h"
#import <WebKit/WebKit.h>
#import "MBProgressHUD.h"
#import "BHAPIBase.h"
@interface QuotationListViewController ()<WKNavigationDelegate,WKScriptMessageHandler,UIScrollViewDelegate>

@property(nonatomic,strong) WKWebView *webView;
@end

@implementation QuotationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"报价单";
    
    
    
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
        _tokenStr =[BHAPIBase getToken];
    }
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.5.19:7777/quote/myquote?token=%@",_tokenStr]];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    [_webView loadRequest:request];//加载
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


@end
