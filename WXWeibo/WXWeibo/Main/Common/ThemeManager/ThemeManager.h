//
//  ThemeManager.h
//  WXWeibo
//
//  Created by liuwei on 15/10/10.
//  Copyright (c) 2015年 wxhl. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ThemeManager : NSObject


/**
 *          蓝月亮  ->  Skins/bluemoon
            猫爷   ->   Skins/cat
 
 *
 *
 */
+ (id)shareManager;

//主题配置字典
@property (nonatomic,strong)NSDictionary *themeDic;


//
@property (nonatomic,copy)NSString *themeName;

/**
 *
 *
 *  @param imgName 图片名
 *
 *  @return 对应主题包下的图片
 */
- (UIImage *)getThemeImageWithImageName:(NSString *)imgName;

/**
 *
 *
 *  @param name 颜色配置文件中对应的key
 *
 *  @return 颜色
 */
- (UIColor *)getThemeColorWithFontName:(NSString *)name;

@end
