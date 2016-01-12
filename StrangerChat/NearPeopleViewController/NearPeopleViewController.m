//
//  NearPeopleViewController.m
//  StrangerChat
//
//  Created by long on 15/11/4.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "NearPeopleViewController.h"
#import "NearPeopleTableViewCell.h"
//#import "NearPeopleModel.h"
//#import "RCDChatViewController.h"
#import "ChatController.h"
@interface NearPeopleViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *allDataArray;

@end

@implementation NearPeopleViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationItem.title = @"附近";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor yellowColor];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.tableView.backgroundColor = HexRGB(0Xeeeeee);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView=[[UIView alloc]init];
    
    self.allDataArray = [NSMutableArray array];
    
    [self initLocationManager];
    
    [self setupRefresh];
    
}
#pragma mark -- 下拉上提刷新
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    //#warning 自动刷新(一进入程序就下拉刷新)
    // [self.tableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
//    self.tableView.headerPullToRefreshText = @"下拉可以刷新";
//    self.tableView.headerReleaseToRefreshText = @"松开马上刷新";
//    self.tableView.headerRefreshingText = @"加载中...";
//    
//    
//    self.tableView.footerPullToRefreshText = @"上拉加载更多附近信息";
//    self.tableView.footerReleaseToRefreshText = @"松开马上加载更多";
//    self.tableView.footerRefreshingText = @"加载中...";
    
}
#pragma mark 开始进入刷新状态
// 下拉
- (void)headerRereshing
{
    [self.allDataArray removeAllObjects];
    [self initLocationManager];
    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        // [self.tableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView headerEndRefreshing];
    });
}

// 上拉
- (void)footerRereshing
{
    
    NSNumber *b96 = [NSGetTools getNearPeopleB96];// 获取是否有下一页
    NSNumber *a69 = [NSGetTools getUserSexInfo];// 性别
    // 位置
    NSDictionary *addressDict = [NSGetTools getCLLocationData];
    if ([b96 intValue] == 1) {
        NSString *a9 = addressDict[@"a9"];
        NSString *a67 = addressDict[@"a67"];
        NSNumber *a38Num = addressDict[@"a38"];// 经
        NSNumber *a40Num = addressDict[@"a40"];// 纬
        CGFloat a38 = [a38Num floatValue];
        CGFloat a40 = [a40Num floatValue];
        static int a95 = 1;
        a95 = a95 + 1;
        [self addAllDatas2:a69 a9:a9 a67:a67 a38:a38 a40:a40 a95:a95];
        
    }else{
        [NSGetTools showAlert:@"暂无更多数据"];
    }

    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView footerEndRefreshing];
    });
}

// 定位
- (void)initLocationManager {
    self.geocoder = [[CLGeocoder alloc] init];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 100.f;
    NSString *m8 = [[UIDevice currentDevice] systemVersion];// 系统版本号
    if ([m8 floatValue] >= 8) {
        [_locationManager requestAlwaysAuthorization];//ios8以后添加这句
    }

    [self.locationManager startUpdatingLocation];
    
}

// 定位代理
#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *currentLocation = [locations lastObject];
    double latitude = currentLocation.coordinate.latitude;// 纬度
    double longitude = currentLocation.coordinate.longitude;// 经度
    self.latitudeStr = [NSString stringWithFormat:@"%f", latitude];
    self.longitudeStr = [NSString stringWithFormat:@"%f", longitude];
    
    // 1.既然已经定位到了用户当前的经纬度了,那么可以让定位管理器 停止定位了
    [_locationManager stopUpdatingLocation];
    // 2.然后,取出第一个位置,根据其经纬度,通过CLGeocoder反向解析,获得该位置所在的城市名称,转成城市对象,用工具保存
    CLLocation *loc = locations[0];
    // 3.CLGeocoder反向通过经纬度,获得城市名
    [_geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error) {
        // 从字典中取出 state---->某某市
        CLPlacemark *place = placemarks[0];
        // 市
        NSString *cityStr = place.addressDictionary[@"City"];
        // 省
        NSString *stateStr = place.addressDictionary[@"State"];
        
        NSDictionary *cityDict = [NSDictionary dictionary];
        NSDictionary *stateDict = [NSDictionary dictionary];
        //获取plist中的数据
        cityDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"cityCode" ofType:@"plist"]];
        stateDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"provinceCode" ofType:@"plist"]];
        NSDictionary *cityCodeDict = cityDict[cityStr];
        NSDictionary *stateCodeDict = stateDict[stateStr];
        
        NSString *a9 = cityCodeDict[@"city_code"];
        NSString *a67 = stateCodeDict[@"provence_code"];
        
        CGFloat a38 = longitude;// 经
        CGFloat a40 = latitude;// 纬
        
        NSNumber *a38Num = [NSNumber numberWithFloat:a38];
        NSNumber *a40Num = [NSNumber numberWithFloat:a40];
        NSMutableDictionary *cllDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:a9,@"a9",a67,@"a67",a38Num,@"a38",a40Num,@"a40", nil];
        [NSGetTools updateCLLocationWithDict:cllDict];
        
        NSNumber *a69 = [NSGetTools getUserSexInfo];
        
        
        [self addAllDatas2:a69 a9:a9 a67:a67 a38:a38 a40:a40 a95:1];
        
//        NSLog(@"-----%@--%@------",a9,a67);
        
    }];
    
}

// 定位失败代理
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if ([error code] == kCLErrorDenied)
    {
        NSLog(@"访问被拒绝");
        NSNumber *a69 = [NSGetTools getUserSexInfo];
        [self addAllDatas2:a69 a9:nil a67:nil a38:0 a40:0 a95:1];
        
        NSMutableDictionary *cllDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:nil,@"a9",nil,@"a67",@"0",@"a38",@"0",@"a40", nil];
        [NSGetTools updateCLLocationWithDict:cllDict];
    }
    if ([error code] == kCLErrorLocationUnknown) {
        //无法获取位置信息
        NSLog(@"无法获取位置信息");
        NSNumber *a69 = [NSGetTools getUserSexInfo];
        [self addAllDatas2:a69 a9:nil a67:nil a38:0 a40:0 a95:1];
        
        NSMutableDictionary *cllDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:nil,@"a9",nil,@"a67",@"0",@"a38",@"0",@"a40", nil];
        [NSGetTools updateCLLocationWithDict:cllDict];
    }
}



// 加载数据
- (void)addAllDatas2:(NSNumber *)a69 a9:(NSString *)a9 a67:(NSString *)a67 a38:(CGFloat)a38 a40:(CGFloat)a40 a95:(int)a95
{
    NSString *p1 = [NSGetTools getUserSessionId];//sessionId
    NSNumber *p2 = [NSGetTools getUserID];
    NSString *appInfo = [NSGetTools getAppInfoString];
    NSString *url = [NSString stringWithFormat:@"%@f_108_16_1.service?p1=%@&p2=%@&a69=%@&a95=%d&%@",kServerAddressTest2,p1,p2,a69,a95,appInfo];
   
    if (a9 != nil || a67 != nil || a38 != 0 || a40 != 0) {
        url = [NSString stringWithFormat:@"%@f_108_16_1.service?p1=%@&p2=%@&a69=%@&a9=%@&a67=%@&a38=%f&a40=%f&a95=%d&%@",kServerAddressTest2,p1,p2,a69,a9,a67,a38,a40,a95,appInfo];
    }
    
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
//    NSLog(@"-----url-%@--",url);
    [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSData *datas = responseObject;
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        // b96 是否有下一页 0:没有 1:有  b95 当前页数
        if ([infoDic[@"code"] integerValue] == 200) {
            NSArray *modelArr = infoDic[@"body"];
            NSNumber *b96 = infoDic[@"b96"];// 是否有下一页
            [NSGetTools updateNearPeopleB96WithNum:b96];// 更新b96
//            NearPeopleModel *tempItem = nil;
            for (NSDictionary *dict2 in modelArr) {
//                NearPeopleModel *model = [NearPeopleModel new];
                DHUserForChatModel *item = [[DHUserForChatModel alloc]init];
                
                [item setValuesForKeysWithDictionary:dict2];
                [self.allDataArray addObject:item];
//                DHUserForChatModel *item = [[DHUserForChatModel alloc]init];
//                [item setValuesForKeysWithDictionary:dict2];
                if (![DBManager checkUserWithUsertId:item.b80]) {
                    [DBManager insertUserToDBWithItem:item];
                }
            }
//            DHUserForChatModel *model = [self.allDataArray firstObject];
//            model.b80 = @"102111604";
//            model.b52 = @"我是优上";
//            [self.allDataArray insertObject:model atIndex:0];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"----附近---error--%@",error);
    }];
    
    
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.allDataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier3";
    NearPeopleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[NearPeopleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,got(20)+gotHeight(50),0,0)];
    }
    if (self.allDataArray.count != 0) {
        cell.model = self.allDataArray[indexPath.row];
    }
    cell.hiButton.tag = indexPath.row;
    [cell.hiButton addTarget:self action:@selector(hiButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

// 打招呼
- (void)hiButtonAction:(UIButton *)sender
{
    NSInteger indexNum = sender.tag;
//    NearPeopleModel *model = self.allDataArray[indexNum];
    DHUserForChatModel *model = self.allDataArray[indexNum];
    NSString *targetId = [NSString stringWithFormat:@"%@",model.b80];
    NSString *targetName = [NSString stringWithFormat:@"%@",model.b52];
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    NSString *token = [NSGetTools getToken];
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *date = [format stringFromDate:[NSDate date]];
    NSDateFormatter *format1 = [[NSDateFormatter alloc]init];
    [format1 setDateFormat:@"yyyyMMddHHmmsssss"];
    NSString *messageId = [format1 stringFromDate:[NSDate date]];
    Message *item = [[Message alloc]init];
    item.messageId = messageId;
    item.messageType = @"1";
    item.message = @"我从附近的人找到你，和我聊天吧！";
    item.fromUserDevice = @"2";
    item.fromUserAccount = userId;
    item.token = token;
    item.timeStamp = date;
    item.toUserAccount = targetId;
    item.userId = userId;
//    item.roomCode = @"";
    item.roomName = targetName;
    item.targetId = [NSString stringWithFormat:@"%@",model.b80];
    ChatController *chatVC = [ChatController new];
    chatVC.item = item;
    chatVC.userInfo = model;
//    [[SocketManager shareInstance] creatRoomWithString:[NSString stringWithFormat:@"%@",model.b52] account:item.fromUserAccount];// 开房间
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:chatVC animated:YES];
    });
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return gotHeight(90);
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
