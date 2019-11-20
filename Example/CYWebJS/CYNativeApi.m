//
//  CYNativeApi.m
//  CYWebJS
//
//  Created by kim on 2019/11/20.
//  Copyright © 2019年 Cralyon. All rights reserved.
//

#import "CYNativeApi.h"

@implementation CYNativeApi

+ (void)configureWithWebView:(UIWebView *)webView andJSObject:(NSString *)jsObj {
    JSContext *jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    CYNativeApi *nativeObj = [CYNativeApi new];
    jsContext[jsObj] = nativeObj;
}

- (BOOL)getBooleanValue {
    return YES;
}

- (NSString *)getStrValue {
    return @"挖哈哈哈哈";
}

@end
