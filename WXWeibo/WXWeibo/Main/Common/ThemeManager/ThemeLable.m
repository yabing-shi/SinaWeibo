//
//  ThemeLable.m
//  WXWeibo
//
//  Created by liuwei on 15/10/10.
//  Copyright (c) 2015年 wxhl. All rights reserved.
//

#import "ThemeLable.h"
#import "ThemeManager.h"

@implementation ThemeLable

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeChangeNotification object:nil];
}

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        //监听主题切换的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadColor) name:kThemeChangeNotification object:nil];
    }
    
    return self;
}

- (void)awakeFromNib{

    //监听主题切换的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadColor) name:kThemeChangeNotification object:nil];

}

- (void)setFontColor:(NSString *)fontColor{

    if (_fontColor != fontColor) {
        
        _fontColor = [fontColor copy];
        
        [self loadColor];
    }
}

- (void)setBgColor:(NSString *)bgColor{
    _bgColor = [bgColor copy];
    [self loadBgColor];
}

- (void)loadColor{
    
    ThemeManager *manager = [ThemeManager shareManager];

    self.textColor = [manager getThemeColorWithFontName:_fontColor];

}

- (void)loadBgColor{
    
    ThemeManager *manager = [ThemeManager shareManager];
    
    self.backgroundColor = [manager getThemeColorWithFontName:_bgColor];
    
}
@end
