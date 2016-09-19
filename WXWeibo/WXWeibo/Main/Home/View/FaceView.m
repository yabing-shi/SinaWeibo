//
//  FaceView.m
//  WXWeibo
//
//  Created by liuwei on 15/10/20.
//  Copyright (c) 2015年 wxhl. All rights reserved.
//

#import "FaceView.h"
#define item_width 45
#define item_height 45

#define face_width 30
#define face_height 30
#define size(_plus,_6,_5) (kScreenWidth>370?(kScreenWidth>400?(_plus/3.0):(_6/2.0)):(_5/2.0))



@interface FaceView ()

@property (nonatomic,strong)UIImageView *imgView;
@property (nonatomic,copy)NSString *selectFace;

@end

@implementation FaceView

- (id)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self _loadFaceFile];
    }
    
    return self;

}

//放大镜
- (UIImageView *)imgView{
    
    if (_imgView == nil) {
        
        _imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"emoticon_keyboard_magnifier.png"]];
        [_imgView sizeToFit];
        _imgView.hidden = YES;
        [self addSubview:_imgView];
        
        UIImageView *faceImg = [[UIImageView alloc] initWithFrame:CGRectMake((_imgView.width - face_width) / 2, 15, face_width, face_height)];
        [_imgView addSubview:faceImg];
        faceImg.tag = 100;

    }
    
    return _imgView;
}

- (void)_loadFaceFile{

    //1.读取表情plist文件 [表情1,表情1,表情1,表情1,表情1,表情1,表情1]
    NSArray *emoticons = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"emoticons.plist" ofType:nil]];
    
    _items = [NSMutableArray array];
    
    NSMutableArray *item2D = nil;
    
    //2.整理数组
    for (NSInteger i = 0; i < emoticons.count; i++) {
       
        if (item2D == nil || item2D.count == size(36 * 3, 32 * 2, 28 * 2)) {
            
            item2D = [NSMutableArray arrayWithCapacity:size(36 * 3, 32 * 2, 28 * 2)];
            [_items addObject:item2D];
            
        }
        //取出标签字典
        NSDictionary *faceDic = [emoticons objectAtIndex:i];
        [item2D addObject:faceDic];
    }
    
    self.width = kScreenWidth * _items.count;
    self.height = item_height * 4;
    
    NSLog(@"%@",_items);
    
    /*分割数组
    [emoticons subarrayWithRange:NSMakeRange(28 * 0, 28)];
    [emoticons subarrayWithRange:NSMakeRange(28 * 1, 28)];
    [emoticons subarrayWithRange:NSMakeRange(28 * 2, 28)];
    [emoticons subarrayWithRange:NSMakeRange(28 * 3, 28)];
     */
}

//绘制表情
- (void)drawRect:(CGRect)rect {
    
    NSInteger colum = 0; //列  0 - 6
    NSInteger row = 0; // 行    0 - 3
    
    //1.绘制表情,遍历所有的表情  4
    for (NSInteger i = 0; i < _items.count; i++) {
        
        //28
        NSArray *item2D = _items[i];
        
        for (NSInteger j = 0; j < item2D.count; j++) {
            
            //取出表情字典
            NSDictionary *faceDic = item2D[j];
            
            //取出图片名
            NSString *imgName = faceDic[@"png"];
            
            UIImage *img = [UIImage imageNamed:imgName];
            
            //x  -> 列确定
            //y -> 行确定
            CGFloat x = colum * item_width + (item_width - face_width) / 2 + i * kScreenWidth;
            CGFloat y = row * item_height + (item_height - face_height) / 2;
            [img drawInRect:CGRectMake(x, y, face_width, face_height)];
            
            //更新行与列
            colum++; //列数+1 6
            
            if (colum == size(9 * 3, 8 * 2, 7 * 2)) {
                colum = 0; //更新列
                row++;     //更新行
            }
            
            if (row == 4) {
                row = 0;
            }

        }
        
    }
    
}

/**
 *  CGFloat x = colum * item_width + (item_width - face_width) / 2 + i * kScreenWidth;
    CGFloat y = row * item_height + (item_height - face_height) / 2;
 *
 *
 */

//根据点击的位置,取得对应的表情
- (void)touchFace:(CGPoint)point{
    
    //1.确定页数
    NSInteger page = point.x / kScreenWidth;
    
    if (page >= _items.count) {
        return;
    }
    
    //2.确定点击的行数与列数
    NSInteger colum =(point.x - ((item_width - face_width) / 2 + page * kScreenWidth)) / item_width;
    NSInteger row = (point.y - ((item_height - face_height) / 2)) / item_height;
    
    //容错处理
    //列  0 - 6
    //行  0 - 3
    if (colum > size(8 * 3, 7 * 2, 6 * 2))
        colum = size(8 * 3, 7 * 2, 6 * 2);
    if (colum < 0)
        colum = 0;
    if (row > 3)
        row = 3;
    if (row < 0)
        row = 0;
    
    //3.计算出表情在数组中的对应位置
    NSInteger index = row * size(9 * 3, 8 * 2, 7 * 2) + colum;
    
    //4.取出对应的字典
    NSArray *itme2D = _items[page];
    NSDictionary *faceDic = itme2D[index];
    NSString *imgName = faceDic[@"png"];
    NSString *faceName = faceDic[@"chs"];
    
    //5.移动放大镜视图(x,y是表情的中心点坐标)
    if (![_selectFace isEqualToString:faceName]) {
        
        CGFloat x = colum * item_width + item_width / 2 + page * kScreenWidth;
        CGFloat y = row * item_height + item_height / 2;
        self.imgView.center = CGPointMake(x, 0);
        self.imgView.bottom = y;
        
        NSLog(@"%@,%@",imgName,faceName);
        
        UIImageView *faceImg = (UIImageView *)[_imgView viewWithTag:100];
        faceImg.image = [UIImage imageNamed:imgName];
        
        _selectFace = faceName;
    }

}

//手指点击时,触发
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    //手指点击时,禁用滑动视图
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        scrollView.scrollEnabled = NO;
    }
    self.imgView.hidden = NO;
    //1.获取到点击的位置
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    [self touchFace:point];

    
}

//手指移动时触发
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    //1.获取到点击的位置
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [self touchFace:point];
}
//手指离开时触发
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    //隐藏放大镜
    self.imgView.hidden = YES;
    //手指点击时,禁用滑动视图
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        scrollView.scrollEnabled = YES;
    }
    
    //调用协议方法,将选择表情的事件传递出去
    if ([_delegate respondsToSelector:@selector(faceView:didSelectedFace:)]) {
        
        [_delegate faceView:self didSelectedFace:_selectFace];
    }
    
}

@end
