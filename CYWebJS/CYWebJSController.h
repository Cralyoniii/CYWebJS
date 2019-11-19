//
//  CYWebJSController.h
//  CYWebJS
//
//  Created by kim on 2019/11/19.
//  Copyright © 2019年 Cralyon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CYWebJSController : UIViewController

@property (nonatomic,   copy) NSString *i_urlStr;

@property (nonatomic, assign) BOOL isGetCurrentNavTitle;

- (void)setupSubView;

- (void)cy_loadLocalHTML:(NSURL *)baseUrl withFilePath:(NSString *)filePath;

///web 是否正在加载
- (BOOL)cy_isWebLoading;

///web 返回
- (void)cy_webGoBack;

///web 刷新
- (void)cy_webAddHeaderRefresh;

///web 重新加载
- (void)cy_webReload;

///注册监听的js方法 {funcName:block(id obj)}
- (void)cy_registerFunc:(NSDictionary *)jsFuncDict;

/**
 运行js方法
 
 @param funcName js方法名 例如：test 不准带括号
 @param param 方法参数
 */
- (void)cy_runJSCriptWithFunc:(NSString *)funcName Param:(NSDictionary *)param IsJsonStr:(BOOL)isJsonStr;

///加载完成后调用
- (void)cy_webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation;

///发送请求前，判断是否跳转
- (void)cy_webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler;

@end

NS_ASSUME_NONNULL_END
