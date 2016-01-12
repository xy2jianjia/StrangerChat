//
//  MailboxController.m
//  StrangerChat
//
//  Created by zxs on 15/12/9.
//  Copyright © 2015年 long. All rights reserved.
//

#import "MailboxController.h"
#import "MyDataViewController.h"
@interface MailboxController ()<UITextFieldDelegate> {
    
    NSString *mailText;
    BOOL mail;
}
@property (nonatomic,strong)UITextField *textField;
@end

@implementation MailboxController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self leftButton];
    [self n_uitextField];
}


- (void)n_uitextField {

    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(0,85, [[UIScreen mainScreen] bounds].size.width, 40)];
    self.textField.delegate            = self;
    self.textField.placeholder         = @"请输入邮箱";
    self.textField.layer.borderWidth   = 1.0f;
    self.textField.layer.masksToBounds = true;
    self.textField.clearButtonMode     =  UITextFieldViewModeAlways;
    self.textField.layer.borderColor   = [kUIColorFromRGB(0xD0D0D0) CGColor];
    [self.view addSubview:self.textField];
    [self.textField addTarget:self action:@selector(photoNumEditChanged:) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark -- 编辑结束获取邮箱正则判断
- (void)photoNumEditChanged:(UITextField *)textField

{
    if ([AllRegular validateEmail:textField.text]) {
        mail = true;
    }else {
        mail = false;
        [self showHint:@"请输入正确邮箱"];
    }
}



-(BOOL)textFieldShouldClear:(UITextField *)textField {
    
    self.textField.placeholder = @"请输入邮箱";
    return true;
}

#pragma mark--- left
- (void)leftButton {
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-normal"] style:(UIBarButtonItemStylePlain) target:self action:@selector(leftAction:)];

}

- (void)leftAction:(UIBarButtonItem *)sender {

    if (mail == true) {
        _mb(_textField.text);
        MyDataViewController *detail = [[MyDataViewController alloc] init];
        [self.navigationController pushViewController:detail animated:true];
    }else {  // 没有输入邮箱，传空值
        _mb(nil);
        MyDataViewController *detail = [[MyDataViewController alloc] init];
        [self.navigationController pushViewController:detail animated:true];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
// 点击空白处隐藏按钮
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.textField resignFirstResponder];
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
