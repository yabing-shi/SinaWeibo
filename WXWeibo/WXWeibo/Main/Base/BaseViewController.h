//
//  BaseViewController.h
//  WXWeibo
//
//  Created by liuwei on 15/10/9.
//  Copyright (c) 2015年 wxhl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController


//加载提示
- (void)showLoading:(BOOL)show;

- (void)showHUDLoading;

- (void)hideHUDLoading;


- (void)showCompleteView:(NSString *)tip;
@end
