//
//  CommentMeController.m
//  WXWeibo
//
//  Created by shiyabing on 16/5/9.
//  Copyright © 2016年 wxhl. All rights reserved.
//

#import "CommentMeController.h"

@interface CommentMeController ()

@end

@implementation CommentMeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"评论我的";
    
    
    UILabel *label= [[UILabel alloc]initWithFrame:CGRectMake(10, 300, ([UIScreen mainScreen].bounds.size.width - 20) / 2, 20)];
    label.text = @"您还没有收到评论~~";
    [label sizeToFit];
    label.mj_x = (kScreenWidth - label.width) / 2;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textColor = [UIColor lightGrayColor];
    [self.view addSubview:label];

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
