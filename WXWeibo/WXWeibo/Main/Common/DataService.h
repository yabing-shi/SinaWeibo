//
//  DataService.h
//  WXWeibo
//
//  Created by liuwei on 15/10/19.
//  Copyright (c) 2015年 wxhl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataService : NSObject

/**
 *  @param urlSting     请求的URL
 *  @param method       请求方式
 *  @param params       请求参数
 *  @param fileDic      需要上传的文件,value必须是NSData类型
 *  @param successBlock 网络请求成功回调的block
 *  @param failureBlock 网络请求失败回调的block
 */
+ (NSURLSessionDataTask *)requestWithURL:(NSString *)urlSting
            httpMethod:(NSString *)method
                params:(NSMutableDictionary *)params
              fileData:(NSMutableDictionary *)fileDic
               success:(void (^)(id result))successBlock
               failure:(void (^)(NSError *error))failureBlock;
@end
