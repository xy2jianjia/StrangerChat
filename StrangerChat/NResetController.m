//
//  NResetController.m
//  StrangerChat
//
//  Created by zxs on 15/11/27.
//  Copyright (c) 2015年 long. All rights reserved.
//  重置密码

#import "NResetController.h"
#import "AccountController.h"
#import "NewPasswrodController.h"
#import "NextView.h"
#define kNumbers @"0123456789"
@interface NResetController ()<UITextFieldDelegate> {



}
@property (nonatomic,strong)NextView *nv;
@property (nonatomic,strong)NSString *photoNumContent;
@property (nonatomic,strong)NSString *verificationContent;
@end

@implementation NResetController

- (void)loadView {

    self.nv = [[NextView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = self.nv;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nv.photoNum.keyboardType = UIKeyboardTypeNumberPad;
    
    [self sethideKeyBoardAccessoryView];
    [self aboutButton];
    [self navigationLR];
    self.nv.photoNum.delegate = self;
    self.nv.verification.delegate = self;
    [self.nv.photoNum addTarget:self action:@selector(photoNumEditChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.nv.verification addTarget:self action:@selector(verificationEditChanged:) forControlEvents:UIControlEventEditingChanged];
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
    [doneBtn addTarget:self action:@selector(hideKeyboard) forControlEvents:(UIControlEventTouchUpInside)];
    [accessoryView addSubview:doneBtn];
    self.nv.photoNum.inputAccessoryView = accessoryView;
    self.nv.verification.inputAccessoryView = accessoryView;
}
- (void)hideKeyboard{
    [self.nv.photoNum resignFirstResponder];
    [self.nv.verification resignFirstResponder];
}
#pragma mark -- 获取手机输入内容
- (void)photoNumEditChanged:(UITextField *)textField

{
    self.photoNumContent = textField.text;
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:kNumbers] invertedSet];
    NSString *filtered =
    [[textField.text componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    if ([textField.text isEqualToString:filtered]) {
        
    }else {
        
        [self showHint:@"请不要输入除数字以外的字符"];
        textField.text = @"";
    }
    
}

#pragma mark -- 获取verification输入内容
- (void)verificationEditChanged:(UITextField *)textField

{
    self.verificationContent = textField.text;

}

#pragma mark -- navigationLR
- (void)navigationLR {
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:(UIBarButtonItemStylePlain) target:self action:@selector(rightAction:)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-normal"] style:(UIBarButtonItemStylePlain) target:self action:@selector(leftAction)];
}

- (void)rightAction:(UIBarButtonItem *)sender {
    [self hideKeyboard];
    NSString *verifyCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"verifyCode"];
    if (verifyCode && [verifyCode length] != 0) {
        if ([self.verificationContent isEqualToString:verifyCode]) {  // 检验验证码
//            NSString *msgType = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"msgType"]];
            // msgType 1、注册；2、修改密码；3、绑定手机
            if (_msgType && [_msgType isEqualToString:@"3"]) {
                [self bindPhoneNumber];
            }else if(_msgType && [_msgType isEqualToString:@"2"]){
                // 改密
                NewPasswrodController *pass = [[NewPasswrodController alloc] init];
                pass.title = @"修改密码";
                pass.verifyCode = verifyCode;
                NSString *phoneNum = self.nv.photoNum.text;
                pass.phoneNumber = phoneNum;
                [self.navigationController pushViewController:pass animated:true];
            }else if(_msgType && [_msgType isEqualToString:@"1"]){
                // 注册
            }else{
                [NSGetTools showAlert:@"未知短信类型!"];
            }
        }else {
            [self showHint:@"输入错误的验证码"];
        }
    }else{
        [self showHint:@"请输入验证码！"];
    }
    
    
}
/**
 *   绑定手机号LP-file-msc/ f_120_14_1.service?a81=电话号码，a152=系统产生用户号，a93=短信验证码，p2=userId，p1=sessionId
 */
- (void)bindPhoneNumber{
    [self hideKeyboard];
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    NSString *sessonId = [NSGetTools getUserSessionId];
    __block NSString *phoneNum = self.nv.photoNum.text;
    if ([phoneNum length] == 0) {
        [self showHint:@"输入正确的手机号！"];
        return ;
    }
    NSString *verifyCode = self.verificationContent;
//    [[NSUserDefaults standardUserDefaults] objectForKey:@"verifyCode"];
    if (!verifyCode) {
        [self showHint:@"请输入验证码！"];
        return ;
    }
    NSString *a152 = [[NSUserDefaults standardUserDefaults] objectForKey:@"b152"];
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSString *appinfoStr = [NSGetTools getAppInfoString];
    NSString *url = [NSString stringWithFormat:@"%@f_120_14_1.service?a81=%@&a152=%@&a93=%@&p1=%@&p2=%@&%@",kServerAddressTest, phoneNum, a152, verifyCode,sessonId,userId,appinfoStr];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        NSNumber *codeNum = infoDic[@"code"];
        if ([codeNum integerValue] == 200) {
            [self showHint:@"已绑定！"];
            
//            NSDictionary *resultDict = [infoDic objectForKey:@"body"];
//            NSString *verifyCode = [resultDict objectForKey:@"b93"];
            NSString *phoneNumber = phoneNum;
//            [resultDict objectForKey:@"b81"];
//            NSString *msgType = [resultDict objectForKey:@"b92"];
            // 保存验证码
//            [[NSUserDefaults standardUserDefaults] setObject:verifyCode forKey:@"verifyCode"];
            [[NSUserDefaults standardUserDefaults] setObject:phoneNumber forKey:@"bindPhone"];
//            [[NSUserDefaults standardUserDefaults] setObject:msgType forKey:@"msgType"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [NSGetTools showAlert:@"绑定失败，请重新绑定！"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.userInfo);
    }];
}
#pragma mark -- left
- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --- 点击事件
- (void)aboutButton {
    [self hideKeyboard];
    [self.nv addWithphoto:@"手机号" verificat:@"验证码"];
    [self.nv.obtain setTitle:@"获取验证码" forState:(UIControlStateNormal)];
    [self.nv.obtain addTarget:self action:@selector(obtainAtion:) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)obtainAtion:(UIButton *)sender {

//  BOOL photo =  [NSGetTools checkPhoneNum:self.photoNumContent];  // 判断运营商
    if (self.photoNumContent.length == 11) {
        [self getVerifyNumber];
        [self.nv.obtain setHidden:true];
        self.nv.seconds.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width - 130 - 15, 40, 130, 40);
        
        __block int timeout = COUNTDOWN;
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            if(timeout<=0){ //倒计时结束，关闭
                dispatch_source_cancel(_timer);
                // dispatch_release(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.nv.obtain setHidden:false];
                    [self.nv.seconds setHidden:true];
                });
            }else{
                // int minutes = timeout / 60;
                int seconds = timeout % (COUNTDOWN*2);
                NSString *strTime = [NSString stringWithFormat:@"%.2ds后重新发送",seconds];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.nv.seconds setTitle:strTime forState:(UIControlStateNormal)];
                });
                timeout--;
            }  
        });  
        dispatch_resume(_timer);
        
    }else {
        [self showHint:@"请输入正确的手机号码"];

    }
}
/**
 *  获取验证码a81：userName：电话号码
 *  a92：msgType 短信类别：1：注册短信 2：修改密码短信 3：绑定手机号
 *  @return 
 *    "b81": "18857869626", 用户名
 *   "b92": "1",  短信类型
 *   "b93": "4124" 短信验证码
 */
- (void)getVerifyNumber{
    
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    NSString *sessonId = [NSGetTools getUserSessionId];
    NSString *phoneNum = self.nv.photoNum.text;
    if ([phoneNum length] == 0) {
        [self showHint:@"输入正确的手机号！"];
        return ;
    }
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSString *appinfoStr = [NSGetTools getAppInfoString];
    NSString *url = [NSString stringWithFormat:@"%@f_118_10_1.service?a81=%@&a92=%@&p1=%@&p2=%@&%@",kServerAddressTest, phoneNum, _msgType,sessonId,userId,appinfoStr];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        NSNumber *codeNum = infoDic[@"code"];
        if ([codeNum integerValue] == 200) {
            [self showHint:@"短信已经发送，请注意查收"];
            NSDictionary *resultDict = [infoDic objectForKey:@"body"];
            NSString *verifyCode = [resultDict objectForKey:@"b93"];
//            NSString *phoneNumber = [resultDict objectForKey:@"b81"];
            NSString *msgType = [resultDict objectForKey:@"b92"];
            // 保存验证码
            [[NSUserDefaults standardUserDefaults] setObject:verifyCode forKey:@"verifyCode"];
//            [[NSUserDefaults standardUserDefaults] setObject:phoneNumber forKey:@"bindPhone"];
            [[NSUserDefaults standardUserDefaults] setObject:msgType forKey:@"msgType"];
        }else if ([codeNum integerValue] == 2001){
            dispatch_async(dispatch_get_main_queue(), ^{
                [NSGetTools showAlert:[infoDic objectForKey:@"msg"]];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.userInfo);
    }];
    
}
#pragma mark --- 当用户全部清空的时候的时候 会调用
-(BOOL)textFieldShouldClear:(UITextField *)textField {
    
    self.nv.photoNum.placeholder = @"请输入手机号码";
    self.nv.verification.placeholder = @"请输入验证码";
    return true;
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
