//
//  WeiboTableView.h
//  WXWeibo
//
//  Created by liuwei on 15/10/12.
//  Copyright (c) 2015年 wxhl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeiboTableView : UITableView<UITableViewDataSource,UITableViewDelegate>


@property (nonatomic,strong)NSArray *statusList;


@end
