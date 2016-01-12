//
//  TempHFController.m
//  StrangerChat
//
//  Created by zxs on 16/1/7.
//  Copyright © 2016年 long. All rights reserved.
//

#import "TempHFController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "PayViewController.h"
#import "ShowVipController.h"
#import "HFVipViewController.h"
@interface TempHFController ()<UIWebViewDelegate> {
    NSString *number;
    
}

@property (nonatomic,strong)JSContext *jsCondex;
@property (nonatomic, strong)UIWebView *myWeb;

@end

@implementation TempHFController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutTempTableView];
    [self privilege];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-arrow"] style:(UIBarButtonItemStylePlain) target:self action:@selector(leftAction:)];
}

- (void)leftAction:(UIBarButtonItem *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark --- return true false
- (void)privilege {  // 完成
    
    
    NSString *p1 = [NSGetTools getUserSessionId];//sessionId
    NSNumber *p2 = [NSGetTools getUserID];//ID
    NSString *appInfo = [NSGetTools getAppInfoString];// 公共参数
    NSString *url = [NSString stringWithFormat:@"%@f_115_13_1.service?p1=%@&p2=%@&%@",kServerAddressTest2,p1,p2,appInfo];
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        
        NSNumber *codeNum = infoDic[@"code"];
        if ([codeNum intValue] == 200) {
            number = infoDic[@"body"];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"系统参数请求失败--%@-",error);
    }];
    
}


- (void)layoutTempTableView
{
#pragma mark --- web
    self.myWeb = [[UIWebView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = _myWeb;
    self.myWeb.delegate = self;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_urlWeb]];
    [self.myWeb loadRequest:request];
}
#pragma mark --- web代理
- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    self.jsCondex = [self.myWeb valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    self.jsCondex[@"getUserInfo"] = ^(){  // 2  完成
        
        NSString *str = [TempHFController dictionaryToJson:_dicts];
        return str;
    };
    
    self.jsCondex[@"getUrl"] = ^(){ // 10 传域名包月
        
        return kServerAddressTest2;
    };
    
    self.jsCondex[@"getSID"] = ^(){   // 1   p1=" + sid   getSID 完成
        
        NSString *p1 = [NSGetTools getUserSessionId]; //sessionId
        return p1;
    };
    
    self.jsCondex[@"getUserID"] = ^(NSString *msg){ // 11  p2=" + user   getUserID 完成
        
        NSNumber *p2 = [NSGetTools getUserID];//ID
        return p2;
    };
    
    self.jsCondex[@"checkCode"] = ^(){ // 4 分类特权信息  True:vip  False:非VIP  f_115_13_1.service  // 返回0 获1判断权限
        
        int numbers = [number intValue];
        return numbers;
    };
    
    self.jsCondex[@"openWeb"] = ^(NSString *tempUrl){ // 获取URL重新加载页面 完成
        
        ShowVipController *show = [[ShowVipController alloc] init];
        show.title = @"VIP专属特权";
        show.showUrl = tempUrl;
        [self.navigationController pushViewController:show animated:true];
        
    };
    
    self.jsCondex[@"sendVip"] = ^(NSString *ss){  // 5  sendVip   统计用户信息等迭代
        
        
    };
    
    self.jsCondex[@"sendMonth"] = ^(NSString *month){  // 6  sendMonth 统计用户信息等迭代
        
        NSLog(@"我要付费%@",month);
    };
    
    self.jsCondex[@"openVip"] = ^(NSString *JSONString,int number){  // 7 openVip  data, 1包月 2VIp 跳转支付页面
        
        NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
        PayViewController *wxpay = [[PayViewController alloc] init];
        wxpay.title = @"付费界面";
        wxpay.payDic = responseJSON;
        [self.navigationController pushViewController:wxpay animated:true];
        
    };
    
    self.jsCondex[@"setTitle"] = ^(NSString *msg){  // 8 setTitle 跳转页面动态标题
        NSLog(@"%@",msg);
        
    };
    
    self.jsCondex[@"decryptJson"] = ^(NSString *jsondata){ // 11 json解密
        
        NSString *jsonStr = [NSGetTools DecryptWith:jsondata];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        NSString *str = [TempHFController dictionaryToJson:infoDic];
        return str;
    };
}

+ (NSString *)dictionaryToJson:(NSDictionary *)dic {
    
    NSError *error = nil;
    NSData *policyData = [NSJSONSerialization dataWithJSONObject:dic options:kNilOptions error:&error];
    if(!policyData && error){
        NSLog(@"Error creating JSON: %@", [error localizedDescription]);
        return [error localizedDescription];
    }
    NSString  *policyStr = [[NSString alloc] initWithData:policyData encoding:NSUTF8StringEncoding];
    return [policyStr stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
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
