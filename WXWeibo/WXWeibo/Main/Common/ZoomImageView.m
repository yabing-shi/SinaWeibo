//
//  ZoomImageView.m
//  WXWeibo
//
//  Created by liuwei on 15/10/16.
//  Copyright (c) 2015年 wxhl. All rights reserved.
//

#import "ZoomImageView.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "SDWebImageManager.h"

@interface ZoomImageView ()

@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)UIImageView *fullImgView;
@property (nonatomic,strong)MBProgressHUD *HUD;


@end

@implementation ZoomImageView

- (id)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        [self _initTap];
    }
    
    return self;
}

- (void)awakeFromNib{

    [self _initTap];
}

- (void)_initTap{
    
    //等比例显示图片
    self.contentMode = UIViewContentModeScaleAspectFit;
    self.userInteractionEnabled = YES;
    //添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomIn)];
    [self addGestureRecognizer:tap];
}

- (void)_createSubViews{
    
    if (_scrollView == nil) {
        
        _scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        [self.window addSubview:_scrollView];
        
        //添加缩小的手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomOut)];
        [_scrollView addGestureRecognizer:tap];
        
        CGRect frame = [self convertRect:self.bounds toView:self.window];
        _fullImgView = [[UIImageView alloc] initWithFrame:frame];
        //等比例放大
        _fullImgView.contentMode = UIViewContentModeScaleAspectFit;
        //显示缩略图
        _fullImgView.image = self.image;
        [_scrollView addSubview:_fullImgView];
        
        //创建进度视图
        _HUD = [[MBProgressHUD alloc] initWithView:_scrollView];
        [_scrollView addSubview:_HUD];
        _HUD.mode = MBProgressHUDModeAnnularDeterminate;
        _HUD.labelText = @"Loading";

    }

}

//放大视图
- (void)zoomIn{

    //将要放大
    if ([_delegate respondsToSelector:@selector(zoomImageViewWillZoomIn:)]) {
        [_delegate zoomImageViewWillZoomIn:self];
    }
    //创建视图
    [self _createSubViews];
    
    //隐藏原始图片
    self.hidden = YES;
    
    [UIView animateWithDuration:.3 animations:^{
       
        _fullImgView.frame = _scrollView.frame;
        
    } completion:^(BOOL finished) {
        
        //已经放大
        if ([_delegate respondsToSelector:@selector(zoomImageViewDidZoomIn:)]) {
            [_delegate zoomImageViewDidZoomIn:self];
        }

        //放大完成后,显示黑色背景
        _scrollView.backgroundColor = [UIColor blackColor];
        
        //判断是否有图片缓存
        BOOL isCache = [[SDWebImageManager sharedManager] diskImageExistsForURL:[NSURL URLWithString:_imgURL]];
        if (!isCache && _imgURL.length > 0) {
            //显示加载进度
            [_HUD show:YES];
        }
        
        //下载原始图片
        [self downLoadImg];
    }];
    
}


- (void)downLoadImg{
    
    //请求大图
    [_fullImgView sd_setImageWithURL:[NSURL URLWithString:_imgURL] placeholderImage:self.image options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
        //显示进度
        _HUD.progress = receivedSize / (float)expectedSize;
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (image == nil) {
            
            return ;
        }
        
        NSLog(@"%@",[NSThread currentThread]);
        
        //下载完成后,隐藏进度条
        [_HUD hide:YES];
        
        //1.处理图片 原图高 / 原图宽 = ? / 屏幕宽
        CGFloat height = image.size.height / image.size.width * kScreenWidth;
        
        if (height < kScreenHeight) {
            
            //居中显示图片
            _fullImgView.top = (kScreenHeight - height) / 2;
        }
        
        _fullImgView.height = height;
        
        _scrollView.contentSize = CGSizeMake(kScreenWidth, height);
        
    }];

}

//缩小视图
- (void)zoomOut{
    
    //将要缩小
    if ([_delegate respondsToSelector:@selector(zoomImageViewWillZoomOut:)]) {
        [_delegate zoomImageViewWillZoomOut:self];
    }

    
    _scrollView.backgroundColor = [UIColor clearColor];
    CGRect frame = [self convertRect:self.bounds toView:self.window];
    [UIView animateWithDuration:.3 animations:^{
        
        _fullImgView.frame = frame;
        
    } completion:^(BOOL finished) {
        
        //已经缩小
        if ([_delegate respondsToSelector:@selector(zoomImageViewDidZoomOut:)]) {
            [_delegate zoomImageViewDidZoomOut:self];
        }
        
        //移除滚动视图
        [_scrollView removeFromSuperview];
        _scrollView = nil;
        _fullImgView = nil;
        self.hidden = NO;
    }];

}

@end
