//
//  XSFooterRefresh.m
//  xiangshangV3
//
//  Created by SPIREJ on 16/2/23.
//  Copyright © 2016年 xiangshang360. All rights reserved.
//

#import "XSFooterRefresh.h"

@interface XSFooterRefresh()
{
    UILabel *_tipLabel;
    UIActivityIndicatorView *_activeView;
}

@end


@implementation XSFooterRefresh
#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    // 设置控件的高度
    self.mj_h = 80;
    self.mj_w = kScreenWidth;
    
    _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    _tipLabel.center = CGPointMake(self.mj_w*0.5, 30);
    _tipLabel.textColor = [UIColor blackColor];
    [_tipLabel setFont:[UIFont systemFontOfSize:13]];
    _tipLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_tipLabel];
    
    _activeView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    _activeView.center = _tipLabel.center;
    [_activeView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    _activeView.color = [UIColor darkGrayColor];
    [self addSubview:_activeView];
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
}
#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
            _tipLabel.hidden = NO;
            _tipLabel.text = @"上拉加载";
            [_activeView stopAnimating];
            break;
        case MJRefreshStatePulling:
            _tipLabel.hidden = NO;
            _tipLabel.text = @"松开加载";
            [_activeView stopAnimating];
            break;
        case MJRefreshStateRefreshing:
            _tipLabel.hidden = YES;
            [_activeView startAnimating];
            break;
        case MJRefreshStateNoMoreData:
            _tipLabel.text = @"已经加载全部";
        default:
            break;
    }
}



#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
}

@end

