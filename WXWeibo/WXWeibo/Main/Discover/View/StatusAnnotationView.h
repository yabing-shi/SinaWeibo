//
//  StatusAnnotationView.h
//  WXWeibo
//
//  Created by liuwei on 15/10/21.
//  Copyright (c) 2015年 wxhl. All rights reserved.
//

#import <MapKit/MapKit.h>
@class StatusAnnotationView;
@protocol StatusAnnotationViewDelegate <NSObject>

- (void)annotationView:(StatusAnnotationView *)view;

@end

@interface StatusAnnotationView : MKAnnotationView

@end
