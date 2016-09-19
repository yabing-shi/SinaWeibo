//
//  MoreCell.m
//  WXWeibo
//
//  Created by liuwei on 15/10/10.
//  Copyright (c) 2015年 wxhl. All rights reserved.
//

#import "MoreCell.h"
#import "ThemeManager.h"

@implementation MoreCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self _createSubViews];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChange) name:kThemeChangeNotification object:nil];
    }

    return self;
}

- (void)themeChange{
    //单元格颜色
    UIColor *corlor = [[ThemeManager shareManager] getThemeColorWithFontName:@"More_Item_color"];
    
    self.backgroundColor = corlor;
}

- (void)_createSubViews{
    
    //单元格颜色
    UIColor *corlor = [[ThemeManager shareManager] getThemeColorWithFontName:@"More_Item_color"];
    self.backgroundColor = corlor;
    
    _imgView = [[ThemeImageView alloc] initWithFrame:CGRectMake(10, (self.height - 30) / 2, 30, 30)];
    [self.contentView addSubview:_imgView];
    
    _titleLable = [[ThemeLable alloc] initWithFrame:CGRectMake(_imgView.right + 10,_imgView.top ,80, 30)];
    [self.contentView addSubview:_titleLable];
    
    _themeNameLable = [[ThemeLable alloc] initWithFrame:CGRectMake(kScreenWidth - 80 - 20, _titleLable.top, 80, 30)];
    _themeNameLable.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_themeNameLable];
    
    //设置lable的主题颜色
    self.titleLable.fontColor = @"More_Item_Text_color";
    self.themeNameLable.fontColor = @"More_Item_Text_color";
    
    //单元格被选中时,所有的子视图会进入到高亮状态
    _themeNameLable.highlightedTextColor = [UIColor redColor];
}


@end
