//
//  MessageViewController.m
//  WXWeibo
//
//  Created by liuwei on 15/10/9.
//  Copyright (c) 2015年 wxhl. All rights reserved.
//

#import "MessageViewController.h"
#import "FacePannel.h"
#import "MessageCell.h"
#import "PointMeController.h"
#import "CommentMeController.h"
#import "ZanMeViewController.h"

@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
   
    [self creatSubViews];
}


- (void)creatSubViews{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerClass:[MessageCell class] forCellReuseIdentifier:@"MESSAGECELL"];
    self.tableView.dataSource      = self;
    self.tableView.delegate        = self;

    
    [self.view addSubview:self.tableView];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MESSAGECELL" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.titleLabel.text = @"@我的";
        cell.iconView.image = [UIImage imageNamed:@"awo"];
    }else if (indexPath.row == 1){
        cell.titleLabel.text = @"评论";
        cell.iconView.image = [UIImage imageNamed:@"message"];
    }else if (indexPath.row == 2){
        cell.titleLabel.text = @"赞";
        cell.iconView.image = [UIImage imageNamed:@"good"];
    }else if (indexPath.row == 3){
        cell.titleLabel.text = @"私信";
        cell.iconView.image = [UIImage imageNamed:@"persionMessage"];
    }else if (indexPath.row == 4){
        cell.titleLabel.text = @"新浪新闻";
        cell.iconView.image = [UIImage imageNamed:@"sina"];
    }else if (indexPath.row == 5){
        cell.titleLabel.text = @"订阅消息";
        cell.iconView.image = [UIImage imageNamed:@"guanzhu"];
    }
    

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        PointMeController *pointCtrl = [[PointMeController alloc]init];
        pointCtrl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:pointCtrl animated:YES];
    }else if (indexPath.row == 1){
        CommentMeController *commentCtrl = [[CommentMeController alloc]init];
        commentCtrl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:commentCtrl animated:YES];
    }else if (indexPath.row == 2){
        ZanMeViewController *zanCtrl = [[ZanMeViewController alloc]init];
        zanCtrl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:zanCtrl animated:YES];
    }else if (indexPath.row == 3){
        
    }else if (indexPath.row == 4){
        
    }
}

@end
