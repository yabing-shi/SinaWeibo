//
//  MoreViewController.m
//  WXWeibo
//
//  Created by liuwei on 15/10/9.
//  Copyright (c) 2015年 wxhl. All rights reserved.
//

#import "MoreViewController.h"
#import "MoreCell.h"
#import "ThemeManager.h"
#import "ThemeController.h"
#import "loginViewController.h"

static NSString *indenty = @"moreCell";

@interface MoreViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MoreViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //注册单元格
    [_tableView registerClass:[MoreCell class] forCellReuseIdentifier:indenty];
    _tableView.backgroundColor = [UIColor clearColor];
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    //刷新表视图
    [_tableView reloadData];

}

#pragma mark -UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 2;
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    MoreCell *cell = [tableView dequeueReusableCellWithIdentifier:indenty forIndexPath:indexPath];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        cell.imgView.imageName = @"more_icon_theme.png";
        cell.titleLable.text = @"主题选择";
        ThemeManager *manager = [ThemeManager shareManager];
        cell.themeNameLable.text = manager.themeName;
    

    }else if (indexPath.section == 0 && indexPath.row == 1){
    
        cell.imgView.imageName = @"more_icon_account.png";
        cell.titleLable.text = @"账户管理";
    
    }else if (indexPath.section == 1){
    
        cell.imgView.imageName = @"more_icon_feedback.png";
        cell.titleLable.text = @"意见反馈";

    }else if (indexPath.section == 2){
    
        cell.imgView.hidden = YES;
        cell.titleLable.frame = CGRectMake((kScreenWidth - 200) / 2, 7, 200, 30);
        cell.titleLable.text = @"登出当前账号";
        cell.titleLable.textAlignment = NSTextAlignmentCenter;

    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 && indexPath.row == 0) {
     
        //故事版对象
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"More" bundle:nil];
        //获取到故事版中的控制器
        UIViewController *ctrl = [story instantiateViewControllerWithIdentifier:@"themeCtrl"];
        ctrl.hidesBottomBarWhenPushed = YES;
        //push
        [self.navigationController pushViewController:ctrl animated:YES];
        
    }else if (indexPath.section == 2){
        NSLog(@"logout");
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"SinaWeiboAuthData"];
        [self.navigationController presentModalViewController:[[loginViewController alloc]init] animated:YES];
    }

    //取消单元格的选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
