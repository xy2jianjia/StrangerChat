//
//  PayViewController.m
//  StrangerChat
//
//  Created by zxs on 16/1/7.
//  Copyright © 2016年 long. All rights reserved.
//

#import "PayViewController.h"
#import "DHTableViewCell.h"
#import "payRequsestHandler.h"
#import "Agreement.h"
#import "NPServiceViewController.h"
#import "TempHFController.h"

//APP端签名相关头文件
#import "payRequsestHandler.h"
//服务端签名只需要用到下面一个头文件
//#import "ApiXml.h"
#import <QuartzCore/QuartzCore.h>
#import "WXApiObject.h"
#import "WXApi.h"
@interface PayViewController ()<UITableViewDelegate,UITableViewDataSource,WXApiDelegate> {

    UITableView *wxPaytabel;
    NSDictionary *wxpayDic;
    enum WXScene _scene;
}
@property (nonatomic,strong)NSArray *payTitleArray;
@property (nonatomic,strong)NSArray *secTitleArray;
@property (nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation PayViewController


- (NSArray *)payTitleArray {

    return @[@"套餐名称",@"套餐时长",@"套餐金额"];
}

- (NSArray *)secTitleArray {

    return @[@"套餐名称",@"套餐时长",@"套餐金额",@"促销信息"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSMutableArray array];
    [self ergodic];
    [self payTables];
    [self wxPaydataRuques];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-arrow"] style:(UIBarButtonItemStylePlain) target:self action:@selector(leftAction:)];
}


- (void)leftAction:(UIBarButtonItem *)sender {
    
    [self.navigationController popViewControllerAnimated:true];
}

- (void)ergodic {  // 遍历数组

    
    
#pragma mark  ---- tabelViewController
    NSString *name     = self.payDic[@"b51"];   // 明细名称
    NSString *month    = self.payDic[@"b137"];  // 时长
    NSString *price    = self.payDic[@"b126"];  // 价格
    NSString *advance  = self.payDic[@"b138"];  // 优惠
    [self.dataArray insertObject:name atIndex:0];
    [self.dataArray insertObject:[NSString stringWithFormat:@"%@个月",month] atIndex:1];
    [self.dataArray insertObject:[NSString stringWithFormat:@"%@ 元",price] atIndex:2];
    if (advance) {
        [self.dataArray insertObject:[NSString stringWithFormat:@"送%@个月",advance] atIndex:3];
    }
}

- (void)wxPaydataRuques {

    NSString *code     = self.payDic[@"b13"];   // 明细编码
    NSString *p1 = [NSGetTools getUserSessionId];//sessionId
    NSNumber *p2 = [NSGetTools getUserID];//ID
    NSString *appInfo = [NSGetTools getAppInfoString];// 公共参数
    NSString *appid = [NSGetTools getBundleID];
    NSString *url = [NSString stringWithFormat:@"%@f_124_10_1.service?m16=%@&a153=%@&a130=%@&p1=%@&p2=%@&%@",kServerAddressTestWXpay,code,@"2",appid,p1,p2,appInfo];
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
        
        NSLog(@"%@",infoDic);
        wxpayDic = infoDic[@"body"];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"系统参数请求失败--%@-",error);
    }];

}


- (void)payTables {
    
    wxPaytabel = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] bounds] style:(UITableViewStylePlain)];
    wxPaytabel.separatorStyle = UITableViewCellSelectionStyleNone;
    wxPaytabel.delegate = self;
    wxPaytabel.dataSource = self;
    [wxPaytabel registerClass:[DHTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:wxPaytabel];
    
}

#pragma mark - UITabelView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.dataArray.count;
    }else {
        return 3;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DHTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        if (self.dataArray.count == 4) {
            [cell setTitle:self.secTitleArray[indexPath.row]];
        }else {
            [cell setTitle:self.payTitleArray[indexPath.row]];
        }
       cell.payContent.text = [NSString stringWithFormat:@"%@",self.dataArray[indexPath.row]];
    }else if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            [cell setTitle:@"选择支付方式"];
        }else if (indexPath.row == 1) {
            [self addWithView:cell];
        }else {
            [self addWithlabelView:cell];
        }
        
    }
    return cell;
}

- (void)addWithlabelView:(UIView *)cellView {

    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, [[UIScreen mainScreen] bounds].size.width, 30)];
    title.font = [UIFont systemFontOfSize:14.0f];
    title.text = @"开通会员既表示同意《触陌会员服务条款》";
    [cellView addSubview:title];
}


- (void)addWithView:(UIView *)cellView { // 1 section 1 row

    UIImageView *wxpayImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
    wxpayImage.image = [UIImage imageNamed:@"wxImage"];
    [cellView addSubview:wxpayImage];
    UILabel *wxLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(wxpayImage.frame)+10, 10, 150, 30)];
    wxLabel.text = @"微信支付";
    [cellView addSubview:wxLabel];
    UIImageView *wxdotImage = [[UIImageView alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width - 30-20, 15, 20, 20)];
    wxdotImage.image = [UIImage imageNamed:@"chosedot"];
    [cellView addSubview:wxdotImage];
}



#pragma mark --- section header
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
        return gotHeight(10);
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    if (section == 1) {
        
        return 70;
    }else {
        return 0;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *views = [[UIView alloc] init];
    UIButton *payButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, [[UIScreen mainScreen] bounds].size.width-20, 50)];
    payButton.backgroundColor = [UIColor redColor];
    [payButton.layer setMasksToBounds:YES];
    [payButton.layer setCornerRadius:5.0];
    [payButton setTitle:@"立即付款" forState:(UIControlStateNormal)];
    [payButton addTarget:self action:@selector(payButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [views addSubview:payButton];
    return views;
}

- (void)payButtonAction:(UIButton *)sender {
    
    [self sendPay_demo];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            [self sendPay_demo];
        }else if (indexPath.row == 2) {
//            Agreement *agre = [[Agreement alloc] init]; // 阅读协议
//            [self.navigationController pushViewController:agre animated:true];
            //服务条款
            NPServiceViewController *temp = [[NPServiceViewController alloc] init];
            temp.title = @"付费服务条款";
            temp.urlWeb = @"http://115.236.55.163:9093/lp-h5-msc/p0.html";
            [self.navigationController pushViewController:temp animated:true];
        }
    }
}

#pragma mark ============ 微信支付 ===========
- (void)sendPay_demo
{
    //{{{
    //本实例只是演示签名过程， 请将该过程在商户服务器上实现
    //创建支付签名对象
    payRequsestHandler *req = [payRequsestHandler alloc] ;
    //初始化支付签名对象
    [req init:wxpayDic[@"appid"] mch_id:wxpayDic[@"mch_id"]];
    //设置密钥
    [req setKey:wxpayDic[@"key"]];
    
    //}}}
    //获取到实际调起微信支付的参数后，进行二次签名
    NSMutableDictionary *dict = [req sendPay_demononcestr:wxpayDic[@"nonce_str"] prepay_id:wxpayDic[@"prepay_id"]];
    if(dict == nil){
        //错误提示
        NSString *debug = [req getDebugifo];
        
        [self alert:@"提示信息" msg:debug];
        
        NSLog(@"%@\n\n",debug);
    }else{
        NSLog(@"%@\n\n",[req getDebugifo]);
        //[self alert:@"确认" msg:@"下单成功，点击OK后调起支付！"];
        NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
        //调起微信支付
        PayReq* req             = [[PayReq alloc] init];
        req.openID              = [dict objectForKey:@"appid"];
        req.partnerId           = [dict objectForKey:@"partnerid"];
        req.prepayId            = [dict objectForKey:@"prepayid"];
        req.nonceStr            = [dict objectForKey:@"noncestr"];
        req.timeStamp           = stamp.intValue;
        req.package             = [dict objectForKey:@"package"];
        req.sign                = [dict objectForKey:@"sign"];
        [WXApi sendReq:req];
    }
}

//客户端提示信息
- (void)alert:(NSString *)title msg:(NSString *)msg
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alter show];
}


#pragma mark --- cell返回高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 2) {
        return [DHTableViewCell payViewCellHeight]+20;
    }else {
        return [DHTableViewCell payViewCellHeight];
    }
    

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
