//
//  MyDataViewController.m
//  StrangerChat
//
//  Created by long on 15/10/27.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "MyDataViewController.h"
#import "BasicViewController.h"
#import "DetailViewController.h"
#import "HobbyViewController.h"
#import "MineViewController.h"
#import "MyData.h"
#import "DHBasicModel.h"
#import "SUNSlideSwitchView.h"
@interface MyDataViewController ()<UIScrollViewDelegate>{

    NSInteger integer;   // 记录当前页面
}
@property (weak, nonatomic) IBOutlet SUNSlideSwitchView *slideView;
@property (nonatomic,strong)MyData *md;
@property (nonatomic,strong)BasicViewController *basicView;
@property (nonatomic,strong)DetailViewController *detailView;
@property (nonatomic,strong)HobbyViewController *hobbView;
/**
 *  用于存放基本信息页有值的数据
 */
@property (nonatomic,strong) NSMutableArray *basicInfoArr;
/**
 *  用于详细信息页有值的数据
 */
@property (nonatomic,strong) NSMutableArray *detailInfoArr;
/**
 *  用于存放兴趣页有值的数据
 */
@property (nonatomic,strong) NSMutableArray *hobyInfoArr;

/**
 *  所有数据
 */
@property (nonatomic,strong) NSMutableArray *headerArray;
@end

@implementation MyDataViewController


- (void)loadView
{
    self.md = [[MyData alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
    self.view = self.md;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.basicInfoArr = [NSMutableArray array];
    self.detailInfoArr = [NSMutableArray array];
    self.hobyInfoArr = [NSMutableArray array];
    self.headerArray = [NSMutableArray array];
    [self afnet];
    
    [self setbutton];
//    [self.md addWithbasicNum:@"( 1 / 10 )" detaile:@"( 0 / 11 )" hobbies:@"( 0 / 2 )"];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-normal"] style:(UIBarButtonItemStylePlain) target:self action:@selector(leftAction)];
    NSString *str = [AllRegular getInterger];  // 每次获取记录的页面
    NSInteger inte = [str integerValue];
    integer = inte;
    [self n_recordValue];
}
#pragma mark --- 数据
- (void)afnet {
    NSString *p1 = [NSGetTools getUserSessionId];//sessionId
    NSString *p2 = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];//ID
    NSString *appInfo = [NSGetTools getAppInfoString];// 公共参数
    if ([p1 length] == 0 || [p1 isEqualToString:@"(null)"] || [p2 length] == 0 || [p2 isEqualToString:@"(null)"]) {
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"regUser"];
        p2 = [dict objectForKey:@"userId"];
        p1 = [dict objectForKey:@"sessionId"];
    }
    NSString *url = [NSString stringWithFormat:@"%@f_108_13_1.service?p1=%@&p2=%@&%@",kServerAddressTest2,p1,p2,appInfo];
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
            NSDictionary *dict2 = infoDic[@"body"];
            for (NSString *key in dict2) {
#pragma mark -----  b112大部分的内容
                if ([key isEqualToString:@"b112"]) {
                    NSDictionary *Valuedic = [dict2 objectForKey:key];
                    if ([Valuedic objectForKey:@"b4"]) {
                        [self.basicInfoArr addObject:[Valuedic objectForKey:@"b4"]];
                    }
                    if ([Valuedic objectForKey:@"b67"]) {
                        [self.basicInfoArr addObject:[Valuedic objectForKey:@"b67"]];
                    }
                    if ([Valuedic objectForKey:@"b74"]) {
                        [self.basicInfoArr addObject:[Valuedic objectForKey:@"b74"]];
                    }
                    if ([Valuedic objectForKey:@"b5"]) {
                        [self.basicInfoArr addObject:[Valuedic objectForKey:@"b5"]];
                    }
                    if ([Valuedic objectForKey:@"b33"]) {
                        [self.basicInfoArr addObject:[Valuedic objectForKey:@"b33"]];
                    }
                    if ([Valuedic objectForKey:@"b19"]) {
                        [self.basicInfoArr addObject:[Valuedic objectForKey:@"b19"]];
                    }
                    if ([Valuedic objectForKey:@"b62"]) {
                        [self.basicInfoArr addObject:[Valuedic objectForKey:@"b62"]];
                    }
                    if ([Valuedic objectForKey:@"b86"]) {
                        [self.basicInfoArr addObject:[Valuedic objectForKey:@"b86"]];
                    }
                    if ([Valuedic objectForKey:@"b88"]) {
                        [self.basicInfoArr addObject:[Valuedic objectForKey:@"b88"]];
                    }
                    
                    // 详细信息
                    // 邮箱
                    //                            if ([Valuedic objectForKey:@"b88"]) {
                    //                                [self.basicInfoArr addObject:[Valuedic objectForKey:@"b88"]];
                    //                            }
                    //                            // 注册意向
                    //                            if ([Valuedic objectForKey:@"b88"]) {
                    //                                [self.basicInfoArr addObject:[Valuedic objectForKey:@"b88"]];
                    //                            }
                    if ([Valuedic objectForKey:@"b46"]) {
                        [self.detailInfoArr addObject:[Valuedic objectForKey:@"b46"]];
                    }
                    if ([Valuedic objectForKey:@"b32"]) {
                        [self.detailInfoArr addObject:[Valuedic objectForKey:@"b32"]];
                    }
                    if ([Valuedic objectForKey:@"b29"]) {
                        [self.detailInfoArr addObject:[Valuedic objectForKey:@"b29"]];
                    }
                    if ([Valuedic objectForKey:@"b8"]) {
                        [self.detailInfoArr addObject:[Valuedic objectForKey:@"b8"]];
                    }
                    if ([Valuedic objectForKey:@"b31"]) {
                        [self.basicInfoArr addObject:[Valuedic objectForKey:@"b31"]];
                    }
                    if ([Valuedic objectForKey:@"b45"]) {
                        [self.detailInfoArr addObject:[Valuedic objectForKey:@"b45"]];
                    }
                    if ([Valuedic objectForKey:@"b47"]) {
                        [self.detailInfoArr addObject:[Valuedic objectForKey:@"b47"]];
                    }
                    if ([Valuedic objectForKey:@"b39"]) {
                        [self.detailInfoArr addObject:[Valuedic objectForKey:@"b39"]];
                    }
                    if ([Valuedic objectForKey:@"b30"]) {
                        [self.detailInfoArr addObject:[Valuedic objectForKey:@"b30"]];
                    }
                    // 个性特征
                    if ([Valuedic objectForKey:@"b37"]) {
                        [self.hobyInfoArr addObject:[Valuedic objectForKey:@"b37"]];
                    }
                    if ([Valuedic objectForKey:@"b24"]) {
                        [self.hobyInfoArr addObject:[Valuedic objectForKey:@"b24"]];
                    }
                    
                    DHBasicModel *homeModel = [[DHBasicModel alloc] init];
                    homeModel.weight     = Valuedic[@"b88"];    // b88  体重
                    homeModel.height     = Valuedic[@"b33"];    // b33  身高
                    homeModel.wageMax    = Valuedic[@"b86"];    // b86  月收入最大值
                    homeModel.wageMin    = Valuedic[@"b87"];    // b87  月收入最小值
                    homeModel.photoUrl   = Valuedic[@"b57"];    // 头像
                    homeModel.photoStatus= Valuedic[@"b142"];   // 头像审核  1通过 2等待审核 3未通过
                    homeModel.age        = Valuedic[@"b1"];     // 年龄
                    homeModel.vip        = Valuedic[@"b144"];   // vip 1yes 2no
                    
                    homeModel.describe   = Valuedic[@"b17"];    // 交友宣言
                    homeModel.d1Status   = Valuedic[@"b118"];   // 交友宣言审核  1通过 2等待审核 3未通过
                    homeModel.systemName = Valuedic[@"b152"];   // 用户系统编号
                    homeModel.id         = Valuedic[@"b34"];    // ID
                    homeModel.nickName   = Valuedic[@"b52"];    // b52  昵称
                    homeModel.status     = Valuedic[@"b75"];   // 昵称审核  1通过 2等待审核 3未通过
                    homeModel.userId     = Valuedic[@"b80"];    // b80  用户id 不能为空
                    if ([Valuedic[@"b69"] intValue] == 1) {  // b69  性别 1 男 2女
                        homeModel.sex = @"男";
                    }else {
                        homeModel.sex = @"女";
                    }
                    
                    
                    if (Valuedic[@"b4"] == nil) { // b4   出生日期
                        homeModel.birthday = @"未填写";
                    }else {
                        NSString *bornDay    = Valuedic[@"b4"];
                        NSArray *yearArray   = [bornDay componentsSeparatedByString:@"-"];
                        homeModel.birthday   = [NSString stringWithFormat:@"%@年%@月%@日",yearArray[0],yearArray[1],yearArray[2]];
                    }
                    
                    NSString *logTime    = Valuedic[@"b44"];    // b44  登陆时间
                    NSArray *loginArray  = [logTime componentsSeparatedByString:@":"];
                    homeModel.loginTime  = [NSString stringWithFormat:@"%@:%@",loginArray[0],loginArray[1]];
                    
                    NSNumber *sexNum = [NSGetTools getUserSexInfo];
                    if ([sexNum isEqualToNumber:[NSNumber numberWithInt:1]]) { // 1男2女
                        homeModel.loveType  = [self addWithVariable:[NSGetSystemTools getloveType1] keyStr:Valuedic[@"b45"]]; // b45  喜欢异性的类型
                        homeModel.kidney    = Valuedic[@"b37"]; // b37 个性特征
                        homeModel.favorite  = Valuedic[@"b24"]; // b24  兴趣爱好
                    }else {
                        homeModel.loveType  = [self addWithVariable:[NSGetSystemTools getloveType2] keyStr:Valuedic[@"b45"]]; // b45  喜欢异性的类型
                        homeModel.kidney    = Valuedic[@"b37"]; // b37 个性特征
                        homeModel.favorite  = Valuedic[@"b24"]; // b24  兴趣爱好
                    }
                    homeModel.charmPart = [self addWithVariable:[NSGetSystemTools getcharmPart] keyStr:Valuedic[@"b8"]];  // b8   魅力部位
                    if (Valuedic[@"b39"] == nil) { // b39  和父母同住
                        homeModel.together = @"";
                    }else {
                        homeModel.together = [NSString stringWithFormat:@"%@和父母同住",[self addWithVariable:[NSGetSystemTools getliveTogether]   keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b39"]]]];
                    }
                    if (Valuedic[@"b47"] == nil) { // b47  婚姻性行为
                        homeModel.marrySex = @"";
                    }else {
                        homeModel.marrySex = [NSString stringWithFormat:@"%@婚前性行为",[self addWithVariable:[NSGetSystemTools getmarrySex] keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b47"]]]];
                    }
                    homeModel.marriage   = [self addWithVariable:[NSGetSystemTools getmarriageStatus] keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b46"]]]; // b46  婚姻状况
                    homeModel.education  = [self addWithVariable:[NSGetSystemTools geteducationLevel] keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b19"]]]; // b19  学历
                    homeModel.star       = [self addWithVariable:[NSGetSystemTools getstar]           keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b74"]]]; // b74  星座 1-12
                    if (Valuedic[@"b30"] == nil) {
                        homeModel.hasChild = @"";
                    }else {
                        homeModel.hasChild = [NSString stringWithFormat:@"%@孩子",[self addWithVariable:[NSGetSystemTools gethasChild]       keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b30"]]]];
                    } // b30  是否想要小孩
                    if (Valuedic[@"b31"] == nil) {
                        homeModel.LoveOther = @"";
                    }else {
                        homeModel.LoveOther = [NSString stringWithFormat:@"%@异地恋",[self addWithVariable:[NSGetSystemTools gethasLoveOther]   keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b31"]]]];
                    }
                    homeModel.hasRoom    = [self addWithVariable:[NSGetSystemTools gethasRoom]        keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b32"]]]; // b32  是否有房
                    homeModel.hasCar     = [self addWithVariable:[NSGetSystemTools gethasCar]         keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b29"]]]; // b29  是否有车
                    homeModel.profession = [self addWithVariable:[NSGetSystemTools getprofession]     keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b62"]]]; // b62  职业
                    homeModel.blood      = [self addWithVariable:[NSGetSystemTools getblood]          keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b5"]]];  // b5   血型
                    homeModel.city     = [self addWithVariDic:[ConditionObject obtainDict]   keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b9"]]];  // b9   居住地(市)
                    homeModel.province = [self addWithVariDic:[ConditionObject provinceDict] keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b67"]]]; // b67  居住地(省)
                    [self.headerArray addObject:homeModel];
                }
            }
        }
        [self.md addWithbasicNum:[NSString stringWithFormat:@"( %ld / 10 )",self.basicInfoArr.count] detaile:[NSString stringWithFormat:@"( %ld / 11 )",self.detailInfoArr.count] hobbies:[NSString stringWithFormat:@"( %ld / 2 )",self.hobyInfoArr.count]];
        [self n_subViewController];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"系统参数请求失败--%@-",error.userInfo);
    }];
}
- (NSString *)addWithVariable:(NSDictionary *)variable keyStr:(NSString *)keystr {
    
    NSDictionary *flashdic = variable;
    return [flashdic objectForKey:keystr];
}
- (NSString *)addWithVariDic:(NSDictionary *)VariDic keyStr:(NSString *)keystr {
    NSDictionary *cityDic = VariDic;    // 市
    NSMutableDictionary *cityDict = [NSMutableDictionary dictionary];
    for (NSString *cityKey in cityDic) {
        NSString *cityValue = [cityDic objectForKey:cityKey];
        [cityDict setObject:cityKey forKey:cityValue];
    }
    return [cityDict objectForKey:[NSString stringWithFormat:@"%@",keystr]];
}
- (void)n_recordValue {
    if (integer == 1) {
        [self addWithButton:self.md.detaile :self.md.hobbies :self.md.basic];
        [UIView animateWithDuration:0.3 animations:^{
            self.md.dividLine.frame = CGRectMake((DATAWIDTH/2-45)/2-45, 64, 90, 2);
            self.md.scrollView.contentOffset = CGPointMake(0, -64);  // x y
        } completion:^(BOOL finished) {
            
        }];
        
    }else if (integer == 2){
        
        [self addWithButton:self.md.basic :self.md.hobbies :self.md.detaile];
        [UIView animateWithDuration:0.3 animations:^{
            self.md.dividLine.frame = CGRectMake(DATAWIDTH/2-45, 64, 90, 2);
            self.md.scrollView.contentOffset = CGPointMake(self.view.frame.size.width, -64);
        } completion:^(BOOL finished) {
            
        }];
        
    }else if (integer == 3){
        
        [self addWithButton:self.md.basic :self.md.detaile :self.md.hobbies];
        [UIView animateWithDuration:0.3 animations:^{
            self.md.dividLine.frame = CGRectMake(DATAWIDTH/2-45+((DATAWIDTH/2-45)/2-45)+90, 64, 90, 2);
            self.md.scrollView.contentOffset = CGPointMake(self.view.frame.size.width*2, -64);
        } completion:^(BOOL finished) {
            
        }];
        
    }else {
        [self addWithButton:self.md.detaile :self.md.hobbies :self.md.basic];
        [UIView animateWithDuration:0.3 animations:^{
            self.md.dividLine.frame = CGRectMake((DATAWIDTH/2-45)/2-45, 64, 90, 2);
            self.md.scrollView.contentOffset = CGPointMake(0, -64);  // x y
        } completion:^(BOOL finished) {
            
        }];
    }
}
/**
 *   ----记录当前页面
 */
- (void)leftAction {
    
    [AllRegular updatehasCarWithDict:[NSString stringWithFormat:@"%ld",integer]];
    [self.navigationController popToRootViewControllerAnimated:true];
}
#pragma mark -- 三个点击事件
- (void)setbutton {
    
    [self.md.basic addTarget:self action:@selector(firstAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.md.basic setTitleColor:kUIColorFromRGB(0xDC143C) forState:(UIControlStateNormal)];
    [self.md.detaile addTarget:self action:@selector(secondAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.md.detaile setTitleColor:kUIColorFromRGB(0x3D3D3D) forState:(UIControlStateNormal)];
    [self.md.hobbies addTarget:self action:@selector(thirtAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.md.hobbies setTitleColor:kUIColorFromRGB(0x3D3D3D) forState:(UIControlStateNormal)];
}

- (void)firstAction:(UIButton *)sender {
    integer = 1;
    [self n_recordValue];
}
- (void)secondAction:(UIButton *)sender {
    integer = 2;
    [self n_recordValue];
}
- (void)thirtAction:(UIButton *)sender {
    
    integer = 3;
    [self n_recordValue];
}
#pragma make 滑动代理 减速结束
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    if (self.md.scrollView.contentOffset.x == 0) {  // 基本资料
        
        [self addWithButton:self.md.detaile :self.md.hobbies :self.md.basic];
        [UIView animateWithDuration:0.3 animations:^{
            self.md.dividLine.frame = CGRectMake((DATAWIDTH/2-45)/2-45, 64, 90, 2);
        } completion:^(BOOL finished) {
            
        }];
        
    }else if (self.md.scrollView.contentOffset.x >= self.view.frame.size.width && self.md.scrollView.contentOffset.x < self.view.frame.size.width*2) { // 详细信息
        
        
        [self addWithButton:self.md.basic :self.md.hobbies :self.md.detaile];
        [UIView animateWithDuration:0.3 animations:^{
            self.md.dividLine.frame = CGRectMake(DATAWIDTH/2-45, 64, 90, 2);
        } completion:^(BOOL finished) {
            
        }];
        
    }else if (self.md.scrollView.contentOffset.x >= self.view.frame.size.width*2){   // 个性爱好
        
        [self addWithButton:self.md.basic :self.md.detaile :self.md.hobbies];
        [UIView animateWithDuration:0.3 animations:^{
            self.md.dividLine.frame = CGRectMake(DATAWIDTH/2-45+((DATAWIDTH/2-45)/2-45)+90, 64, 90, 2);
        } completion:^(BOOL finished) {
            
        }];
        
    }
    
}

- (void)addWithButton:(UIButton *)first :(UIButton *)second :(UIButton *)thirt {
    
    [first setTitleColor:kUIColorFromRGB(0x3D3D3D) forState:(UIControlStateNormal)];
    [second setTitleColor:kUIColorFromRGB(0x3D3D3D) forState:(UIControlStateNormal)];
    [thirt setTitleColor:kUIColorFromRGB(0xDC143C) forState:(UIControlStateNormal)];
}

#pragma mark ---- 添加子控制
- (void)n_subViewController {

    self.md.scrollView.pagingEnabled = true; // 按页翻动
    _md.scrollView.delegate = self;
    self.md.scrollView.contentSize = CGSizeMake(self.view.frame.size.width*3, 0);

    _basicView = [[BasicViewController alloc] init];
    _basicView.dataArr = [NSArray arrayWithArray:self.basicInfoArr];
    _basicView.view.frame = CGRectMake(0, 0, self.view.frame.size.width, [[UIScreen mainScreen] bounds].size.height);
    
    _detailView = [[DetailViewController alloc] init];
    _detailView.dataArr = [NSArray arrayWithArray:self.headerArray];
    _detailView.view.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, [[UIScreen mainScreen] bounds].size.height);
    
    _hobbView = [[HobbyViewController alloc] init];
    _hobbView.dataArr = [NSArray arrayWithArray:self.headerArray];
    _hobbView.view.frame = CGRectMake(self.view.frame.size.width*2, 0, self.view.frame.size.width, [[UIScreen mainScreen] bounds].size.height);
    
    [self addChildViewController:_basicView];
    [self.md.scrollView addSubview:_basicView.view];
    
    [self addChildViewController:_detailView];
    [self.md.scrollView addSubview:_detailView.view];
    
    [self addChildViewController:_hobbView];
    [self.md.scrollView addSubview:_hobbView.view];
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
