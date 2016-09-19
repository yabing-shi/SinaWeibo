//
//  WXLabel.h
//  CoreTextClicke
//
//  Created by zsm on 13-12-17.
//  Copyright (c) 2013年 zsm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
@class WXLabel;
@protocol WXLabelDelegate <NSObject>

@optional

//手指离开当前超链接文本响应的协议方法
- (void)toucheEndWXLabel:(WXLabel *)wxLabel withContext:(NSString *)context;
//手指接触当前超链接文本响应的协议方法
- (void)toucheBenginWXLabel:(WXLabel *)wxLabel withContext:(NSString *)context;
//检索文本的正则表达式的字符串
- (NSString *)contentsOfRegexStringWithWXLabel:(WXLabel *)wxLabel;
//设置当前链接文本的颜色
- (UIColor *)linkColorWithWXLabel:(WXLabel *)wxLabel;
//设置当前文本手指经过的颜色
- (UIColor *)passColorWithWXLabel:(WXLabel *)wxLabel;
//检索文本中图片的正则表达式的字符串
- (NSString *)imagesOfRegexStringWithWXLabel:(WXLabel *)wxLabel;
@end

@interface WXLabel : UILabel
@property(nonatomic,assign)id<WXLabelDelegate> wxLabelDelegate;//代理对象
@property(nonatomic,assign)CGFloat linespace;//行间距   default = 10.0f
@property(nonatomic,assign)CGFloat mutiHeight;//行高(倍数) default = 1.0f
@property(nonatomic,assign)float textHeight;

//计算文本内容的高度
+ (float)getTextHeight:(float)fontSize
                 width:(float)width
                  text:(NSString *)text;
@end
