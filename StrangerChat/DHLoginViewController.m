//
//  DHLoginViewController.m
//  StrangerChat
//
//  Created by xy2 on 15/12/22.
//  Copyright © 2015年 long. All rights reserved.
//

#import "DHLoginViewController.h"
#import "DHRegFirstViewController.h"
#import "MainViewController.h"
@interface DHLoginViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *logoImageV;
//@property (weak, nonatomic) IBOutlet UIView *inputBgView;

@property (weak, nonatomic) IBOutlet UIView *inputUserNameBgView;
@property (weak, nonatomic) IBOutlet UIView *inputPasswordBgView;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *userPassTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;


@end

@implementation DHLoginViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.userNameTextFiled becomeFirstResponder];
    UIColor *color = HexRGB(0xffffff);
    self.userNameTextFiled.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入用户账号" attributes:@{NSForegroundColorAttributeName: color}];
    self.userPassTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入密码" attributes:@{NSForegroundColorAttributeName: color}];
    self.inputUserNameBgView.layer.masksToBounds = YES;
    
    self.inputUserNameBgView.layer.borderColor=HexRGB(0xffffff).CGColor;
    self.inputUserNameBgView.layer.borderWidth=1;
    self.inputUserNameBgView.layer.cornerRadius=CGRectGetHeight(self.inputUserNameBgView.frame)/2;
//    self.inputUserNameBgView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.inputPasswordBgView.layer.masksToBounds = YES;
    self.inputPasswordBgView.layer.borderColor=HexRGB(0xffffff).CGColor;
    self.inputPasswordBgView.layer.borderWidth=1;
    self.inputPasswordBgView.layer.cornerRadius=CGRectGetHeight(self.inputPasswordBgView.frame)/2;
    self.loginBtn.layer.cornerRadius = 5;
    if (iPhone4) {
        self.view.backgroundColor = [UIColor clearColor];
        UIImageView *imageV = [[UIImageView alloc]init];
        imageV.frame = [[UIScreen mainScreen] bounds];
        imageV.image = [UIImage imageNamed:@"background-640x960.png"];
        [self.view addSubview:imageV];
        [self.view sendSubviewToBack:imageV];
//       self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background-640x960.png"]];
    }else if (iPhonePlus){
        self.view.backgroundColor = [UIColor clearColor];
        UIImageView *imageV = [[UIImageView alloc]init];
        imageV.frame = [[UIScreen mainScreen] bounds];
        imageV.image = [UIImage imageNamed:@"background-1242x2208.png"];
        [self.view addSubview:imageV];
        [self.view sendSubviewToBack:imageV];
//        self.view.backgroundColor = [UIColor clearColor];
//        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background-1242x2208.png"]];
    }else{
        self.view.backgroundColor = [UIColor clearColor];
        UIImageView *imageV = [[UIImageView alloc]init];
        imageV.frame = [[UIScreen mainScreen] bounds];
        imageV.image = [UIImage imageNamed:@"background-750x1334.png"];
        [self.view addSubview:imageV];
        [self.view sendSubviewToBack:imageV];
//        [self.view sendSubviewToBack:imageV];
//       self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background-750x1334.png"]];
    }
    //    self.inputUserNameBgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"button-login-white.png"]];
//    self.inputUserNameBgView.clipsToBounds = YES;
//    self.inputPasswordBgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"button-login-white.png"]];
    //b101 sessionId sessionID
    //b80 userId 用户ID
    //b56 password 密码
    //b81 userName 用户名称
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"regUser"];
    self.userNameTextFiled.text = [dict objectForKey:@"userName"];
    self.userPassTextField.text = [dict objectForKey:@"password"];

}
- (void)sethideKeyBoardAccessoryView{
    UIView *accessoryView = [[UIView alloc]init];
    accessoryView.frame = CGRectMake(0, 0, ScreenWidth, 30);
    accessoryView.backgroundColor = [UIColor colorWithWhite:0.900 alpha:1];
    UIButton *doneBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    doneBtn.frame = CGRectMake(CGRectGetMaxX(accessoryView.bounds) - 50, CGRectGetMinY(accessoryView.bounds), 40,30);
    //    doneBtn.backgroundColor = [UIColor grayColor];
    [doneBtn setTitle:@"完成" forState:(UIControlStateNormal)];
    [doneBtn setTitleColor:[UIColor colorWithRed:236/255.0 green:49/255.0 blue:88/255.0 alpha:1] forState:(UIControlStateNormal)];
    [doneBtn addTarget:self action:@selector(loginBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [accessoryView addSubview:doneBtn];
    self.userNameTextFiled.inputAccessoryView = accessoryView;
    self.userPassTextField.inputAccessoryView = accessoryView;
}
- (IBAction)loginBtnAction:(id)sender {
    [self.userNameTextFiled resignFirstResponder];
    [self.userPassTextField resignFirstResponder];
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"regUser"];
    NSString *userName = self.userNameTextFiled.text;
    NSString *userPass = self.userPassTextField.text ;
    [self loginWithUserId:[dict objectForKey:@"b80"] == nil ?@"":[dict objectForKey:@"b80"] sessionId:[dict objectForKey:@"b101"]==nil?@"":[dict objectForKey:@"b101"] username:userName password:userPass];
}
- (IBAction)regBtnAction:(id)sender {
//    DHRegFirstViewController *vc = [[DHRegFirstViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
    MainViewController *vc = [[MainViewController alloc]init];
    vc.title = @"注册";
    [[[UIApplication sharedApplication] keyWindow] setRootViewController:vc];
//    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)forgetPassBtnAction:(id)sender {
    
}
- (void)loginWithUserId:(NSString *)userId sessionId:(NSString *)sessionId username:(NSString *)username password :(NSString *)password{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString *appinfoStr = [NSGetTools getAppInfoString];
    
    NSString *url = [NSString stringWithFormat:@"%@f_120_10_1.service?a81=%@&a56=%@&p2=%@&p1=%@&%@",kServerAddressTest,username,password,userId,sessionId,appinfoStr];
    
    //    [NSString stringWithFormat:@"%@f_120_10_1.service?a81=%@&a56=%@&p1=%@&p2=%@",kServerAddressTest,username,password,userId,sessionId];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        
//        NSLog(@"-登陆->%@",infoDic);
        NSDictionary *dict2 = infoDic[@"body"];
        NSNumber *codeNum = infoDic[@"code"];
        
        if ([codeNum intValue] == 200) {
            // 保存账号 密码
            [NSGetTools updateUserAccount:username];
            [NSGetTools updateUserPassWord:password];
            
            // 保存用户ID
            [NSGetTools upDateUserID:dict2[@"b80"]];
            // 保存用户SessionId
            [NSGetTools upDateUserSessionId:dict2[@"b101"]];
            [NSGetTools updateUserSexInfoWithB69:[NSNumber numberWithInteger:[dict2[@"b69"] integerValue]]];
            
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:username,@"userName",password,@"password",dict2[@"b80"],@"userId",dict2[@"b101"],@"sessionId",dict2[@"b80"],@"gender", nil];
            [NSGetTools updateUserAccount:username];
            [NSGetTools updateUserPassWord:password];
            // 保存用户ID
            [NSGetTools upDateUserID:dict2[@"b80"]];
            // 保存用户SessionId
            [NSGetTools upDateUserSessionId:dict2[@"b101"]];
            
            [NSGetTools updateIsLoadWithStr:@"isLoad"];
            
            [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"regUser"];
//            [NSGetTools updateIsLoadWithStr:@"isLoad"];
            NSLog(@"登陆成功");
            
            if ([self.whoVC isEqualToString:@"check"]) {
                // 提交用户信息
                [self sendUserInfos];
                [self sendHeadIcon];// 提交头像
            }
            [self getUserInfosWithp1:dict2[@"b101"] p2:dict2[@"b80"]];
            //[self gotoMainView];
        }else if ([codeNum intValue] == 2010){
            NSLog(@"输入密码错误,请检查");
            [NSGetTools shotTipAnimationWith:_userPassTextField];
            [NSGetTools showAlert:@"密码输入错误"];
        }else if ([codeNum intValue] == 206){
            NSLog(@"用户信息审核不通过,请检查用户信息,或者联系客服人员");
            [NSGetTools showAlert:@"用户信息审核不通过,请检查用户信息,或者联系客服人员"];
        }else{
            [self showHint:[infoDic objectForKey:@"msg"]];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.userInfo);
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
    
//    NSLog(@"---dict->-%@----",dict);
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
        
        
//        NSLog(@"---提交用户信息--%@",infoDic);
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
    
//    NSLog(@"--DICT-%@---",dict);
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
        
//        NSLog(@"头像保存--%@-",infoDic);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"头像保存--%@--",error);
    }];
    
    
}
// 请求用户信息
- (void)getUserInfosWithp1:(NSString *)p1 p2:(NSString *)p2
{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSString *appinfoStr = [NSGetTools getAppInfoString];
//    NSDictionary *dict = [NSGetTools getAppInfoDict];
//    NSString *p1 = [dict objectForKey:@"p1"];
//    NSString *p2 = [dict objectForKey:@"p2"];
    NSString *url = [NSString stringWithFormat:@"%@f_108_10_1.service?p1=%@&p2=%@&%@",kServerAddressTest2,p1,p2,appinfoStr];
//
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
            [[NSUserDefaults standardUserDefaults] setObject:[dict2 objectForKey:@"b52"] forKey:@"nickName"];
            [[NSUserDefaults standardUserDefaults] setObject:[dict2 objectForKey:@"b17"] forKey:@"b17"];
            [[NSUserDefaults standardUserDefaults] setObject:dict2 forKey:@"loginUser"];
            [self gotoMainView];
        }
        
//        NSLog(@"用户信息-----%@-",infoDic);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"===error-%@",error);
    }];
}
// 登陆成功
- (void)gotoMainView{
    //发送自动登陆状态通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loginStateChange" object:@YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tap];
    [self sethideKeyBoardAccessoryView];
    if (iPhone4) {
//        [self loadIPhone4];
    }
    
}
- (void)tapAction:(UITapGestureRecognizer *)sender{
    [self.userNameTextFiled resignFirstResponder];
    [self.userPassTextField resignFirstResponder];
}
- (void)loadIPhone4{
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    // logo
    UIImageView *logoImageV = [[UIImageView alloc]init];
    logoImageV.frame = CGRectMake(CGRectGetMidX([[UIScreen mainScreen] bounds])-33, 40, 66, 66);
    logoImageV.image = [UIImage imageNamed:@"icon-chumo.png"];
    [self.view addSubview:logoImageV];
    // 触陌
    UIImageView *logoImageVlabel = [[UIImageView alloc]init];
    logoImageVlabel.frame = CGRectMake(CGRectGetMidX([[UIScreen mainScreen] bounds])-15, CGRectGetMaxY(logoImageV.frame)+20, 30, 15);
    logoImageVlabel.image = [UIImage imageNamed:@"Writing-chumo.png"];
    [self.view addSubview:logoImageVlabel];
    
    // 用户名背景
    UIImageView *inputUserBgView = [[UIImageView alloc]init];
    inputUserBgView.userInteractionEnabled = YES;
    inputUserBgView.frame = CGRectMake(CGRectGetMinX([[UIScreen mainScreen] bounds])+15, CGRectGetMaxY(logoImageVlabel.frame)+20, CGRectGetWidth([[UIScreen mainScreen] bounds])-30, 40);
    inputUserBgView.image = [UIImage imageNamed:@"button-login-white.png"];
    [self.view addSubview:inputUserBgView];
    // 用户名图标
    UIImageView *usericonImageV = [[UIImageView alloc]init];
    usericonImageV.frame = CGRectMake(20, 10, 18, 19);
    usericonImageV.image = [UIImage imageNamed:@"icon-account.png"];
    [inputUserBgView addSubview:usericonImageV];
    
    UITextField *userNameTextField = [[UITextField alloc]init];
    userNameTextField.frame = CGRectMake(CGRectGetMaxX(usericonImageV.frame)+30, CGRectGetMinY(usericonImageV.frame), CGRectGetWidth(inputUserBgView.bounds)-40-20-30-10, CGRectGetHeight(usericonImageV.frame));
    UIColor *color = HexRGB(0xffffff);
    userNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入用户名" attributes:@{NSForegroundColorAttributeName: color}];
    userNameTextField.font = [UIFont systemFontOfSize:12];
    userNameTextField.textColor = [UIColor whiteColor];
    [inputUserBgView addSubview:userNameTextField];
    // 密码背景
    UIImageView *inputPassBgView = [[UIImageView alloc]init];
    inputPassBgView.userInteractionEnabled = YES;
    
    inputPassBgView.frame = CGRectMake(CGRectGetMinX(inputUserBgView.frame), CGRectGetMaxY(inputUserBgView.frame)+20, CGRectGetWidth(inputUserBgView.frame)-0, CGRectGetHeight(inputUserBgView.frame));
    inputPassBgView.image = [UIImage imageNamed:@"button-login-white.png"];
    [self.view addSubview:inputPassBgView];
    // 密码图标
    UIImageView *passiconImageV = [[UIImageView alloc]init];
    passiconImageV.frame = CGRectMake(20, 10, 18, 19);
    passiconImageV.image = [UIImage imageNamed:@"icon-password-login.png"];
    [inputPassBgView addSubview:passiconImageV];
    
    UITextField *userPassTextField = [[UITextField alloc]init];
    userPassTextField.frame = CGRectMake(CGRectGetMaxX(passiconImageV.frame)+30, CGRectGetMinY(passiconImageV.frame), CGRectGetWidth(inputPassBgView.bounds)-40-20-30-10, CGRectGetHeight(passiconImageV.frame));
    userPassTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入密码" attributes:@{NSForegroundColorAttributeName: color}];
    userPassTextField.font = [UIFont systemFontOfSize:12];
    userPassTextField.textColor = [UIColor whiteColor];
    userPassTextField.secureTextEntry = YES;
    [inputPassBgView addSubview:userPassTextField];
    
    // 登陆按钮
    UIButton *loginBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    loginBtn.frame = CGRectMake(CGRectGetMinX(inputUserBgView.frame), CGRectGetMaxY(inputPassBgView.frame)+20, CGRectGetWidth(inputUserBgView.frame)-0, CGRectGetHeight(inputUserBgView.frame));
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"button-login-red.png"] forState:(UIControlStateNormal)];
    [loginBtn setTitle:@"登    录" forState:(UIControlStateNormal)];
    [self.view addSubview:loginBtn];
    
    // 注册按钮
    UIButton *regBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    regBtn.frame = CGRectMake(CGRectGetMinX(loginBtn.frame), CGRectGetMaxY(loginBtn.frame)+10, 60, 20);
    [regBtn setTitle:@"注册" forState:(UIControlStateNormal)];
    regBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:regBtn];
    // 忘记密码
    UIButton *forgetPassBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    forgetPassBtn.frame = CGRectMake(CGRectGetMaxX(loginBtn.frame)-80, CGRectGetMaxY(loginBtn.frame)+10, 70, 20);
    [forgetPassBtn setTitle:@"忘记密码" forState:(UIControlStateNormal)];
    forgetPassBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:forgetPassBtn];
    
    
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
