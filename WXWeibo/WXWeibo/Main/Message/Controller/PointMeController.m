//
//  ProfileViewController.m
//  WXWeibo
//
//  Created by liuwei on 15/10/9.
//  Copyright (c) 2015年 wxhl. All rights reserved.
//

#import "PointMeController.h"
#import "PointMeCell.h"
#import "DataService.h"
#import "StatusModel.h"
#import "UIImageView+WebCache.h"
#import "WeiboContentViewLayout.h"
#import "ThemeLable.h"
#import "loginViewController.h"
#import "DetailViewController.h"

@interface PointMeController ()<UITableViewDelegate,UITableViewDataSource>{
    BOOL isPulling;
    NSString *maxId,*firstId;
    WeiboContentViewLayout *headLayout;
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)NSMutableDictionary *param;

@end

@implementation PointMeController

- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableDictionary *)param{
    if (_param == nil) {
        _param = [NSMutableDictionary dictionary];
    }
    if (!isPulling) {
        [_param setObject:maxId forKey:@"max_id"];
    }else{
        [_param setObject:@"0" forKey:@"max_id"];
    }
    return _param;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"@我的";
    //监听主题切换通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themPic) name:kThemeChangeNotification object:nil];
    
    isPulling = YES;
    maxId = @"0";
    [self loadData];
    [self creatSubViews];
    [self refresh];
}

- (void)refresh{
    //    刷新
    __weak UITableView *tableView = self.tableView;
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

- (void)creatSubViews{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64 - 9) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerClass:[PointMeCell class] forCellReuseIdentifier:@"POINTMECELL"];
    self.tableView.dataSource = self;
    self.tableView.delegate   = self;
    
    
    [self.view addSubview:self.tableView];
}

- (void)loadData{
    [self showHUDLoading];
    [DataService requestWithURL:@"statuses/mentions.json" httpMethod:@"GET" params:self.param fileData:nil success:^(id result) {
        [self hideHUDLoading];
        NSLog(@"%@",result);
        NSArray *statuses = result[@"statuses"];
        NSMutableArray *tempStatues = [NSMutableArray array];
        for (NSDictionary *dic in statuses) {
            StatusModel *model = [[StatusModel alloc]initWithDataDic:dic];
            model.user.descrip = dic[@"user"][@"description"];
            WeiboContentViewLayout *layout = [[WeiboContentViewLayout alloc]init];
            layout.isDetail = YES;
            layout.status = model;
            [tempStatues addObject:layout];
        }
        if (isPulling) {
            //将微博数据存储到全局的数组中
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:tempStatues];
        }else{
            [self.dataArray addObjectsFromArray:tempStatues];
        }
        if (tempStatues.count < 20) {
            [self.tableView.footer endRefreshingWithNoMoreData];
        }else{
            [self.tableView.footer endRefreshing];
        }
        WeiboContentViewLayout *lastLayout = [tempStatues lastObject];
        WeiboContentViewLayout *firstLayout = [tempStatues firstObject];
        if ([lastLayout.status.idstr isKindOfClass:[NSString class]]) {
            maxId = lastLayout.status.idstr;
        }
        firstId = firstLayout.status.idstr;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        [self hideHUDLoading];
        if ([error.userInfo[@"NSLocalizedDescription"] rangeOfString:@"400"].location != NSNotFound) {
            [self.navigationController presentViewController:[[loginViewController alloc]init] animated:YES completion:nil];
            [self showCompleteView:@"认证超时，请重新登录"];
        }else if ([error.userInfo[@"NSLocalizedDescription"] rangeOfString:@"403"].location != NSNotFound){
            [self showCompleteView:@"请求次数超限，请明天再试"];
        }    }];
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //取得布局对象
    WeiboContentViewLayout *layout = self.dataArray[indexPath.row];
    
    return layout.frame.size.height + 110;
    
    return 110;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PointMeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"POINTMECELL" forIndexPath:indexPath];
    cell.layout = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WeiboContentViewLayout *layout = self.dataArray[indexPath.row];
    
    //跳转到详情页
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    DetailViewController *detailCtrl = [storyBoard instantiateViewControllerWithIdentifier:@"detailCtrl"];
    detailCtrl.hidesBottomBarWhenPushed = YES;
    
    //将微博数据交给详情页
    detailCtrl.status = layout.status;
    
    [self.navigationController pushViewController:detailCtrl animated:YES];
    
}

- (void)themPic{
    for (NSInteger i = 0; i < self.dataArray.count; i ++) {
        PointMeCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        cell.topLabel.bgColor = @"Channel_Dot_color";
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
