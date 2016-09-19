//
//  UIView+Controller.m
//  03 事件分发
//
//  Created by liuwei on 15/9/11.
//  Copyright (c) 2015年 wxhl. All rights reserved.
//

#import "UIView+Controller.h"

@implementation UIView (Controller)

- (UIViewController *)viewController {

    UIResponder *next = self.nextResponder;
    
    while (next != nil) {
        
        //判断下一个响应者是否为控制器
        if ([next isKindOfClass:[UIViewController class]]) {
            
            return (UIViewController *)next;
            
        }
        
        next = next.nextResponder;
    }
    
    return nil;
}


@end
