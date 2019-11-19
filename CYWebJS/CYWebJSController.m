//
//  CYWebJSController.m
//  CYWebJS
//
//  Created by kim on 2019/11/19.
//  Copyright © 2019年 Cralyon. All rights reserved.
//

#import "CYWebJSController.h"
#import "CYJSWebView.h"

@interface CYWebJSController ()<CYJSWebViewDelegate>

@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic, strong) CYJSWebView *webView;

@property (nonatomic, strong) NSDictionary *jsFuncDict;

@end

@implementation CYWebJSController

- (void)cy_loadLocalHTML:(NSURL *)baseUrl withFilePath:(nonnull NSString *)filePath {
    
    [self.webView loadHTMLString:[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil] baseURL:baseUrl];
}

- (BOOL)cy_isWebLoading {
    return self.webView.isLoading;
}

- (void)cy_webGoBack {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)cy_webReload {
    NSURL *url = self.webView.URL;
    [self.webView loadHTMLString:@"" baseURL:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.webView loadRequest:[NSURLRequest requestWithURL:url cachePolicy:(NSURLRequestReloadIgnoringLocalAndRemoteCacheData) timeoutInterval:20]];
    });
}

- (void)cy_webAddHeaderRefresh {
    ///暂时废弃
//    __weak __typeof__(self) weakSelf = self;
//    [self.webView.scrollView cy_addHeaderRefresh:^{
//        [weakSelf.webView reload];
//    }];
}

- (void)cy_runJSCriptWithFunc:(NSString *)funcName Param:(NSDictionary *)param IsJsonStr:(BOOL)isJsonStr {
    [self.webView cyw_runJSFuncWithFuncName:funcName Param:param IsJsonStr:isJsonStr];
}

- (void)cy_registerFunc:(NSDictionary *)jsFuncDict {
    self.jsFuncDict = jsFuncDict;
    [self.webView cyw_registerFunc:jsFuncDict.allKeys];
}

- (void)cy_webView:(WKWebView *)webView didFinishNavigation:(WKNavigation*)navigation{}

- (void)cy_webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark - CYJSWebViewDelegate
- (void)JSWebView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    [self cy_webView:webView decidePolicyForNavigationAction:navigationAction decisionHandler:decisionHandler];
}

- (void)JSWebView:(WKWebView *)webView DidFinishNavigation:(WKNavigation *)navigation {
    [self cy_webView:webView didFinishNavigation:navigation];
}

- (void)JSWebView:(WKWebView *)webView JSActionsWithMSG:(WKScriptMessage *)msg {
    if ([msg.name isKindOfClass:[NSNull class]] || !msg.name) return;
    void (^actionBlock)(id obj) = self.jsFuncDict[msg.name];
    if (actionBlock) {
        actionBlock(msg.body);
    }
}

#pragma mark - UI life
- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"title"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubView];
}

- (void)setupSubView {
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    //配置信息
    self.webView = [[CYJSWebView alloc] initWithFrame:CGRectMake(0, 0, screenW, [UIScreen mainScreen].bounds.size.height) UrlStr:self.i_urlStr ?: @""];
    self.webView.webDelegate = self;
    [self.view addSubview:self.webView];
    
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, screenW, 8.0)];
    self.progressView.progressTintColor = UIColor.greenColor;
    self.progressView.trackTintColor = UIColor.whiteColor;
    [self.webView addSubview:self.progressView];
}

#pragma mark - observe
///加载进度监听
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (object != self.webView) return;
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        [self.progressView setAlpha:1.0f];
        [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
        if (self.webView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:YES];
            }];
        }
    } else if ([keyPath isEqualToString:@"title"]){
        if (!self.isGetCurrentNavTitle) return;
        self.navigationItem.title = self.webView.title;
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - lazy
- (NSDictionary *)jsFuncDict {
    if (!_jsFuncDict) {
        _jsFuncDict = [NSDictionary dictionary];
    }
    return _jsFuncDict;
}

@end
