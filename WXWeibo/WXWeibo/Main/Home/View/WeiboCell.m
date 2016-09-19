//
//  WeiboCell.m
//  WXWeibo
//
//  Created by liuwei on 15/10/12.
//  Copyright (c) 2015年 wxhl. All rights reserved.
//

#import "WeiboCell.h"
#import "ThemeLable.h"
#import "UIImageView+WebCache.h"
#import "UIUtils.h"
#import "WeiboContentView.h"

@interface WeiboCell ()

@property (weak, nonatomic) IBOutlet UIImageView *weiboImageView;
@property (weak, nonatomic) IBOutlet ThemeLable *nickNameLabel;
@property (weak, nonatomic) IBOutlet ThemeLable *commentCountLabel;
@property (weak, nonatomic) IBOutlet ThemeLable *createTimeLabel;
@property (weak, nonatomic) IBOutlet ThemeLable *sourceLable;
@property (weak, nonatomic) IBOutlet ThemeLable *zanLabel;
@property (weak, nonatomic) IBOutlet ThemeLable *repostCountLabel;

@property (strong,nonatomic)WeiboContentView *weiboContentView;

@end

@implementation WeiboCell


- (void)awakeFromNib{

    //设置主题
    _nickNameLabel.fontColor = @"Timeline_Name_color";
    _repostCountLabel.fontColor = @"Timeline_Name_color";
    _commentCountLabel.fontColor = @"Timeline_Name_color";
    _zanLabel.fontColor = @"Timeline_Name_color";
    _createTimeLabel.fontColor = @"Timeline_Time_color";
    _sourceLable.fontColor = @"Timeline_Time_color";

    //微博内容视图
    _weiboContentView = [[WeiboContentView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_weiboContentView];
    
    self.backgroundColor = [UIColor clearColor];

}

- (void)setLayout:(WeiboContentViewLayout *)layout{

    _layout = layout;
    
    //取出status对象
    StatusModel *status = _layout.status;
    
    //昵称
    _nickNameLabel.text = status.user.screen_name;
    //转发数
    _repostCountLabel.text = [NSString stringWithFormat:@"转发:%@",[status.reposts_count stringValue]];
    //评论数
    _commentCountLabel.text = [NSString stringWithFormat:@"评论:%@",[status.comments_count stringValue]];
    _zanLabel.text = [NSString stringWithFormat:@"赞:%@",[status.attitudes_count stringValue]];
    //发布时间
    _createTimeLabel.text = [UIUtils fomateString:status.created_at];
    
    _sourceLable.text = [NSString stringWithFormat:@"来源:%@",status.source];
    
    
    //用户头像
    NSURL *url = [NSURL URLWithString:status.user.profile_image_url];
    [_weiboImageView sd_setImageWithURL:url];
    _weiboImageView.layer.cornerRadius = _weiboImageView.height / 2.0;
    _weiboImageView.layer.masksToBounds = YES;
    //将微博数据交给微博内容视图
    _weiboContentView.layout = _layout;
    
    //设置微博内容视图的frame
    _weiboContentView.frame = _layout.frame;
}


@end
