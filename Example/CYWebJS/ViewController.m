//
//  ViewController.m
//  CYWebJS
//
//  Created by kim on 2019/11/19.
//  Copyright © 2019年 Cralyon. All rights reserved.
//

#import "ViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "CYNativeApi.h"

@interface ViewController ()

@property (nonatomic, strong) JSContext *context;

@end

@implementation ViewController

- (void)showUserInfo {
    [self cy_runJSCriptWithFunc:@"userInfoCallBack" Param:@{@"name":@"张三",@"sex":@"未知"} IsJsonStr:NO];
}

- (void)viewDidLoad {
//    self.i_urlStr = @"http://www.baidu.com"; 加载线上网页
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"查看用户信息" style:(UIBarButtonItemStylePlain) target:self action:@selector(showUserInfo)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)setupSubView {
    [super setupSubView];
    ///本地测试
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"a" ofType:@"html"];
    NSURL *baseURL=[[NSBundle mainBundle]bundleURL];
    [self cy_loadLocalHTML:baseURL withFilePath:filePath];

    __weak __typeof__(self) weakSelf = self;
    [self cy_registerFunc:@{@"getMobile":^(id obj) {
        [weakSelf cy_runJSCriptWithFunc:@"mobileCallBack" Param:@{@"phone":@(10086)} IsJsonStr:NO];
    }}];
    
}

@end
