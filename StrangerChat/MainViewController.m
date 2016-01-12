//
//  MainViewController.m
//  StrangerChat
//
//  Created by long on 15/10/16.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "MainViewController.h"
//#import "LoginViewController.h"
#import "FirstViewController.h"

#import "CXAlertView.h"
#import "DHRegFirstViewController.h"
#import "DHLoginViewController.h"
@interface MainViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,strong) UIButton *boyButton;// 注册按钮
@property (nonatomic,strong) UIButton *girlButton;// 找回密码按钮
@property (nonatomic,strong) UIButton *loginButton;// 登陆
@property (nonatomic,strong) UIPickerView *pickerView;// 登陆

@property (nonatomic,strong) NSMutableArray *ageArray;
@property (nonatomic,assign) NSInteger selectAge;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _ageArray = [NSMutableArray array];
    
    for (int i =18; i < 66; i ++) {
        [_ageArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
//    if (iPhone4) {
//        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login-bg21.png"]];
//    }else if (iPhone5){
//        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login-bg2.png"]];
//    }else if (iPhone6){
//        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login-bg23.png"]];
//    }else{
//        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login-bg24.png"]];
//    }
    
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:nil];
    UIImageView *imageView = nil;
    if (iPhone4) {
         imageView = [[UIImageView alloc] initWithFrame:CGRectMake(got(10), got(20), got(300), got(255))];
    }else{
    
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(got(10), got(30), got(300), got(255))];
    }
    imageView.image = [UIImage imageNamed:@"background-photo-normal.png"];
    [self.view addSubview:imageView];
    
    if (iPhone4) {
        self.boyButton = [[UIButton alloc] initWithFrame:CGRectMake(got(50), gotHeight(330), got(70), got(70))];
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        btn.frame = CGRectMake(CGRectGetMidX(self.boyButton.frame)-35, CGRectGetMaxY(self.boyButton.frame)+10, 70, 20);
        [btn setBackgroundImage:[UIImage imageNamed:@"button-boy-normal.png"] forState:(UIControlStateNormal)];
        [btn setTitle:@"帅哥注册" forState:(UIControlStateNormal)];
        btn.titleLabel.font = [UIFont systemFontOfSize:11];
        [btn addTarget:self action:@selector(boyButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }else{
        self.boyButton = [[UIButton alloc] initWithFrame:CGRectMake(got(40), gotHeight(280), got(90), got(90))];
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        btn.frame = CGRectMake(CGRectGetMidX(self.boyButton.frame)-42, CGRectGetMaxY(self.boyButton.frame)+10, 85, 31);
        [btn setBackgroundImage:[UIImage imageNamed:@"button-boy-normal.png"] forState:(UIControlStateNormal)];
        [btn setTitle:@"帅哥注册" forState:(UIControlStateNormal)];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn addTarget:self action:@selector(boyButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];

    }
    
    [self.boyButton setImage:[UIImage imageNamed:@"icon-boy-normal.png"] forState:UIControlStateNormal];
//    [self.boyButton setImage:[UIImage imageNamed:@"icon-boy-normal.png"] forState:UIControlStateSelected];
    [self.boyButton addTarget:self action:@selector(boyButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.boyButton];
    
    if (iPhone4) {
        self.girlButton = [[UIButton alloc] initWithFrame:CGRectMake(got(200), gotHeight(330), got(70), got(70))];
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        btn.frame = CGRectMake(CGRectGetMidX(self.girlButton.frame)-35, CGRectGetMaxY(self.girlButton.frame)+10, 70, 20);
        [btn setBackgroundImage:[UIImage imageNamed:@"button-girl-normal.png"] forState:(UIControlStateNormal)];
        [btn setTitle:@"美女注册" forState:(UIControlStateNormal)];
        btn.titleLabel.font = [UIFont systemFontOfSize:11];
        [btn addTarget:self action:@selector(girlButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }else{
        self.girlButton = [[UIButton alloc] initWithFrame:CGRectMake(got(190), gotHeight(280), got(90), got(90))];
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        btn.frame = CGRectMake(CGRectGetMidX(self.girlButton.frame)-42, CGRectGetMaxY(self.girlButton.frame)+10, 85, 31);
        [btn setBackgroundImage:[UIImage imageNamed:@"button-girl-normal.png"] forState:(UIControlStateNormal)];
        [btn setTitle:@"美女注册" forState:(UIControlStateNormal)];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn addTarget:self action:@selector(girlButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];

    }
    
    
    [self.girlButton setImage:[UIImage imageNamed:@"icon-girl-normal.png"] forState:UIControlStateNormal];
//    [self.girlButton setImage:[UIImage imageNamed:@"icon-girl-normal.png"] forState:UIControlStateSelected];
    [self.girlButton addTarget:self action:@selector(girlButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.girlButton];
    
    //登陆按钮
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    nextButton.backgroundColor = HexRGB(0Xf04d6d);
    [nextButton setBackgroundImage:[UIImage imageNamed:@"button-login-normal.png"] forState:UIControlStateNormal];
    if (iPhone4) {
        nextButton.frame = CGRectMake(got(16), gotHeight(470), ScreenWidth-32, gotHeight(45));
    }else{
        nextButton.frame = CGRectMake(got(16), gotHeight(450), ScreenWidth-32, gotHeight(45));
    }
    [nextButton setTitle:@"已有账号，点此登录" forState:UIControlStateNormal];
    [self.view addSubview:nextButton];
    [nextButton setTitleColor:HexRGB(0xef4f6e) forState:UIControlStateNormal];
    nextButton.titleLabel.font = [UIFont systemFontOfSize:got(13)];
    nextButton.layer.cornerRadius = got(5);
    nextButton.clipsToBounds = YES;
    [nextButton addTarget:self action:@selector(nextButtonAction:) forControlEvents:UIControlEventTouchUpInside];

}


- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}


// 男孩:1
- (void)boyButtonAction:(UIButton *)sender{
    _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(-30, 0, CGRectGetWidth([[UIScreen mainScreen] bounds])-60, 200)];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    CXAlertView *alert = [[CXAlertView alloc]initWithTitle:@"您的年龄" contentView:_pickerView cancelButtonTitle:@"取消"];
    [alert addButtonWithTitle:@"确定" type:(CXAlertViewButtonTypeCustom) handler:^(CXAlertView *alertView, CXAlertButtonItem *button) {
        if (_selectAge == 0) {
            _selectAge = 22;
        }
        [alertView dismiss];
        DHRegFirstViewController *vc = [[DHRegFirstViewController alloc]init];
        vc.selectAge = _selectAge;
        vc.gender = 1;
        UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:vc];
//        nc.navigationBar.backgroundColor = [UIColor blackColor];
        [self presentViewController:nc animated:YES completion:^{
            
        }];
    }];
    [alert show];
}
// 女孩:2
- (void)girlButtonAction:(UIButton *)sender{
    _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(-30, 0, CGRectGetWidth([[UIScreen mainScreen] bounds])-60, 200)];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    CXAlertView *alert = [[CXAlertView alloc]initWithTitle:@"您的年龄" contentView:_pickerView cancelButtonTitle:@"取消"];
    [alert addButtonWithTitle:@"确定" type:(CXAlertViewButtonTypeCustom) handler:^(CXAlertView *alertView, CXAlertButtonItem *button) {
        if (_selectAge == 0) {
            _selectAge = 22;
        }
        [alertView dismiss];
        DHRegFirstViewController *vc = [[DHRegFirstViewController alloc]init];
        vc.selectAge = _selectAge;
        vc.gender = 2;
//        [self.navigationController pushViewController:vc animated:YES];
        UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:vc];
        //        nc.navigationBar.backgroundColor = [UIColor blackColor];
        [self presentViewController:nc animated:YES completion:^{
            
        }];
    }];
    [alert show];
}

// 登陆
- (void)nextButtonAction:(UIButton *)sender{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    DHLoginViewController *loginVC = [DHLoginViewController new];
    loginVC.whoVC = @"login";
    [[[UIApplication sharedApplication] keyWindow] setRootViewController:loginVC];
    [UIView commitAnimations];
    
    
//    [self.navigationController pushViewController:loginVC animated:YES];
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _ageArray.count;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [_ageArray objectAtIndex:row];
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _selectAge = [[_ageArray objectAtIndex:row] integerValue];
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
