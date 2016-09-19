//
//  WeiboTableView.m
//  WXWeibo
//
//  Created by liuwei on 15/10/12.
//  Copyright (c) 2015年 wxhl. All rights reserved.
//

#import "WeiboTableView.h"
#import "WeiboCell.h"
#import "DetailViewController.h"
#import "UIView+Controller.h"

@implementation WeiboTableView

- (void)setStatusList:(NSArray *)statusList{
    _statusList = statusList;
    [self reloadData];
}

- (void)awakeFromNib{
    
    //指定代理,数据源
    self.delegate = self;
    self.dataSource = self;
    
    self.backgroundColor = [UIColor clearColor];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _statusList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

     WeiboCell *cell = [tableView dequeueReusableCellWithIdentifier:@"weiboCell" forIndexPath:indexPath];
    
    cell.layout = _statusList[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //取得布局对象
    WeiboContentViewLayout *layout = _statusList[indexPath.row];
    
    return layout.frame.size.height + 70;
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    WeiboContentViewLayout *layout = _statusList[indexPath.row];
    
    //跳转到详情页
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    DetailViewController *detailCtrl = [storyBoard instantiateViewControllerWithIdentifier:@"detailCtrl"];
    detailCtrl.hidesBottomBarWhenPushed = YES;
    
    //将微博数据交给详情页
    detailCtrl.status = layout.status;
    
    [self.viewController.navigationController pushViewController:detailCtrl animated:YES];
    
}
@end
