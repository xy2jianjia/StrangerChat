//
//  NPOpinionController.m
//  StrangerChat
//
//  Created by zxs on 15/11/27.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "NPOpinionController.h"
#import "OpinionView.h"
@interface NPOpinionController ()<UITextViewDelegate> {
    
    NSString *textViewStr;
    UILabel *placeHolderLabel;
} 
@property (nonatomic,strong)OpinionView *pv;
@end

@implementation NPOpinionController
- (void)loadView {
    
    self.pv = [[OpinionView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = self.pv;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self sethideKeyBoardAccessoryView];
    [self placeholder];
    [self n_button];
//    [self setInputAccessory];
    self.pv.feedback.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.pv addDataWithtitle:@"200字以内"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-arrow"] style:(UIBarButtonItemStylePlain) target:self action:@selector(leftAction:)];
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
    self.pv.feedback.inputAccessoryView = accessoryView;
//    self.nv.verification.inputAccessoryView = accessoryView;
}
- (void)leftAction:(UIBarButtonItem *)sender {
    
    [self.navigationController popViewControllerAnimated:true];
}
#pragma mark ---- button
- (void)n_button {
    
    [self.pv.submit setTitle:@"提交" forState:(UIControlStateNormal)];
    [self.pv.submit addTarget:self action:@selector(submitAction:) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)submitAction:(UIButton *)sender {
    [self hideKeyboard];
    NSString *m11 = [NSGetTools getCurrentDevice];// 手机型号
    NSString *m5 = [NSGetTools getAppVersion];// 应用版本号
    NSString *m8 = [[UIDevice currentDevice] systemVersion];// 系统版本号
    NSString *p1 = [NSGetTools getUserSessionId];//sessionId
    NSNumber *p2 = [NSGetTools getUserID];//ID
    NSString *appInfo = [NSGetTools getAppInfoString];// 公共参数
    NSMutableDictionary *allDict = [NSMutableDictionary dictionary];
    [allDict setObject:textViewStr forKey:@"a14"];
    [allDict setObject:@"2" forKey:@"a61"];  // 2 ---IOS
    [allDict setObject:m5 forKey:@"a2"];
    [allDict setObject:m11 forKey:@"a49"];
    [allDict setObject:m8 forKey:@"a68"];
    NSString *number = [[NSUserDefaults standardUserDefaults] objectForKey:@"bindPhone"];
    if (!number) {
        [self showHint:@"还未绑定手机"];
        return;
    }
    [allDict setObject:number forKey:@"a81"];
    [NSURLObject addWithVariableDic:allDict];
    [NSURLObject addWithdict:allDict urlStr:[NSString stringWithFormat:@"%@f_103_10_2.service?p1=%@&p2=%@&%@",kServerAddressTest2,p1,p2,appInfo]];  // 上传服务器
}

- (void)placeholder {

    //TextView占位符
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, 7, 400/2, 20)];
    placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
    placeHolderLabel.font = [UIFont systemFontOfSize:18.0f];
    placeHolderLabel.textColor = kUIColorFromRGB(0x808080);
    placeHolderLabel.alpha = 0;
    placeHolderLabel.tag = 999;
    placeHolderLabel.text = @"请输入您的意见和建议……";
    [self.pv.feedback addSubview:placeHolderLabel];
    if ([[self.pv.feedback text] length] == 0) {
        [[self.pv.feedback viewWithTag:999] setAlpha:1];
    }
    
}

- (void)setInputAccessory {
    
    // 在键盘上添加一个隐藏的按钮
    UIToolbar *topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 30)];
    //设置style
    [topView
     setBarStyle:UIBarStyleBlack];
    //定义两个flexibleSpace的button，放在toolBar上，这样完成按钮就会在最右边
    UIBarButtonItem
    * button1 =[[UIBarButtonItem  alloc]initWithBarButtonSystemItem:                                        UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem
    * button2 = [[UIBarButtonItem  alloc]initWithBarButtonSystemItem:                                        UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    //定义完成按钮
    UIBarButtonItem
    * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成"style:UIBarButtonItemStyleDone
                                                  target:self action:@selector(hideKeyboard)];
    //在toolBar上加上这些按钮
    NSArray * buttonsArray = [NSArray arrayWithObjects:button1,button2,doneButton,nil];
    [topView setItems:buttonsArray];
    [self.pv.feedback
     setInputAccessoryView:topView];
    
}
- (void)hideKeyboard
{
    [self.pv.feedback resignFirstResponder];
}

//结束编辑
- (void)textViewDidEndEditing:(UITextView *)textView {
    
    textViewStr = textView.text;
}


//输入框要编辑的时候
- (void)textChanged:(NSNotification *)notification
{
    if ([[self.pv.feedback text] length] == 0) {
        [[self.pv.feedback viewWithTag:999] setAlpha:1];
    }
    else {
        [[self.pv.feedback viewWithTag:999] setAlpha:0];
    }
}

// 点击空白处隐藏按钮
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.pv.feedback resignFirstResponder];
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
