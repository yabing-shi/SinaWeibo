//
//  DataService.m
//  WXWeibo
//
//  Created by liuwei on 15/10/19.
//  Copyright (c) 2015年 wxhl. All rights reserved.
//

#import "DataService.h"
#import "AFNetworking.h"

#define BASE_URL @"https://api.weibo.com/2/"

@implementation DataService

//SDK
+ (NSURLSessionDataTask *)requestWithURL:(NSString *)urlSting
            httpMethod:(NSString *)method
                params:(NSMutableDictionary *)params
              fileData:(NSMutableDictionary *)fileDic
               success:(void (^)(id result))successBlock
               failure:(void (^)(NSError *error))failureBlock {

    //1.拼接URL
    urlSting = [BASE_URL stringByAppendingString:urlSting];
    
    //2.拼接token
    //读取本地存储的授权信息
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSDictionary *sinaweiboInfo = [defaults objectForKey:@"SinaWeiboAuthData"];
    NSString *accessTokenKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"SinaWeiboAuthData"];
    [params setObject:accessTokenKey forKey:@"access_token"];
    
    //创建AFHTTPSessionManager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    if ([method caseInsensitiveCompare:@"GET"] == NSOrderedSame) {
        
        return [manager GET:urlSting parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
            
            //回调block
            successBlock(responseObject);
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            failureBlock(error);
        }];
    }else if([method caseInsensitiveCompare:@"POST"] == NSOrderedSame){
    
        //是否需要上传文件  fileDic  {pic : 数据}
        if (fileDic) {
            
            return [manager POST:urlSting parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                
                for (NSString *key in fileDic) {
                    
                    NSData *data = fileDic[key];
                    
                    [formData appendPartWithFileData:data name:key fileName:key mimeType:@"image/jpeg"];
                }
                
                
            } success:^(NSURLSessionDataTask *task, id responseObject) {
                
                successBlock(responseObject);
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
                failureBlock(error);
            }];
          
            //不上传文件
        }else {
        
            return [manager POST:urlSting parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
                successBlock(responseObject);
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                failureBlock(error);
            }];
        
        }
    
    }
   
    return nil;
}

@end
