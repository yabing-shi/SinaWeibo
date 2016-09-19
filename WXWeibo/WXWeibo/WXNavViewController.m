//
//  WXNavViewController.m
//  WXWeibo
//
//  Created by liuwei on 15/10/9.
//  Copyright (c) 2015年 wxhl. All rights reserved.
//

#import "WXNavViewController.h"
#import "ThemeManager.h"

@interface WXNavViewController ()<UIGestureRecognizerDelegate>

@end

@implementation WXNavViewController

- (void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeChangeNotification object:nil];

}

//如果控制器是从故事版加载的,initWithCoder会被调用
- (id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        //监听主题切换通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadTheme) name:kThemeChangeNotification object:nil];
        
    }
    return self;

}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    //解决手势返回失效
    self.interactivePopGestureRecognizer.delegate = self;
    
    NSLog(@"%@",self.interactivePopGestureRecognizer);
    
    [self loadTheme];
}

- (void)loadTheme{

    //1.取得主题对应的图片
    UIImage *img = [[ThemeManager shareManager] getThemeImageWithImageName:@"mask_titlebar64.png"];
    [self.navigationBar setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
    //2.取得主题对应的颜色
    UIColor *color = [[ThemeManager shareManager] getThemeColorWithFontName:@"Mask_Title_color"];
    
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : color};

}

@end
