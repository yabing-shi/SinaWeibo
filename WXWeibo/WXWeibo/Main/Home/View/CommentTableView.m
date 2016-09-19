//
//  CommentTableView.m
//  WXWeibo
//
//  Created by liuwei on 15/10/16.
//  Copyright (c) 2015年 wxhl. All rights reserved.
//

#import "CommentTableView.h"
#import "WeiboContentViewLayout.h"
#import "WeiboContentView.h"
#import "UIImageView+WebCache.h"
#import "ThemeLable.h"
#import "CommentCell.h"
#import "UIView+Blur.h"
@implementation CommentTableView

- (void)awakeFromNib{

    self.backgroundColor = [UIColor clearColor];
    
    self.dataSource = self;
    self.delegate = self;

}

- (void)setStatus:(StatusModel *)status{
    
    _status = status;
    
    [self _createHeaderView];
 }

//创建头视图
- (void)_createHeaderView{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectZero];
    headerView.backgroundColor = [UIColor clearColor];
    
    UIView *userView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 90)];
    userView.backgroundColor = [UIColor clearColor];
    //1.用户的头像
    UIImageView *userImgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 80, 80)];
    [userImgView sd_setImageWithURL:[NSURL URLWithString:_status.user.avatar_large]];
    
    //圆角
    userImgView.layer.cornerRadius = 40;
    userImgView.layer.masksToBounds = YES;
    //边框
    userImgView.layer.borderColor = [UIColor whiteColor].CGColor;
    userImgView.layer.borderWidth = 2;
    [userView addSubview:userImgView];
    
    //2.用户昵称
    ThemeLable *nickLable = [[ThemeLable alloc] initWithFrame:CGRectMake(userImgView.right + 10, 5, 0, 0)];
    nickLable.font = [UIFont systemFontOfSize:14];
    nickLable.text = _status.user.screen_name;
    nickLable.fontColor = @"Timeline_Name_color";
    [nickLable sizeToFit];
    [userView addSubview:nickLable];
    
    //3.来源
    ThemeLable *sourceLable = [[ThemeLable alloc] initWithFrame:CGRectZero];
    sourceLable.font = [UIFont systemFontOfSize:12];
    sourceLable.text = [NSString stringWithFormat:@"来源:%@",_status.source];
    [sourceLable sizeToFit];
    sourceLable.left = kScreenWidth - sourceLable.width - 10;
    sourceLable.bottom = userImgView.bottom;
    sourceLable.fontColor = @"Timeline_Time_color";
    [userView addSubview:sourceLable];

    //创建布局对象
    WeiboContentViewLayout *layout = [[WeiboContentViewLayout alloc] init];
    layout.isDetail = YES;
    layout.status = _status;
    //创建微博视图
    WeiboContentView *contentView = [[WeiboContentView alloc] initWithFrame:layout.frame];
    
    //布局ContentView的子视图
    contentView.layout = layout;
    contentView.top = userView.bottom;
    
    [headerView addSubview:userView];
    [headerView addSubview:contentView];
    headerView.height = userView.height + contentView.height;
    
    self.tableHeaderView = headerView;
    
}

#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.data.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identify = @"CommentCell";
    
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:identify forIndexPath:indexPath];
    
    cell.commentModel = self.data[indexPath.row];
    
    return cell;
}

//获取组的头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    //1.创建组视图
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 40)];
    sectionHeaderView.backgroundColor = [UIColor colorWithRed:127/255.0 green:127/255.0 blue:127/255.0 alpha:0.7];
    
    //2.评论Label
    UIButton *countBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, (kScreenWidth - 22) / 3, 20)];
    countBtn.backgroundColor = [UIColor clearColor];
    countBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [countBtn addTarget:self action:@selector(commentButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *relayBtn = [[UIButton alloc] initWithFrame:CGRectMake(countBtn.right + 1, 10, (kScreenWidth - 22) / 3, 20)];
    relayBtn.backgroundColor = [UIColor clearColor];
    relayBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [relayBtn addTarget:self action:@selector(relayButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *goodBtn = [[UIButton alloc] initWithFrame:CGRectMake(relayBtn.right + 1, 10, (kScreenWidth - 22) / 3, 20)];
    goodBtn.backgroundColor = [UIColor clearColor];
    goodBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [goodBtn addTarget:self action:@selector(goodButton:) forControlEvents:UIControlEventTouchUpInside];
    
    //3.评论数量
    NSArray *comments = self.commentDic[@"comments"];
    NSNumber *total = @(comments.count);
    int value = [total intValue];
    [countBtn setTitle:[NSString stringWithFormat:@"评论:%d",value] forState:UIControlStateNormal];
    [sectionHeaderView addSubview:countBtn];
    
    NSNumber *total2 = self.status.reposts_count;
    int value2 = [total2 intValue];
    [relayBtn setTitle:[NSString stringWithFormat:@"转发:%d",value2] forState:UIControlStateNormal];
    [sectionHeaderView addSubview:relayBtn];
    
    NSNumber *total3 = self.status.attitudes_count;
    int value3 = [total3 intValue];
    [goodBtn setTitle:[NSString stringWithFormat:@"赞:%d",value3] forState:UIControlStateNormal];
    [sectionHeaderView addSubview:goodBtn];
    
    //4.设置毛玻璃效果
    [sectionHeaderView enableBlur:YES];
        //设置背景色
        sectionHeaderView.blurTintColor = [UIColor colorWithWhite:0.1 alpha:1];
        //设置浅色/深色 样式
        sectionHeaderView.blurStyle = UIViewBlurLightStyle;
    
    
    return sectionHeaderView;
}

- (void)commentButton:(UIButton *)btn{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"COMMENT" object:btn];
}

- (void)relayButton:(UIButton *)btn{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RELAY" object:btn];
}

- (void)goodButton:(UIButton *)btn{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ZAN" object:btn];
    
}

//设置组的头视图的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

//设置单元格的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CommentModel *model = self.data[indexPath.row];
    
    //计算单元格的高度,使用自定义单元格的类方法计算高度
    CGFloat height = [CommentCell getCommentHeight:model];
    
    return height;
}



@end
