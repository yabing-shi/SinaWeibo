//
//  ThemeController.m
//  WXWeibo
//
//  Created by liuwei on 15/10/10.
//  Copyright (c) 2015年 wxhl. All rights reserved.
//

#import "ThemeController.h"
#import "ThemeManager.h"

@interface ThemeController ()

@property (nonatomic,strong)NSArray *themeNames;

@end

static NSString *identy = @"ThemeCell";

@implementation ThemeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identy];
    
    ThemeManager *manager = [ThemeManager shareManager];

    //取到主题配置字典中所有的key
    _themeNames = [manager.themeDic allKeys];
    
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _themeNames.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identy forIndexPath:indexPath];
    cell.textLabel.text = _themeNames[indexPath.row];
    
    ThemeManager *manager = [ThemeManager shareManager];
    
    //如果是当前被选择的主题,则显示对勾
    if ([manager.themeName isEqualToString:_themeNames[indexPath.row]]) {
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
    }else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ThemeManager *manager = [ThemeManager shareManager];
    
    //更改主题
    manager.themeName = _themeNames[indexPath.row];
    
    //刷新表视图
    [tableView reloadData];
}


@end
