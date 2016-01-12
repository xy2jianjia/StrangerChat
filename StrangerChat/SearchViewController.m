//
//  SearchViewController.m
//  StrangerChat
//
//  Created by long on 15/10/2.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchTableViewCell.h"
//#import "SearchModel.h"
#import "SearchSetViewController.h"
#import "ChatController.h"
#import "Homepage.h"
@interface SearchViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *allDataArray;

@property (nonatomic,strong) NSString *a1;// 年龄范围 20-25
@property (nonatomic,strong) NSString *a85;// 收入范围 10000-12000
@property (nonatomic,strong) NSString *a33;// 身高170-180
@property (nonatomic,strong) NSString *a46;// 婚姻状态
@property (nonatomic,strong) NSString *a40;// 经度(当前自己的位置)
@property (nonatomic,strong) NSString *a38;// 纬度
@property (nonatomic,strong) NSString *a29;// 是否有车
@property (nonatomic,strong) NSString *a32;// 是否有房
@property (nonatomic,strong) NSString *a62;// 职业
@property (nonatomic,strong) NSString *a19;// 最低学历
@property (nonatomic,strong) NSString *a67;// 省
@property (nonatomic,strong) NSString *a9;// 市

@end

@implementation SearchViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationItem.title = @"搜索";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor yellowColor];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"navigation-search.png"] style:UIBarButtonItemStyleDone target:self action:@selector(searchMore)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"navigation-search.png"] landscapeImagePhone:nil style:UIBarButtonItemStylePlain target:self action:@selector(searchMore)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
//WithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchMore)];
    self.allDataArray = [NSMutableArray array];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.tableView.backgroundColor = HexRGB(0Xeeeeee);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView=[[UIView alloc]init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SearchSetData:) name:@"searchSetData"object:nil];
    
    NSNumber *num = [NSNumber numberWithInt:1];
    [self searchSet:num];// 加载数据
    [self setupRefresh];
}
- (void)searchMore{
    SearchSetViewController *vc = [[SearchSetViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
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
    self.tableView.headerPullToRefreshText = @"下拉可以刷新";
    self.tableView.headerReleaseToRefreshText = @"松开马上刷新";
    self.tableView.headerRefreshingText = @"加载中...";
    
    
    self.tableView.footerPullToRefreshText = @"上拉加载更多附近信息";
    self.tableView.footerReleaseToRefreshText = @"松开马上加载更多";
    self.tableView.footerRefreshingText = @"加载中...";
    
}


#pragma mark 开始进入刷新状态
// 下拉
- (void)headerRereshing
{
    [self.allDataArray removeAllObjects];
    NSNumber *num = [NSNumber numberWithInt:1];
    [self searchSet:num];// 加载数据
    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView headerEndRefreshing];
    });
}

// 上拉
- (void)footerRereshing{
    NSNumber *b96 = [NSGetTools getSearchB96];// 获取是否有下一页
    if ([b96 intValue] == 1) {
        static int a95 = 1;
        a95 = a95 + 1;
        NSNumber *a95Num = [NSNumber numberWithInt:a95];
        [self searchSet:a95Num];
        
    }else{
        [NSGetTools showAlert:@"暂无更多数据"];
    }
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView footerEndRefreshing];
    });
}

// 搜索条件通知
- (void)SearchSetData:(NSNotification *)notification
{
    [self.allDataArray removeAllObjects];
    NSNumber *num = [NSNumber numberWithInt:1];
    [self searchSet:num];// 加载数据

}

// 搜索条件
- (void)searchSet:(NSNumber *)a95Num
{
    NSDictionary *dict = [NSGetTools getSearchSetDict];
    NSString *a1 = dict[@"年龄"];
    NSString *a33 = dict[@"身高"];
    NSString *a85 = dict[@"收入"];
    NSString *addressStr = dict[@"地区"];
    NSString *a9 = nil;
    NSString *a67 = nil;
    if (addressStr != nil) {
        NSArray *array = [addressStr componentsSeparatedByString:@" "];
        NSString *cityStr = array[1];// 市
        NSString *stateStr = array[0];// 省
        NSDictionary *cityDict = [NSDictionary dictionary];
        NSDictionary *stateDict = [NSDictionary dictionary];
        //获取plist中的数据
        cityDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"cityCode" ofType:@"plist"]];
        stateDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"provinceCode" ofType:@"plist"]];
        NSDictionary *cityCodeDict = cityDict[cityStr];
        NSDictionary *stateCodeDict = stateDict[stateStr];
        
        a9 = cityCodeDict[@"city_code"];
        a67 = stateCodeDict[@"provence_code"];
        
    }
    NSString *a46Str = dict[@"婚姻"];
    NSDictionary *a46Dcit = [NSGetSystemTools getmarriageStatus];
    NSNumber *a46 = [NSGetTools getSystemNumWithDict:a46Dcit value:a46Str];
    
    NSString *a19Str = dict[@"学历"];
    NSDictionary *a19Dcit = [NSGetSystemTools geteducationLevel];
    NSNumber *a19 = [NSGetTools getSystemNumWithDict:a19Dcit value:a19Str];
    
    NSString *a29Str = dict[@"车子"];
    NSDictionary *a29Dcit = [NSGetSystemTools gethasCar];
    NSNumber *a29 = [NSGetTools getSystemNumWithDict:a29Dcit value:a29Str];
    
    NSString *a32Str = dict[@"房子"];
    NSDictionary *a32Dcit = [NSGetSystemTools gethasRoom];
    NSNumber *a32 = [NSGetTools getSystemNumWithDict:a32Dcit value:a32Str];
    
    NSMutableDictionary *searchDict2 = [NSMutableDictionary dictionary];
    if (a1 != nil || a1 != NULL) {
        [searchDict2 setObject:a1 forKey:@"a1"];
    }
    if (a33 != nil || a33 != NULL){
        [searchDict2 setObject:a33 forKey:@"a33"];
    }
    if (a85 != nil|| a85 != NULL){
        [searchDict2 setObject:a85 forKey:@"a85"];
    }
    if (a9 != nil || a9 != NULL){
        [searchDict2 setObject:a9 forKey:@"a9"];
    }
    if (a67 != nil || a67 != NULL){
        [searchDict2 setObject:a67 forKey:@"a67"];
    }
    if (a46 != nil || a46 != NULL){
        [searchDict2 setObject:a46 forKey:@"a46"];
    }
    if (a19 != nil || a19 != NULL){
        [searchDict2 setObject:a19 forKey:@"a19"];
    }
    if (a29 != nil || a29 != NULL){
        [searchDict2 setObject:a29 forKey:@"a29"];
    }
    if (a32 != nil || a32 != NULL){
        [searchDict2 setObject:a32 forKey:@"a32"];
    }
    
    
    [self addSearchDatasWithDict:searchDict2 a95:a95Num];// 重新搜索数据
    
}

// 搜索数据
/**
 *  a95:分页参数,a9:居住地（市）,a67:居住地（省）,a1:年龄范围,a85:收入,a19:最低学历,a33:身高,a46:婚姻状态,a69:性别
 *  a40:经度,a38:纬度,a29:是否有车,a32:是否有房,a62:职业
 *
 *  @param dict3
 *  @param a95Num
 */
- (void)addSearchDatasWithDict:(NSDictionary *)dict3 a95:(NSNumber *)a95Num
{
    NSString *p1 = [NSGetTools getUserSessionId];//sessionId
    NSNumber *p2 = [NSGetTools getUserID];
    NSNumber *a69 = [NSGetTools getUserSexInfo];
    NSDictionary *cllDict = [NSGetTools getCLLocationData];
    NSNumber *a38Num = cllDict[@"a38"];// 经
    NSNumber *a40Num = cllDict[@"a40"];// 纬
//a95:分页参数,a9:居住地（市）,a67:居住地（省）,a1:年龄范围,a85:收入,a19:最低学历,a33:身高,a46:婚姻状态,a69:性别 a40:经度,a38:纬度,a29:是否有车,a32:是否有房,a62:职业
    NSString *url = [NSString stringWithFormat:@"%@f_108_12_1.service?p1=%@&p2=%@&a69=%@&a38=%@&a40=%@&a95=%@",kServerAddressTest2,p1,p2,a69,a38Num,a40Num,a95Num];
    
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];

    [manger GET:url parameters:dict3 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSData *datas = responseObject;
        
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典

        if ([infoDic[@"code"] integerValue] == 200) {
            NSArray *arr = infoDic[@"body"];
            NSNumber *b96 = infoDic[@"b96"];// 是否有下一页
            [NSGetTools updateSearchB96WithNum:b96];// 更新b96
            for (NSDictionary *dict in arr) {
//                SearchModel *model = [SearchModel new];
                DHUserForChatModel *item = [[DHUserForChatModel alloc]init];
                [item setValuesForKeysWithDictionary:dict];
                [self.allDataArray addObject:item];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }else{
//            NSString *msg = infoDic[@"msg"];
//            [NSGetTools showAlert:msg];
            [self showHint:@"查询出错"];
        }
        
        //NSLog(@"---%@--%ld",self.allDataArray,self.allDataArray.count);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"----搜索---error--%@",error.userInfo);
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
    static NSString *cellIdentifier = @"cellIdentifier2";
    SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[SearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,got(20)+gotHeight(50),0,0)];
    }
    
    if (self.allDataArray.count > 0) {
//        SearchModel *model = self.allDataArray[indexPath.row];
        DHUserForChatModel *item = self.allDataArray[indexPath.row];
        cell.searchModel = item;
        cell.iconImageView.tag = indexPath.row;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showUserDetail:)];
        cell.iconImageView.userInteractionEnabled = YES;
        [cell.iconImageView addGestureRecognizer:tap];
    }
    
    
    return cell;

}
- (void)showUserDetail:(UITapGestureRecognizer *)sender{
    
    Homepage *home = [[Homepage alloc] init];
    [self.navigationController pushViewController:home animated:YES];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    SearchModel *model = self.allDataArray[indexPath.row];
    DHUserForChatModel *model = self.allDataArray[indexPath.row];
    
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
    item.message = @"我在这里搜索到你，和我聊天吧！";
    item.fromUserDevice = @"2";
    item.fromUserAccount = userId;
    item.token = token;
    item.timeStamp = date;
    item.toUserAccount = targetId;
    item.userId = userId;
//    item.roomCode = @"";
    item.roomName = targetName;
    item.targetId = [NSString stringWithFormat:@"%@",model.b80];
//    if (![DBManager checkMessageWithMessageId:messageId fromUserAccount:item.fromUserAccount]) {
//        [DBManager insertMessageDataDBWithModel:item userId:userId];
//    }
//    [[SocketManager shareInstance] creatRoomWithString:nil account:[NSString stringWithFormat:@"%@",model.b80]];// 开房间
    ChatController *vc = [[ChatController alloc]init];
    vc.item = item;
    vc.userInfo = model;
    [self.navigationController pushViewController:vc animated:YES];
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
