//
//  ZoomImageView.h
//  WXWeibo
//
//  Created by liuwei on 15/10/16.
//  Copyright (c) 2015年 wxhl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZoomImageView;

@protocol ZoomImageViewDelegate <NSObject>

@optional
//将要放大
- (void)zoomImageViewWillZoomIn:(ZoomImageView *)zoomImg;

//已经放大
- (void)zoomImageViewDidZoomIn:(ZoomImageView *)zoomImg;

//将要缩小
- (void)zoomImageViewWillZoomOut:(ZoomImageView *)zoomImg;

//已经缩小
- (void)zoomImageViewDidZoomOut:(ZoomImageView *)zoomImg;


@end

@interface ZoomImageView : UIImageView

@property (nonatomic,copy)NSString *imgURL;
@property (nonatomic,assign)id<ZoomImageViewDelegate> delegate;

@end
