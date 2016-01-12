//
//  EyeLuckViewController.m
//  StrangerChat
//
//  Created by long on 15/10/30.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "EyeLuckViewController.h"
//#import "EyeLuckModel.h"
#import "OtherDetailViewController.h"
#import "Homepage.h"
#import "DHUserForChatModel.h"
#define colletionCell 2  //设置具体几列
#define KcellHeight  got(93) // cell最小高
#define KcellSpace got(10) // cell之间的间隔

@interface EyeLuckViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    
    NSMutableArray  *hArr; //记录每个cell的高度
    NSMutableArray *wArr;
    UIImageView *imageView;
    UILabel *addLabel;
    
}
@property (nonatomic,strong) UICollectionView *collectionView2;
@property (nonatomic,strong) NSMutableArray *allModelArray;
@property (nonatomic,strong) NSTimer *lineTimer;

/**
 *  头像布局显示方式，1为大图，2为小图
 */
@property (nonatomic,assign) NSInteger largeType;
/**
 *  心跳按钮
 */
@property (nonatomic,assign) BOOL isBtnSelected;
@property (nonatomic,strong) DHUserForChatModel *model;
@end

@implementation EyeLuckViewController
static NSString * CellIdentifier2 = @"UICollectionViewCells";
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationItem.title = @"缘分";
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"缘分";
    
//    self.navigationController.navigationBar.translucent = NO;
  //  self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self getSystemDataInfos];
    
    
    self.allModelArray = [NSMutableArray array];
    hArr = [[NSMutableArray alloc] init];
    wArr = [[NSMutableArray alloc] init];
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical]; //设置横向还是竖向
    _collectionView2=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth ,ScreenHeight) collectionViewLayout:flowLayout];
    _collectionView2.dataSource=self;
    _collectionView2.delegate=self;
    [_collectionView2 setBackgroundColor:HexRGB(0Xeeeeee)];
    [_collectionView2 registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CellIdentifier2];
    [self.view addSubview:_collectionView2];
    
    // 2.集成刷新控件
    [self addHeader];
    [self addFooter];
    
    // 添加心跳
    self.lineTimer = [NSTimer scheduledTimerWithTimeInterval:50.0 target:self selector:@selector(userOnLineMethod) userInfo:nil repeats:YES];

}

// 用户保持
- (void)userOnLineMethod
{
    NSString *p1 = [NSGetTools getUserSessionId];//sessionId
    NSNumber *p2 = [NSGetTools getUserID];//ID
    NSString *url = [NSString stringWithFormat:@"%@f_120_12_1.service?p1=%@&p2=%@",kServerAddressTest4,p1,p2];
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
        
//        NSLog(@"-----用户保持在线----%@",infoDic);
        if ([infoDic[@"code"] integerValue] == 200) {
            NSLog(@"在线");
        }else{
            NSString *msgStr = infoDic[@"msg"];
//             NSLog(@"-----用户掉线---%@",msgStr);
            [NSGetTools showAlert:msgStr];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
        [NSGetTools showAlert:@"网络不佳或已掉线"];
    }];
}



- (void)addHeader
{
    
    __unsafe_unretained typeof(self) vc = self;
    // 添加下拉刷新头部控件
    [_collectionView2 addHeaderWithCallback:^{
        [vc.allModelArray removeAllObjects];
        // 进入刷新状态就会回调这个Block
        [vc initLocationManager];// 定位
        
        // 模拟延迟加载数据，因此2秒后才调用）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 结束刷新
            [vc.collectionView2 headerEndRefreshing];
        });
    }];
    // 自动刷新(一进入程序就下拉刷新)
    [self.collectionView2 headerBeginRefreshing];
}

- (void)addFooter
{
    __unsafe_unretained typeof(self) vc = self;
    // 添加上拉刷新尾部控件
    [self.collectionView2 addFooterWithCallback:^{
        // 进入刷新状态就会回调这个Block
        NSNumber *b96 = [NSGetTools getLuckB96];// 获取是否有下一页
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
            [vc addAllDatas:a69 a9:a9 a67:a67 a38:a38 a40:a40 a95:a95];
            
        }else{
            [NSGetTools showAlert:@"暂无更多数据"];
        }
        
        
        // 模拟延迟加载数据，因此2秒后才调用）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            // 结束刷新
            [vc.collectionView2 footerEndRefreshing];
        });
    }];
}

// 系统参数请求  http://115.236.55.163:8086/LP-bus-msc/f_101_10_1.service
- (void)getSystemDataInfos
{
    NSString *p1 = [NSGetTools getUserSessionId];//sessionId
    NSNumber *p2 = [NSGetTools getUserID];
    NSString *appInfo = [NSGetTools getAppInfoString];// 公共参数
    
    NSString *url = [NSString stringWithFormat:@"%@f_101_10_1.service?p1=%@&p2=%@&%@",kServerAddressTest2,p1,p2,appInfo];
    
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
        
        if ([infoDic[@"code"] integerValue] == 200) {
            NSArray *sysArray = infoDic[@"body"];
            
            for (NSDictionary *dict in sysArray) {
                
                NSArray *b98Arr = dict[@"b98"];
                // 默认消息
                if ([dict[@"b20"] isEqualToString:@"default_message"]) {
                    NSMutableDictionary *messageDict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b72"]];
                        [messageDict setValue:dict2[@"b22"] forKey:keyStr];
                    }
                    // 保存
                    [NSGetSystemTools updateDefaultMessageWithDict:messageDict];
                }else if ([dict[@"b20"] isEqualToString:@"charmPart"]){// 魅力部位
                    NSMutableDictionary *charmPartDict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b22"]];
                        [charmPartDict setValue:dict2[@"b21"] forKey:keyStr];
                    }
                    // 保存
                    [NSGetSystemTools updatecharmPartWithDict:charmPartDict];
                }else if ([dict[@"b20"] isEqualToString:@"marriageStatus"]){// 婚状态
                    NSMutableDictionary *marriageStatusDict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b22"]];
                        [marriageStatusDict setValue:dict2[@"b21"] forKey:keyStr];
                    }
                    // 保存
                    [NSGetSystemTools updatemarriageStatusWithDict:marriageStatusDict];
                    
                    
                }else if ([dict[@"b20"] isEqualToString:@"marrySex"]){// 婚前行为
                    NSMutableDictionary *marrySexDict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b22"]];
                        [marrySexDict setValue:dict2[@"b21"] forKey:keyStr];
                    }
                    // 保存
                    [NSGetSystemTools updatemarrySexWithDict:marrySexDict];
                }else if ([dict[@"b20"] isEqualToString:@"profession"]){//职业
                    NSMutableDictionary *professionDict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b22"]];
                        [professionDict setValue:dict2[@"b21"] forKey:keyStr];
                    }
                    // 保存
                    [NSGetSystemTools updateprofessionDict:professionDict];
                }else if ([dict[@"b20"] isEqualToString:@"loveType-2"]){// 喜欢的类型(女)
                    NSMutableDictionary *loveType2Dict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b22"]];
                        [loveType2Dict setValue:dict2[@"b21"] forKey:keyStr];
                    }
                    // 保存
                    [NSGetSystemTools updateloveType2Dict:loveType2Dict];
                }else if ([dict[@"b20"] isEqualToString:@"hasLoveOther"]){// 异地恋
                    NSMutableDictionary *hasLoveOtherDict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b22"]];
                        [hasLoveOtherDict setValue:dict2[@"b21"] forKey:keyStr];
                    }
                    // 保存
                    [NSGetSystemTools updatehasLoveOtherWithDict:hasLoveOtherDict];
                }else if ([dict[@"b20"] isEqualToString:@"star"]){// 星座
                    NSMutableDictionary *starDict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b22"]];
                        [starDict setValue:dict2[@"b21"] forKey:keyStr];
                    }
                    // 保存
                    [NSGetSystemTools updatestarWithDict:starDict];
                }else if ([dict[@"b20"] isEqualToString:@"liveTogether"]){// 住一起
                    NSMutableDictionary *liveTogetherDict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b22"]];
                        [liveTogetherDict setValue:dict2[@"b21"] forKey:keyStr];
                    }
                    // 保存
                    [NSGetSystemTools updateliveTogetherWithDict:liveTogetherDict];
                }else if ([dict[@"b20"] isEqualToString:@"loveType-1"]){// 喜欢的类型(男)
                    NSMutableDictionary *loveType1Dict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b22"]];
                        [loveType1Dict setValue:dict2[@"b21"] forKey:keyStr];
                    }
                    // 保存
                    [NSGetSystemTools updateloveType1WithDict:loveType1Dict];
                }else if ([dict[@"b20"] isEqualToString:@"purpose"]){// 交友目的
                    NSMutableDictionary *purposeDict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b22"]];
                        [purposeDict setValue:dict2[@"b21"] forKey:keyStr];
                    }
                    // 保存
                    [NSGetSystemTools updatepurposeWithDict:purposeDict];
                }else if ([dict[@"b20"] isEqualToString:@"blood"]){// 血型
                    NSMutableDictionary *bloodDict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b22"]];
                        [bloodDict setValue:dict2[@"b21"] forKey:keyStr];
                    }
                    // 保存
                    [NSGetSystemTools updatebloodWithDict:bloodDict];
                }else if ([dict[@"b20"] isEqualToString:@"hasCar"]){// 车子
                    NSMutableDictionary *hasCarDict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b22"]];
                        [hasCarDict setValue:dict2[@"b21"] forKey:keyStr];
                        
                    }
                    NSLog(@"%@",hasCarDict);
                    // 保存
                    [NSGetSystemTools updatehasCarWithDict:hasCarDict];
                }else if ([dict[@"b20"] isEqualToString:@"educationLevel"]){
                    NSMutableDictionary *educationLevelDict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b22"]];
                        [educationLevelDict setValue:dict2[@"b21"] forKey:keyStr];
                    }
                    // 保存
                    [NSGetSystemTools updateeducationLevelWithDict:educationLevelDict];
                }else if ([dict[@"b20"] isEqualToString:@"hasChild"]){
                    NSMutableDictionary *hasChildDict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b22"]];
                        [hasChildDict setValue:dict2[@"b21"] forKey:keyStr];
                    }
                    // 保存
                    [NSGetSystemTools updatehasChildWithDict:hasChildDict];
                }else if ([dict[@"b20"] isEqualToString:@"system_pm"]){
                    NSMutableDictionary *system_pmDict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b22"]];
                        [system_pmDict setValue:dict2[@"b21"] forKey:keyStr];
                    }
                    // 保存
                    [NSGetSystemTools updatesystem_pmWithDict:system_pmDict];
                }else if ([dict[@"b20"] isEqualToString:@"favorite-2"]){
                    NSMutableDictionary *favorite2Dict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b22"]];
                        [favorite2Dict setValue:dict2[@"b21"] forKey:keyStr];
                    }
                    // 保存
                    [NSGetSystemTools updatefavorite2WithDict:favorite2Dict];
                }else if ([dict[@"b20"] isEqualToString:@"favorite-1"]){
                    NSMutableDictionary *favorite1Dict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b22"]];
                        [favorite1Dict setValue:dict2[@"b21"] forKey:keyStr];
                    }
                    // 保存
                    [NSGetSystemTools updatefavorite1WithDict:favorite1Dict];
                }else if ([dict[@"b20"] isEqualToString:@"kidney-1"]){
                    NSMutableDictionary *kidney1Dict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b22"]];
                        [kidney1Dict setValue:dict2[@"b21"] forKey:keyStr];
                    }
                    // 保存
                    [NSGetSystemTools updatekidney1WithDict:kidney1Dict];
                }else if ([dict[@"b20"] isEqualToString:@"kidney-2"]){
                    NSMutableDictionary *kidney2Dict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b22"]];
                        [kidney2Dict setValue:dict2[@"b21"] forKey:keyStr];
                    }
                    // 保存
                    [NSGetSystemTools updatekidney2WithDict:kidney2Dict];
                }else if ([dict[@"b20"] isEqualToString:@"hasRoom"]){
                    NSMutableDictionary *hasRoomDict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b22"]];
                        [hasRoomDict setValue:dict2[@"b21"] forKey:keyStr];
                    }
                    // 保存
                    [NSGetSystemTools updatehasRoomWithDict:hasRoomDict];
                }else if ([dict[@"b20"] isEqualToString:@"timestem"]){
                    NSMutableDictionary *timestemDict = [NSMutableDictionary dictionary];
                    for (NSDictionary *dict2 in b98Arr) {
                        
                        [timestemDict setValue:dict2[@"b22"] forKey:dict2[@"b20"]];
                    }
                    // 保存
                    [NSGetSystemTools updatetimestemWithDict:timestemDict];
                }
            }
        }
        
        //NSLog(@"---系统参数---%@",infoDic);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"系统参数请求失败--%@-",error);
    }];
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
        
//        NSArray *cityDict = [NSDictionary dictionary];
//        NSArray *stateDict = [NSDictionary dictionary];
        //获取plist中的数据
        NSDictionary *cityDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"cityCode" ofType:@"plist"]];
//        [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"cityCode" ofType:@"plist"]];
//
        NSDictionary *stateDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"provinceCode" ofType:@"plist"]];
//        [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"provinceCode" ofType:@"plist"]];
//
        
        NSDictionary *cityCodeDict = cityDict[cityStr];
        NSDictionary *stateCodeDict = stateDict[stateStr];
        
        NSString *a9 = cityCodeDict[@"city_code"];
        NSString *a67 = stateCodeDict[@"provence_code"];
//        NSLog(@"--眼缘--%@--%@-省市--",a9,a67);
        CGFloat a38 = longitude;// 经
        CGFloat a40 = latitude;// 纬
        
        NSNumber *a38Num = [NSNumber numberWithFloat:a38];
        NSNumber *a40Num = [NSNumber numberWithFloat:a40];
        NSMutableDictionary *cllDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:a9,@"a9",a67,@"a67",a38Num,@"a38",a40Num,@"a40", nil];
        [NSGetTools updateCLLocationWithDict:cllDict];
        
        NSNumber *a69 = [NSGetTools getUserSexInfo];
        
        
        [self addAllDatas:a69 a9:a9 a67:a67 a38:a38 a40:a40 a95:1];
        
//        NSLog(@"-----%@--%@------",a9,a67);
        
    }];
    
}

// 定位失败代理
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if ([error code] == kCLErrorDenied)
    {
//        NSLog(@"访问被拒绝");
        NSNumber *a69 = [NSGetTools getUserSexInfo];
        [self addAllDatas:a69 a9:@"330100" a67:@"330000" a38:120.0842098311915 a40:30.291924863746186 a95:1];
        
        NSMutableDictionary *cllDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"330100",@"a9",@"330000",@"a67",@"120.0842098311915",@"a38",@"30.291924863746186",@"a40", nil];
        [NSGetTools updateCLLocationWithDict:cllDict];
    }
    if ([error code] == kCLErrorLocationUnknown) {
        //无法获取位置信息
//        NSLog(@"无法获取位置信息");
        NSNumber *a69 = [NSGetTools getUserSexInfo];
        [self addAllDatas:a69 a9:@"330100" a67:@"330000" a38:120.0842098311915 a40:30.291924863746186 a95:1];
        
        NSMutableDictionary *cllDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"330100",@"a9",@"330000",@"a67",@"120.0842098311915",@"a38",@"30.291924863746186",@"a40", nil];
        [NSGetTools updateCLLocationWithDict:cllDict];
    }
}

// 加载数据
// a69 性别，a95：分页参数，a67：省代码（int）a9：市代码（int） a40：经度 a38：纬度
- (void)addAllDatas:(NSNumber *)a69 a9:(NSString *)a9 a67:(NSString *)a67 a38:(CGFloat)a38 a40:(CGFloat)a40 a95:(int)a95{
    NSString *url = [NSString stringWithFormat:@"%@f_111_15_1.service?a69=%@&a95=%d&a67=%@&a9=%@&a40=%f&a38=%f",kServerAddressTest2,a69,a95,a67,a9,a40,a38];
    NSDictionary *dict = [NSGetTools getAppInfoDict];
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [manger GET:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        if ([infoDic[@"code"] integerValue] == 200) {
            NSArray *modelArr = infoDic[@"body"];
            NSNumber *b96 = infoDic[@"b96"];// 是否有下一页
            [NSGetTools updateB96WithNum:b96];// 更新b96
            for (NSDictionary *dict2 in modelArr) {
//                EyeLuckModel *model = [EyeLuckModel new];
//                [model setValuesForKeysWithDictionary:dict2];
                DHUserForChatModel *item = [[DHUserForChatModel alloc]init];
                [item setValuesForKeysWithDictionary:dict2];
                if (![DBManager checkUserWithUsertId:item.b80]) {
                    [DBManager insertUserToDBWithItem:item];
                }
                if (![self.allModelArray containsObject:item]) {
                    [self.allModelArray addObject:item];
                }
            }
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [_collectionView2 reloadData];
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"----眼缘---error--%@",error);
    }];
}




#pragma mark -- UICollectionViewDataSource

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.allModelArray.count;
}


//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier2 forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    //移除cell
    for (id subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    if (self.allModelArray.count > 0) {
        // 模型
        DHUserForChatModel *model = self.allModelArray[indexPath.row];
        
        NSURL *imgUrl = [NSURL URLWithString:model.b57];

        CGFloat currentWidth = [wArr[indexPath.row] floatValue];
        CGFloat currentHeight = [hArr[indexPath.row] floatValue];
        
        NSInteger xNum = indexPath.row/9;
        //重新定义cell位置、宽高
        if (indexPath.row%9 == 0) {
            _largeType = 1;
            cell.frame = CGRectMake(KcellSpace, xNum*(4*(KcellHeight+KcellSpace*2.5))+KcellSpace,currentWidth,currentHeight+4*KcellSpace);
            // 昵称
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(got(10), currentHeight, got(100), gotHeight(20))];
            nameLabel.textColor = [UIColor colorWithRed:213/255.0 green:17/255.0 blue:68/255.0 alpha:1];
            nameLabel.text = model.b52;
            nameLabel.font = [UIFont systemFontOfSize:14.0];
            [cell.contentView addSubview:nameLabel];
            // 年龄
            UILabel *ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(got(10), currentHeight+20, got(40), gotHeight(20))];
            //ageLabel.backgroundColor = [UIColor grayColor];
            ageLabel.text = [NSString stringWithFormat:@"%@岁",model.b1];
            ageLabel.font = [UIFont systemFontOfSize:14.0];
            [cell.contentView addSubview:ageLabel];
            
            UIImageView *rangeimageV = [[UIImageView alloc]init];
            rangeimageV.frame = CGRectMake(CGRectGetMaxX(ageLabel.frame)+10, CGRectGetMinY(ageLabel.frame)+5, 10, 12);
            rangeimageV.image = [UIImage imageNamed:@"icon-locate-normal.png"];
            [cell.contentView addSubview:rangeimageV];
            
            UILabel *rangeLabel = [[UILabel alloc]init];
            rangeLabel.frame = CGRectMake(CGRectGetMaxX(rangeimageV.frame)+5, CGRectGetMinY(ageLabel.frame), 50, CGRectGetHeight(ageLabel.frame));
            rangeLabel.font = [UIFont systemFontOfSize:13];
            rangeLabel.text = [NSString stringWithFormat:@"%.2fkm",[model.b94 floatValue]/1000];
            [cell.contentView addSubview:rangeLabel];
            // 心
            UIButton *starButton = [[UIButton alloc] initWithFrame:CGRectMake(got(160), currentHeight+5, got(35), gotHeight(30))];
            starButton.tag = indexPath.row;
            [starButton setImage:[UIImage imageNamed:@"chudong-vip-normal.png"] forState:UIControlStateNormal];
            [starButton addTarget:self action:@selector(starButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            self.isBtnSelected = NO;
            [cell.contentView addSubview:starButton];
            
        }
        if (indexPath.row%9 == 1) {
            cell.frame = CGRectMake(0+KcellHeight*2+3*KcellSpace, xNum*(4*(KcellHeight+KcellSpace*2.5))+KcellSpace,currentWidth,currentHeight+2*KcellSpace);
            
        }
        if (indexPath.row%9 == 2) {
            cell.frame = CGRectMake(0+KcellHeight*2+3*KcellSpace, xNum*(4*(KcellHeight+KcellSpace*2.5))+currentHeight+4*KcellSpace,currentWidth,currentHeight+2*KcellSpace);
            
        }
        //--------------------------------------
        if (indexPath.row%9 == 3) {
            cell.frame = CGRectMake(0*currentWidth+KcellSpace, xNum*(4*(KcellHeight+KcellSpace*2.5))+2*currentHeight+7*KcellSpace,currentWidth,currentHeight);
        }
        
        if (indexPath.row%9 == 4) {
            cell.frame = CGRectMake(1*currentWidth+2*KcellSpace, xNum*(4*(KcellHeight+KcellSpace*2.5))+2*currentHeight+7*KcellSpace,currentWidth,currentHeight);
        }
        
        if (indexPath.row%9 == 5) {
            cell.frame = CGRectMake(2*currentWidth+3*KcellSpace, xNum*(4*(KcellHeight+KcellSpace*2.5))+2*currentHeight+7*KcellSpace,currentWidth,currentHeight);

        }
        
        // --------------------------------------
        if (indexPath.row%9 == 6) {
            cell.frame = CGRectMake(0*currentWidth+KcellSpace, xNum*(4*(KcellHeight+KcellSpace*2.5))+3*currentHeight+8*KcellSpace,currentWidth,currentHeight);

        }
        if (indexPath.row%9 == 7) {
            cell.frame = CGRectMake(1*currentWidth+2*KcellSpace, xNum*(4*(KcellHeight+KcellSpace*2.5))+3*currentHeight+8*KcellSpace,currentWidth,currentHeight);
            
        }
        if (indexPath.row%9 == 8) {
            cell.frame = CGRectMake(2*currentWidth+3*KcellSpace, xNum*(4*(KcellHeight+KcellSpace*2.5))+3*currentHeight+8*KcellSpace,currentWidth,currentHeight);
        }
        
        // 头像
        UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, currentWidth, currentHeight)];
        [imageView2 sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"list_item_icon.png"]];
        [cell.contentView addSubview:imageView2];
        // vip
        if ([model.b144 integerValue] == 1) {
            UIImageView *vipImageV = [[UIImageView alloc]init];
            vipImageV.frame = CGRectMake(5, 5, 30, 25);
            vipImageV.image = [UIImage imageNamed:@"Imperialcrown-vip.png"];
            [imageView2 addSubview:vipImageV];
        }
        // label+心(1,2)
        if (indexPath.row%9 == 1 || indexPath.row%9 == 2) {
            // 昵称
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(got(3), currentHeight, got(60), gotHeight(20))];
            //nameLabel.backgroundColor = [UIColor redColor];
            nameLabel.text = model.b52;
            nameLabel.font = [UIFont systemFontOfSize:got(12)];
            [cell.contentView addSubview:nameLabel];
            
            // 年龄
            UILabel *ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(got(65), currentHeight, got(28), gotHeight(20))];
            //ageLabel.backgroundColor = [UIColor yellowColor];
            ageLabel.text = [NSString stringWithFormat:@"%@岁",model.b1];
            ageLabel.font = [UIFont systemFontOfSize:got(12)];
            [cell.contentView addSubview:ageLabel];
            
        
        }
         // 心(1,2,3,4,5,6,7,8)
        if (indexPath.row%9 != 0) {
            // 小图布局
//            _largeType = 2;
            UIButton *starButton = [[UIButton alloc] initWithFrame:CGRectMake(got(65), currentHeight-gotHeight(25), got(28), gotHeight(25))];
            starButton.tag = indexPath.row;
            [starButton setImage:[UIImage imageNamed:@"chudong-normal.png"] forState:UIControlStateNormal];
//            [starButton setImage:[UIImage imageNamed:@"icon-love80x70-s-.png"] forState:UIControlStateSelected];
            [starButton addTarget:self action:@selector(starButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            self.isBtnSelected = NO;
            [cell.contentView addSubview:starButton];

        }
    }else{
        // 数组无数据
    }
    return cell;
}



#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellWith;
    CGFloat cellHeight;
    
    if (indexPath.row%9 == 0) {
        cellWith = KcellHeight*2+KcellHeight/8;
        cellHeight = KcellHeight *2+KcellSpace;
    }else if (indexPath.row%9 == 1){
        cellWith = KcellHeight;
        cellHeight = KcellHeight;
    }else if (indexPath.row%9 == 2){
        cellWith = KcellHeight;
        cellHeight = KcellHeight;
    }else {
        cellWith = KcellHeight;
        cellHeight = KcellHeight;
    }
    [wArr addObject:[NSString stringWithFormat:@"%f",cellWith]];
    [hArr addObject:[NSString stringWithFormat:@"%f",cellHeight]];
    return  CGSizeMake(cellWith, cellHeight);  //设置cell宽高
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0,0, 0, 0);
}

#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   // UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
//    EyeLuckModel *model = self.allModelArray[indexPath.row];
    DHUserForChatModel *model = self.allModelArray[indexPath.row];
    
//    OtherDetailViewController *otherVC = [OtherDetailViewController new];
//    otherVC.p2 = model.b80;
    Homepage *otherVC = [[Homepage alloc]init];
    otherVC.touchP2 = model.b80;
    otherVC.item = model;
    [self.navigationController pushViewController:otherVC animated:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self uoloadLookMeInfo:model];
    });
    
}
/**
 *  保存谁看过我： LP-bus-msc/ f_109_11_2.service ？a77：被查看用户ID
 *
 *  @param model
 */
- (void)uoloadLookMeInfo:(DHUserForChatModel *)model{
    NSDictionary *dict = [NSGetTools getAppInfoDict];
    NSString *userId = [dict objectForKey:@"p2"];
    NSString *sessionId = [dict objectForKey:@"p1"];
    NSString *str = [NSGetTools getAppInfoString];
    NSString *url = [NSString stringWithFormat:@"%@f_109_11_2.service?a77=%@&p1=%@&p2=%@&%@",kServerAddressTest2,model.b80,sessionId,userId,str];
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
        if ([[infoDic objectForKey:@"code"] integerValue] == 200) {
            dispatch_async(dispatch_get_main_queue(), ^{
              [self showHint:@"看过看过"];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
// 红心被点击的时候
- (void)createRoom:(UIButton *)sender model:(DHUserForChatModel *)model{
    [Mynotification addObserver:self selector:@selector(createRoomForTouch:) name:@"createRoomForTouch" object:nil];
//    DHUserForChatModel *userinfo = [DBManager getUserWithCurrentUserId:self.item.fromUserAccount];
    [[SocketManager shareInstance] creatRoomWithString:[NSString stringWithFormat:@"%@",model.b52] account:[NSString stringWithFormat:@"%@",model.b80]];// 开房间
    self.model = model;
}
- (void)createRoomForTouch:(NSNotification *)notifi{
    NSDictionary *dict = notifi.object;
    NSString *roomCode = [[dict objectForKey:@"body"] objectForKey:@"roomCode"];
    NSString *roomName = [[dict objectForKey:@"body"] objectForKey:@"roomName"];
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"charRoomInfo"];
    
    // 加入我的关注,并发送消息
    NSString *targetId = [NSString stringWithFormat:@"%@",_model.b80];
    NSString *targetName = [NSString stringWithFormat:@"%@",_model.b52];
    //    NSString *header = [NSString stringWithFormat:@"%@",model.b57];
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
    item.message = @"我觉得跟你很有眼缘哦，点击名字和我聊天吧！";
    item.fromUserDevice = @"2";
    item.fromUserAccount = userId;
    item.token = token;
    item.timeStamp = date;
    item.toUserAccount = targetId;
    item.userId = userId;
    item.roomCode = roomCode;
    item.roomName = targetName;
    item.targetId = [NSString stringWithFormat:@"%@",_model.b80];
    if (![DBManager checkMessageWithMessageId:messageId targetId:item.targetId]) {
        [DBManager insertMessageDataDBWithModel:item userId:userId];
    }
}

- (void)starButtonAction:(UIButton *)sender{
    
    DHUserForChatModel *model = self.allModelArray[sender.tag];
    [self createRoom:sender model:model];
    NSString *imageName = nil;
    // 会员，与普通用户图片不一样
    if ([model.b144 integerValue] == 1) {
        imageName = @"chudong-vip-selected.png";
    }else{
        imageName = @"chudong-selected.png";
    }
//     _largeType == 1?@"chudong-vip-selected.png":@"chudong-selected.png";
    [sender setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    _largeType = 0;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self uploadShakeInfo:model];
    });
}
/**
 *  上传我触动谁LP-bus-msc/f_105_10_2.service？a77：被关注用户
 *  @param model
 */
- (void)uploadShakeInfo:(DHUserForChatModel *)model{
    NSDictionary *dict = [NSGetTools getAppInfoDict];
    NSString *userId = [dict objectForKey:@"p2"];
    NSString *sessionId = [dict objectForKey:@"p1"];
    NSString *str = [NSGetTools getAppInfoString];
    NSString *url = [NSString stringWithFormat:@"%@f_105_10_2.service?a77=%@&p1=%@&p2=%@&%@",kServerAddressTest2,model.b80,sessionId,userId,str];
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
        if ([[infoDic objectForKey:@"code"] integerValue] == 200) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showHint:@"我触动你了！"];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
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
