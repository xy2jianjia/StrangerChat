//
//  SeenMeController.m
//  StrangerChat
//
//  Created by zxs on 15/12/1.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "SeenMeController.h"
#import "SeenCell.h"
#import "DHSeenModel.h"
#import "Homepage.h"
@interface SeenMeController ()<UITableViewDelegate,UITableViewDataSource> {
    
    UITableView *paraTabelView;
}

@property (nonatomic,strong)NSMutableArray *seenMeArray;
@end

@implementation SeenMeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutParallax];
    self.seenMeArray = [NSMutableArray array];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-normal"] style:(UIBarButtonItemStylePlain) target:self action:@selector(leftAction)];
    [self n_Request];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)leftAction {
    
    [self.navigationController popToRootViewControllerAnimated:true];
}
- (void)layoutParallax
{
    paraTabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:(UITableViewStylePlain)];
    paraTabelView.separatorStyle = UITableViewCellSelectionStyleNone;
    paraTabelView.delegate = self;
    paraTabelView.dataSource = self;
    paraTabelView.backgroundColor = kUIColorFromRGB(0xEEEEEE);
    [paraTabelView registerClass:[SeenCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:paraTabelView];
}

#pragma mark ---- request
- (void)n_Request {
    
    NSString *p1 = [NSGetTools getUserSessionId];//sessionId
    NSNumber *p2 = [NSGetTools getUserID];//ID
    NSString *appInfo = [NSGetTools getAppInfoString];// 公共参数
    NSString *url = [NSString stringWithFormat:@"%@f_109_10_1.service?a95=%@&p1=%@&p2=%@&%@",kServerAddressTest2,@"1",p1,p2,appInfo];
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
        NSLog(@"%@",infoDic);
        if ([codeNum intValue] == 200) {
            
            NSArray *touchArray = infoDic[@"body"];
            
            for (NSDictionary *touchDic in touchArray) {
                
                DHSeenModel *seen = [[DHSeenModel alloc] init];
                seen.userId    = touchDic[@"b80"];  // ID传值用
                seen.photoUrl  = touchDic[@"b57"];  // 头像连接
                seen.nickName  = touchDic[@"b52"];  // 昵称
                seen.vip       = [touchDic[@"b144"] integerValue]; // 1：VIP 2：非VIP  (int)
                if (touchDic[@"b1"] == nil) {
                    seen.ageStr = @"0岁";
                }else {
                    seen.ageStr = [NSString stringWithFormat:@"%@岁",touchDic[@"b1"]];   // 年龄
                }
                
                if (touchDic[@"b33"] == nil) {
                    seen.heightStr = @"保密";
                }else {
                    seen.heightStr    = [NSString stringWithFormat:@"%@cm",touchDic[@"b33"]];  // 身高
                }
                if (touchDic[@"b67"] == nil) {
                    seen.province = @"保密";
                }else {
                    seen.province  = [self addWithVariDic:[ConditionObject provinceDict] keyStr:[NSString stringWithFormat:@"%@",touchDic[@"b67"]]];  // 省份
                }
                if (touchDic[@"b9"] == nil) {
                    seen.city = @"保密";
                }else {
                    seen.city = [self addWithVariDic:[ConditionObject obtainDict]   keyStr:[NSString stringWithFormat:@"%@",touchDic[@"b9"]]];   // 城市
                }
                
                [self.seenMeArray addObject:seen];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.seenMeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DHSeenModel *seen = self.seenMeArray[indexPath.row];
    SeenCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.title.text = seen.nickName;
    cell.age.text = seen.ageStr;
    if (seen.vip == 1) { // VIP标志
        cell.VipImage.image = [UIImage imageNamed:@"icon-name-vip"];
    }
    
    [cell addDataWithheight:seen.heightStr address:[NSString stringWithFormat:@"%@ %@",seen.province,seen.city]];
    [cell cellLoadWithurlStr:[NSURL URLWithString:seen.photoUrl]];
    return cell;
    
}



#pragma mark --- cell返回高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return [SeenCell touchmeCellHeight];
    
    
}

#pragma mark --- section header
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return gotHeight(12);
}

#pragma mark --- 选中cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *p1 = [NSGetTools getUserSessionId];//sessionId
    NSNumber *p2 = [NSGetTools getUserID];//ID
    NSString *appInfo = [NSGetTools getAppInfoString];// 公共参数
    DHSeenModel *seen = self.seenMeArray[indexPath.row];
    Homepage *home = [[Homepage alloc] init];
    home.touchP2 = seen.userId;
    [self.navigationController pushViewController:home animated:true];
    [NSURLObject addWithdict:nil urlStr:[NSString stringWithFormat:@"%@f_109_11_2.service?a77=%@&p1=%@&p2=%@&%@",kServerAddressTest2,seen.userId,p1,p2,appInfo]];
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
