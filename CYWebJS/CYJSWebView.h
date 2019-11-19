//
//  CYWebView.h
//  CYWebJS
//
//  Created by kim on 2019/11/19.
//  Copyright © 2019年 Cralyon. All rights reserved.
//

#import <WebKit/WebKit.h>

@protocol CYJSWebViewDelegate <NSObject>

///页面加载完成后调用
- (void)JSWebView:(WKWebView *)webView DidFinishNavigation:(WKNavigation *)navigation;

///发送请求前，是否跳转 一定要实现 decisionHandler(allow/cancle) 否则崩溃
- (void)JSWebView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler;

@optional
///js调用原生方法的回调
- (void)JSWebView:(WKWebView *)webView JSActionsWithMSG:(WKScriptMessage *)msg;

@end

@interface CYJSWebView : WKWebView

@property (nonatomic, weak) id<CYJSWebViewDelegate>webDelegate;

@property (nonatomic, copy) NSString *i_urlStr;

- (instancetype)initWithFrame:(CGRect)frame UrlStr:(NSString *)urlStr;

///注册监听的js方法
- (void)cyw_registerFunc:(NSArray <NSString *>*)funcNameArray;

/**
 调用js方法
 
 @param funcName 方法名 不准带括号
 @param param 入参
 @param isJsonStr 是否传json字符串、否则传json对象
 */
- (void)cyw_runJSFuncWithFuncName:(NSString *)funcName Param:(NSDictionary *)param IsJsonStr:(BOOL)isJsonStr;

@end
