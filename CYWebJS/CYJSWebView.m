//
//  CYWebView.m
//  CYWebJS
//
//  Created by kim on 2019/11/19.
//  Copyright © 2019年 Cralyon. All rights reserved.
//

#import "CYJSWebView.h"

@interface CYJSWebView () <WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>

@end

@implementation CYJSWebView
#pragma mark - action
///注册交互的js方法
- (void)cyw_registerFunc:(NSArray<NSString *> *)funcNameArray {
    for (NSString *funcName in funcNameArray) {
        [self.configuration.userContentController addScriptMessageHandler:self name:funcName];
    }
}

///调用js方法
- (void)cyw_runJSFuncWithFuncName:(NSString *)funcName Param:(NSDictionary *)param IsJsonStr:(BOOL)isJsonStr {
    if (!funcName || [funcName isKindOfClass:[NSNull class]]) {
#ifdef DEBUG
        NSLog(@"JS方法名无效，请稍后再试");
#endif
        return;
    }
    NSString *jsStr = funcName;
    if (param && param.allValues.count > 0) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:0 error:&error];
        NSString *paramJsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSMutableString *mutStr = [NSMutableString stringWithString:paramJsonStr];
        NSRange range = {0,paramJsonStr.length};
        //去掉字符串中的空格
        [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
        NSRange range2 = {0,mutStr.length};
        //去掉字符串中的换行符
        [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
        if (isJsonStr) {
            jsStr = [jsStr stringByAppendingFormat:@"('%@')",mutStr];
        } else {
            jsStr = [jsStr stringByAppendingFormat:@"(%@)",mutStr];
        }
    } else {
        jsStr = [jsStr stringByAppendingString:@"()"];
    }
    [self evaluateJavaScript:jsStr completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
        if (!error) return;
#ifdef DEBUG
        NSLog(@"%@", error);
#endif
    }];
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
#ifdef DEBUG
    NSLog(@"\njs唤起原生 \n方法名：%@，\n参数：%@",message.name,message.body);
#endif
    if ([self.webDelegate respondsToSelector:@selector(JSWebView:JSActionsWithMSG:)]) {
        [self.webDelegate JSWebView:self JSActionsWithMSG:message];
        
    }
}

#pragma mark - UI life
- (void)dealloc {
    [self.configuration.userContentController removeAllUserScripts];
    [self setNavigationDelegate:nil];
    [self setUIDelegate:nil];
}

- (instancetype)initWithFrame:(CGRect)frame UrlStr:(NSString *)urlStr {
    self = [super initWithFrame:frame configuration:[[WKWebViewConfiguration alloc]init]];
    if (self) {
        self.i_urlStr = urlStr;
        [self setupWebView];
    }
    return self;
}

- (void)setupWebView {
    //配置信息
    self.UIDelegate         = self;
    self.navigationDelegate = self;
    
    //设置UA
    NSDate *date                = [NSDate date];
    NSTimeInterval interval     = date.timeIntervalSince1970;
    unsigned long long ti       = interval * 1000;
    NSNumber *timeInterval      = [NSNumber numberWithUnsignedLongLong:ti];
    NSString *bundleName        =  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    NSString *userAgent         = [NSString stringWithFormat:@"%@_iOS_Safari_WKWebKit_%@",bundleName, timeInterval];
    self.customUserAgent    = userAgent;
    
    [self loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.i_urlStr]]];
    
}

#pragma mark - WKNavigationDelegate
// 2.页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    //暂时屏蔽刷新功能
//    [self.scrollView CY_endRefreshing];
}

// 5.当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
}
// 6.页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    if ([self.webDelegate respondsToSelector:@selector(JSWebView:DidFinishNavigation:)]) {
        [self.webDelegate JSWebView:webView DidFinishNavigation:navigation];
    }
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
#ifdef DEBUG
    NSLog(@"加载失败");
#endif
//    [self.scrollView CY_endRefreshing];
}

///页面提交数据时发生错误
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
#ifdef DEBUG
    NSLog(@"页面提交数据时发生错误%@",error);
#endif
//    [self.scrollView CY_endRefreshing];
}

// 3.接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    
}
// 4.在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    
    decisionHandler(WKNavigationResponsePolicyAllow);
}
// 1.在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if ([self.webDelegate respondsToSelector:@selector(JSWebView:decidePolicyForNavigationAction:decisionHandler:)]) {
        [self.webDelegate JSWebView:webView decidePolicyForNavigationAction:navigationAction decisionHandler:decisionHandler];
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
#ifdef DEBUG
    NSLog(@"WEB弹框信息:%@",message);
#endif
    completionHandler();
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    //    if(navigationType==UIWebViewNavigationTypeLinkClicked) {///禁用本页点击请求
    //        return NO;
    //    }
    return YES;
}


@end
