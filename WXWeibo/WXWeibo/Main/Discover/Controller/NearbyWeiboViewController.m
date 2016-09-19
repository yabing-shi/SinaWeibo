//
//  NearbyWeiboViewController.m
//  WXWeibo
//
//  Created by liuwei on 15/10/20.
//  Copyright (c) 2015年 wxhl. All rights reserved.
//

#import "NearbyWeiboViewController.h"
#import <MapKit/MapKit.h>
#import "WeiboAnnotation.h"
#import "DataService.h"
#import "StatusModel.h"
#import "StatusAnnotationView.h"

@interface NearbyWeiboViewController ()<CLLocationManagerDelegate,MKMapViewDelegate>

@property (nonatomic,strong)CLLocationManager *locationManger;

@property (nonatomic,strong)MKMapView *mapView;

@end


/**
 *在地图上显示标注视图MKAnnotationView
 
    1.创建MKAnnotation协议(model,用来记录标注视图的位置)
    2.将MKAnnotation类创建的对象加到地图上
    3.实现协议方法,自己创建标注视图
 */

@implementation NearbyWeiboViewController

- (id)initWithCoder:(NSCoder *)aDecoder{

    self = [super initWithCoder:aDecoder];
    if (self) {
        
        self.hidesBottomBarWhenPushed = YES;
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建地图
    _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    //地图的类型  MKMapTypeSatellite卫星地图
    _mapView.mapType = MKMapTypeStandard;
    
    //显示用户的位置(触发协议方法,显示标注视图)
    _mapView.showsUserLocation = YES;
    
    _mapView.delegate = self;
    
    [self.view addSubview:_mapView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"img_detail_close.png"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(10, 10, 0, 0);
    [btn sizeToFit];
    [btn addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

    
    //定位
    _locationManger = [[CLLocationManager alloc] init];
    _locationManger = [CLLocationManager new];
    //设置精确度
    _locationManger.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    _locationManger.delegate = self;
    [_locationManger startUpdatingLocation];
    
    /*
    //创建MKAnnotation用来在地图上显示标注
    WeiboAnnotation *annotatino = [[WeiboAnnotation alloc] init];
    annotatino.coordinate = CLLocationCoordinate2DMake(39.925398, 116.152992);
    
    //设置标题
    annotatino.title = @"无线互联";
    //将annotatino添加到地图,会触发mapView的协议方法,创建标注视图
    [_mapView addAnnotation:annotatino];
     */
    
    [self.view sendSubviewToBack:_mapView];
    
}

- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)clickAction{
    
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)loadNearbyStatusData:(CLLocationCoordinate2D)coordinate{
    
    //请求参数 新浪服务器 
    NSDictionary *params = @{@"lat" : [NSString stringWithFormat:@"%f",coordinate.latitude],@"long":[NSString stringWithFormat:@"%f",coordinate.longitude]};
    [DataService requestWithURL:nearbyStatus httpMethod:@"GET" params:[params mutableCopy] fileData:nil success:^(id result) {
        if ([result isKindOfClass:[NSArray class]]) {
            return ;
        }
        //取出微博列表
        NSArray *statuses = result[@"statuses"];
        
        //存储请求下来的微博数据
        NSMutableArray *tempStatues = [NSMutableArray array];
        
        if (statuses.count > 0) {
            
            for (NSDictionary *statusDic in statuses) {
                
                //创建微博对象,使用BaseModel给model中的属性赋值
                StatusModel *status = [[StatusModel alloc] initWithDataDic:statusDic];
                //取出geoannotation
                WeiboAnnotation *annotatino = [[WeiboAnnotation alloc] init];
                //将微博信息交给annotatino
                annotatino.status = status;
                
                [tempStatues addObject:annotatino];
                
            }
            
            //将annotatino对象加到地图上
            [_mapView addAnnotations:tempStatues];
        }

    } failure:^(NSError *error) {
       
        NSLog(@"%@",error);
    }];

}

#pragma mark -CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    //停止定位
    [manager stopUpdatingLocation];
    
    //取得用户所在的位置
    CLLocation *location = [locations lastObject];
    //取得经纬度
    CLLocationCoordinate2D coordinate = location.coordinate;
    
    //请求附近的微博数据
    [self loadNearbyStatusData:coordinate];

    //span控制区域的详细程度,值越小,地图越详细
    MKCoordinateSpan span = MKCoordinateSpanMake(.03, .03);
    
    MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, span);
    //设置地图的显示区域
    [_mapView setRegion:region animated:YES];

}

#pragma mark -MKAnnotationViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    
    //如果是用户自己的位置,不需要显示大头针
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        
        return nil;
    }
    
    static NSString *identy = @"map";
    
    //自定义标注视图
    StatusAnnotationView *view = (StatusAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identy];
    
    if (view == nil) {
        
        view = [[StatusAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identy];
        
    }
    
    return view;
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views{


    for (NSInteger i = 0; i < views.count; i++) {
        
        StatusAnnotationView *annotationView = views[i];
        
        annotationView.transform = CGAffineTransformMakeScale(.5, .5);
        
        //给标注视图增加动画
        [UIView animateWithDuration:.2 animations:^{
            annotationView.transform = CGAffineTransformMakeScale(1.3, 1.3);
            
            //动画延迟
//            [UIView setAnimationDelay:.1 * i];
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:.1 animations:^{
                
                annotationView.transform = CGAffineTransformMakeScale(1, 1);

            }];
        }];
        
    }

}



@end
