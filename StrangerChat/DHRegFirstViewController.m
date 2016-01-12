//
//  DHRegFirstViewController.m
//  StrangerChat
//
//  Created by xy2 on 15/12/22.
//  Copyright © 2015年 long. All rights reserved.
//

#import "DHRegFirstViewController.h"
#import "NSGetTools.h"
#import <CoreFoundation/CoreFoundation.h>
#import "UIDevice+IdentifierAddition.h"
#import "DHRegThirdViewController.h"
#import "NSGetTools.h"
@interface DHRegFirstViewController ()
@property (weak, nonatomic) IBOutlet UIView *topbgView;
@property (weak, nonatomic) IBOutlet UIView *headerBgView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageV;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIView *topStepLineView;
@property (weak, nonatomic) IBOutlet UITextField *nickNameTextFiled;
@property (weak, nonatomic) IBOutlet UIButton *agreeProtocalBtn;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
@property (weak, nonatomic) IBOutlet UIView *nickNameBgView;



@end

@implementation DHRegFirstViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = HexRGB(0x313131);
    self.navigationItem.title = @"注册";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent] ;
    if (iPhone4) {
        self.infoLabel.font = [UIFont systemFontOfSize:10];
    }else if (iPhonePlus){
        self.infoLabel.font = [UIFont systemFontOfSize:14];
    }
    self.topbgView.backgroundColor = [UIColor clearColor];
    UIImageView *topimageV = [[UIImageView alloc]init];
    topimageV.frame = CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), 200);
    topimageV.image = [UIImage imageNamed:@"regbackground.png"];
    [self.topbgView addSubview:topimageV];
    [self.topbgView sendSubviewToBack:topimageV];
    UIImageView *imageV = [[UIImageView alloc]init];
    imageV.frame = CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds])-66, 50);
    imageV.image = [UIImage imageNamed:@"head-background-writing.png"];
    self.headerBgView.backgroundColor = [UIColor clearColor];
    [self.headerBgView sendSubviewToBack:imageV];
    [self.headerBgView addSubview:imageV];
    self.headerImageV.layer.masksToBounds = YES;
    self.headerImageV.layer.cornerRadius = CGRectGetWidth(_headerImageV.frame)/2;
    self.infoLabel.backgroundColor = [UIColor clearColor];
    _topStepLineView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"reg_line.png"]];
    self.doneBtn.layer.cornerRadius = CGRectGetHeight(_doneBtn.frame)/2;
    self.nickNameBgView.layer.borderColor=[UIColor colorWithRed:0.906 green:0.306 blue:0.435 alpha:1.000].CGColor;
    self.nickNameBgView.layer.borderWidth=1;
    self.nickNameBgView.layer.cornerRadius=CGRectGetHeight(_nickNameBgView.frame)/2;
    // 男
    if (_gender == 1) {
        _headerImageV.image = [UIImage imageNamed:@"headerimage_f_1.png"];
    }else{
      _headerImageV.image = [UIImage imageNamed:@"headerimage_m_1.png"];
    }
    
}
- (IBAction)doneBtnAction:(id)sender {
    [self sendUserInfoToServer];
}
- (void)tapAction:(UITapGestureRecognizer *)sender{
    [self.nickNameTextFiled resignFirstResponder];
}
- (IBAction)agreeProtocalBtnAction:(id)sender {
    
}
// a81手机号，a56密码，a115确认密码，a93短信验证码，a151手机序列号

- (void)sendUserInfoToServer{
    
    NSString *nickName = self.nickNameTextFiled.text;
    if ([nickName length] == 0) {
        [NSGetTools showAlert:@"请填写昵称"];
        return;
    }
    NSString *identifierForVendor = [NSString stringWithFormat:@"%@",[[UIDevice currentDevice] uniqueDeviceIdentifier]];
//    NSString *iden = [NSString stringWithFormat:@"%@",[[UIDevice currentDevice] uniqueGlobalDeviceIdentifier]];
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSString *url = [NSString stringWithFormat:@"%@f_119_11_1.service?a151=%@",kServerAddressTest,identifierForVendor];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        NSNumber *codeNum = infoDic[@"code"];
        NSDictionary *dict2 = infoDic[@"body"];
//         注册成功,将信息保存到服务器
        if ([codeNum integerValue] == 200) {
            //b101 sessionId sessionID
            //b80 userId 用户ID
            //b56 password 密码
            //b81 userName 用户名称
            NSString *sessionId = [dict2 objectForKey:@"b101"];
            NSString *userId = [dict2 objectForKey:@"b80"];
            NSString *password = [dict2 objectForKey:@"b56"];
            NSString *userName = [dict2 objectForKey:@"b81"];
            NSDictionary *dict1 = [NSDictionary dictionaryWithObjectsAndKeys:userName,@"userName",password,@"password",dict2[@"b80"],@"userId",dict2[@"b101"],@"sessionId",dict2[@"b80"],@"gender", nil];
            [[NSUserDefaults standardUserDefaults] setObject:dict1 forKey:@"regUser"];
            dispatch_async(dispatch_get_main_queue(), ^{
                DHRegThirdViewController *vc = [[DHRegThirdViewController alloc]init];
                vc.gender = _gender;
                vc.selectAge = _selectAge;
                [self.navigationController pushViewController:vc animated:YES];
            });
            // 登陆
            [self loginWithUserId:userId sessionId:sessionId username:userName password:password];
        }else{
            [NSGetTools showAlert:[infoDic objectForKey:@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}
//a81:username a56:password p1:sessionid p2: userId
- (void)loginWithUserId:(NSString *)userId sessionId:(NSString *)sessionId username:(NSString *)username password :(NSString *)password{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSString *url = [NSString stringWithFormat:@"%@f_120_10_1.service?a81=%@&a56=%@&p1=%@&p2=%@",kServerAddressTest,username,password,sessionId,userId];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        NSNumber *codeNum = infoDic[@"code"];
        NSDictionary *dict2 = infoDic[@"body"];
        if ([codeNum integerValue] == 200) {
            // 保存账号 密码
            [NSGetTools updateUserAccount:username];
            [NSGetTools updateUserPassWord:password];
            // 保存用户ID
            [NSGetTools upDateUserID:dict2[@"b80"]];
            // 保存用户SessionId
            [NSGetTools upDateUserSessionId:dict2[@"b101"]];
            
            [NSGetTools updateIsLoadWithStr:@"isLoad"];
            NSLog(@"登陆成功");
            [self saveUserInfoWithSessionId:sessionId userId:userId password:password userName:username];
            // 保存用户信息
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.userInfo);
    }];
}

- (void)saveUserInfoWithSessionId:(NSString *)sessionId userId:(NSString *)userId password:(NSString *)password userName:(NSString *)userName{
    
    NSString *nickName = self.nickNameTextFiled.text;
    if ([nickName length] == 0) {
        [NSGetTools showAlert:@"请填写昵称"];
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:nickName forKey:@"nickName"];
    NSInteger gender = self.gender;
    NSNumber *b69 = [NSNumber numberWithInteger:gender];
    [NSGetTools updateUserSexInfoWithB69:b69];
    NSString *appInfo = [NSGetTools getAppInfoString];
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    //a34:id a1:年龄 a69：性别 a52：昵称
    NSString *url = [NSString stringWithFormat:@"%@f_108_11_2.service?p1=%@&p2=%@&%@",kServerAddressTest2,sessionId,userId,appInfo];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    [dataDict setObject:[NSNumber numberWithInteger:self.selectAge] forKey:@"a1"];
    [dataDict setObject:[NSNumber numberWithInteger:gender] forKey:@"a69"];
    [dataDict setObject:nickName forKey:@"a52"];
    [manger POST:url parameters:dataDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        NSDictionary *dict2 = infoDic[@"body"];
        NSNumber *codeNum = infoDic[@"code"];
        if ([codeNum integerValue] == 200) {
            NSString *b34 = [dict2 objectForKey:@"b34"];
            [NSGetTools upDateB34:[NSNumber numberWithInteger:[b34 integerValue]]];
        }else{
            [NSGetTools showAlert:infoDic[@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@",error.userInfo);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tap];
    [self sethideKeyBoardAccessoryView];
    [Mynotification addObserver:self selector:@selector(dismissVC) name:@"dismissVC" object:nil];
    // Do any additional setup after loading the view from its nib.
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
    [doneBtn addTarget:self action:@selector(tapAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [accessoryView addSubview:doneBtn];
    self.nickNameTextFiled.inputAccessoryView = accessoryView;
    //    self.userPassTextField.inputAccessoryView = accessoryView;
}
- (void)dismissVC{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)dealloc{
    [Mynotification removeObserver:self];
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
