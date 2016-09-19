//
//  ThemeImageView.m
//  WXWeibo
//
//  Created by liuwei on 15/10/10.
//  Copyright (c) 2015年 wxhl. All rights reserved.
//

#import "ThemeImageView.h"
#import "ThemeManager.h"

@implementation ThemeImageView


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
    
    if (_leftCap != 0 || _topCap != 0) {
        
        img = [img stretchableImageWithLeftCapWidth:_leftCap topCapHeight:_topCap];
    }
    
    self.image = img;
    
}

@end
