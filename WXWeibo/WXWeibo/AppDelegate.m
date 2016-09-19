//
//  AppDelegate.m
//  WXWeibo
//
//  Created by liuwei on 15/10/9.
//  Copyright (c) 2015年 wxhl. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "Common.h"
#import "UMSocial.h"
#import "loginViewController.h"
#import "MMDrawerController.h"
#import "RightViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

//
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window = window;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"SinaWeiboAuthData"];
    if ([token isKindOfClass:[NSString class]]) {
        //创建右侧侧控制器
        RightViewController *right = [[RightViewController alloc] init];
        
        //创建中间的控制器
        MainViewController *center = [[MainViewController alloc] init];
        
        MMDrawerController *drawerCtrl = [[MMDrawerController alloc] initWithCenterViewController:center leftDrawerViewController:nil rightDrawerViewController:right];
        
        //取消阴影
        [drawerCtrl setShowsShadow:YES];
        
        //设置右侧显示的宽度
        [drawerCtrl setMaximumRightDrawerWidth:100];
        [drawerCtrl setMaximumLeftDrawerWidth:100];
        
        //设置打开的区域
        [drawerCtrl setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
        
        //设置关闭的区域
        [drawerCtrl setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
        self.window.rootViewController = drawerCtrl;
    }else{
        //设置窗口的根控制器
        self.window.rootViewController = [[loginViewController alloc]init];
    }
    
    [UMSocialData setAppKey:@"56a19f8be0f55ab0cc0001a1"];

    return YES;
}


@end
