//
//  MeTouchController.m
//  StrangerChat
//
//  Created by zxs on 15/12/1.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "MeTouchController.h"
#import "MeTouchCell.h"
#import "Homepage.h"
#import "MeTouchModel.h"
@interface MeTouchController ()<UITableViewDelegate,UITableViewDataSource> {
    
    UITableView *paraTabelView;
}
@property (nonatomic,strong)NSMutableArray *touchArray;
@end

@implementation MeTouchController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.touchArray = [NSMutableArray array];
    [self layoutParallax];
    [self getTouchData];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-normal"] style:(UIBarButtonItemStylePlain) target:self action:@selector(leftAction)];
}

- (void)leftAction {
    
    [self.navigationController popToRootViewControllerAnimated:true];
}

- (void)getTouchData {

    NSString *p1 = [NSGetTools getUserSessionId];//sessionId
    NSNumber *p2 = [NSGetTools getUserID];//ID
    NSString *appInfo = [NSGetTools getAppInfoString];// 公共参数
    NSString *url = [NSString stringWithFormat:@"%@f_105_11_1.service?a78=%@&a95=%@&p1=%@&p2=%@&%@",kServerAddressTest2,@"1",@"1",p1,p2,appInfo];
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
        for (NSString *keys in infoDic) {
            NSLog(@"错误信息----->:%@ 错误条件----->:%@",keys,[infoDic objectForKey:keys]);
        }
        NSNumber *codeNum = infoDic[@"code"];
        if ([codeNum intValue] == 200) {
            NSArray *touchArray = infoDic[@"body"];
            
            for (NSDictionary *touchDic in touchArray) {
                
                MeTouchModel *touch = [[MeTouchModel alloc] init];
                touch.userId    = touchDic[@"b80"];
                touch.photoUrl  = touchDic[@"b57"];  // 头像连接
                touch.nickName  = touchDic[@"b52"];  // 昵称
                touch.vip       = [touchDic[@"b144"] integerValue]; // 1：VIP 2：非VIP  (int)
                touch.ageStr    = [NSString stringWithFormat:@"%@",touchDic[@"b1"]];   // 年龄
                if (touchDic[@"b33"] == nil) {
                    touch.heightStr = @"保密";
                }else {
                    touch.heightStr    = [NSString stringWithFormat:@"%@cm",touchDic[@"b33"]];  // 身高
                }
                touch.province  = [self addWithVariDic:[ConditionObject provinceDict] keyStr:[NSString stringWithFormat:@"%@",touchDic[@"b67"]]];  // 省份
                touch.city      = [self addWithVariDic:[ConditionObject obtainDict]   keyStr:[NSString stringWithFormat:@"%@",touchDic[@"b9"]]];   // 城市
                
                [self.touchArray addObject:touch];
                
            }
        }
        [paraTabelView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"系统参数请求失败--%@-",error);
    }];
    
}

/**
 *  Description
 *
 *  @param VariDic 倒叙的城市/省份 字典
 *  @param keystr  key取值
 *
 *  @return 结果
 */
- (NSString *)addWithVariDic:(NSDictionary *)VariDic keyStr:(NSString *)keystr {
    
    NSDictionary *cityDic = VariDic;    // 市
    NSMutableDictionary *cityDict = [NSMutableDictionary dictionary];
    for (NSString *cityKey in cityDic) {
        NSString *cityValue = [cityDic objectForKey:cityKey];
        [cityDict setObject:cityKey forKey:cityValue];
    }
    return [cityDict objectForKey:[NSString stringWithFormat:@"%@",keystr]];
}

- (void)layoutParallax
{
    paraTabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:(UITableViewStylePlain)];
    paraTabelView.separatorStyle = UITableViewCellSelectionStyleNone;
    paraTabelView.delegate = self;
    paraTabelView.dataSource = self;
    paraTabelView.backgroundColor = kUIColorFromRGB(0xEEEEEE);
    [paraTabelView registerClass:[MeTouchCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:paraTabelView];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.touchArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MeTouchModel *touch = self.touchArray[indexPath.row];
    MeTouchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.VipImage.image = [UIImage imageNamed:@"icon-name-vip"];  // Vip会员专有头像（vip 为 true else nil）
    
    cell.title.text = touch.nickName;
    if (touch.ageStr == nil) {
        cell.age.text  = @"保密";
    }else {
        cell.age.text   = [NSString stringWithFormat:@"%@岁",touch.ageStr];
    }
    
    if (touch.vip == 1) { // VIP标志
        cell.VipImage.image = [UIImage imageNamed:@"icon-name-vip"];
    }
    if (touch.province == nil) {
        touch.province = @"保密";
    }
    if (touch.city == nil) {
        touch.city = @"保密";
    }
    [cell addDataWithheight:[NSString stringWithFormat:@"%@",touch.heightStr] address:[NSString stringWithFormat:@"%@ %@",touch.province,touch.city]];
    [cell cellLoadWithurlStr:[NSURL URLWithString:touch.photoUrl]];
    
    
    
    if (indexPath.row == 0) {
        cell.topLine.frame  = CGRectMake( 0,    0, [[UIScreen mainScreen] bounds].size.width, 0.5);
        cell.downLine.frame = CGRectMake(80, 79.5, [[UIScreen mainScreen] bounds].size.width, 0.5);
    }else {
        cell.downLine.frame = CGRectMake(80, 79.5, [[UIScreen mainScreen] bounds].size.width, 0.5);
    }
    return cell;
    
}



#pragma mark --- cell返回高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return [MeTouchCell meTouchCellHeight];
    
    
}

#pragma mark --- section header
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return gotHeight(12);
}

#pragma mark --- 选中cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    NSString *p1 = [NSGetTools getUserSessionId];//sessionId
    NSNumber *p2 = [NSGetTools getUserID];//ID
    NSString *appInfo = [NSGetTools getAppInfoString];// 公共参数
    MeTouchModel *touch = self.touchArray[indexPath.row];
    Homepage *home = [[Homepage alloc] init];
    home.touchP2 = touch.userId;
    [self.navigationController pushViewController:home animated:false];
    [NSURLObject addWithdict:nil urlStr:[NSString stringWithFormat:@"%@f_109_11_2.service?a77=%@&p1=%@&p2=%@&%@",kServerAddressTest2,touch.userId,p1,p2,appInfo]];
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
