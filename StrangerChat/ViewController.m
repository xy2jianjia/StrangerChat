//
//  ViewController.m
//  StrangerChat
//
//  Created by long on 15/10/2.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "ViewController.h"
#import "SearchSetViewController.h"
#import "ChatController.h"
#import "HomeController.h"
#import "DHMsgPlaySound.h"
@interface ViewController () <UITabBarControllerDelegate,UIAlertViewDelegate>
@property (nonatomic,strong) NSTimer *timer;
/**
 *  接收到的消息数组，包括机器人消息和用户消息
 */
@property (nonatomic,strong) NSMutableArray *recMesgArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.recMesgArr = [NSMutableArray array];
    // 加载所有子视图控制器
    [self loadAllSubViewControllers];
    // 请求自己头像数据
    [self addMyHeaderDatas];
//    // 连接通信服务器
//    [[SocketManager shareInstance] ClientConnectServer];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self login];
    });
    [Mynotification addObserver:self selector:@selector(getRoBotInfo) name:@"getRoBotInfo" object:nil];
    [Mynotification addObserver:self selector:@selector(sendRobotMessage) name:@"sendRobotMessage" object:nil];
    [Mynotification addObserver:self selector:@selector(recieveRobotMessage:) name:@"recieveRobotMessage" object:nil];
    [Mynotification addObserver:self selector:@selector(recieveOffLineMessage:) name:@"recieveOffLineMessage" object:nil];
    [Mynotification addObserver:self selector:@selector(recieveOnLineMessageOutOfChatVc:) name:@"recieveOnLineMessageOutOfChatVc" object:nil];
//    [self updateBadgeValue];
}
-(UINavigationController*) viewControllerWithTitle:(NSString*) title image:(UIImage*)image tag:(NSInteger )tag viewController:(UIViewController *)viewController{
//    viewController = [[UIViewController alloc] init];
    viewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:image tag:tag];
    viewController.title = title;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:viewController];
    return nav;
}
- (void)loadAllSubViewControllers{
    
    // 1. 创建子视图控制器
    EyeLuckViewController *luckVC = [EyeLuckViewController new];
    SearchViewController *searchVC = [SearchViewController new];
    HomeController *messageVC = [HomeController new];
    NearPeopleViewController *nearVC = [NearPeopleViewController new];
    MineViewController *mineVC = [MineViewController new];
//    self.viewControllers = [NSArray arrayWithObjects: [self viewControllerWithTitle:@"缘分" image:[UIImage imageNamed:@"icon-chudong-normal.png"] tag:1000 viewController:luckVC], [self viewControllerWithTitle:@"搜索" image:[UIImage imageNamed:@"icon-search-normal.png"] tag:1001 viewController:searchVC],[self viewControllerWithTitle:nil image:nil tag:1003 viewController:messageVC],[self viewControllerWithTitle:@"附近" image:[UIImage imageNamed:@"icon-nearby-normal.png"] tag:1004 viewController:nearVC], [self viewControllerWithTitle:@"我" image:[UIImage imageNamed:@"icon-i-normal.png"] tag:1005 viewController:mineVC], nil];
    // 2. 设置tabBarItem
    luckVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"缘分" image:[UIImage imageNamed:@"icon-chudong-normal.png"] selectedImage:[UIImage imageNamed:@"icon-chudong-selected.png"]];
    luckVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"缘分" image:[UIImage imageNamed:@"icon-chudong-normal.png"] tag:1000];
    luckVC.tabBarItem.tag = 1000;
    searchVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"搜索" image:[UIImage imageNamed:@"icon-search-normal.png"] selectedImage:[UIImage imageNamed:@"icon-search-selected.png"]];
    searchVC.tabBarItem.tag = 1001;
    messageVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"消息" image:[UIImage imageNamed:@"tab2_normal.png"] selectedImage:[UIImage imageNamed:@"tab2_focus.png"]];
    messageVC.tabBarItem.tag = 1002;
    nearVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"附近" image:[UIImage imageNamed:@"icon-nearby-normal.png"] selectedImage:[UIImage imageNamed:@"icon-nearby-selected.png"]];
    nearVC.tabBarItem.tag = 1003;
    mineVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我" image:[UIImage imageNamed:@"icon-i-normal.png"] selectedImage:[UIImage imageNamed:@"icon-i-normal.png"]];
    mineVC.tabBarItem.tag = 1004;
    // 3. 添加导航控制器
    UINavigationController *luckNC = [[UINavigationController alloc] initWithRootViewController:luckVC];
    UINavigationController *searchNC = [[UINavigationController alloc] initWithRootViewController:searchVC];
    UINavigationController *messageNC = [[UINavigationController alloc] initWithRootViewController:messageVC];
    UINavigationController *nearNC = [[UINavigationController alloc] initWithRootViewController:nearVC];
    UINavigationController *mineNC = [[UINavigationController alloc] initWithRootViewController:mineVC];
//    UINavigationController *NC = [[UINavigationController alloc] initWithRootViewController:vc];
    
    luckNC.navigationBar.barTintColor = [UIColor colorWithRed:236/255.0 green:49/255.0 blue:88/255.0 alpha:1];
    [luckNC.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    searchNC.navigationBar.barTintColor = [UIColor colorWithRed:236/255.0 green:49/255.0 blue:88/255.0 alpha:1];
    [searchNC.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    messageNC.navigationBar.barTintColor = [UIColor colorWithRed:236/255.0 green:49/255.0 blue:88/255.0 alpha:1];
    [messageNC.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    nearNC.navigationBar.barTintColor = [UIColor colorWithRed:236/255.0 green:49/255.0 blue:88/255.0 alpha:1];
    [nearNC.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    mineNC.navigationBar.barTintColor = [UIColor colorWithRed:236/255.0 green:49/255.0 blue:88/255.0 alpha:1];
    [mineNC.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    // 设置选中的颜色
    self.tabBar.selectedImageTintColor = [UIColor colorWithRed:236/255.0 green:49/255.0 blue:88/255.0 alpha:1];
    [self.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    
    // 3. 设置视图控制器
    self.viewControllers = @[luckNC, searchNC, messageNC, nearNC, mineNC];
//    self.selectedViewController = luckNC;// 默认选中的控制器
//    self.title = @"缘分";
    [[NSNotificationCenter defaultCenter] postNotificationName:@"startChat" object:self userInfo:nil];
    
}

#pragma mark----tabBar点击代理----
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if (item.tag == 1000) {
//        NSLog(@"%@",item);
        item.selectedImage = [UIImage imageNamed:@"icon-chudong-selected.png"];
    }else if (item.tag == 1001){
//        self.title = @"搜索";
        // 左上角
//        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"重置" style:UIBarButtonItemStyleDone target:self action:@selector(clearActive:)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn-search2-n.png"] style:UIBarButtonItemStyleDone target:self action:@selector(goViewController:)];
        
        
    }else if (item.tag == 1002){
        UINavigationController *nc = [self.viewControllers objectAtIndex:2];
        HomeController *vc = [nc.viewControllers objectAtIndex:0];
        vc.chatDataArr = [NSMutableArray arrayWithArray:self.recMesgArr];
    }else if (item.tag == 1003){
        self.title = @"附近";
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = nil;
    }else{
        self.title = @"我";
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = nil;
    }
}

// 搜索
- (void)goViewController:(UIBarButtonItem *)sender
{
//    NSLog(@"----%@",sender.title);
    SearchSetViewController *sSetVC = [SearchSetViewController new];
    [self.navigationController pushViewController:sSetVC animated:YES];
    
}

// 联系人
- (void)contactController:(UIBarButtonItem *)sender
{
//    NSLog(@"----%@",sender.title);
}

// 角标
- (void)addbadges
{
    UIView *badgeView = [[UIView alloc] initWithFrame:CGRectMake(165, 5, 15, 15)];
    badgeView.layer.cornerRadius = 15/2;
    badgeView.clipsToBounds = YES;
    badgeView.backgroundColor = [UIColor redColor];
    
    [self.tabBar addSubview:badgeView];
}


// 加载头像数据
- (void)addMyHeaderDatas
{
    NSString *p1 = [NSGetTools getUserSessionId];//sessionId
    NSNumber *p2 = [NSGetTools getUserID];
    NSString *appInfo = [NSGetTools getAppInfoString];
    NSNumber *headerNum = [NSNumber numberWithInt:1000];
    NSString *url = [NSString stringWithFormat:@"%@f_107_11_1.service?p1=%@&p2=%@&a78=%@&%@",kServerAddressTest3,p1,p2,headerNum,appInfo];
    
    
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
        
//        NSLog(@"--头像--%@",infoDic);
        
        if ([infoDic[@"code"] integerValue] == 200) {
            NSArray *modelArr = infoDic[@"body"];
            if (modelArr.count > 0) {
                NSDictionary *headDict = modelArr[0];
                NSString *urlStr = headDict[@"b57"];
                [NSGetTools upDateIconB57:urlStr];// 更新保存头像信息
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"----头像---error--%@",error);
    }];
}

- (void)login{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"regUser"];
    NSString *username = [dict objectForKey:@"userName"];
    NSString *password = [dict objectForKey:@"password"];
    NSString *userId = [dict objectForKey:@"userId"];
    NSString *sessionId = [dict objectForKey:@"sessionId"];
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSString *appinfoStr = [NSGetTools getAppInfoString];
    NSString *url = [NSString stringWithFormat:@"%@f_120_10_1.service?a81=%@&a56=%@&p2=%@&p1=%@&%@",kServerAddressTest,username,password,userId,sessionId,appinfoStr];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        NSDictionary *dict2 = infoDic[@"body"];
        NSNumber *codeNum = infoDic[@"code"];
        if ([codeNum intValue] == 200) {
            // 保存账号 密码
            [NSGetTools updateUserAccount:username];
            [NSGetTools updateUserPassWord:password];
            // 保存用户ID
            [NSGetTools upDateUserID:dict2[@"b80"]];
            // 保存用户SessionId
            [NSGetTools upDateUserSessionId:dict2[@"b101"]];
            [NSGetTools updateIsLoadWithStr:@"isLoad"];
            [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"regUser"];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self getUserInfosWithp1:dict2[@"b101"] p2:dict2[@"b80"]];
            });
        }else if ([codeNum intValue] == 207){
            [NSGetTools showAlert:@"密码输入错误"];
        }else if ([codeNum intValue] == 206){
            [NSGetTools showAlert:@"用户信息审核不通过,请检查用户信息,或者联系客服人员"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.userInfo);
    }];
}
// 请求用户信息
- (void)getUserInfosWithp1:(NSString *)p1 p2:(NSString *)p2
{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSString *appinfoStr = [NSGetTools getAppInfoString];
//    LP-bus-msc/ f_108_13_1
//    NSString *url = [NSString stringWithFormat:@"%@f_108_10_1.service?p1=%@&p2=%@&%@",kServerAddressTest2,p1,p2,appinfoStr];
    NSString *url = [NSString stringWithFormat:@"%@f_108_13_1.service?p1=%@&p2=%@&%@",kServerAddressTest2,p1,p2,appinfoStr];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        NSNumber *codeNum = infoDic[@"code"];
        if ([codeNum intValue] == 200) {
            NSDictionary *dict2 = infoDic[@"body"];
            DHUserForChatModel *item = [[DHUserForChatModel alloc]init];
            [item setValuesForKeysWithDictionary:[dict2 objectForKey:@"b112"]];
            [item setValuesForKeysWithDictionary:[dict2 objectForKey:@"b113"]];
            if (![DBManager checkUserWithUsertId:item.b80]) {
                [DBManager insertUserToDBWithItem:item];
            }
            NSNumber *b34 = [dict2 objectForKey:@"b112"][@"b34"];
            [NSGetTools upDateB34:b34];
            NSNumber *b144 = [dict2 objectForKey:@"b112"][@"b144"];
            [NSGetTools upDateUserVipInfo:b144];
            NSNumber *b69 = [dict2 objectForKey:@"b112"][@"b69"];
            [NSGetTools updateUserSexInfoWithB69:b69];
            // 系统生成用户号
            NSString *b152 = [[dict2 objectForKey:@"b112"] objectForKey:@"b152"];
            [[NSUserDefaults standardUserDefaults] setObject:b152 forKey:@"b152"];
            [[NSUserDefaults standardUserDefaults] setObject:[[dict2 objectForKey:@"b112"] objectForKey:@"b52"] forKey:@"nickName"];
            [[NSUserDefaults standardUserDefaults] setObject:[[dict2 objectForKey:@"b112"] objectForKey:@"b17"] forKey:@"b17"];
            [[NSUserDefaults standardUserDefaults] setObject:dict2 forKey:@"loginUser"];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"===error-%@",error.userInfo);
    }];
}

/**
 *  接收离线消息
 *
 *  @param notifi
 */
- (void)recieveOffLineMessage:(NSNotification *)notifi{
//    [self.recMesgArr addObject:notifi.object];
    NSDictionary *rootDict = notifi.object;
    NSArray *arr = [rootDict objectForKey:@"body"];
    if (arr.count == 0) {
        
    }else{
        for (NSDictionary *dict in arr) {
            Message *item = [[Message alloc]init];
            NSDictionary *contentDict = [dict objectForKey:@"content"];
            item.messageId = [dict objectForKey:@"id"];
            [item setValuesForKeysWithDictionary:contentDict];
            [item setValuesForKeysWithDictionary:dict];
            [item setValuesForKeysWithDictionary:[rootDict objectForKey:@"head"]];
            NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
            item.userId = userId;
            item.targetId = item.fromUserAccount;
            if (![DBManager checkMessageWithMessageId:item.messageId targetId:item.targetId]) {
                [DBManager insertMessageDataDBWithModel:item userId:[NSString stringWithFormat:@"%@",userId]];
            }
            [self.recMesgArr addObject:item];
        }
        [self updateBadgeValue];
    }
}
/**
 *  请求机器人
 */
- (void)getRoBotInfo{
    dispatch_async(dispatch_get_main_queue(), ^{
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0*60*30 target:self selector:@selector(getRobot:) userInfo:nil repeats:YES];
        [_timer fire];
    });
}
/**
 *  发送机器人消息，每隔三十分钟发送一次
 */
- (void)sendRobotMessage{
    NSString *token = [NSGetTools getToken];
    [[SocketManager shareInstance] sendRobotMessageWithToken:token];
}
- (void)getRobot:(NSTimer *)timer{
    NSString *token = [NSGetTools getToken];
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"rebotResult"];
    NSString *account = [dict objectForKey:@"toUserAccount"];
    [[SocketManager shareInstance] getRobotWithToken:token fromUserAccount:account];
}
/**
 *  接收到机器人消息
 *
 *  @param notifi
 */
- (void)recieveRobotMessage:(NSNotification *)notifi{
    
    NSDictionary *dict = notifi.object;
    NSDictionary *bodyDict = [dict objectForKey:@"body"];
    NSDictionary *contentDict = [bodyDict objectForKey:@"content"];
    Message *item = [[Message alloc]init];
    [item setValuesForKeysWithDictionary:dict];
    [item setValuesForKeysWithDictionary:contentDict];
    [item setValuesForKeysWithDictionary:[dict objectForKey:@"head"]];
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    [fmt setDateFormat:@"yyyyMMddHHmmddsssss"];
    NSString *messageId = [fmt stringFromDate:[NSDate date]];
    item.messageId = messageId;
    item.fromUserDevice = @"2";
    item.toUserAccount = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    item.userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    item.roomCode = [bodyDict objectForKey:@"fromUserAccount"];
    item.roomName = @"路人甲";
    item.targetId = [bodyDict objectForKey:@"fromUserAccount"];
    item.fromUserAccount = [bodyDict objectForKey:@"fromUserAccount"];
    NSNumber *userId = [NSGetTools getUserID];
    if (![DBManager checkMessageWithMessageId:item.messageId targetId:item.targetId]) {
        [DBManager insertMessageDataDBWithModel:item userId:[NSString stringWithFormat:@"%@",userId]];
    }
    [self.recMesgArr addObject:item];
    [self updateBadgeValue];
}

/**
 *  接收在线消息
 *
 *  @param notifi
 */
- (void)recieveOnLineMessageOutOfChatVc:(NSNotification *)notifi{
    NSDictionary *dict = notifi.object;
    NSDictionary *bodyDict = [dict objectForKey:@"body"];
    NSDictionary *contentDict = [bodyDict objectForKey:@"content"];
    NSDictionary *fromDict = [bodyDict objectForKey:@"from"];
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    [fmt setDateFormat:@"yyyyMMddHHmmsssss"];
    NSString *messageId = [fmt stringFromDate:[NSDate date]];
    Message *item = [[Message alloc]init];
    item.messageId = messageId;
    [item setValuesForKeysWithDictionary:contentDict];
    //    [item setValuesForKeysWithDictionary:fromDict];
    item.fromUserAccount = [fromDict objectForKey:@"userAccount"];
    item.fromUserDevice =[fromDict objectForKey:@"userDevice"];
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    item.toUserAccount = userId;
    [item setValuesForKeysWithDictionary:[dict objectForKey:@"head"]];
    [item setValuesForKeysWithDictionary:[dict objectForKey:@"body"]];
    item.userId = userId;
    item.targetId = item.fromUserAccount;
//    item.roomCode = _item.roomCode;
//    item.roomName = _item.roomName;
    if (![DBManager checkMessageWithMessageId:item.messageId targetId:item.targetId]) {
        [DBManager insertMessageDataDBWithModel:item userId:[NSString stringWithFormat:@"%@",userId]];
    }
    [self.recMesgArr addObject:item];
    [self updateBadgeValue];
}


/**
 *  更新角标
 */
- (void)updateBadgeValue{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[self.viewControllers objectAtIndex:2] tabBarItem] setBadgeValue:[NSString stringWithFormat:@"%ld",_recMesgArr.count]];
        DHMsgPlaySound *sound = [[DHMsgPlaySound alloc]initSystemSoundWithName:nil SoundType:nil];
        [sound play];
    });
}
-(void)dealloc{
    [Mynotification removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
