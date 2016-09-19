//
//  CommentViewController.h
//  WXWeibo
//
//  Created by shiyabing on 16/4/29.
//  Copyright © 2016年 wxhl. All rights reserved.
//

#import "BaseViewController.h"
#import "StatusModel.h"

@interface CommentViewController : BaseViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    //1.编辑输入框
    UITextView *_textView;
    //2.工具栏
    UIView *_editorBar;
}

@property (nonatomic,strong)StatusModel *status;

@end
