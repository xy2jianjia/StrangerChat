//
//  ShowVipController.m
//  StrangerChat
//
//  Created by zxs on 16/1/9.
//  Copyright © 2016年 long. All rights reserved.
//

#import "ShowVipController.h"
#import "TempHFController.h"
@interface ShowVipController ()<UIWebViewDelegate>

@property (nonatomic, strong)UIWebView *myWeb;

@end

@implementation ShowVipController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self layoutTempTableView];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-arrow"] style:(UIBarButtonItemStylePlain) target:self action:@selector(leftAction:)];
}

- (void)leftAction:(UIBarButtonItem *)sender {
    
//    TempHFController *cg = [[TempHFController alloc] init];
    [self.navigationController popViewControllerAnimated:true];
    
}
- (void)layoutTempTableView
{
#pragma mark --- web
    self.myWeb = [[UIWebView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = _myWeb;
    self.myWeb.delegate = self;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.showUrl]];
    [self.myWeb loadRequest:request];
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
