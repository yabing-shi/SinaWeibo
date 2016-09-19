//
//  WeiboContentViewLayout.m
//  WXWeibo
//
//  Created by liuwei on 15/10/12.
//  Copyright (c) 2015年 wxhl. All rights reserved.
//

#import "WeiboContentViewLayout.h"
#import "WXLabel.h"

@implementation WeiboContentViewLayout


- (void)setStatus:(StatusModel *)status{

    _status = status;

    [self layoutFrame];
}

- (void)layoutFrame{

    //取得微博model
    StatusModel *status = self.status;
    
    //布局微博内容视图
    
    //1.微博内容视图的frame  50 50
#warning 增加微博详情的判断
    CGFloat x = _isDetail ? 10 : 65;
    CGFloat y = _isDetail ? 10 : 40;
    CGFloat width = _isDetail ? kScreenWidth - 20 :kScreenWidth - 65 - 10;
    self.frame = CGRectMake(x,y, width, 0);
    
    //计算文字的高度
    CGFloat textHeight = [WXLabel getTextHeight:FontSize_Status(self.isDetail) width:CGRectGetWidth(self.frame) text:status.text];
    //2.微博文字的frame
    self.textFrame = CGRectMake(5, 0, CGRectGetWidth(self.frame), textHeight);
    
    //3.判断是否为转发的微博
    if (status.reStatus) {
        
        //4.转发的微博的文字内容
        CGFloat reTextx = CGRectGetMinX(self.textFrame);
        CGFloat reTexty = CGRectGetMaxY(self.textFrame);
        CGFloat reTextWidth = CGRectGetWidth(self.textFrame) - 10 * 2;
        
        //转发的微博的文字内容的高度
#warning 增加微博详情的判断
        CGFloat reTextHeight = [WXLabel getTextHeight:FontSize_ReStatus(self.isDetail) width:reTextWidth text:status.reStatus.text];
        self.reTextFrame = CGRectMake(reTextx + 10, reTexty + 10, reTextWidth, reTextHeight);
        
        //5.判断转发微博是否有图片
        if (status.reStatus.thumbnail_pic) {
#warning 增加微博详情的判断
            CGFloat width = _isDetail ? (kScreenWidth - 20) : 80;
            CGFloat height = _isDetail ? 120 : 80;
            self.imgFrame = CGRectMake(reTextx + 10, CGRectGetMaxY(self.reTextFrame), width, height);
        }
        
        //6.微博背景的frame
        CGFloat bgHeight = CGRectGetHeight(self.imgFrame) + CGRectGetHeight(self.reTextFrame) + 10 + 10;
        self.bgImgFrame = CGRectMake(CGRectGetMinX(self.textFrame), CGRectGetMaxY(self.textFrame), CGRectGetWidth(self.textFrame), bgHeight);
        
    }else {
        
        //如果微博有图片
        if (status.thumbnail_pic) {
            
#warning 增加微博详情的判断
            CGFloat width = _isDetail ? (kScreenWidth - 20) : 80;
            CGFloat height = _isDetail ? 120 : 80;
            self.imgFrame = CGRectMake(CGRectGetMinX(self.textFrame), CGRectGetMaxY(self.textFrame), width, height);
        }

    }
    
    //整个微博内容的frame
    CGFloat imgHeight = status.reStatus ? 0 : self.imgFrame.size.height;
    CGFloat height = CGRectGetHeight(self.textFrame) + CGRectGetHeight(self.bgImgFrame) + imgHeight + 2;
    
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;

}

@end
