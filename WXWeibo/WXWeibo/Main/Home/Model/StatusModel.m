//
//  StatusModel.m
//  WXWeibo
//
//  Created by liuwei on 15/10/12.
//  Copyright (c) 2015年 wxhl. All rights reserved.
//

#import "StatusModel.h"
#import "RegexKitLite.h"
#import "UIUtils.h"

@implementation StatusModel

/**
 *  重写baseModel中的方法,给没有定义的属性赋值
    dataDic:model对象创建时传入的字典
 */
- (void)setAttributes:(NSDictionary*)dataDic {
    
    //调用父类的方法(父类的方法中会给其他的属性赋值)
    [super setAttributes:dataDic];
    
    NSDictionary *userDic = [dataDic objectForKey:@"user"];
    
    //创建User对象
    UserModel *user = [[UserModel alloc] initWithDataDic:userDic];
    self.user = user;
    
    //转发的原微博
    NSDictionary *reStatusDic = dataDic[@"retweeted_status"];
    
#warning 添加转发微博的作者,处理微博的来源
    //如果是转发的微博
    if (reStatusDic) {
        
         StatusModel *reStatus = [[StatusModel alloc] initWithDataDic:reStatusDic];
         self.reStatus = reStatus;
        
        //取得转发微博的内容
        NSString *reText = self.reStatus.text;
        //取得转发微博的作者
        NSString *user = self.reStatus.user.screen_name;
        //拼接
        self.reStatus.text = [NSString stringWithFormat:@"@%@:%@",user,reText];
        
    }
    
    // <a href="http://weibo.com/" rel="nofollow">微博 weibo.com</a>
    
        //取得微博来源
        NSString *source = self.source;
        //定义正则表达式
        NSString *sourceRegex = @">.+<";
        NSArray *array = [source componentsMatchedByRegex:sourceRegex];
        
        //result = >iphone6<
        NSString *result = [array firstObject];
        if (result) {
            NSRange range = [source rangeOfString:result];
            range.location += 1;
            range.length -= 2;
            self.source = [source substringWithRange:range];
        }
    
    //3.处理表情图片的显示
    self.text = [UIUtils parseTextImage:self.text];
    
    //处理微博表情 [笑脸]  -> <image url = '001.png'>
    NSString *faceRegex = @"\\[\\w+\\]";
    
    //使用正则表达式,找出所有的表情[@"[兔子]",@"[笑脸]"]
    NSArray *faces = [self.text componentsMatchedByRegex:faceRegex];
    
    //读取表情配置字典
    NSArray *faceArr = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"emoticons.plist" ofType:nil]];
    
//    faceStr = [兔子];
    for (NSString *faceStr in faces) {
        
        //使用谓词过滤出符合条件的字典
        NSString *s = [NSString stringWithFormat:@"chs = '%@'",faceStr];
        NSArray *result = [faceArr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:s]];
        NSDictionary *dic = [result firstObject];
        
        //取出对应的图片
        NSString *imgName = dic[@"png"];
        
        // [兔子] --> <image url = '001.png'>
        NSString *imgUrl = [NSString stringWithFormat:@"<image url = '%@'>",imgName];
        
        //替换字符串
       self.text = [self.text stringByReplacingOccurrencesOfString:faceStr withString:imgUrl];
        
    }
    
 }

@end
