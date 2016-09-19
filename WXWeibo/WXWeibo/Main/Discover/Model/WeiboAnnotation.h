//
//  WeiboAnnotation.h
//  WXWeibo
//
//  Created by liuwei on 15/10/20.
//  Copyright (c) 2015年 wxhl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "StatusModel.h"
@interface WeiboAnnotation : NSObject<MKAnnotation>

@property (nonatomic,assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) StatusModel *status;


@end
