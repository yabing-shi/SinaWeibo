//
//  WeiboCell.m
//  WXWeibo
//
//  Created by liuwei on 15/10/12.
//  Copyright (c) 2015年 wxhl. All rights reserved.
//

#import "PointMeCell.h"
#import "ThemeLable.h"
#import "UIImageView+WebCache.h"
#import "UIUtils.h"
#import "WeiboContentView.h"

@interface PointMeCell (){
    ThemeLable *divLabel;
    ThemeLable *divLabel1;
    ThemeLable *divLabel2;
}
@property (strong,nonatomic ) UIImageView *headIcon;
@property (strong, nonatomic) ThemeLable  *nickNameLabel;
@property (strong, nonatomic) ThemeLable  *commentCountLabel;
@property (strong, nonatomic) ThemeLable  *createTimeLabel;
@property (strong, nonatomic) ThemeLable  *sourceLable;
@property (strong, nonatomic) ThemeLable  *zanLabel;
@property (strong, nonatomic) ThemeLable  *repostCountLabel;

@property (strong,nonatomic)WeiboContentView *weiboContentView;

@end

@implementation PointMeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self creatSubViews];
    }
    return self;
}

- (void)creatSubViews{
    _headIcon = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 40, 40)];
    _topLabel = [[ThemeLable alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    _nickNameLabel = [[ThemeLable alloc]initWithFrame:CGRectMake(_headIcon.right + 5, 20, kScreenWidth/2, 15)];
    _createTimeLabel = [[ThemeLable alloc]initWithFrame:CGRectMake(_headIcon.right + 5, _nickNameLabel.bottom +5, kScreenWidth/2, 12)];
    _createTimeLabel.font = [UIFont systemFontOfSize:12];
    _createTimeLabel.textColor = [UIColor grayColor];
    _sourceLable = [[ThemeLable alloc]initWithFrame:CGRectMake(_createTimeLabel.right + 5, _nickNameLabel.bottom + 5, kScreenWidth/2, 12)];
    _sourceLable.font = [UIFont systemFontOfSize:12];
    _sourceLable.textColor = [UIColor grayColor];
    
    divLabel = [[ThemeLable alloc]initWithFrame:CGRectMake(0, self.contentView.bottom + 10, kScreenWidth, 1)];
    divLabel.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:.7];
    _repostCountLabel = [[ThemeLable alloc]initWithFrame:CGRectMake(0, self.size.height - 30, (kScreenWidth - 2)/3, 30)];
    _repostCountLabel.textAlignment = NSTextAlignmentCenter;
    divLabel1 = [[ThemeLable alloc]initWithFrame:CGRectMake(_repostCountLabel.right, divLabel.bottom+ 17.5, 1, 15)];
    divLabel1.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:.7];
    _commentCountLabel = [[ThemeLable alloc]initWithFrame:CGRectMake(_repostCountLabel.right, divLabel.bottom, (kScreenWidth - 2)/3, 30)];
    _commentCountLabel.textAlignment = NSTextAlignmentCenter;
    divLabel2 = [[ThemeLable alloc]initWithFrame:CGRectMake(_commentCountLabel.right, divLabel.bottom+ 17.5, 1, 15)];
    divLabel2.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:.7];
    _zanLabel = [[ThemeLable alloc]initWithFrame:CGRectMake(_commentCountLabel.right + 1, divLabel.bottom, (kScreenWidth - 2)/3, 30)];
    _zanLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView addSubview:_headIcon];
    [self.contentView addSubview:_topLabel];
    [self.contentView addSubview:_nickNameLabel];
    [self.contentView addSubview:_createTimeLabel];
    [self.contentView addSubview:_sourceLable];
    [self.contentView addSubview:_commentCountLabel];
    [self.contentView addSubview:_repostCountLabel];
    [self.contentView addSubview:_zanLabel];
    [self.contentView addSubview:divLabel];
    [self.contentView addSubview:divLabel1];
    [self.contentView addSubview:divLabel2];
    //设置主题
    _nickNameLabel.fontColor = @"Timeline_Name_color";
    _repostCountLabel.fontColor = @"Timeline_Name_color";
    _commentCountLabel.fontColor = @"Timeline_Name_color";
    _zanLabel.fontColor = @"Timeline_Name_color";
    _createTimeLabel.fontColor = @"Timeline_Time_color";
    _sourceLable.fontColor = @"Timeline_Time_color";
    _topLabel.bgColor = @"Channel_Dot_color";
    divLabel.bgColor = @"Channel_Dot_color";
    divLabel1.bgColor = @"Channel_Dot_color";
    divLabel2.bgColor = @"Channel_Dot_color";
    
    //微博内容视图
    _weiboContentView = [[WeiboContentView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_weiboContentView];
    
    self.backgroundColor = [UIColor clearColor];
    
}

- (void)setLayout:(WeiboContentViewLayout *)layout{
    _topLabel.bgColor = @"Channel_Dot_color";
    _layout = layout;
    
    //取出status对象
    StatusModel *status = _layout.status;
    [_headIcon sd_setImageWithURL:[NSURL URLWithString:status.user.profile_image_url]];
    _headIcon.layer.cornerRadius = _headIcon.height / 2.0;
    _headIcon.layer.masksToBounds = YES;
    //昵称
    _nickNameLabel.text = status.user.screen_name;
    //转发数
    _repostCountLabel.text = [NSString stringWithFormat:@"转发:%@",[status.reposts_count stringValue]];
    //评论数
    _commentCountLabel.text = [NSString stringWithFormat:@"评论:%@",[status.comments_count stringValue]];
    _zanLabel.text = [NSString stringWithFormat:@"赞:%@",[status.attitudes_count stringValue]];
    //发布时间
    _createTimeLabel.text = [UIUtils fomateString:status.created_at];
    [_createTimeLabel sizeToFit];
    _sourceLable.text = [NSString stringWithFormat:@"来源:%@",status.source];
    _sourceLable.mj_x = _createTimeLabel.right + 10;
    
    //将微博数据交给微博内容视图
    _weiboContentView.layout = _layout;
    
    //设置微博内容视图的frame
    _weiboContentView.frame = _layout.frame;
    _weiboContentView.mj_y += 60;
    
    divLabel.mj_y = _weiboContentView.bottom + 5;
    divLabel1.mj_y = divLabel.bottom + 7.5;
    _repostCountLabel.mj_y = divLabel.bottom;
    _commentCountLabel.mj_y = divLabel.bottom;
    _zanLabel.mj_y = divLabel.bottom;
    divLabel2.mj_y = divLabel.bottom + 7.5;
}

@end
