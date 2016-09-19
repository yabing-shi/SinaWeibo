//
//  StatusAnnotationView.m
//  WXWeibo
//
//  Created by liuwei on 15/10/21.
//  Copyright (c) 2015年 wxhl. All rights reserved.
//

#import "StatusAnnotationView.h"
#import "WeiboAnnotation.h"
#import "UIImageView+WebCache.h"

@interface StatusAnnotationView ()
@property (nonatomic,strong)UIImageView *userImgView;
@end

@implementation StatusAnnotationView


- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        //用户头像的背景
        UIImageView *bgImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nearby_map_people_bg.png"]];
        [bgImg sizeToFit];
        [self addSubview:bgImg];
        bgImg.layer.anchorPoint = CGPointMake(1, 1.5);
        
        _userImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10,7, 50, 50)];
        _userImgView.layer.cornerRadius = 2;
        _userImgView.layer.masksToBounds = YES;
        
        WeiboAnnotation *annotation = (WeiboAnnotation *)self.annotation;
        
        NSString *url = annotation.status.user.profile_image_url;
        [_userImgView sd_setImageWithURL:[NSURL URLWithString:url]];
        
        [bgImg addSubview:_userImgView];
        
    }
    
    return self;

}

@end
