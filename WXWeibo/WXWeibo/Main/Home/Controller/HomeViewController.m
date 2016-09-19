//
//  HomeViewController.m
//  WXWeibo
//
//  Created by liuwei on 15/10/9.
//  Copyright (c) 2015年 wxhl. All rights reserved.
//

#import "HomeViewController.h"
#import "ThemeManager.h"
#import "ThemeLable.h"
#import "StatusModel.h"
#import "UserModel.h"
#import "WeiboTableView.h"
#import "WeiboContentViewLayout.h"
#import "MJRefresh.h"
#import "ThemeImageView.h"
#import <AudioToolbox/AudioToolbox.h>
#import "UIViewController+MMDrawerController.h"
#import "UMSocial.h"
#import "DataService.h"
#import "loginViewController.h"

@interface HomeViewController (){
    BOOL isPulling;
    NSString *maxId,*firstId;
}

@property (weak, nonatomic) IBOutlet WeiboTableView *weiboTableView;
@property (nonatomic,strong)NSMutableArray *statusList;
@property (nonatomic,strong)ThemeImageView *notifyView;
@property (nonatomic,strong)NSMutableDictionary *param;

@end

@implementation HomeViewController{

    UIWindow *window;
}

- (NSMutableDictionary *)param{
    if (_param == nil) {
        _param = [NSMutableDictionary dictionary];
    }
    if (!isPulling) {
        [_param setObject:maxId forKey:@"max_id"];
    }

    return _param;
}

- (NSMutableArray *)statusList{
    
    if (_statusList == nil) {

        _statusList = [NSMutableArray array];
    }
    
    return _statusList;
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    //打开左右侧滑
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.mm_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];

}

- (void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    //关闭左右侧滑关闭(只有在首页才能使用左右侧滑)
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    [self.mm_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];

}
- (ThemeImageView *)notifyView{
    
    if (_notifyView == nil) {
        
        _notifyView = [[ThemeImageView alloc] initWithFrame:CGRectMake(5, -40, kScreenWidth - 10, 40)];
        _notifyView.imageName = @"timeline_notify.png";
        
        [self.view addSubview:_notifyView];
        
        ThemeLable *lable = [[ThemeLable alloc] initWithFrame:_notifyView.bounds];
        lable.tag = 100;
        lable.fontColor = @"Timeline_Notice_color";
        lable.backgroundColor = [UIColor clearColor];
        lable.textAlignment = NSTextAlignmentCenter;
        [_notifyView addSubview:lable];
        
    }
    
    return _notifyView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //接收消息 自己写个action的动作
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(webViewController:)
                                                 name:@"WEBVIEW" object:nil];
    maxId = @"0";
    [self loadData];
    [self refresh];
}
- (void)webViewController:(NSNotification *)not{
    XSCommonWebViewController *webView = [[XSCommonWebViewController alloc]init] ;
    webView.urlStr = not.object;
    webView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webView animated:YES];
}
//加载第一页数据
- (void)loadFirstStatusData{
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"SinaWeiboAuthData"];
    if ([token isKindOfClass:[NSString class]]) {
        [self loadData];
    }else{
       
    }

    
}

- (void)loadData{
    [self showHUDLoading];
    
    [DataService requestWithURL:@"statuses/friends_timeline.json" httpMethod:@"GET" params:self.param fileData:nil success:^(id result) {
        //隐藏加载提示
        [self hideHUDLoading];
        //取出微博列表
        NSArray *statuses = result[@"statuses"];
        
        //存储请求下来的微博数据
        NSMutableArray *tempStatues = [NSMutableArray array];
        
        if (statuses.count > 0) {
            
            for (NSDictionary *statusDic in statuses) {
                
                //创建微博对象,使用BaseModel给model中的属性赋值
                StatusModel *status = [[StatusModel alloc] initWithDataDic:statusDic];
                
                //创建微博视图的布局类
                WeiboContentViewLayout *layout = [[WeiboContentViewLayout alloc] init];
                //将微博信息存储到布局类中
                layout.status = status;
                [tempStatues addObject:layout];
            }
            _weiboTableView.hidden = NO;
            if (isPulling) {
                //将微博数据存储到全局的数组中
                self.statusList = tempStatues;
            }else{
                [self.statusList removeLastObject];
                [self.statusList addObjectsFromArray:tempStatues];
            }
            //将数据交给表视图显示
            _weiboTableView.statusList = self.statusList;
            //刷新表视图
            [_weiboTableView reloadData];
            
            
            if (isPulling) {
                for (NSInteger i = 0; i < tempStatues.count; i ++) {
                    WeiboContentViewLayout *layout = tempStatues[i];
                    if ([layout.status.idstr isEqualToString:firstId]) {
                        [self showNewWeiboCount:i];
                    }
                }
            }
            WeiboContentViewLayout *lastLayout = [tempStatues lastObject];
            WeiboContentViewLayout *firstLayout = [tempStatues firstObject];
            maxId = lastLayout.status.idstr;
            firstId = firstLayout.status.idstr;
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error.userInfo[@"NSLocalizedDescription"]);
        [self hideHUDLoading];
        if ([error.userInfo[@"NSLocalizedDescription"] rangeOfString:@"400"].location != NSNotFound) {
            [self.navigationController presentViewController:[[loginViewController alloc]init] animated:YES completion:nil];
        }else if ([error.userInfo[@"NSLocalizedDescription"] rangeOfString:@"403"].location != NSNotFound){
            [self showCompleteView:@"接口请求次数超限，请明天再试"];
        }
    }];

}

- (void)refresh{
    //    刷新
    __weak UITableView *tableView = self.weiboTableView;
    XSHeaderRefresh *normalHeader = [XSHeaderRefresh headerWithRefreshingBlock:^{
        tableView.header.state = MJRefreshStateIdle;
        [tableView.footer resetNoMoreData];
        isPulling = YES;
        maxId = @"0";
        [self loadData];
        
        [tableView.header endRefreshing];
    }];
    normalHeader.automaticallyChangeAlpha = YES;
    tableView.header = normalHeader;
    XSFooterRefresh *foot = [XSFooterRefresh footerWithRefreshingBlock:^{
        isPulling = NO;
        [self loadData];
        [tableView.footer endRefreshing];
    }];
    foot.ignoredScrollViewContentInsetBottom = YES;
    tableView.footer = foot;
    
}


//显示未读微博的数量
- (void)showNewWeiboCount:(NSInteger)count{
    
    if (count <= 0) {
        
        return;
    }
    
    UILabel *lable = (UILabel *)[self.notifyView viewWithTag:100];
    lable.text = [NSString stringWithFormat:@"%ld条新微博",count];
    [UIView animateWithDuration:.6 animations:^{
        
        self.notifyView.transform = CGAffineTransformMakeTranslation(0, 40 + kNavgationBarHeight + 10);
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:.6 animations:^{
            //延迟执行动画
            [UIView setAnimationDelay:2];
            self.notifyView.transform = CGAffineTransformIdentity;
        }];
        
    }];
    
    //_______________播放系统声音____________
    //1.读取音频文件
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"msgcome.wav" ofType:nil];
    
    NSURL *url = [NSURL fileURLWithPath:filePath];
    
    SystemSoundID soundID = 0;
    
    //2.注册音频文件
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &soundID);
    
    //3.播放音频文件
    AudioServicesPlaySystemSound(soundID);
    
    
}

@end
