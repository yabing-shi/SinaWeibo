//
//  XSCommonWebViewController.m
//  XiangshangV2
//
//  Created by Edward on 14-1-24.
//  Copyright (c) 2014年 Beijing Zendai Up Network Technology co., LTD. All rights reserved.
//

#import "XSCommonWebViewController.h"

@interface XSCommonWebViewController ()

@end

@implementation XSCommonWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"娱乐新闻";
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 40, 30);
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.navigationItem.leftBarButtonItem = item;

    
    
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
    [self.view addSubview:webView];
}
- (void)clickAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
