//
//  CommentTableView.h
//  WXWeibo
//
//  Created by liuwei on 15/10/16.
//  Copyright (c) 2015年 wxhl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StatusModel.h"

@interface CommentTableView : UITableView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)StatusModel *status;

@property (nonatomic,strong)NSArray *data;

@property (nonatomic,strong)NSDictionary *commentDic;

@property(nonatomic,strong)UIButton *countBtn,*relayBtn,*goodBtn;


@end
