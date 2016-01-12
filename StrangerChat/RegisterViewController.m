//
//  RegisterViewController.m
//  StrangerChat
//
//  Created by long on 15/10/12.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "RegisterViewController.h"
#import "JxbScaleButton.h"
#import "CheckViewController.h"
@interface RegisterViewController () <UITextFieldDelegate,UIAlertViewDelegate>

@property (nonatomic,strong) UITextField *textFeild;
@property (nonatomic,strong) UITextField *passWordFeild;
//@property (nonatomic,strong) JxbScaleButton *checkNumButton;// 发送验证码
@property (nonatomic,strong) UIButton *regtBtn;// 注册按钮

@end

@implementation RegisterViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(backButton)];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:HexRGB(0XFFFFFF),NSForegroundColorAttributeName,nil];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    self.view.backgroundColor = HexRGB(0xFFFEFB);
    self.navigationController.navigationBar.tintColor = HexRGB(0xFFFFFF);
    self.navigationController.navigationBar.barTintColor = HexRGB(0XF04D6D);
   self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"上一页" style:UIBarButtonItemStylePlain target:self action:nil];
    
    // 分割线
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, gotHeight(85), ScreenWidth,1)];
    lineLabel.backgroundColor = HexRGB(0XD0D0D0);
    [self.view addSubview:lineLabel];
    
    //设置账号密码输入框
    self.textFeild = [[UITextField alloc] initWithFrame:CGRectMake(got(20), gotHeight(90), got(270), gotHeight(40))];;
    _textFeild.delegate = self;
    _textFeild.tag = 1006;
    _textFeild.backgroundColor = [UIColor clearColor];
    _textFeild.clearButtonMode = UITextFieldViewModeAlways;//一次性删除
    _textFeild.placeholder = @"请输入手机号码";
    [_textFeild setValue:HexRGB(0X808080) forKeyPath:@"_placeholderLabel.textColor"];
    _textFeild.autocorrectionType = UITextAutocorrectionTypeYes;//自动提示
    //_textFeild.borderStyle = UITextBorderStyleRoundedRect;//输入框样式
    _textFeild.keyboardType = UIKeyboardTypeDecimalPad;
    [self.view addSubview:_textFeild];
    _textFeild.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *view5 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, got(50), got(40))];
    
    UIImageView *textView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-phone.png"]];
    textView.frame = CGRectMake(got(5), got(5), got(30), got(30));
    [view5 addSubview:textView];
    
    _textFeild.leftView = view5;
    
    
    // 分割线
    UILabel *lineLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(got(70), gotHeight(135), ScreenWidth-got(70),1)];
    lineLabel2.backgroundColor = HexRGB(0XD0D0D0);
    [self.view addSubview:lineLabel2];
    
    self.passWordFeild = [[UITextField alloc] initWithFrame:CGRectMake(got(20), gotHeight(140), got(270), gotHeight(40))];
    _passWordFeild.delegate = self;
    _passWordFeild.tag = 1007;
    _passWordFeild.backgroundColor = [UIColor clearColor];
    _passWordFeild.clearButtonMode = UITextFieldViewModeAlways;
    _passWordFeild.placeholder = @"请设置密码";
    [_passWordFeild setValue:HexRGB(0X808080) forKeyPath:@"_placeholderLabel.textColor"];
    _passWordFeild.secureTextEntry = YES;
    _passWordFeild.autocorrectionType = UITextAutocorrectionTypeYes;
    //_passWordFeild.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:_passWordFeild];
    _passWordFeild.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *view6 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, got(50), got(40))];
    
    UIImageView *textView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-password.png"]];
    textView2.frame = CGRectMake(got(5), got(5), got(30), got(30));
    [view6 addSubview:textView2];
    _passWordFeild.leftView = view6;
    
    // 分割线
    UILabel *lineLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(0, gotHeight(185), ScreenWidth,1)];
    lineLabel3.backgroundColor = HexRGB(0XD0D0D0);
    [self.view addSubview:lineLabel3];
    

//    self.checkNumButton = [[JxbScaleButton alloc] initWithFrame:CGRectMake(220, 140, 80, 40)];
//    _checkNumButton.layer.cornerRadius = 5;
//    _checkNumButton.layer.masksToBounds = YES;
//    _checkNumButton.backgroundColor = [UIColor grayColor];
//    [_checkNumButton setTitle:@"获取验证码" forState:UIControlStateNormal];
//    _checkNumButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
//    [_checkNumButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_checkNumButton];
    
    
    self.regtBtn = [[UIButton alloc] initWithFrame:CGRectMake(got(30), gotHeight(240), got(260), gotHeight(50))];
    self.regtBtn.backgroundColor = HexRGB(0Xf04d6d);
    [self.regtBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [self.regtBtn setTitleColor:HexRGB(0XFFFFFF) forState:UIControlStateNormal];
    self.regtBtn.layer.cornerRadius = got(5);
    self.regtBtn.clipsToBounds = YES;
    [self.regtBtn addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.regtBtn];
    
}

//// 返回
//- (void)backButton
//{
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 1007) {
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

//// 点击验证码
//- (void)btnAction:(id)sender {
//    NSLog(@"click");
//    
//    
//    if (_textFeild.text.length == 0 || [_textFeild.text isEqualToString:@""] || _textFeild.text == nil) {
//        NSLog(@"手机号不能为空");
//        [NSGetTools shotTipAnimationWith:_textFeild];
//        [NSGetTools showAlert:@"手机号不能为空"];
//    }else{
//        BOOL isPhone = [NSGetTools checkPhoneNum:_textFeild.text];
//        if (!isPhone) {
//            NSLog(@"请输入正确的手机号");
//            [NSGetTools shotTipAnimationWith:_textFeild];
//            [NSGetTools showAlert:@"请输入正确的手机号"];
//        }else{
//            NSLog(@"正确");
//            [self getCheckNum];
//        }
//    }
//
//}

//// 倒计时
//- (void)checkNumViewWithSecond:(int)seconds
//{
//    JxbScaleSetting* setting = [[JxbScaleSetting alloc] init];
//    setting.strPrefix = @"";
//    setting.strSuffix = @"秒";
//    setting.strCommon = @"重新发送";
//    setting.indexStart = seconds;
//    [_checkNumButton startWithSetting:setting];
//}




// 获取验证码  a92:1是注册,2是修改
//a81=%@&a56=%@&a115=%@&a93=%@&a151=%@&%@  a81手机号，a56密码，a115确认密码，a93短信验证码，a151手机序列号
- (void)getCheckNum
{
    NSString *phoneNum = self.textFeild.text;
    NSString *appInfo = [NSGetTools getAppInfoString];// 公共参数
    
    NSString *a92 = @"1";
    if ([self.title isEqualToString:@"注册"]) {
        a92 = @"1";
    }else if([self.title isEqualToString:@"找回密码"]){
        a92 = @"2";
    }else{
        a92 = @"1";
    }
    
    
    NSLog(@"---appInfo--%@",appInfo);
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *url = [NSString stringWithFormat:@"%@f_119_10_1.service?a81=%@&a56=%@&a115=%@&a93=%@&a151=%@&%@",kServerAddressTest,phoneNum,a92,appInfo];   // f_119_11_1.service  系统注册  f_119_10_1.service 手机注册
    
    
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSLog(@"---url--%@",url);
    
    [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSData *datas = responseObject;
        
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        NSLog(@"-注册找回->%@",infoDic);
        
        NSNumber *codeNum = infoDic[@"code"];
        
        if ([codeNum intValue] == 200) {
            NSLog(@"发送成功");
            //[self checkNumViewWithSecond:60];// 倒计时
            [NSGetTools showAlert:@"发送成功"];
           [self nextStep];
        }else if ([codeNum intValue] == 222){
            NSLog(@"当前注册帐号已被注册,请检查!");
           //[_checkNumButton setTitle:@"获取验证码" forState:UIControlStateNormal];
            //_checkNumButton.backgroundColor = [UIColor grayColor];
            [NSGetTools showAlert:@"当前注册帐号已被注册,请检查或找回密码"];
        }else if ([codeNum intValue] == 202){
            NSLog(@"发送失败");
            [NSGetTools showAlert:@"发送失败,请重新尝试"];
            //[self checkNumViewWithSecond:0];
        }else{
            [NSGetTools showAlert:@"系统异常"];
            //[_checkNumButton setTitle:@"获取验证码" forState:UIControlStateNormal];
           // _checkNumButton.backgroundColor = [UIColor grayColor];
        }

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error==%@",error);
        [NSGetTools showAlert:@"发送失败,请重新尝试"];
        //[self checkNumViewWithSecond:0];
    }];

}



// 注册下一步
- (void)registerAction:(UIButton *)sender
{
    
    BOOL isPhone = [NSGetTools checkPhoneNum:_textFeild.text];
    
    if (_textFeild.text.length == 0 || [_textFeild.text isEqualToString:@""] || _textFeild.text == nil) {
        [NSGetTools shotTipAnimationWith:_textFeild];
        [NSGetTools showAlert:@"手机号不能为空"];
    }else if (!isPhone){
        NSLog(@"请输入正确的手机号");
        [NSGetTools shotTipAnimationWith:_textFeild];
        [NSGetTools showAlert:@"请输入正确的手机号"];

    }else{
        
        BOOL isPassWord = [NSGetTools checkPassWord:_passWordFeild.text];
        
        if (_passWordFeild.text.length == 0 || [_passWordFeild.text isEqualToString:@""] || _passWordFeild.text == nil) {
            NSLog(@"密码不能为空");
            [NSGetTools shotTipAnimationWith:_passWordFeild];
            [NSGetTools showAlert:@"密码不能为空"];
        }else if (_passWordFeild.text.length >= 6 && isPassWord == YES){
            NSLog(@"密码输入正确");
            NSString *tipStr = [NSString stringWithFormat:@"我们将发送验证码短信到这个手机号:  +86 %@",_textFeild.text];
            [self tipWithMessage:tipStr];
        }else{
            NSLog(@"密码格式错误");
            [NSGetTools shotTipAnimationWith:_passWordFeild];
            [NSGetTools showAlert:@"密码为6位以上字母和数字组合"];
        }
    }

    
}

#pragma mark 提示信息
- (void)tipWithMessage:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认手机号码" message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alert show];
}

#pragma mark - 警告框代理方法

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self getCheckNum];// 验证码
    }
    
}

- (void)nextStep
{
    CheckViewController *checkVC = [CheckViewController new];
    checkVC.title = self.title;
    checkVC.phoneNum = _textFeild.text;
    checkVC.passWord = _passWordFeild.text;
    
    checkVC.isSex = self.isSex;
    checkVC.userName = self.userName;
    checkVC.birthDay = self.birthDay;
    checkVC.wantNum = self.wantNum;
    
    [self.navigationController pushViewController:checkVC animated:YES];
}

//空白处点击
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
