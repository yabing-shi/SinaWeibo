//
//  SendViewController.m
//  WXWeibo
//
//  Created by wei.chen on 14-9-27.
//  Copyright (c) 2014年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "CommentViewController.h"
#import "ThemeButton.h"
#import "UIViewController+MMDrawerController.h"
#import "ZoomImageView.h"
#import "ThemeImageView.h"
#import "UIViewController+MMDrawerController.h"
#import "AFNetworking.h"
#import "DataService.h"
#import "MBProgressHUD.h"
#import "UIProgressView+AFNetworking.h"
#import <CoreLocation/CoreLocation.h>
#import "FacePannel.h"
/**
 *  iOS8以前可以直接使用CoreLocation/CoreLocation.h框架定位
 iOS8以后需要配置plist文件,告诉用户,在什么时候使用定位
 1.在应用使用期间,使用定位
 2.在任何时候都可以使用定位
 */

@interface CommentViewController ()<ZoomImageViewDelegate,CLLocationManagerDelegate,FaceViewDelegate,UITextViewDelegate>
@property (nonatomic,strong) UILabel    *tipLabel;
@property (nonatomic,strong)UIImage *sendImg;
@property (nonatomic,strong)UIWindow *tipWindow;
@property (nonatomic,strong)CLLocationManager *locationManager;
@property (nonatomic,strong)UIActivityIndicatorView *activityView;
@property (nonatomic,strong)CLLocation *location;
@property (nonatomic,strong)FacePannel *facePannel;
@end

@implementation CommentViewController
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //弹出键盘
    [_textView becomeFirstResponder];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    //监听键盘的弹出事件   UIWidow
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //1.创建导航栏上的视图
    [self _createNavigationViews];
    
    //2.创建编辑工具栏的视图
    [self _loadEditorViews];
    
}
//状态栏显示发送进度
- (void)showTipWindow:(NSURLSessionUploadTask *)task{
    
    if (_tipWindow == nil) {
        
        //创建窗口覆盖状态栏
        _tipWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        _tipWindow.backgroundColor = [UIColor blackColor];
        _tipWindow.windowLevel = UIWindowLevelStatusBar;
        _tipWindow.hidden = NO;
        
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.font = [UIFont systemFontOfSize:13];
        lable.textColor = [UIColor whiteColor];
        lable.text = @"正在发送...";
        [_tipWindow addSubview:lable];
        
        UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0,3, kScreenWidth, 5)];
        [_tipWindow addSubview:progressView];
        progressView.progress = 0;
        
        //通过af提供的类目显示上传进度
        [progressView setProgressWithUploadProgressOfTask:task animated:YES];
        
    }
    
}

#pragma mark - create UI  创建子视图
//1.创建导航栏上的视图
- (void)_createNavigationViews {
    
    //1.关闭按钮
    ThemeButton *closeButton = [[ThemeButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    closeButton.imageName = @"button_icon_close.png";
    [closeButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    [self.navigationItem setLeftBarButtonItem:closeItem];
    
    //2.发送按钮
    ThemeButton *sendButton = [[ThemeButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    sendButton.imageName = @"button_icon_ok.png";
    [sendButton addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *sendItem = [[UIBarButtonItem alloc] initWithCustomView:sendButton];
    [self.navigationItem setRightBarButtonItem:sendItem];
    
}
//2.创建编辑工具栏的视图
- (void)_loadEditorViews {
    
    //1.创建输入框视图
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 300)];
    _textView.font = [UIFont systemFontOfSize:16.0f];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.delegate = self;
    [self.view addSubview:_textView];
    
    _tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, 20)];
    _tipLabel.text = @"分享新鲜事...";
    _tipLabel.textColor = [UIColor lightGrayColor];
    _tipLabel.font = [UIFont systemFontOfSize:14];
    [_textView addSubview:_tipLabel];
    //2.创建编辑工具栏
    _editorBar = [[UIView alloc] initWithFrame:CGRectMake(0, _textView.bottom, kScreenWidth, 55)];
    _editorBar.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_editorBar];
    
    //3.创建多个编辑按钮
    NSArray *imgs = @[
                      @"compose_toolbar_1.png",
                      @"compose_toolbar_4.png",
                      @"compose_toolbar_3.png",
                      @"compose_toolbar_5.png",
                      @"compose_toolbar_6.png"
                      ];
    for (int i=0; i<imgs.count; i++) {
        NSString *imgName = imgs[i];
        ThemeButton *button = [[ThemeButton alloc] initWithFrame:CGRectMake(15+(kScreenWidth/5)*i, 20, 40, 33)];
        [button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 10+i;
        button.imageName = imgName;
        [_editorBar addSubview:button];
    }
}

#pragma mark -UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        
        UIImagePickerController *imgPick = [[UIImagePickerController alloc] init];
        imgPick.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        //监听用户选择照片的事件
        imgPick.delegate = self;
        //跳转到相册
        [self presentViewController:imgPick animated:YES completion:NULL];
    }else if (buttonIndex == 0){
        [_textView becomeFirstResponder];
    }
}

#pragma mark -UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    //获取到选中的图片
    UIImage *img = info[@"UIImagePickerControllerOriginalImage"];
    if (!img) return;
    
    ZoomImageView *imgView = [[ZoomImageView alloc] initWithFrame:CGRectMake(10, 20, 40, 30)];
    imgView.image = img;
    _sendImg = img;
    //指定代理,监听放大缩小的事件
    imgView.delegate = self;
    [_editorBar addSubview:imgView];
    
    //移动按钮
    for (NSInteger i = 0; i < 5; i++) {
        //取得按钮
        UIView *btn = [_editorBar viewWithTag:10 + i];
        btn.transform = CGAffineTransformMakeTranslation(30 - i * 5, 0);
    }
}

#pragma mark -ZoomImageViewDelegate
- (void)zoomImageViewWillZoomIn:(ZoomImageView *)zoomImg{
    
    //缩回键盘
    [_textView endEditing:YES];
    
}
- (void)zoomImageViewDidZoomOut:(ZoomImageView *)zoomImg{
    
    //弹出键盘
    [_textView becomeFirstResponder];
    
}

#pragma mark -CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations{
    
    //定位成功后,调用的协议方法
    //停止定位
    [manager stopUpdatingLocation];
    
    //获取到地理位置信息经纬度
    _location = [locations lastObject];
    
    CLLocationCoordinate2D coordinate = _location.coordinate;
    
    //纬度
    double latitude = coordinate.latitude;
    
    //经度
    double longitude = coordinate.longitude;
    
    //使用经纬度 ->位置反编码 新浪接口  location/geo/geo_to_address.json
    NSString *coordinateStr = [NSString stringWithFormat:@"%f,%f",longitude,latitude];
    NSDictionary *params = @{@"coordinate":coordinateStr};
    //请求网络,获取实际的位置信息,需要将经纬度传递给新浪
    [DataService requestWithURL:@"location/geo/geo_to_address.json" httpMethod:@"GET" params:[params mutableCopy] fileData:nil success:^(id result) {
        
        NSLog(@"%@",result);
        NSArray *geos = result[@"geos"];
        NSDictionary *addressDic = [geos lastObject];
        NSString *address = addressDic[@"address"];
        
        //停止活动视图
        [_activityView stopAnimating];
        
        UIView *loactionView = [_editorBar viewWithTag:100];
        loactionView.hidden = NO;
        
        //显示地理位置信息
        UILabel *lable =  (UILabel *)[_editorBar viewWithTag:101];
        lable.hidden = NO;
        lable.text = address;
        
        
    } failure:^(NSError *error) {
        
    }];
    
   
}

#pragma mark -FaceViewDelegate
- (void)faceView:(FaceView *)faceView didSelectedFace:(NSString *)faceName{
    
    //拼接表情
    _textView.text = [_textView.text stringByAppendingString:faceName];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    _tipLabel.hidden = YES;
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    if (textView.text.length == 0) {
        _tipLabel.hidden = NO;
    }
    return YES;
}
#pragma mark - 按钮事件
- (void)closeAction {
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)clickAction:(UIButton *)btn{
    if (btn.tag == 10) {
        [_textView endEditing:NO];
        //弹出actionSheet
        if (_facePannel != nil) {
            _editorBar.frame = CGRectMake(0, kScreenHeight - 55 - _facePannel.height - 64, kScreenWidth, 55);
        }else{
            _editorBar.frame = CGRectMake(0, kScreenHeight - 55 - 64, kScreenWidth, 55);
        }
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
        [sheet showInView:self.view];
        
    }else if(btn.tag == 13){
        //gps定位 经纬度 ->(位置反编码) 地理位置(苹果,新浪,谷歌,百度地图)
        [self requestlocation];
        
    }else if (btn.tag == 14){
        
        //判断键盘是否显示
        if (_textView.isFirstResponder) {
            
            //1.显示表情,隐藏键盘
            [self showFacePanel];
            _tipLabel.hidden = YES;
            
        }else{
            //2.隐藏表情,显示键盘
            [self hideFacePanel];
        }
    }
    
}

//显示表情
- (void)showFacePanel{
    
    if (_facePannel == nil) {
        _facePannel = [[FacePannel alloc] initWithFrame:CGRectMake(0, kScreenHeight, 0, 0)];
        
        _facePannel.faceViewDelegate = self;
        
        [self.view addSubview:_facePannel];
    }
    
    [UIView animateWithDuration:.4 animations:^{
        
        _facePannel.transform = CGAffineTransformMakeTranslation(0, -_facePannel.height - 64);
        //调整按钮工具栏与文本框的frame
        _editorBar.bottom = _facePannel.top;
        _textView.height = kScreenHeight - _editorBar.height - _facePannel.height - 64;
    }];
    
    //隐藏键盘
    [_textView endEditing:YES];
}
//隐藏表情
- (void)hideFacePanel{
    
    [UIView animateWithDuration:.4 animations:^{
        
        _facePannel.transform = CGAffineTransformIdentity;
        
    }];
    
    //弹出键盘
    [_textView becomeFirstResponder];
    
}
//定位
- (void)requestlocation{
    
    _locationManager = [[CLLocationManager alloc] init];
    
    //请求用户,获得定位的权限
    [_locationManager requestWhenInUseAuthorization];
    
    //设置精确度
    _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    
    _locationManager.delegate = self;
    
    //定位
    [_locationManager startUpdatingLocation];
    
    //显示加载提示
    if (_activityView == nil) {
        
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityView.frame = CGRectMake(10, 0,15, 15);
        
        ThemeImageView *locationView = [[ThemeImageView alloc] initWithFrame:_activityView.frame];
        locationView.imageName = @"timeline_item_address_icon.png";
        locationView.tag = 100;
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(_activityView.right,0, kScreenWidth - 30, 15)];
        lable.font = [UIFont systemFontOfSize:13];
        lable.tag  = 101;
        [_editorBar addSubview:lable];
        [_editorBar addSubview:_activityView];
        [_editorBar addSubview:locationView];
    }
    
    [_activityView startAnimating];
    UIView *view = [_editorBar viewWithTag:100];
    UIView *lable = [_editorBar viewWithTag:101];
    view.hidden = YES;
    lable.hidden = YES;
    
}
- (void)sendAction {
    
    //1.字数 > 0   字数< 140
    NSString *text = _textView.text;
    NSString *error =nil;
    
    if (text.length == 0) {
        error = @"微博内容不能为空";
        
    }else if(text.length > 140){
        error = @"微博内容不能超出140字";
    }
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    //发送微博
    [self sendStatus];
    //关闭当前页面
    [self closeAction];
}
//发送微博
- (void)sendStatus{
    [DataService requestWithURL:@"comments/create.json" httpMethod:@"POST" params:[@{@"id" : _status.idstr , @"comment" : [_textView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]} mutableCopy] fileData:nil success:^(id result) {
//        [self showCompleteView:@"评论成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        
    }];
}
//键盘弹出的通知事件
- (void)keyBoardWillShow:(NSNotification *)notification{
    NSLog(@"%@",notification.userInfo);
    //取得键盘的frame
    NSValue *value = notification.userInfo[@"UIKeyboardBoundsUserInfoKey"];
    CGRect frame = [value CGRectValue];
    //取得键盘的高度
    CGFloat height = frame.size.height;
    
    _textView.height = kScreenHeight - _editorBar.height - height - 64;
    _editorBar.top = _textView.bottom;
}

@end
