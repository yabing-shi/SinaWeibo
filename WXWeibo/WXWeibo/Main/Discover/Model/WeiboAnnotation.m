//
//  WeiboAnnotation.m
//  WXWeibo
//
//  Created by liuwei on 15/10/20.
//  Copyright (c) 2015年 wxhl. All rights reserved.
//

#import "WeiboAnnotation.h"

@implementation WeiboAnnotation


- (void)setStatus:(StatusModel *)status{

    _status = status;
    
    //取出地理信息
    NSArray *coordinates = _status.geo[@"coordinates"];
    
    if (coordinates.count >= 2) {
        
        //取出纬度
        double lat = [coordinates[0] doubleValue];
        //取出精度
        double longt = [coordinates[1] doubleValue];
        
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(lat, longt);
        
        self.coordinate = coordinate;
    }


}
@end
