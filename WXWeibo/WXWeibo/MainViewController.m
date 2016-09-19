//
//  MainViewController.m
//  WXWeibo
//
//  Created by liuwei on 15/10/9.
//  Copyright (c) 2015年 wxhl. All rights reserved.
//

#import "MainViewController.h"
#import "WXNavViewController.h"
#import "Common.h"
#import "ThemeButton.h"
#import "ThemeManager.h"
#import "ThemeImageView.h"

@interface MainViewController (){
    UIImageView *selectView;
    CGFloat itemWidth;
}

@property (nonatomic,strong)ThemeImageView *tabbar;

@property (nonatomic,strong)NSMutableArray *viewCtrls;

@end

@implementation MainViewController


- (void)viewDidLoad {
    [super viewDidLoad];
 
    //监听主题切换通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themPicture) name:kThemeChangeNotification object:nil];
    //1.加载子控制器
    [self loadViewCtrls];

    //2.标签栏
    [self createTabbar];
    [self themPicture];
}

- (void)createTabbar{
    
    //将系统tabbar上的按钮移除
    for (UIView *subView in self.tabBar.subviews) {
        
        Class c = NSClassFromString(@"UITabBarButton");
        if ([subView isKindOfClass:c]) {
            
            [subView removeFromSuperview];
        }
    }
    
    //1.自定义tabbar
    _tabbar = [[ThemeImageView alloc] initWithFrame:CGRectMake(0,0, kScreenWidth, kTabBarHeight)];
    _tabbar.userInteractionEnabled = YES;
    _tabbar.imageName = @"mask_navbar.png";
    
    [self.tabBar addSubview:_tabbar];
    
    NSArray *imgNames = @[
                          @"home_tab_icon_1.png",
                          @"home_tab_icon_2.png",
                          @"home_tab_icon_3.png",
                          @"home_tab_icon_4.png",
                          @"home_tab_icon_5.png",
                          ];
    
    itemWidth = kScreenWidth / imgNames.count;
    
    selectView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, itemWidth, kTabBarHeight)];
//    selectView.backgroundColor = [UIColor greenColor];
    selectView.tag = 8888;
//    selectView.image = [UIImage imageNamed:@"detail_comment_item_selected_9.png"];
    [_tabbar addSubview:selectView];
    
    for (NSInteger i = 0; i < imgNames.count; i++) {
        
        NSString *name = imgNames[i];
        
        ThemeButton *button = [ThemeButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(itemWidth * i, 0, itemWidth, 44);
        //设置按钮对应的图片名
        button.imageName = name;
//        [button setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
        button.tag = i;
        [button addTarget:self action:@selector(selectTab:) forControlEvents:UIControlEventTouchUpInside];
        [_tabbar addSubview:button];
    }
}

- (void)selectTab:(UIButton *)btn{
    
    //切换子控制器
    self.selectedIndex = btn.tag;
    selectView.mj_x = itemWidth * btn.tag;
}


- (void)loadViewCtrls{
    
    //各个模块的故事版的名字
    NSArray *names = @[@"Home",@"Message",@"Discover",@"Profile",@"More"];
    
    //1.创建可变数组,存储导航控制器
    _viewCtrls = [NSMutableArray arrayWithCapacity:5];
    
    for (NSString *storyBoardName in names) {
        
        //2.加载故事版中的控制器
        WXNavViewController *nav = [self viewCtrlsWithStoryBoardName:storyBoardName];
        //3.将加载的导航控制器放入数组
        [_viewCtrls addObject:nav];
    }
    
    self.viewControllers = _viewCtrls;
 }

- (WXNavViewController *)viewCtrlsWithStoryBoardName:(NSString *)name{
    
    //1.加载故事版中的控制器
    UIStoryboard *homeStoryBorad = [UIStoryboard storyboardWithName:name bundle:nil];
    
    //2.加载对应故事版中的导航控制器
    WXNavViewController *nav = [homeStoryBorad instantiateInitialViewController];
    
    return nav;
}

- (void)themPicture{
    UIImage *img = [[ThemeManager shareManager] getThemeImageWithImageName:@"detail_tab_9"];
    UIImageView *selectView = [self.tabbar viewWithTag:8888];
    selectView.image = img;
}

@end
