//
//  WeiboContentView.m
//  WXWeibo
//
//  Created by liuwei on 15/10/12.
//  Copyright (c) 2015年 wxhl. All rights reserved.
//

#import "WeiboContentView.h"
#import "WXLabel.h"
#import "ThemeImageView.h"
#import "ThemeManager.h"
#import "UIImageView+WebCache.h"
#import "ZoomImageView.h"
#import "XSCommonWebViewController.h"

@interface WeiboContentView ()<WXLabelDelegate>

//微博的文字内容
@property (nonatomic,strong)WXLabel *textLable;
//被转发的微博文字内容
@property (nonatomic,strong)WXLabel *reTextLable;
//被转发的微博的背景
@property (nonatomic,strong)ThemeImageView *bgImgView;
//微博的图片内容
@property (nonatomic,strong)ZoomImageView *imgView;

@end

//富文本  图文混排  文字的检索 -> 正则表达式

@implementation WeiboContentView

- (id)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    
    if (self) {
        
        //创建子视图
        [self createSubviews];
        
        //监听主题切换的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themmeChangeAction) name:kThemeChangeNotification object:nil];
    }
    return self;
}

- (void)setLayout:(WeiboContentViewLayout *)layout{

    _layout = layout;
    
    [self setNeedsLayout];

}

- (void)createSubviews{
    
    _bgImgView = [[ThemeImageView alloc] initWithFrame:CGRectZero];
    //设置主题
    _bgImgView.leftCap = 25;
    _bgImgView.topCap = 25;
    _bgImgView.imageName = @"timeline_rt_border_9.png";
    [self addSubview:_bgImgView];
    
    //微博文字label
    _textLable = [[WXLabel alloc] initWithFrame:CGRectZero];
    
    //指定代理,添加超链接
    _textLable.wxLabelDelegate = self;
    
    _textLable.textColor = [[ThemeManager shareManager] getThemeColorWithFontName:@"Timeline_Content_color"];
    [self addSubview:_textLable];
    
    //转发微博文字label
    _reTextLable = [[WXLabel alloc] initWithFrame:CGRectZero];
    //指定代理,添加超链接
    _reTextLable.wxLabelDelegate = self;
     _reTextLable.textColor = [[ThemeManager shareManager] getThemeColorWithFontName:@"Detail_Content_color"];
    [self addSubview:_reTextLable];

    //微博图片
    _imgView = [[ZoomImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:_imgView];


}

- (void)layoutSubviews{

    [super layoutSubviews];
    
#warning 增加微博详情的判断
    _textLable.font = [UIFont systemFontOfSize:FontSize_Status(_layout.isDetail)];
    _reTextLable.font = [UIFont systemFontOfSize:FontSize_ReStatus(_layout.isDetail)];

    //取得微博信息
    StatusModel *status = _layout.status;
    
    _textLable.frame = _layout.textFrame;
    _textLable.text = status.text;
    
    //判断是否为转发的微博
    if (status.reStatus) {
        
        //显示原微博内容与原微博背景
        _reTextLable.hidden = NO;
        _bgImgView.hidden = NO;
        
        //转发微博的文字内容
        _reTextLable.frame = _layout.reTextFrame;
        _reTextLable.text = status.reStatus.text;
        
        //取出缩略图
        NSString *thumbnailImg = _layout.status.reStatus.thumbnail_pic;
        //如果是详情页,显示中图
        if (_layout.isDetail) {
            thumbnailImg = _layout.status.reStatus.bmiddle_pic;
        }
        //转发的微博是否有图片
        if (thumbnailImg) {
            
            //显示转发微博的图片
            _imgView.hidden = NO;
            
            _imgView.frame = _layout.imgFrame;
            [_imgView sd_setImageWithURL:[NSURL URLWithString:thumbnailImg]];
            
            //设置原图的URL
            _imgView.imgURL = status.reStatus.original_pic;
           
        }else{
            //隐藏转发微博的图片
            _imgView.hidden = YES;
        }
        
        //背景
        _bgImgView.frame = _layout.bgImgFrame;
        
    }else{
        
        _reTextLable.hidden = YES;
        _bgImgView.hidden = YES;
        
        //判断是否有图片
        if (_layout.status.thumbnail_pic) {
            
            _imgView.hidden = NO;
            _imgView.frame = _layout.imgFrame;
            [_imgView sd_setImageWithURL:[NSURL URLWithString:status.thumbnail_pic]];
            
            //设置原图的URL
            _imgView.imgURL = status.original_pic;
            
        }else{
        
            _imgView.hidden = YES;
        }
        
    }

}

#pragma mark -WXLabelDelegate
//检索文本的正则表达式的字符串
- (NSString *)contentsOfRegexStringWithWXLabel:(WXLabel *)wxLabel {
    
    //话题 #... #  超链接  https://www.baidu.com/w.x/a-a/bb @
    NSString *regex1 = @"#\\w+#";
    NSString *regex2 = @"http(s)?://([A-Za-z0-9._-]+(/)?)*";
    NSString *regex3 = @"@\\w+";
    
    NSString *regex = [NSString stringWithFormat:@"%@|%@|%@",regex1,regex2,regex3];
    
    return regex;
}
//设置当前链接文本的颜色
- (UIColor *)linkColorWithWXLabel:(WXLabel *)wxLabel {

    return [[ThemeManager shareManager] getThemeColorWithFontName:@"Link_color"];

}

//设置当前文本手指经过的颜色
- (UIColor *)passColorWithWXLabel:(WXLabel *)wxLabel {

    return [UIColor redColor];
}

//手指接触当前超链接文本响应的协议方法
- (void)toucheBenginWXLabel:(WXLabel *)wxLabel withContext:(NSString *)context {
    NSLog(@"%@",context);
    if ([context rangeOfString:@"http"].location != NSNotFound) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WEBVIEW" object:context];
    }
    
}

//主题切换
- (void)themmeChangeAction{
    
    //重绘文字内容,重绘超链接
    [_textLable setNeedsDisplay];
    [_reTextLable setNeedsDisplay];
    
    //更改lable属性时,系统会自动调用drawRect
    _textLable.textColor = [[ThemeManager shareManager] getThemeColorWithFontName:@"Timeline_Content_color"];
    _reTextLable.textColor = [[ThemeManager shareManager] getThemeColorWithFontName:@"Detail_Content_color"];

}

@end
