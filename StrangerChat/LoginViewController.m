//
//  LoginViewController.m
//  StrangerChat
//
//  Created by long on 15/10/12.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "LoginViewController.h"
#import "ViewController.h"
#import "FirstViewController.h"
#import "RegisterViewController.h"
@interface LoginViewController () <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITextField *textFeild;
@property (nonatomic,strong) UITextField *passwordTextFeild;
@property (nonatomic,strong) UIButton *registerBtn;// 注册按钮
@property (nonatomic,strong) UIButton *findButton;// 找回密码按钮

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation LoginViewController
static BOOL isPush = NO;
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (iPhone4) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login-bg21.png"]];
    }else if (iPhone5){
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login-bg2.png"]];
    }else if (iPhone6){
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login-bg23.png"]];
    }else{
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login-bg24.png"]];
    }
    self.title = @"登陆";
   
    UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, got(80), got(80))];
    headImageView.center = CGPointMake(ScreenWidth/2, gotHeight(120));
    headImageView.layer.cornerRadius = got(40);
    headImageView.clipsToBounds = YES;
    headImageView.image = [UIImage imageNamed:@"icon-boy.png"];
    [self.view addSubview:headImageView];
    
//    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, got(40), gotHeight(20))];
//    headerLabel.center = CGPointMake(ScreenWidth/2, gotHeight(180));
//    //_headerLabel.backgroundColor = [UIColor redColor];
//    headerLabel.text = @"头像";
//    headerLabel.textAlignment = NSTextAlignmentCenter;
//    headerLabel.textColor = [UIColor blackColor];
//    headerLabel.font = [UIFont systemFontOfSize:got(16)];
//    [self.view addSubview:headerLabel];
    
    
    // 分割线
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, gotHeight(210), ScreenWidth,1)];
    lineLabel.backgroundColor = HexRGB(0Xd0d0d0);
    [self.view addSubview:lineLabel];
        
    //设置账号输入框
    self.textFeild = [[UITextField alloc] initWithFrame:CGRectMake(got(20), gotHeight(215), got(240), gotHeight(43))];
    _textFeild.delegate = self;
    _textFeild.tag = 1001;
    _textFeild.backgroundColor = [UIColor clearColor];
    _textFeild.clearButtonMode = UITextFieldViewModeAlways;//一次性删除
    _textFeild.placeholder = @"请输入账号";
    [_textFeild setValue:HexRGB(0X808080) forKeyPath:@"_placeholderLabel.textColor"];
    _textFeild.autocorrectionType = UITextAutocorrectionTypeYes;//自动提示
    //_textFeild.borderStyle = UITextBorderStyleRoundedRect;//输入框样式
    _textFeild.keyboardType = UIKeyboardTypeDecimalPad;
    [self.view addSubview:_textFeild];
    _textFeild.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *view5 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, got(50), got(40))];

    UIImageView *textView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-user.png"]];
    textView.frame = CGRectMake(got(5), got(5), got(30), got(30));
    [view5 addSubview:textView];
    
    _textFeild.leftView = view5;
    
    // 切换账号,如果一个也没有会隐藏
    shotBtn = [[UIButton alloc] initWithFrame:CGRectMake(got(270), gotHeight(215), got(50), gotHeight(43))];
    [shotBtn setImage:[UIImage imageNamed:@"bnt-downl-n.png"] forState:UIControlStateNormal];
    [shotBtn addTarget:self action:@selector(shotBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shotBtn];
    
    
    
    
    
    
    // 分割线
    UILabel *lineLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(got(70), gotHeight(260), ScreenWidth-got(70),1)];
    lineLabel2.backgroundColor = HexRGB(0Xd0d0d0);
    [self.view addSubview:lineLabel2];
    
    self.passwordTextFeild = [[UITextField alloc] initWithFrame:CGRectMake(got(20), gotHeight(265), got(260), gotHeight(43))];
    _passwordTextFeild.delegate = self;
    _passwordTextFeild.tag = 1002;
    _passwordTextFeild.backgroundColor = [UIColor clearColor];
    _passwordTextFeild.clearButtonMode = UITextFieldViewModeAlways;
    _passwordTextFeild.placeholder = @"请输入密码";
    [_passwordTextFeild setValue:HexRGB(0X808080) forKeyPath:@"_placeholderLabel.textColor"];
    _passwordTextFeild.secureTextEntry = YES;
    _passwordTextFeild.autocorrectionType = UITextAutocorrectionTypeYes;
   // _passwordTextFeild.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:_passwordTextFeild];
    _passwordTextFeild.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *view6 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, got(50), got(40))];
    
    UIImageView *textView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-password.png"]];
    textView2.frame = CGRectMake(got(5), got(5), got(30), got(30));
    [view6 addSubview:textView2];
    _passwordTextFeild.leftView = view6;
    
    // 分割线
    UILabel *lineLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(0, gotHeight(305), ScreenWidth,1)];
    lineLabel3.backgroundColor = HexRGB(0Xd0d0d0);
    [self.view addSubview:lineLabel3];

    // tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(got(20), gotHeight(260), got(240), gotHeight(100))];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.hidden = YES;
    [self.view addSubview:_tableView];
    
    self.registerBtn = [[UIButton alloc] initWithFrame:CGRectMake(got(20),gotHeight(530), got(40), gotHeight(30))];
    [self.registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [self.registerBtn addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.registerBtn];
    
    
    self.findButton = [[UIButton alloc] initWithFrame:CGRectMake(got(220), gotHeight(530), got(80), gotHeight(30))];
    [self.findButton setTitle:@"找回密码" forState:UIControlStateNormal];
    [self.findButton addTarget:self action:@selector(findAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.findButton];
    
    //登陆按钮
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeSystem];
    nextButton.backgroundColor = HexRGB(0Xf04d6d);
    nextButton.frame = CGRectMake(got(30), gotHeight(380), got(260), gotHeight(50));
    [nextButton setTitle:@"登 陆" forState:UIControlStateNormal];
    [self.view addSubview:nextButton];
    [nextButton setTitleColor:HexRGB(0XFFFFFF) forState:UIControlStateNormal];
    nextButton.layer.cornerRadius = got(5);
    nextButton.clipsToBounds = YES;
    [nextButton addTarget:self action:@selector(nextButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(got(10), gotHeight(30), got(40), got(40))];
    [backButton setImage:[UIImage imageNamed:@"btn-return-n.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
        
    
}




// 返回
- (void)backButtonAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shotBtn:(UIButton *)sender
{
    if (isPush == NO) {
        // 弹出
        isPush = YES;
        [shotBtn setImage:[UIImage imageNamed:@"bnt-up-n-.png"] forState:UIControlStateNormal];
        _tableView.hidden = NO;
    }else{
        // 关闭
        isPush = NO;
        [shotBtn setImage:[UIImage imageNamed:@"bnt-downl-n.png"] forState:UIControlStateNormal];
        _tableView.hidden = YES;
    }
}


// 注册
- (void)registerAction:(UIButton *)sender
{
    FirstViewController *firstVC = [FirstViewController new];
    firstVC.title = @"注册";
    
    [self.navigationController pushViewController:firstVC animated:YES];
    
}

// 找回密码
- (void)findAction:(UIButton *)sender
{
    RegisterViewController *registerVC = [RegisterViewController new];

    registerVC.title = @"找回密码";
    
    [self.navigationController pushViewController:registerVC animated:YES];
}

// 注册成功自动登陆
- (void)registerSuccess
{
    self.textFeild.text = self.phoneNum;
    self.passwordTextFeild.text = self.passWord;
    
    [self sendLoginInfo];// 登陆
    NSLog(@"走了---");
}


// 提交登陆信息
- (void)sendLoginInfo
{
    NSString *accountNum = self.textFeild.text;// 用户名
    NSString *passWord = self.passwordTextFeild.text;// 密码
    NSString *p1 = [NSGetTools getUserSessionId];//sessionId
    NSNumber *p2 = [NSGetTools getUserID];//ID
    NSString *appInfo = [NSGetTools getAppInfoString];// 公共参数
    
    NSLog(@"---appInfo--%@",appInfo);
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSString *url = [NSString stringWithFormat:@"%@f_120_10_1.service?a81=%@&a56=%@&p1=%@&p2=%@&%@",kServerAddressTest,accountNum,passWord,p1,p2,appInfo];

    
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSLog(@"---url--%@",url);
    
    [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
       
        NSData *datas = responseObject;
        
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典

         NSLog(@"-登陆->%@",infoDic);
        NSDictionary *dict2 = infoDic[@"body"];
        NSNumber *codeNum = infoDic[@"code"];
        
        if ([codeNum intValue] == 200) {
            // 保存账号 密码
            [NSGetTools updateUserAccount:accountNum];
            [NSGetTools updateUserPassWord:passWord];
            
            // 保存用户ID
            [NSGetTools upDateUserID:dict2[@"b80"]];
            // 保存用户SessionId
            [NSGetTools upDateUserSessionId:dict2[@"b101"]];
            
            [NSGetTools updateIsLoadWithStr:@"isLoad"];
            NSLog(@"登陆成功");
            
            if ([self.whoVC isEqualToString:@"check"]) {
                // 提交用户信息
                [self sendUserInfos];
                [self sendHeadIcon];// 提交头像
            }
            [self getUserInfos];
            //[self gotoMainView];
        }else if ([codeNum intValue] == 207){
            NSLog(@"输入密码错误,请检查");
            [NSGetTools shotTipAnimationWith:_passwordTextFeild];
            [NSGetTools showAlert:@"密码输入错误"];
        }else if ([codeNum intValue] == 206){
            NSLog(@"用户信息审核不通过,请检查用户信息,或者联系客服人员");
            [NSGetTools showAlert:@"用户信息审核不通过,请检查用户信息,或者联系客服人员"];
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error==%@",error);
    }];

}

// 登陆成功
- (void)gotoMainView
{
    //发送自动登陆状态通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loginStateChange" object:@YES];
    
    
}

// 请求用户信息
- (void)getUserInfos
{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSString *url = [NSString stringWithFormat:@"%@f_108_10_1.service?",kServerAddressTest2];
    NSDictionary *dict = [NSGetTools getAppInfoDict];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    [manger GET:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        
        NSNumber *codeNum = infoDic[@"code"];
        if ([codeNum intValue] == 200) {
            NSDictionary *dict2 = infoDic[@"body"];
            NSNumber *b34 = dict2[@"b34"];
            [NSGetTools upDateB34:b34];
            NSNumber *b144 = dict2[@"b144"];
            [NSGetTools upDateUserVipInfo:b144];
            NSNumber *b69 = dict2[@"b69"];
            [NSGetTools updateUserSexInfoWithB69:b69];
            
            [self gotoMainView];
        }
        
        NSLog(@"用户信息-----%@-",infoDic);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"===error-%@",error);
    }];
}


// 提交用户保存信息
- (void)sendUserInfos
{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSString *url = [NSString stringWithFormat:@"%@f_108_11_2.service?",kServerAddressTest];
    NSMutableDictionary *dict = [NSGetTools getUserInfoDict];

    NSLog(@"---dict->-%@----",dict);
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    [manger POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSData *datas = responseObject;
        
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        
        NSNumber *codeNum = infoDic[@"code"];
        if ([codeNum intValue] == 200) {
            NSDictionary *dict2 = infoDic[@"body"];
            NSNumber *b34 = dict2[@"b34"];
            [NSGetTools upDateB34:b34];

        }
        
        
        NSLog(@"---提交用户信息--%@",infoDic);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"===error-%@",error);
    }];
    
}

// 提交头像保存信息  /LP-file-msc/f_107_10_2.service
- (void)sendHeadIcon
{
    
    NSDictionary *dict = [NSGetTools getAppInfoDict];
    
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSString *url = [NSString stringWithFormat:@"%@f_107_10_2.service?",kServerAddressTest3];
    
    UIImage *iconImage = [NSGetTools getHeadIcon];
    NSData *iconData = UIImageJPEGRepresentation(iconImage, 1.0);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置日期格式
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *fileName = [formatter stringFromDate:[NSDate date]];
    
    NSLog(@"--DICT-%@---",dict);
    [manger POST:url parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileData:iconData name:@"a102" fileName:fileName mimeType:@"image/png"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSData *datas = responseObject;
        
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        
       NSNumber *codeNum = infoDic[@"code"];

        
        if ([codeNum intValue] == 200) {
            NSArray *iconArray = infoDic[@"body"];
            
            for (NSDictionary *dict in iconArray) {
                if ([dict[@"b78"] intValue] == 1000) {
                    NSNumber *b34Num = dict[@"b34"];
                    NSNumber *b75Num = dict[@"b75"];
                    NSString *iconUrl = dict[@"b57"];
                    [NSGetTools upDateIconB34:b34Num];
                    [NSGetTools upDateIconB75:b75Num];
                    [NSGetTools upDateIconB57:iconUrl];
                }
            }
        }

        NSLog(@"头像保存--%@-",infoDic);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"头像保存--%@--",error);
    }];
    
    
}




- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 1002) {
        if (_textFeild.text.length == 0 || [_textFeild.text isEqualToString:@""] || _textFeild.text == nil) {
            NSLog(@"手机号不能为空");
            [NSGetTools shotTipAnimationWith:_textFeild];
            [NSGetTools showAlert:@"手机号不能为空"];
        }else{
            BOOL isPhone = [NSGetTools checkPhoneNum:_textFeild.text];
            if (!isPhone) {
                NSLog(@"请输入正确的手机号");
                [NSGetTools shotTipAnimationWith:_textFeild];
                [NSGetTools showAlert:@"请输入正确的手机号"];
            }else{
                NSLog(@"正确");
            }
        }
    }
}



//登陆
- (void)nextButtonAction:(UIView *)view
{
    // 判断账户手机号
    if (_textFeild.text.length == 0 || [_textFeild.text isEqualToString:@""] || _textFeild.text == nil) {
        NSLog(@"手机号不能为空");
        [NSGetTools shotTipAnimationWith:_textFeild];
        [NSGetTools showAlert:@"手机号不能为空"];
    }else{
        BOOL isPhone = [NSGetTools checkPhoneNum:_textFeild.text];
        if (!isPhone) {
            NSLog(@"请输入正确的手机号");
            [NSGetTools shotTipAnimationWith:_textFeild];
            [NSGetTools showAlert:@"请输入正确的手机号"];
        }else{
           
            NSLog(@"账号正确");
            
            // 判断密码
            if (_passwordTextFeild.text.length == 0 || [_passwordTextFeild.text isEqualToString:@""] || _passwordTextFeild.text == nil) {
                NSLog(@"密码不能为空");
                [NSGetTools shotTipAnimationWith:_passwordTextFeild];
                [NSGetTools showAlert:@"密码不能为空"];
            }else{
                
                BOOL isOK = [NSGetTools checkPassWord:_passwordTextFeild.text];
                if (!isOK) {
                    NSLog(@"密码为数字和字母组合");
                    [NSGetTools shotTipAnimationWith:_textFeild];
                    [NSGetTools showAlert:@"请输入字母和数字组合密码"];
                }else{
                    NSLog(@"密码设置正确");
                    [self sendLoginInfo];//提交登陆
                }
                
                
            }
            
        
        }
    }

}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

//空白处点击
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    
    if ([self.whoVC isEqualToString:@"check"]) {
        [self registerSuccess];
    }else{
        
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
