//
//  loginViewController.m
//  WXWeibo
//
//  Created by shiyabing on 16/4/21.
//  Copyright © 2016年 wxhl. All rights reserved.
//

#import "loginViewController.h"
#import "MainViewController.h"
#import "MMDrawerController.h"
#import "RightViewController.h"
#import "UMSocial.h"

@interface loginViewController ()

@end

@implementation loginViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake((kScreenWidth - 120)/2, 120, 120, 30)];
    [button setTitle:@"Sina微博登录" forState:UIControlStateNormal];
    [button setTag:10];
    [button setBackgroundColor:[UIColor clearColor]];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

}

- (void)click:(UIButton *)btn{
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

    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
            //                NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            [[NSUserDefaults standardUserDefaults] setObject:snsAccount.accessToken forKey:@"SinaWeiboAuthData"];
            [UIApplication sharedApplication].delegate.window.rootViewController = drawerCtrl;
        }
    });

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
