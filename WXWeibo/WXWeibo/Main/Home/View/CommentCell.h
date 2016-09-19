//
//  CommentCell.h
//  WXWeibo
//
//  Created by wei.chen on 13-5-20.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXLabel.h"
#import "ThemeLable.h"

@class CommentModel;
@interface CommentCell : UITableViewCell<WXLabelDelegate> {
    
    WXLabel *_rtTextLabel;
    
    __weak IBOutlet UIImageView *_imgView;
    __weak IBOutlet ThemeLable*_nickLabel;
    __weak IBOutlet UILabel *_timeLabel;
}

@property(nonatomic,retain)CommentModel *commentModel;

//计算评论单元格的高度
+ (float)getCommentHeight:(CommentModel *)commentModel;

@end
