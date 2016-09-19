//
//  FacePannel.h
//  WXWeibo
//
//  Created by liuwei on 15/10/20.
//  Copyright (c) 2015年 wxhl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FaceView.h"
@interface FacePannel : UIView<UIScrollViewDelegate>

@property (nonatomic,assign)id<FaceViewDelegate> faceViewDelegate;
@end
