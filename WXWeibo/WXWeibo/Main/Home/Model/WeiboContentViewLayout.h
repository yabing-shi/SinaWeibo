//
//  WeiboContentViewLayout.h
//  WXWeibo
//
//  Created by liuwei on 15/10/12.
//  Copyright (c) 2015年 wxhl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StatusModel.h"

//布局微博视图的子视图
@interface WeiboContentViewLayout : NSObject

//微博文字布局
@property (nonatomic,assign)CGRect textFrame;

//转发微博文字布局
@property (nonatomic,assign)CGRect reTextFrame;

//背景布局
@property (nonatomic,assign)CGRect bgImgFrame;

//微博图片布局
@property (nonatomic,assign)CGRect imgFrame;

//微博内容视图的布局
@property (nonatomic,assign)CGRect frame;

//微博信息
@property (nonatomic,strong)StatusModel *status;

@property (nonatomic,assign)BOOL isDetail;


@end
