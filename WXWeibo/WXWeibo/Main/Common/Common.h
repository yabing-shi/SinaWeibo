//
//  Common.h
//  WXMovie
//
//  Created by liuwei on 15/8/26.
//  Copyright (c) 2015年 wxhl. All rights reserved.
//

#ifndef WXMovie_Common_h
#define WXMovie_Common_h


//Xcode 5 PCH文件

//Xcode 6需要手动添加


#define kScreenWidth [UIScreen  mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kTabBarHeight 49
#define kNavgationBarHeight 64

//周边的微博
#define nearbyStatus @"place/nearby_timeline.json"


#define kAppKey             @"1866503151"
#define kAppSecret          @"579f89927845304d21571fee9ae73a7f"
#define kAppRedirectURI     @"https://api.weibo.com/oauth2/default.html"

//微博字体大小
#define FontSize_Status(isDetail) isDetail ? 16 : 14
//转发微博字体大小
#define FontSize_ReStatus(isDetail) isDetail ? 14 : 12

#endif
