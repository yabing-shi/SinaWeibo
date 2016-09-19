//
//  SendViewController.h
//  WXWeibo
//
//  Created by wei.chen on 14-9-27.
//  Copyright (c) 2014年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "BaseViewController.h"

@interface SendViewController : BaseViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate> {
    //1.编辑输入框
    UITextView *_textView;
    //2.工具栏
    UIView *_editorBar;
    

}

@end
