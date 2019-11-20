//
//  CYNativeApi.h
//  CYWebJS
//
//  Created by kim on 2019/11/20.
//  Copyright © 2019年 Cralyon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CYNavtiveApiDelegate <JSExport>

- (BOOL)getBooleanValue;

- (NSString *)getStrValue;

@end

@interface CYNativeApi : NSObject<CYNavtiveApiDelegate>

+ (void)configureWithWebView:(UIWebView *)webView andJSObject:(NSString *)jsObj;

@end

NS_ASSUME_NONNULL_END
