//
//  DetailViewController.m
//  WXWeibo
//
//  Created by liuwei on 15/10/16.
//  Copyright (c) 2015年 wxhl. All rights reserved.
//

#import "DetailViewController.h"
#import "WeiboContentView.h"
#import "CommentTableView.h"
#import "DataService.h"
#import "CommentModel.h"
#import "MJRefresh.h"
#import "CommentViewController.h"
@interface DetailViewController (){
    BOOL isPulling;
    NSString *weiboId,*max_id;
}
@property (weak, nonatomic) IBOutlet CommentTableView *commentTableView;

@property (nonatomic,strong)NSMutableArray *dataModel,*dataArray;

@end

@implementation DetailViewController

- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:@"COMMENT"];
    [[NSNotificationCenter defaultCenter]removeObserver:@"RELAY"];
    [[NSNotificationCenter defaultCenter]removeObserver:@"ZAN"];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    isPulling = YES;
    max_id = @"0";
    //加载第一页数据
    [self _loadCommentData];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    weiboId = self.status.idstr;
    self.navigationItem.title = @"详情";
    //接收消息 自己写个action的动作
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(webViewController:)
                                                 name:@"WEBVIEWDETAIL" object:nil];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 40, 30);
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.navigationItem.leftBarButtonItem = item;
    
    //将微博数据交给评论表视图
    _commentTableView.status = _status;
    
    
    //下拉刷新
    _commentTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        isPulling = YES;
        [self _loadCommentData];
    }];
    
    //上拉加载
    _commentTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        isPulling = NO;
        [self _loadCommentData];
    }];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(commentButton:) name:@"COMMENT" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(relayButton:) name:@"RELAY" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(goodButton:) name:@"ZAN" object:nil];

}

- (void)clickAction{

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 加载数据
//1.加载第一页评论数据
- (void)_loadCommentData {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:weiboId forKey:@"id"];
    if (!isPulling) {
        [params setObject:max_id forKey:@"max_id"];
    }
    [DataService requestWithURL:@"comments/show.json" httpMethod:@"GET" params:params fileData:nil success:^(id result) {
        NSLog(@"%@",result);
        [self afterLoadData:result];
        
    } failure:^(NSError *error) {
        NSLog(@"请求失败");
    }];
}

- (void)afterLoadData:(NSDictionary *)result {
    NSArray *tempArr = [result objectForKey:@"comments"];
    if (tempArr.count < 50) {
        [_commentTableView.footer endRefreshingWithNoMoreData];
    }
    if (!isPulling) {
        [self.dataArray removeLastObject];
        [self.dataArray addObjectsFromArray:tempArr];
    }else{
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:tempArr];
    }
    _dataModel = [NSMutableArray array];
    for (NSDictionary *dic in self.dataArray) {
        CommentModel *commentModel = [[CommentModel alloc] initWithDataDic:dic];
        [_dataModel addObject:commentModel];
    }
    
    //将评论列表数据交给表视图
    _commentTableView.data = _dataModel;
    //将评论数等信息交给表视图
    _commentTableView.commentDic = result;
    [_commentTableView reloadData];
    
    //收起下拉
    [_commentTableView.header endRefreshing];
    max_id = [tempArr lastObject][@"idstr"];
}

- (void)webViewController:(NSNotification *)not{
    XSCommonWebViewController *webView = [[XSCommonWebViewController alloc]init] ;
    webView.urlStr = not.object;
    webView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webView animated:YES];
}

- (void)commentButton:(NSNotification *)not{
    NSLog(@"评论");
    CommentViewController *comment = [CommentViewController alloc];
    comment.status = self.status;
    [self.navigationController pushViewController:comment animated:YES];
}

- (void)relayButton:(NSNotification *)not{
    NSLog(@"转发");
    
    [DataService requestWithURL:@"statuses/repost.json" httpMethod:@"POST" params:[@{@"id" : self.status.idstr} mutableCopy] fileData:nil success:^(id result) {
        [self.navigationController popViewControllerAnimated:YES];
        [self showCompleteView:@"发送成功"];
    } failure:^(NSError *error) {
        
    }];
}

- (void)goodButton:(NSNotification *)not{
    NSLog(@"赞");
}

@end
