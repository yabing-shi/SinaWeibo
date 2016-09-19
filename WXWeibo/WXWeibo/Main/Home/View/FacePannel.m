//
//  FacePannel.m
//  WXWeibo
//
//  Created by liuwei on 15/10/20.
//  Copyright (c) 2015年 wxhl. All rights reserved.
//

#import "FacePannel.h"
#import "FaceView.h"

@implementation FacePannel{

    FaceView *face;
}


/**
 *  faceView
    scrollView
    pageControl
*/

- (id)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    
    if (self) {
        [self _createSubViews];
    }
    return self;
}

- (void)setFaceViewDelegate:(id<FaceViewDelegate>)faceViewDelegate{

    face.delegate = faceViewDelegate;

}

- (void)_createSubViews{
    
    face = [[FaceView alloc] initWithFrame:CGRectZero];
    face.backgroundColor = [UIColor clearColor];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,face.height)];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.clipsToBounds = NO;
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(face.width,face.height);
    [scrollView addSubview:face];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    [self addSubview:scrollView];
    
    //kScreenWidth
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, face.bottom, kScreenWidth, 20)];
    pageControl.numberOfPages = face.items.count;
    pageControl.tag = 2015;
    
    /**
     *  子视图是否跟随父视图变化
     */
    self.autoresizesSubviews = NO;
//    self.autoresizingMask = UIViewAutoresizingNone;
    //父视图的宽度 0
    [self addSubview:pageControl];
    //更改父视图的宽度
    self.width = kScreenWidth;
    self.height = face.height + pageControl.height;
}


- (void)drawRect:(CGRect)rect{

    UIImage *img = [UIImage imageNamed:@"emoticon_keyboard_background.png"];
    [img drawInRect:rect];
}
#pragma mark -UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    NSInteger index = scrollView.contentOffset.x / kScreenWidth;
    
    UIPageControl *pageControl = (UIPageControl *)[self viewWithTag:2015];
    
    pageControl.currentPage = index;

}


@end
