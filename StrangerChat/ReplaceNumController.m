//
//  ReplaceNumController.m
//  StrangerChat
//
//  Created by zxs on 15/11/30.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "ReplaceNumController.h"
#import "BindingController.h"
#import "AccountController.h"
#import "ReplaceView.h"
#define kAlphaNum  @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
@interface ReplaceNumController ()<UITextFieldDelegate>

@property (nonatomic,strong)ReplaceView *pv;
@property (nonatomic,strong)NSString *verificationContent;
@property (nonatomic,strong)NSString *photoNumContent;
@end

@implementation ReplaceNumController
- (void)loadView {

    self.pv = [[ReplaceView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = self.pv;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self aboutButton];
    [self navigationLR];
    self.pv.photoNum.delegate = self;
    self.pv.verification.delegate = self;
    [self.pv.photoNum addTarget:self action:@selector(photoNumEditChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.pv.verification addTarget:self action:@selector(verificationEditChanged:) forControlEvents:UIControlEventEditingChanged];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-normal"] style:(UIBarButtonItemStylePlain) target:self action:@selector(leftAction)];
    
}
#pragma mark---- left
- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- 获取photoNum输入内容
- (void)photoNumEditChanged:(UITextField *)textField

{
    self.photoNumContent = textField.text;
    NSLog(@"textfield text %@",textField.text);
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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:(UIBarButtonItemStylePlain) target:self action:@selector(rightAction:)];
    
}

- (void)rightAction:(UIBarButtonItem *)sender {
    
    NSString *str = @"12";
    if ([self.verificationContent isEqualToString:str]) {  // 检验验证码
        AccountController *account = [[AccountController alloc] init];
        [self.navigationController pushViewController:account animated:true];
    }else {
        [self showHint:@"输入错误的验证码"];
    }
}

#pragma mark --- 点击事件
- (void)aboutButton {
    
    [self.pv addWithphoto:@"手机号" verificat:@"验证码"];
    [self.pv.obtain setTitle:@"获取验证码" forState:(UIControlStateNormal)];
    [self.pv.obtain addTarget:self action:@selector(obtainAtion:) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)obtainAtion:(UIButton *)sender {
    
    //  BOOL photo =  [NSGetTools checkPhoneNum:self.photoNumContent];  // 判断运营商
    if (self.photoNumContent.length == 11) {
        
        [self.pv.obtain setHidden:true];
        self.pv.seconds.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width - 130 - 15, 40, 130, 40);
        
        __block int timeout = COUNTDOWN;
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
        dispatch_source_set_event_handler(_timer, ^{
            if(timeout<=0){
                dispatch_source_cancel(_timer);
                // dispatch_release(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.pv.obtain setHidden:false];
                    [self.pv.seconds setHidden:true];
                });
            }else{
                
                int seconds = timeout % (COUNTDOWN*2);
                NSString *strTime = [NSString stringWithFormat:@"%.2ds后重新发送",seconds];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.pv.seconds setTitle:strTime forState:(UIControlStateNormal)];
                });
                timeout--;
                
            }
        });
        dispatch_resume(_timer);
        
    }else {
        
        
        [self showHint:@"请输入正确的手机号码"];  // 线程优先顺序退出才显示。。。。。
        
    }
    
    
    
}

#pragma mark --- 当用户全部清空的时候的时候 会调用
-(BOOL)textFieldShouldClear:(UITextField *)textField {
    
    self.pv.photoNum.placeholder = @"请输入手机号码";
    self.pv.verification.placeholder = @"请输入验证码";
    return true;
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
