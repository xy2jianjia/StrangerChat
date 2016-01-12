//
//  LoginViewController.h
//  StrangerChat
//
//  Created by long on 15/10/12.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
{
    UIButton *shotBtn;
}

@property (nonatomic,copy) NSString *phoneNum;// 手机号
@property (nonatomic,copy) NSString *passWord;// 密码

@property (nonatomic,copy) NSString *whoVC;// 判断那个页面过来的

// 登陆成功
- (void)gotoMainView;
@end
