//
//  MessageCell.m
//  WXWeibo
//
//  Created by shiyabing on 16/4/28.
//  Copyright © 2016年 wxhl. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        [self creatSubViews];
    }
    return self;
}

- (void)creatSubViews{
    
    _iconView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 40, 40)];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(_iconView.right + 20, 10, kScreenWidth / 2, 40)];
    
    
    [self.contentView addSubview:_iconView];
    [self.contentView addSubview:_titleLabel];

}

@end
