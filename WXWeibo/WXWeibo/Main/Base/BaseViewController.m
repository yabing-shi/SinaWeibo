//
//  BaseViewController.m
//  WXWeibo
//
//  Created by liuwei on 15/10/9.
//  Copyright (c) 2015年 wxhl. All rights reserved.
//

#import "BaseViewController.h"
#import "ThemeManager.h"
#import "MBProgressHUD.h"

@interface BaseViewController ()

@property (nonatomic,strong)UIView *tipView;
@property (nonatomic,strong)MBProgressHUD *hud;

@end

@implementation BaseViewController

- (id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    
    if (self){
        
        //监听主题切换通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadImg) name:kThemeChangeNotification object:nil];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadImg];
}

- (void)showCompleteView:(NSString *)tip {

    //显示微博发送成功视图,应该在窗口上显示
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hub.customView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] ;
    hub.mode = MBProgressHUDModeCustomView;
    hub.labelText = tip;
    //延迟隐藏
    [hub hide:YES afterDelay:1.2];

}


- (void)loadImg{

    UIImage *img = [[ThemeManager shareManager] getThemeImageWithImageName:@"bg_home.jpg"];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:img];
}
- (void)showLoading:(BOOL)show {
    
    if (_tipView == nil) {
        _tipView = [[UIView alloc] initWithFrame:CGRectMake(0, (kScreenHeight - 40) / 2, kScreenWidth, 40)];
        _tipView.hidden = YES;
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [activityView startAnimating];
        [_tipView addSubview:activityView];
        
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectZero];
        lable.text = @"正在加载...";
        [lable sizeToFit];
        lable.left = (kScreenWidth - lable.width) / 2;
        [_tipView addSubview:lable];
        activityView.right = lable.left - 5;

        [self.view addSubview:_tipView];
    }
    
    if (show) {
        
        _tipView.hidden = NO;
        
    }else {
    
        [_tipView removeFromSuperview];
        _tipView = nil;
    }

}
- (void)showHUDLoading {
    _hud = [[MBProgressHUD alloc] initWithView:self.view];
    _hud.labelText = @"正在加载...";
    _hud.dimBackground = YES;
    [self.view addSubview:_hud];
    [_hud show:YES];
}
- (void)hideHUDLoading {
    [_hud hide:YES];
}

@end
