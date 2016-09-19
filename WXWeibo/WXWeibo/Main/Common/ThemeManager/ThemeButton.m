//
//  ThemeButton.m
//  WXWeibo
//
//  Created by liuwei on 15/10/10.
//  Copyright (c) 2015年 wxhl. All rights reserved.
//

#import "ThemeButton.h"
#import "ThemeManager.h"

@implementation ThemeButton

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeChangeNotification object:nil];
}

- (id)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    
    if (self) {
        
        //监听主题切换的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadImg) name:kThemeChangeNotification object:nil];
    }

    return self;
}

- (void)awakeFromNib{
    
    //监听主题切换的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadImg) name:kThemeChangeNotification object:nil];
    
}


- (void)setImageName:(NSString *)imageName{

    if (_imageName != imageName) {
        
        _imageName = [imageName copy];
        
        [self loadImg];
    }

}

- (void)loadImg{

    UIImage *img = [[ThemeManager shareManager] getThemeImageWithImageName:_imageName];
    
    [self setImage:img forState:UIControlStateNormal];

}

@end
