//
//  CheckViewController.m
//  StrangerChat
//
//  Created by long on 15/10/19.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "CheckViewController.h"
#import "DHLoginViewController.h"
@interface CheckViewController () <UITextFieldDelegate>

@property (nonatomic,strong) UITextField *checkNumTextField;

@property (nonatomic,strong) UIButton *sureButton;//完成

@end

@implementation CheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(got(45), gotHeight(80), got(240), gotHeight(20))];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc] initWithString:@"我们已发送验证码短信到这个号:"];
    
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:got(16)],NSFontAttributeName,[UIColor redColor],NSForegroundColorAttributeName,nil];
    
    NSRange range = NSMakeRange(5, 3);
    [AttributedStr setAttributes:attributeDict range:range];
    label.font = [UIFont systemFontOfSize:got(16)];
    label.attributedText = AttributedStr;
    
    [self.view addSubview:label];
    
    UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(got(40), gotHeight(100), got(240), gotHeight(50))];
    numLabel.font = [UIFont systemFontOfSize:got(25)];
    NSMutableString *str = [NSMutableString stringWithString:self.phoneNum];
    [str insertString:@"  " atIndex:3];
    [str insertString:@"  " atIndex:9];
    numLabel.text = [NSString stringWithFormat:@"+86  %@",str];
    numLabel.textColor = [UIColor blackColor];
    [self.view addSubview:numLabel];
    
    // 分割线
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, gotHeight(155), ScreenWidth,1)];
    lineLabel.backgroundColor = HexRGB(0XD0D0D0);
    [self.view addSubview:lineLabel];
    
    // 验证码
    //设置输入框
    self.checkNumTextField = [[UITextField alloc] initWithFrame:CGRectMake(got(40), gotHeight(160), got(180), got(43))];
    _checkNumTextField.delegate = self;
    _checkNumTextField.backgroundColor = [UIColor clearColor];
    _checkNumTextField.clearButtonMode = UITextFieldViewModeAlways;//一次性删除
    _checkNumTextField.placeholder = @"请输入验证码";
    _checkNumTextField.autocorrectionType = UITextAutocorrectionTypeYes;//自动提示
    //_checkNumTextField.borderStyle = UITextBorderStyleRoundedRect;//输入框样式
    _checkNumTextField.keyboardType = UIKeyboardTypeDecimalPad;
    [self.view addSubview:_checkNumTextField];
    _checkNumTextField.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *view5 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, got(50), got(40))];
    
    UIImageView *textView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-validation.png"]];
    textView.frame = CGRectMake(got(5), got(5), got(30), got(30));
    [view5 addSubview:textView];
    
    _checkNumTextField.leftView = view5;
    
    
    
    // 分割线
    UILabel *lineLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, gotHeight(205), ScreenWidth,1)];
    lineLabel2.backgroundColor = HexRGB(0XD0D0D0);
    [self.view addSubview:lineLabel2];
    
    
    UILabel *Label3 = [[UILabel alloc] initWithFrame:CGRectMake(got(80), gotHeight(220), got(200), gotHeight(20))];
    
    Label3.text = @"接收短信大约需要60秒钟";
    Label3.textColor = [UIColor grayColor];
    Label3.font = [UIFont systemFontOfSize:got(14)];
    [self.view addSubview:Label3];

    
    
    //完成按钮
    self.sureButton = [[UIButton alloc] initWithFrame:CGRectMake(got(30), gotHeight(260), got(260), gotHeight(50))];
    _sureButton.backgroundColor = HexRGB(0Xf04d6d);
    [_sureButton setTitle:@"完 成" forState:UIControlStateNormal];
    [_sureButton setTitleColor:HexRGB(0XFFFFFF) forState:UIControlStateNormal];
    _sureButton.layer.cornerRadius = got(5);
    _sureButton.clipsToBounds = YES;
    [self.view addSubview:_sureButton];
    [_sureButton addTarget:self action:@selector(sureButtonAction:) forControlEvents:UIControlEventTouchUpInside];

}

// 完成
- (void)sureButtonAction:(UIButton *)sender
{
    if (_checkNumTextField.text == nil || [_checkNumTextField.text isEqualToString:@""] || _checkNumTextField.text.length == 0) {
        [NSGetTools shotTipAnimationWith:_checkNumTextField];
        [NSGetTools showAlert:@"请输入验证码"];
    }else{
        
        [self checkCheckNums];// 核对验证码
    }
    
    
}

// 核对验证码
- (void)checkCheckNums
{
    ////lp-uc/f_2_4.service?a81=18357129775&a93=1362&m1=23432432&m2=3432432......
    NSString *phoneNum = self.phoneNum;
    NSString *a93 = self.checkNumTextField.text;
    NSString *appInfo = [NSGetTools getAppInfoString];// 公共参数

//    NSLog(@"---appInfo--%@",appInfo);
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *url = [NSString stringWithFormat:@"%@f_2_4.service?a81=%@&a93=%@&%@",kServerAddressTest,phoneNum,a93,appInfo];


    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
//    NSLog(@"---url--%@",url);

    [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSData *datas = responseObject;

        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
//        NSLog(@"-验证码核对->%@",infoDic);

        NSNumber *codeNum = infoDic[@"code"];

        
        
        if ([codeNum intValue] == 200) {
            NSLog(@"验证成功");
            // 登陆
           [self registerOrFindPassWord];
            //修改

        }else if ([codeNum intValue] == 203){
            NSLog(@"验证码输入错误");
        
            [NSGetTools showAlert:@"验证码输入错误"];
        }else if ([codeNum intValue] == 218){
            NSLog(@"验证码失效");
            [NSGetTools showAlert:@"验证码失效"];
        }else{
            [NSGetTools showAlert:@"系统错误"];

        }


    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error==%@",error);
        [NSGetTools showAlert:@"系统错误,或联网失败"];

    }];


}

// 注册或者找回密码
- (void)registerOrFindPassWord
{
    if ([self.title isEqualToString:@"注册"]) {
        [self registActions];
    }else if ([self.title isEqualToString:@"找回密码"]){
        [self findPassWord];
    }else{
        
    }
}


// 用户注册
- (void)registActions
{
    NSString *appInfo = [NSGetTools getAppInfoString];// 公共参数
    
//    NSLog(@"---appInfo--%@",appInfo);
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *url = [NSString stringWithFormat:@"%@f_2_5.service?a81=%@&a56=%@&a115=%@&%@",kServerAddressTest,_phoneNum,self.passWord,self.passWord,appInfo];
    
    
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
//    NSLog(@"---url--%@",url);
    
    [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSData *datas = responseObject;
        
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        
//        NSLog(@"注册返回字典--->%@-",infoDic);
        NSDictionary *dict2 = infoDic[@"body"];
        NSNumber *codeNum = infoDic[@"code"];
        
        if ([codeNum intValue] == 200) {
            NSLog(@"注册成功");
            
            // 保存用户ID
            [NSGetTools upDateUserID:dict2[@"b80"]];
            // 保存用户SessionId
            [NSGetTools upDateUserSessionId:dict2[@"b100"]];
            
            // 保存用户基本信息
            NSNumber *p2 = dict2[@"b80"];//ID
            NSString *p1 = dict2[@"b100"];// ssid
            NSNumber *a69 = [NSNumber numberWithInteger:self.isSex];
            NSNumber *a145 = [NSNumber numberWithInteger:self.wantNum];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:p2 forKey:@"p2"];
            [dict setValue:p1 forKey:@"p1"];
            [dict setValue:a69 forKey:@"a69"];
            [dict setValue:self.userName forKey:@"a52"];
            [dict setValue:self.birthDay forKey:@"a4"];
            [dict setValue:a145 forKey:@"a145"];
            [NSGetTools updateUserInfoWithDict:dict];// 保存信息
            
            
            [NSGetTools showAlert:@"注册成功"];
            [NSGetTools updateIsLoadWithStr:@"isLoad"];
            [self successToMainView];// 登陆
        }else if ([codeNum intValue] == 204){
            NSLog(@"该用户已注册");
            
            [NSGetTools showAlert:@"该用户已注册"];
        }else{
            [NSGetTools showAlert:@"系统错误"];
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error==%@",error);
        [NSGetTools showAlert:@"系统错误,或联网失败"];
        
    }];
    
    
}

// 密码重置
- (void)findPassWord
{
    NSString *p1 = [NSGetTools getUserSessionId];//sessionId
    NSNumber *p2 = [NSGetTools getUserID];//ID
    
    NSString *appInfo = [NSGetTools getAppInfoString];// 公共参数
    
//    NSLog(@"---appInfo--%@",appInfo);
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *url = [NSString stringWithFormat:@"%@f_2_10.service?a81=%@&a99=%@&a115=%@&p1=%@&p2=%@&%@",kServerAddressTest,_phoneNum,self.passWord,self.passWord,p1,p2,appInfo];
    
    
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSLog(@"---url--%@",url);
    
    [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSData *datas = responseObject;
        
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        
//        NSLog(@"重置密码返回字典--->%@-",infoDic);
        NSNumber *codeNum = infoDic[@"code"];
        
        if ([codeNum intValue] == 200) {
            NSLog(@"设置成功");
            [NSGetTools showAlert:@"设置成功"];
            [NSGetTools updateIsLoadWithStr:@"isLoad"];
            [self successToMainView];// 登陆
        }else if ([codeNum intValue] == 206){
            NSLog(@"信息不通过审核");
            
            [NSGetTools showAlert:@"用户信息审核不通过,请检查用户信息,或者联系客服人员"];
        }else if ([codeNum intValue] == 220){
            NSLog(@"两次密码输入不一致");
            
            [NSGetTools showAlert:@"两次密码输入不一致"];
        }else{
            [NSGetTools showAlert:@"系统错误"];
            
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error==%@",error);
        [NSGetTools showAlert:@"系统错误,或联网失败"];
        
    }];
    
}




// 注册或修改成功去登陆
- (void)successToMainView
{
    DHLoginViewController *loginVC = [DHLoginViewController new];
    loginVC.phoneNum = _phoneNum;
    loginVC.passWord = _passWord;
    loginVC.whoVC = @"check";
    [self.navigationController pushViewController:loginVC animated:YES];

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
