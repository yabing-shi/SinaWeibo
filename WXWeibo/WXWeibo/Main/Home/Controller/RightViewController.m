//
//  RightViewController.m
//  WXWeibo
//
//  Created by liuwei on 15/10/17.
//  Copyright (c) 2015年 wxhl. All rights reserved.
//

#import "RightViewController.h"
#import "ThemeButton.h"
#import "SendViewController.h"
#import "WXNavViewController.h"

@implementation RightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    for (NSInteger i = 0; i < 5; i ++) {
        ThemeButton *btn = [ThemeButton buttonWithType:UIButtonTypeCustom];
        btn.imageName = [NSString stringWithFormat:@"newbar_icon_%ld.png",i + 1];
        btn.tag = i;
        btn.frame = CGRectMake(100 - 40 - 20, 50 * i + 60, 40, 40);
        [btn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
}

- (void)clickAction:(UIButton *)btn{
    if (btn.tag == 0) {
        SendViewController *ctrl = [[SendViewController alloc] init];
        WXNavViewController *nav = [[WXNavViewController alloc] initWithRootViewController:ctrl];
        [self presentViewController:nav animated:YES completion:NULL];
    }else if (btn.tag == 1){
    
    }else if (btn.tag == 2){
        
    }else if (btn.tag == 3){
        
    }else if (btn.tag == 4){
        
    }else if (btn.tag == 5){
        
    }

}

@end
