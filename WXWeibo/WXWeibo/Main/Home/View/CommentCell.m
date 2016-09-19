//
//  CommentCell.m
//  WXWeibo
//
//  Created by wei.chen on 13-5-20.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "CommentCell.h"
#import "UIImageView+WebCache.h"
#import "CommentModel.h"
#import "UIUtils.h"
#import "UIView+Controller.h"
#import "ThemeManager.h"

@implementation CommentCell

/*
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        
        
        
    }
    return self;
}
 */

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _rtTextLabel = [[WXLabel alloc] initWithFrame:CGRectZero];
    _rtTextLabel.font = [UIFont systemFontOfSize:14.0f];
    _rtTextLabel.linespace = 5;
    _rtTextLabel.wxLabelDelegate = self;
    _rtTextLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_rtTextLabel];
    self.backgroundColor = [UIColor clearColor];
    
    //用户头像
    _imgView.layer.cornerRadius = _imgView.width/2;
    _imgView.layer.masksToBounds = YES;
    _imgView.layer.borderColor = [UIColor whiteColor].CGColor;
    _imgView.layer.borderWidth = 1;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSString *urlstring = _commentModel.user.profile_image_url;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:urlstring]];
    
    //昵称
    _nickLabel.text = _commentModel.user.screen_name;
    _nickLabel.fontColor = @"Detail_Bottom_Info_color";
    //发布时间
    _timeLabel.text = [UIUtils fomateString:_commentModel.created_at];
    
    
    //评论内容
    CGFloat height = [WXLabel getTextHeight:14.0f
                                      width:kScreenWidth-80
                                       text:_commentModel.text
                                  ];
    
    _rtTextLabel.frame = CGRectMake(_imgView.right+15, _nickLabel.bottom+15, kScreenWidth-85, height);
    _rtTextLabel.text = _commentModel.text;
    
}

#pragma mark - WXLabel delegate
//手指离开当前超链接文本响应的协议方法
//- (void)toucheEndWXLabel:(WXLabel *)wxLabel withContext:(NSString *)context {
//    UIViewController *vc = [[UIViewController alloc] init];
//    [self.viewController.navigationController pushViewController:vc animated:YES];
//}

//返回一个正则表达式，通过此正则表达式查找出需要添加超链接的文本
- (NSString *)contentsOfRegexStringWithWXLabel:(WXLabel *)wxLabel {
    //需要添加连接的字符串的正则表达式：@用户、http://... 、 #话题#
    NSString *regex1 = @"@\\w+"; //@"@[_$]";
    NSString *regex2 = @"http(s)?://([A-Za-z0-9._-]+(/)?)*";
    NSString *regex3 = @"#^#+#";  //\w 匹配字母或数字或下划线或汉字
    
    NSString *regex = [NSString stringWithFormat:@"(%@)|(%@)|(%@)",regex1,regex2,regex3];
    
    return regex;
}

//设置当前链接文本的颜色
- (UIColor *)linkColorWithWXLabel:(WXLabel *)wxLabel {
    
    UIColor *linkColor = [[ThemeManager shareManager] getThemeColorWithFontName:@"Link_color"];
    return linkColor;
}

//设置当前文本手指经过的颜色
- (UIColor *)passColorWithWXLabel:(WXLabel *)wxLabel {
    return [UIColor darkGrayColor];
}


//计算评论单元格的高度
+ (float)getCommentHeight:(CommentModel *)commentModel {
    CGFloat height = [WXLabel getTextHeight:14.0f
                                      width:kScreenWidth-80
                                       text:commentModel.text
                                  ];
    
    return height+40;
}
//手指接触当前超链接文本响应的协议方法
- (void)toucheBenginWXLabel:(WXLabel *)wxLabel withContext:(NSString *)context {
    NSLog(@"%@",context);
    if ([context rangeOfString:@"http"].location != NSNotFound) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WEBVIEWDETAIL" object:context];
    }
    
}
@end
