//
//  CheckViewController.h
//  StrangerChat
//
//  Created by long on 15/10/19.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckViewController : UIViewController

@property (nonatomic,copy) NSString *phoneNum;// 手机号
@property (nonatomic,copy) NSString *passWord;// 密码

@property (nonatomic,assign) NSInteger isSex;// 性别
@property (nonatomic,strong) NSString *userName;// 昵称
@property (nonatomic,strong) NSString *birthDay;// 生日日期
@property (nonatomic,assign) NSInteger wantNum;// 意向

@end
