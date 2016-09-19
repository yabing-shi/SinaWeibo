//
//  FaceView.h
//  WXWeibo
//
//  Created by liuwei on 15/10/20.
//  Copyright (c) 2015年 wxhl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FaceView;
@protocol FaceViewDelegate <NSObject>

@optional
- (void)faceView:(FaceView *)faceView didSelectedFace:(NSString *)faceName;

@end

@interface FaceView : UIView

@property (nonatomic,strong)NSMutableArray *items;

@property (nonatomic,assign)id delegate;


@end
