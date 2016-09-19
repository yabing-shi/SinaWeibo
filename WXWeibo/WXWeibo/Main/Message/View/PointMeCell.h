//
//  PointMeCell.h
//  WXWeibo
//
//  Created by shiyabing on 16/5/9.
//  Copyright © 2016年 wxhl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboContentViewLayout.h"
#import "ThemeLable.h"

@interface PointMeCell : UITableViewCell
@property (nonatomic,strong)WeiboContentViewLayout *layout;
@property (nonatomic,strong)ThemeLable *topLabel;

@end
