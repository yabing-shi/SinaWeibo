//
//  MoreCell.h
//  WXWeibo
//
//  Created by liuwei on 15/10/10.
//  Copyright (c) 2015年 wxhl. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ThemeImageView.h"
#import "ThemeLable.h"

@interface MoreCell : UITableViewCell

@property (nonatomic,strong)ThemeImageView *imgView;
@property (nonatomic,strong)ThemeLable *titleLable;
@property (nonatomic,strong)ThemeLable *themeNameLable;

@end
