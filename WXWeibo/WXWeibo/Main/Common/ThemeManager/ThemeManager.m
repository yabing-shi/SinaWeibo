//
//  ThemeManager.m
//  WXWeibo
//
//  Created by liuwei on 15/10/10.
//  Copyright (c) 2015年 wxhl. All rights reserved.
//

#import "ThemeManager.h"

static ThemeManager *instance = nil;

@interface ThemeManager ()

//颜色字典
@property (nonatomic,strong)NSDictionary *colorDic;

@end

@implementation ThemeManager

+ (id)shareManager {

    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        instance = [[self alloc] init];
    });

    return instance;
}

- (id)init{

    self = [super init];
    
    if (self) {
       
        //读取本地保存的主题名
        NSString *themeName = [[NSUserDefaults standardUserDefaults] objectForKey:@"ThemeName"];
        //如果本地保存的数据有值则使用本地的数据,如果没有,则使用猫爷主题
        _themeName = themeName ? : @"猫爷";
        
        //读取主题plist文件
        /**
         * 蓝月亮  ->  Skins/bluemoon
           猫爷    ->   Skins/cat
         */
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Theme.plist" ofType:nil];
        
        _themeDic = [NSDictionary dictionaryWithContentsOfFile:filePath];
        
        //读取颜色配置文件
        [self loadColorCofigurationFile];
    }

    return self;
}

- (void)setThemeName:(NSString *)themeName{
    
    if (_themeName != themeName) {
        
        _themeName = [themeName copy];
        
        //保存当前主题的信息
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:_themeName forKey:@"ThemeName"];
        
        //主题更改时,需要重新加载对应的颜色配置文件
        [self loadColorCofigurationFile];
        
        //发送主题更改的通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kThemeChangeNotification object:nil];
    }
}

//加载主题颜色配置文件
- (void)loadColorCofigurationFile{
    
    //1.获取对应主题的路径
    NSString *themePath = self.themePath;
    
    //2.拼接路径
    NSString *filePath = [themePath stringByAppendingPathComponent:@"config.plist"];
    
    _colorDic = [NSDictionary dictionaryWithContentsOfFile:filePath];

}

- (NSString *)themePath{

    //获取对应主题的路径
    NSString *themePath = [_themeDic objectForKey:_themeName];

    NSString *bundlePath = [[NSBundle mainBundle] resourcePath];
    
    return [bundlePath stringByAppendingPathComponent:themePath];
}

/**
    根据图片名获取到对应主题下的图片
 */
- (UIImage *)getThemeImageWithImageName:(NSString *)imgName {
    
    //1.主题路径
    NSString *themePath = [self themePath];
 
    //2.拼接完整的路径 imgPath: bundle/Skins/bluemoon/1.png
    NSString *imgPath = [themePath stringByAppendingPathComponent:imgName];
    
    //3.加载对应的图片
    UIImage *img = [UIImage imageWithContentsOfFile:imgPath];
    
    return img;
}

/**
 *  根据图片名获取到对应主题下的颜色
 */
- (UIColor *)getThemeColorWithFontName:(NSString *)name {
    
    NSDictionary *rgb = _colorDic[name];
    
    double R = [rgb[@"R"] doubleValue];
    double G = [rgb[@"G"] doubleValue];
    double B = [rgb[@"B"] doubleValue];
    
    //如果rgb字典中没有alpha,则将透明度设为1
    double alpha = [rgb[@"alpha"] doubleValue] ? : 1 ;
    
   return  [UIColor colorWithRed:R / 255 green:G / 255 blue:B / 255 alpha:alpha];

}

@end
