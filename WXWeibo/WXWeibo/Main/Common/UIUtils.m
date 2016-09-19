//
//  UIUtils.m
//  WXTime
//
//  Created by wei.chen on 12-7-22.
//  Copyright (c) 2012年 www.iphonetrain.com 无限互联ios开发培训中心 All rights reserved.
//

#import "UIUtils.h"
#import <CommonCrypto/CommonDigest.h>
#import "RegexKitLite.h"

@implementation UIUtils

//处理文本中显示的图片
+ (NSString *)parseTextImage:(NSString *)text {
    //[哈哈]--->图片名 ----> 替换成： <image url = '图片名'>
    NSString *faceRegex = @"\\[\\w+\\]";
    NSArray *faceItem = [text componentsMatchedByRegex:faceRegex];
    
    //1>.读取emoticons.plist 表情配置文件
    NSString *configPath = [[NSBundle mainBundle] pathForResource:@"emoticons" ofType:@"plist"];
    NSArray *faceConfig = [NSArray arrayWithContentsOfFile:configPath];
    
    //2>.循环、遍历所有的查找出来的表情名：[哈哈]、[赞]、....
    for (NSString *faceName in faceItem) {
        //faceName = [哈哈]
        
        //3.定义谓词条件，到emoticons.plist中查找表情名对应的表情item
        NSString *t = [NSString stringWithFormat:@"self.chs='%@'",faceName];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:t];
        NSArray *items = [faceConfig filteredArrayUsingPredicate:predicate];
        
        if (items.count > 0) {
            //4.取得过滤出来的表情item
            NSDictionary *faceDic = items[0];
            
            //5.取得图片名
            NSString *imgName = faceDic[@"png"];
            
            //6.构造表情表情 <image url = '图片名'>
            NSString *replace = [NSString stringWithFormat:@"<image url = '%@'>",imgName];
            
            //7.替换：将[哈哈] 替换成 <image url = '90.png'>
            text = [text stringByReplacingOccurrencesOfString:faceName withString:replace];
            
        }
        
    }
    
    return text;
}

+ (NSString *)getDocumentsPath:(NSString *)fileName {
    
    //两种获取document路径的方式
//    NSString *documents = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documents = [paths objectAtIndex:0];
    NSString *path = [documents stringByAppendingPathComponent:fileName];
    
    return path;
}

+ (NSString*) stringFromFomate:(NSDate*) date formate:(NSString*)formate {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:formate];
	NSString *str = [formatter stringFromDate:date];
	return str;
}

+ (NSDate *) dateFromFomate:(NSString *)datestring formate:(NSString*)formate {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    //设置本地的环境
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en-US"];
    
    [formatter setDateFormat:formate];
    
    NSDate *date = [formatter dateFromString:datestring];
    return date;
}

//Sat Jan 12 11:50:16 +0800 2013
+ (NSString *)fomateString:(NSString *)datestring {
    NSString *formate = @"E MMM d HH:mm:ss Z yyyy";
    

    NSDate *createDate = [UIUtils dateFromFomate:datestring formate:formate];
    NSString *text = [UIUtils stringFromFomate:createDate formate:@"MM-dd HH:mm"];
    return text;
}

@end
