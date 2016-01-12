//
//  Homepage.m
//  StrangerChat
//
//  Created by zxs on 15/11/25.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "Homepage.h"
#import "MyPhotoViewController.h"
#import "DHUserAlbumModel.h"
#import "ChatController.h"
@interface Homepage ()<UITableViewDataSource,UITableViewDelegate>
{
    
    UITableView *paraTabelView;
    NSString *contentStr;
    NSString *marriageStr;
    NSString *makeFriendStr;
    CGFloat h;
    CGFloat marriageHige;
    CGFloat makeFriend;
    NSNumber *VipNum;
}
@property (nonatomic,strong)NSArray *basicArray;
@property (nonatomic,strong)NSArray *vipAssetsArray;
@property (nonatomic,strong)NSMutableArray *allData;
@property (nonatomic,strong)NSMutableArray *conditonArray;
/**
 *  相册数组
 */
@property (nonatomic,strong) NSMutableArray *albumArr;

@end

@implementation Homepage

- (NSArray *)basicArray {

    return @[@"基本资料",@"身高",@"体重",@"婚姻状况",@"学历",@"星座",@"职业"];
}

- (NSArray *)vipAssetsArray {
    
    return @[@"资产信息",@"月收入",@"房产",@"车产"];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"个人主页";
    self.allData       = [NSMutableArray array];
    self.conditonArray = [NSMutableArray array];
    self.albumArr = [NSMutableArray array];
    [self afnet];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-normal"] style:(UIBarButtonItemStylePlain) target:self action:@selector(leftAction)];
    // 点击了 记录当前值
    
}

- (void)leftAction {
    
    [self.navigationController popToRootViewControllerAnimated:true];
}



#pragma mark ---- 获取数据
- (void)afnet {

    NSString *p1 = [NSGetTools getUserSessionId];//sessionId
    NSString *appInfo = [NSGetTools getAppInfoString];// 公共参数
    NSString *url = [NSString stringWithFormat:@"%@f_108_13_1.service?p1=%@&p2=%@&%@",kServerAddressTest2,p1,self.touchP2,appInfo];
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
//         NSLog(@"zong字典-----:%@",infoDic);
        NSNumber *codeNum = infoDic[@"code"];
        if ([codeNum intValue] == 200) {
            NSDictionary *dict2 = infoDic[@"body"];
//            NSLog(@"字典-----:%@",dict2);
            for (NSString *key in dict2) {
                
                
#pragma mark ----- b114择友条件
                if ([key isEqualToString:@"b114"]) {
                     NSDictionary *Valuedic = [dict2 objectForKey:key];
                    for (NSString *makeKey in Valuedic) {
//                        NSLog(@"%@",makeKey);
                        if (makeKey) {
                            
                            NConditonModel *condit = [[NConditonModel alloc] init];
                            if (Valuedic[@"b1"] == nil) {
                                condit.age = @"";
                            }else {
                                condit.age     = [NSString stringWithFormat:@"年龄范围:%@",Valuedic[@"b1"]];  // 年龄
                            }
                            if (Valuedic[@"b85"] == nil) {
                                condit.wage = @"";
                            }else {
                                condit.wage    = [NSString stringWithFormat:@"收入范围:%@",Valuedic[@"b85"]];  // 收入范围
                            }
                            if (Valuedic[@"b33"] == nil) {
                                condit.heights = @"";
                            }else {
                                condit.heights = [NSString stringWithFormat:@"身高范围:%@",Valuedic[@"b33"]];    // b33  身高
                            }
                            
                            if (Valuedic[@"b9"] == nil) {
                                condit.city = @"";
                            }else {
                                condit.city     = [self addWithVariDic:[ConditionObject obtainDict]   keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b9"]]];  // b9   居住地(市)
                            }
                            if (Valuedic[@"b67"] == nil) {
                                condit.proVince = @"";
                            }else {
                                condit.proVince = [self addWithVariDic:[ConditionObject provinceDict] keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b67"]]]; // b67  居住地(省)
                            }
                            if (Valuedic[@"b19"] == nil) {
                                condit.education = @"";
                            }else {
                                condit.education  = [NSString stringWithFormat:@"学历:%@",[self addWithVariable:[NSGetSystemTools geteducationLevel] keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b19"]]]]; // b19  学历
                            }
                            if (Valuedic[@"b46"] == nil) {
                                condit.marriage = @"";
                            }else {
                                condit.marriage = [NSString stringWithFormat:@"婚姻状况:%@",[self addWithVariable:[NSGetSystemTools getmarriageStatus] keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b46"]]]];
                            }
                            
                            [self.conditonArray addObject:condit];
                        }
                    }
                }
                
#pragma mark -----  b112大部分的内容
                if ([key isEqualToString:@"b112"]) {
                    NSDictionary *Valuedic = [dict2 objectForKey:key];
                    
                    for (NSString *strss in Valuedic) {
                        
                        if (strss) {
                            NHome *homeModel = [[NHome alloc] init];
                            homeModel.weight     = Valuedic[@"b88"];    // b88  体重
                            homeModel.height     = Valuedic[@"b33"];    // b33  身高
                            homeModel.wageMax    = Valuedic[@"b86"];    // b86  月收入最大值
                            homeModel.wageMin    = Valuedic[@"b87"];    // b87  月收入最小值
                            homeModel.photoUrl   = Valuedic[@"b57"];    // 头像
                            homeModel.photoStatus= Valuedic[@"b142"];   // 头像审核  1通过 2等待审核 3未通过
                            homeModel.age        = Valuedic[@"b1"];     // 年龄
                            homeModel.vip        = Valuedic[@"b144"];   // vip 1yes 2no
                            VipNum = Valuedic[@"b144"];
                            homeModel.describe   = Valuedic[@"b17"];    // 交友宣言
                            homeModel.d1Status   = Valuedic[@"b118"];   // 交友宣言审核  1通过 2等待审核 3未通过
                            homeModel.systemName = Valuedic[@"b152"];   // 用户系统编号
                            homeModel.id         = Valuedic[@"b34"];    // ID
                            homeModel.nickName   = Valuedic[@"b52"];    // b52  昵称
                            homeModel.status     = Valuedic[@"b75"];   // 昵称审核  1通过 2等待审核 3未通过
                            homeModel.sex        = Valuedic[@"b69"];    // b69  性别 1 男 2女
                            homeModel.userId     = Valuedic[@"b80"];    // b80  用户id 不能为空
                            
                            NSString *bornDay    = Valuedic[@"b4"];     // b4   出生日期
                            NSArray *yearArray   = [bornDay componentsSeparatedByString:@"-"];
                            homeModel.birthday   = [NSString stringWithFormat:@"%@年%@月%@日",yearArray[0],yearArray[1],yearArray[2]];
                            NSString *logTime    = Valuedic[@"b44"];    // b44  登陆时间
                            if (logTime) {
                                NSArray *loginArray  = [logTime componentsSeparatedByString:@":"];
                                homeModel.loginTime  = [NSString stringWithFormat:@"%@:%@",loginArray[0],loginArray[1]];
                            }else{
                               homeModel.loginTime = @"1999-01-01 00:00";
                            }
                            
                            
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
                            homeModel.blood      = [self addWithVariable:[NSGetSystemTools getblood]          keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b5"]]];  //  b5   血型
                            homeModel.city     = [self addWithVariDic:[ConditionObject obtainDict]   keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b9"]]];  // b9   居住地(市)
                            homeModel.province = [self addWithVariDic:[ConditionObject provinceDict] keyStr:[NSString stringWithFormat:@"%@",Valuedic[@"b67"]]]; // b67  居住地(省)
                            [self.allData addObject:homeModel];
                            
                        }
                    }
                }else if ([key isEqualToString:@"b113"]){
                    NSArray *arr = [dict2 objectForKey:@"b113"];
                    for (NSDictionary *dict in arr) {
                        DHUserAlbumModel *item = [[DHUserAlbumModel alloc]init];
                        [item setValuesForKeysWithDictionary:dict];
                        [self.albumArr addObject:item];
                    }
                }
              // ======
                
             }
        }
        [self layoutParallax];
        
        //NSLog(@"---系统参数---%@",infoDic);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"系统参数请求失败--%@-",error);
    }];
}

/**
 *  Description
 *
 *  @param variable 不可变字典
 *  @param keystr   根据key取值
 *
 *  @return 结果
 */
- (NSString *)addWithVariable:(NSDictionary *)variable keyStr:(NSString *)keystr {

    NSDictionary *flashdic = variable;
    return [flashdic objectForKey:keystr];
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
    [paraTabelView registerClass:[ParaTableViewCell class] forCellReuseIdentifier:KCell_A];
    [paraTabelView registerClass:[N_photoViewCell class] forCellReuseIdentifier:KCell_B];
    [paraTabelView registerClass:[HMakeFriendCell class] forCellReuseIdentifier:KCell_C];
    [paraTabelView registerClass:[HTBasicdataCell class] forCellReuseIdentifier:KCell_D];
    [paraTabelView registerClass:[HAssetsCell class] forCellReuseIdentifier:KCell_E];
    [paraTabelView registerClass:[HPersonalityCell class] forCellReuseIdentifier:KCell_F];
    [paraTabelView registerClass:[HMarriageCell class] forCellReuseIdentifier:KCell_G];
    [paraTabelView registerClass:[HChooseCell class] forCellReuseIdentifier:KCell_H];
    [paraTabelView registerClass:[NVIpAssetsCell class] forCellReuseIdentifier:KCell_J];
    [self.view addSubview:paraTabelView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 9;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 3) {
        return self.basicArray.count;
    }else if (section == 4){
        
        if ([VipNum intValue] == 1) {  /// 测试需要先改为VIP 为2
            return 4;
        }else {
            return 1;
        }
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NHome *homeModel = nil;
    if (self.allData.count > 0) {
        homeModel = self.allData[indexPath.row];
    }
    NSNumber *sexNum = [NSGetTools getUserSexInfo];
    if (indexPath.section == 0) {
        // nickname:  urlStr:
        ParaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KCell_A forIndexPath:indexPath];
        cell.selected = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.heartImage.userInteractionEnabled = YES;
        cell.wxImage.userInteractionEnabled = YES;
        UITapGestureRecognizer *touchHeartTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchHeartTapAction:)];
        [cell.heartImage addGestureRecognizer:touchHeartTap];
        UITapGestureRecognizer *getChatTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(getChatTapAction:)];
        [cell.wxImage addGestureRecognizer:getChatTap];
        [cell cellLoadDataWithBackground:@"bg-1" heart:@"btn-love60x60-n" wxpic:@"btn-chat-n" ageImage:@"icon-gender-gril" age:[NSString stringWithFormat:@"%@",homeModel.age] dressImage:@"icon-locate-normal.png" address:homeModel.city timeImage:@"icon-time" time:homeModel.loginTime model:homeModel];
        if ([homeModel.status intValue] == 1) {  // 昵称审核
            [cell cellLoadWithnickname:homeModel.nickName model:homeModel];
        }else if ([homeModel.status intValue] == 2) {
            [cell cellLoadWithnickname:@"用户昵称审核中" model:homeModel];
        }else if ([homeModel.status intValue] == 3){
            [cell cellLoadWithnickname:@"用户昵称审核失败" model:homeModel];
        }
        
        if ([homeModel.photoStatus intValue] == 1) {  // 头像审核
            [cell cellLoadWithurlStr:[NSURL URLWithString:homeModel.photoUrl] ];
        }else if ([homeModel.photoStatus intValue] == 2) {
            [cell cellLoadWithurlStr:[NSURL URLWithString:@""]];
        }else if ([homeModel.photoStatus intValue] == 3){
            [cell cellLoadWithurlStr:[NSURL URLWithString:@""]];
        }
        return cell;
        
    }else if (indexPath.section == 1) {
        N_photoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KCell_B forIndexPath:indexPath];
        NPhotoController *photo = [[NPhotoController alloc] init];
        photo.albumArr = [NSArray arrayWithArray:_albumArr];
        photo.view.frame = cell.allView.frame;
        [self addChildViewController:photo];
        
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginUser"];
        NSArray *albumTempArr = [dict objectForKey:@"b113"];
        if (albumTempArr.count == 0) {
            [cell.allView addSubview:photo.view];
            UIView *coverView = [[UIView alloc]init];
            coverView.frame = cell.bounds;
            coverView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
            [cell.allView addSubview:coverView];
            UIButton *pushBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            pushBtn.frame = CGRectMake(CGRectGetMinX(coverView.bounds), 5, CGRectGetWidth(coverView.bounds), CGRectGetHeight(coverView.bounds)-10);
            [pushBtn setTitle:@"传一张自己的账片再来看TA的照片吧~" forState:(UIControlStateNormal)];
            pushBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            [pushBtn addTarget:self action:@selector(pushToUploadAlbums) forControlEvents:(UIControlEventTouchUpInside)];
            [coverView addSubview:pushBtn];
            
        }else{
          [cell.allView addSubview:photo.view];
        }
        return cell;
        
    }else if (indexPath.section == 2) {
        
        HMakeFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:KCell_C forIndexPath:indexPath];
        [cell addDataWithtitle:@"交友宣言"];
        if ([homeModel.d1Status intValue] == 1) {  // 宣言审核
            contentStr = homeModel.describe;
        }else if ([homeModel.d1Status intValue] == 2) {
            contentStr = @"交友宣言审核中";
        }else if ([homeModel.d1Status intValue] == 3){
            contentStr = @"交友宣言审核失败";
        }
        if (contentStr == nil) {
            cell.content.text = @"保密";
        }else {
            cell.content.text = contentStr;
        }
        cell.content.font = [UIFont systemFontOfSize:13];
        h =[self hightForContent:contentStr fontSize:13.0f];
        CGRect temp = cell.content.frame;
        temp.size.height = h;
        cell.content.frame = temp;
        cell.downLine.frame = CGRectMake(0, 30+h-0.5, [[UIScreen mainScreen] bounds].size.width, 0.5);
        return cell;
        
    }else if (indexPath.section == 3) {
        
        HTBasicdataCell *cell = [tableView dequeueReusableCellWithIdentifier:KCell_D forIndexPath:indexPath];
        [cell addDataWithsomeData:self.basicArray[indexPath.row]];
        if (self.allData) {
            if (indexPath.row == 0) {
                cell.shortLine.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 0.5);
            }else if (indexPath.row == 1) {
                if (homeModel.height != nil) {
                    cell.choice.text = [NSString stringWithFormat:@"%@cm",homeModel.height];
                }else {
                    cell.choice.text = @"保密";
                }
                cell.shortLine.frame = CGRectMake(90 + 15, 54.5, [[UIScreen mainScreen] bounds].size.width, 0.5);
            }else if (indexPath.row == 2) {
                if (homeModel.weight != nil) {
                    cell.choice.text = [NSString stringWithFormat:@"%@",homeModel.weight];
                }else {
                    cell.choice.text = @"保密";
                }
                cell.shortLine.frame = CGRectMake(90 + 15, 54.5, [[UIScreen mainScreen] bounds].size.width, 0.5);
            }else if (indexPath.row == 3) {
                if (homeModel.marriage != nil) {
                    cell.choice.text = homeModel.marriage;
                }else {
                    cell.choice.text = @"保密";
                }
                cell.shortLine.frame = CGRectMake(90 + 15, 54.5, [[UIScreen mainScreen] bounds].size.width, 0.5);
            }else if (indexPath.row == 4) {
                if (homeModel.education != nil) {
                    cell.choice.text = homeModel.education;
                }else {
                    cell.choice.text = @"保密";
                }
                cell.shortLine.frame = CGRectMake(90 + 15, 54.5, [[UIScreen mainScreen] bounds].size.width, 0.5);
            }else if (indexPath.row == 5) {
                NSLog(@"%@",homeModel.star);
                if (homeModel.star != nil) {
                    cell.choice.text = homeModel.star;
                }else {
                    cell.choice.text = @"保密";
                }
                cell.shortLine.frame = CGRectMake(90 + 15, 54.5, [[UIScreen mainScreen] bounds].size.width, 0.5);
            }else if (indexPath.row == 6) {
                if (homeModel.profession != nil) {
                    cell.choice.text = homeModel.profession;
                }else {
                    cell.choice.text = @"保密";
                }
                cell.shortLine.frame = CGRectMake(0, 54.5, [[UIScreen mainScreen] bounds].size.width, 0.5);
            }
        }
        return cell;
    
    }else if (indexPath.section == 4) {
        
        if ([homeModel.vip intValue] == 1) {
            NVIpAssetsCell *cell = [tableView dequeueReusableCellWithIdentifier:KCell_J forIndexPath:indexPath];
            [cell addDataWithsomeData:self.vipAssetsArray[indexPath.row]];
            if (self.allData) {
                if (indexPath.row == 0) {
                    cell.shortLine.frame = CGRectMake(0,    0,       [[UIScreen mainScreen] bounds].size.width, 0.5);
                }else if (indexPath.row == 1) {
                    if (homeModel.wageMax != nil) {
                        cell.choice.text = [NSString stringWithFormat:@"%@-%@",homeModel.wageMax,homeModel.wageMin];
                    }else {
                        cell.choice.text = @"保密";
                    }
                    cell.shortLine.frame = CGRectMake(90 + 15, 54.5, [[UIScreen mainScreen] bounds].size.width, 0.5);
                }else if (indexPath.row == 2) {
                    if (homeModel.hasRoom != nil) {
                        cell.choice.text = homeModel.hasRoom;
                    }else {
                        cell.choice.text = @"保密";
                    }
                    cell.shortLine.frame = CGRectMake(90 + 15, 54.5, [[UIScreen mainScreen] bounds].size.width, 0.5);
                }else if (indexPath.row == 3) {
                    if (homeModel.hasCar != nil) {
                        cell.choice.text = homeModel.hasCar;
                    }else {
                        cell.choice.text = @"保密";
                    }
                    cell.shortLine.frame = CGRectMake(90 + 15, 54.5, [[UIScreen mainScreen] bounds].size.width, 0.5);
                }
            }
            return cell;
        }else {
            HAssetsCell *cell = [tableView dequeueReusableCellWithIdentifier:KCell_E forIndexPath:indexPath];
            [cell addDataWithassets:@"资产信息" monthImage:@"" month:@"月收入" propertyImage:@"" property:@"房产" carImage:@"" car:@"车产" vipImage:@"btn-vip-exclusive-h"];
            return cell;
        }
        
    }else if (indexPath.section == 5) {
        
        
        HPersonalityCell *cell = [tableView dequeueReusableCellWithIdentifier:KCell_F forIndexPath:indexPath];
        NSArray *kidneyArray  = [homeModel.kidney componentsSeparatedByString:@"-"];
        [cell addDataWithtitleLabel:@"个性特征"];
        
        if ([sexNum isEqualToNumber:[NSNumber numberWithInt:1]]) { // 男
            
            if (kidneyArray.count == 1) {
                
                [self addWithKidDic:[NSGetSystemTools getkidney1] keyStr:kidneyArray[0] content:cell.content];
                
            }else if (kidneyArray.count == 2) {
                
                [self addWithKidDic:[NSGetSystemTools getkidney1] keyStr:kidneyArray[0] content:cell.content];
                [self addWithKidDic:[NSGetSystemTools getkidney1] keyStr:kidneyArray[1] content:cell.sContent];
                
            }else if (kidneyArray.count == 3) {
                
                [self addWithKidDic:[NSGetSystemTools getkidney1] keyStr:kidneyArray[0] content:cell.content];
                [self addWithKidDic:[NSGetSystemTools getkidney1] keyStr:kidneyArray[1] content:cell.sContent];
                [self addWithKidDic:[NSGetSystemTools getkidney1] keyStr:kidneyArray[2] content:cell.tContent];
            }
            
        }else {  // 女
            
            if (kidneyArray.count == 1) {
                
                [self addWithKidDic:[NSGetSystemTools getkidney2] keyStr:kidneyArray[0] content:cell.content];
                
            }else if (kidneyArray.count == 2) {
                
                [self addWithKidDic:[NSGetSystemTools getkidney2] keyStr:kidneyArray[0] content:cell.content];
                [self addWithKidDic:[NSGetSystemTools getkidney2] keyStr:kidneyArray[1] content:cell.sContent];
                
            }else if (kidneyArray.count == 3) {
                
                [self addWithKidDic:[NSGetSystemTools getkidney2] keyStr:kidneyArray[0] content:cell.content];
                [self addWithKidDic:[NSGetSystemTools getkidney2] keyStr:kidneyArray[1] content:cell.sContent];
                [self addWithKidDic:[NSGetSystemTools getkidney2] keyStr:kidneyArray[2] content:cell.tContent];
            }
        }
        return cell;
        
    }else if (indexPath.section == 6) {
        
        HPersonalityCell *cell = [tableView dequeueReusableCellWithIdentifier:KCell_F forIndexPath:indexPath];
        [cell addDataWithtitleLabel:@"兴趣爱好"];
        NSArray *favoArray  = [homeModel.favorite componentsSeparatedByString:@"-"];
        
        if ([sexNum isEqualToNumber:[NSNumber numberWithInt:1]]) { // 男
            
            if (favoArray.count == 1) {
                
                [self addWithKidDic:[NSGetSystemTools getfavorite1] keyStr:favoArray[0] content:cell.content];
                
            }else if (favoArray.count == 2) {
                
                [self addWithKidDic:[NSGetSystemTools getfavorite1] keyStr:favoArray[0] content:cell.content];
                [self addWithKidDic:[NSGetSystemTools getfavorite1] keyStr:favoArray[1] content:cell.sContent];
                
            }else if (favoArray.count == 3) {
                
                [self addWithKidDic:[NSGetSystemTools getfavorite1] keyStr:favoArray[0] content:cell.content];
                [self addWithKidDic:[NSGetSystemTools getfavorite1] keyStr:favoArray[1] content:cell.sContent];
                [self addWithKidDic:[NSGetSystemTools getfavorite1] keyStr:favoArray[2] content:cell.tContent];
            }
            
        }else {  // 女
            
            if (favoArray.count == 1) {
                
                [self addWithKidDic:[NSGetSystemTools getfavorite2] keyStr:favoArray[0] content:cell.content];
                
            }else if (favoArray.count == 2) {
                
                [self addWithKidDic:[NSGetSystemTools getfavorite2] keyStr:favoArray[0] content:cell.content];
                [self addWithKidDic:[NSGetSystemTools getfavorite2] keyStr:favoArray[1] content:cell.sContent];
                
            }else if (favoArray.count == 3) {
                
                [self addWithKidDic:[NSGetSystemTools getfavorite2] keyStr:favoArray[0] content:cell.content];
                [self addWithKidDic:[NSGetSystemTools getfavorite2] keyStr:favoArray[1] content:cell.sContent];
                [self addWithKidDic:[NSGetSystemTools getfavorite2] keyStr:favoArray[2] content:cell.tContent];
            }
        }
        return cell;
        
    }else if (indexPath.section == 7){
        

        HMakeFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:KCell_C forIndexPath:indexPath];
        [cell addDataWithtitle:@"婚恋观"];
        
        if (homeModel.LoveOther.length == 0 || homeModel.marrySex.length == 0 || homeModel.together.length == 0 || homeModel.hasChild .length== 0) {
            marriageStr = @"保密";
        }else {
            
            marriageStr = [NSString stringWithFormat:@"%@  %@  %@  %@",homeModel.LoveOther,homeModel.marrySex,homeModel.together,homeModel.hasChild];
        }
        cell.content.text = marriageStr;
        marriageHige =[self shightForContent:marriageStr fontSize:16.0f];
        CGRect temp = cell.content.frame;
        temp.size.height = marriageHige;
        cell.content.frame = temp;
        cell.downLine.frame = CGRectMake(0, 30+marriageHige-0.5, [[UIScreen mainScreen] bounds].size.width, 0.5);
        return cell;
        
    }else {
        
        HMakeFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:KCell_C forIndexPath:indexPath];
        [cell addDataWithtitle:@"择友标准"];
        if (self.conditonArray.count > 0) {
            NConditonModel *condit = self.conditonArray[indexPath.row];
            
            makeFriendStr = [NSString stringWithFormat:@"%@  %@  %@  %@  %@  %@  %@",condit.age,condit.heights,condit.marriage,condit.education,condit.wage,condit.proVince,condit.city];
            cell.content.text = makeFriendStr;
            makeFriend =[self sshightForContent:makeFriendStr fontSize:16.0f];
            CGRect temp = cell.content.frame;
            temp.size.height = makeFriend;
            cell.content.frame = temp;
            cell.downLine.frame = CGRectMake(0, 30+makeFriend-0.5, [[UIScreen mainScreen] bounds].size.width, 0.5);
        }else {
            makeFriendStr = @"保密";
            cell.content.text = makeFriendStr;
            makeFriend =[self sshightForContent:makeFriendStr fontSize:16.0f];
            CGRect temp = cell.content.frame;
            temp.size.height = makeFriend;
            cell.content.frame = temp;
            cell.downLine.frame = CGRectMake(0, 30+makeFriend-0.5, [[UIScreen mainScreen] bounds].size.width, 0.5);
        
        }
        
        
        return cell;
    }
    
}
- (void)pushToUploadAlbums{
    MyPhotoViewController *vc = [[MyPhotoViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)touchHeartTapAction:(UITapGestureRecognizer *)sender{
    [self createRoom:sender];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self uploadShakeInfo:_item];
    });
}
/**
 *  上传我触动谁LP-bus-msc/f_105_10_2.service？a77：被关注用户
 *  @param model
 */
- (void)uploadShakeInfo:(EyeLuckModel *)model{
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
- (void)createRoom:(UITapGestureRecognizer *)sender {
    [Mynotification addObserver:self selector:@selector(createRoomForTouchDetail:) name:@"createRoomForTouchDetail" object:nil];
    //    DHUserForChatModel *userinfo = [DBManager getUserWithCurrentUserId:self.item.fromUserAccount];
    [[SocketManager shareInstance] creatRoomWithString:[NSString stringWithFormat:@"%@",_item.b52] account:[NSString stringWithFormat:@"%@",_item.b80]];// 开房间
//    self.model = model;
}
- (void)createRoomForTouchDetail:(NSNotification *)notifi{
    NSDictionary *dict = notifi.object;
    NSString *roomCode = [[dict objectForKey:@"body"] objectForKey:@"roomCode"];
    NSString *roomName = [[dict objectForKey:@"body"] objectForKey:@"roomName"];
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"charRoomInfo"];
    
    // 加入我的关注,并发送消息
    NSString *targetId = [NSString stringWithFormat:@"%@",_item.b80];
    NSString *targetName = [NSString stringWithFormat:@"%@",_item.b52];
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
    item.targetId = [NSString stringWithFormat:@"%@",_item.b80];
    if (![DBManager checkMessageWithMessageId:messageId targetId:item.targetId]) {
        [DBManager insertMessageDataDBWithModel:item userId:userId];
    }
}
- (void)getChatTapAction:(UITapGestureRecognizer *)sender{
    
    // 加入我的关注,并发送消息
    NSString *targetId = [NSString stringWithFormat:@"%@",_item.b80];
    NSString *targetName = [NSString stringWithFormat:@"%@",_item.b52];
    //    NSString *header = [NSString stringWithFormat:@"%@",model.b57];
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    NSString *token = [NSGetTools getToken];
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *date = [format stringFromDate:[NSDate date]];
    NSDateFormatter *format1 = [[NSDateFormatter alloc]init];
    [format1 setDateFormat:@"yyyyMMddHHmmsssss"];
    NSString *messageId = [format1 stringFromDate:[NSDate date]];
    ChatController *chatVC = [ChatController new];
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
//    item.roomCode = @"";
    item.roomName = targetName;
    item.targetId = [NSString stringWithFormat:@"%@",_item.b80];
    chatVC.item = item;
    chatVC.userInfo = self.item;
    [self.navigationController pushViewController:chatVC animated:YES];
    
}

/**
 *  Description
 *
 *  @param kinDic  倒叙的字典便于取值
 *  @param keyStr  key字符串
 *  @param content 内容
 */
- (void)addWithKidDic:(NSDictionary *)kinDic keyStr:(NSString *)keyStr content:(UILabel *)content{
    
    NSString *oneStr = [self addWithVariable:kinDic   keyStr:keyStr];
    content.backgroundColor = kUIColorFromRGB(0xeeeeee);
    content.layer.borderWidth = 0.6f;
    content.text  = [NSString stringWithFormat:@"# %@",oneStr];
    [self addWithContent:content.text textLabel:content];
}

/**
 *  Description
 *
 *  @param textContent label内容
 *  @param textLabel   选取的属性
 */
- (void)addWithContent:(NSString *)textContent textLabel:(UILabel *)textLabel{
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:textContent];
    
    [AttributedStr addAttribute:NSFontAttributeName
     
                          value:[UIFont systemFontOfSize:14.0]
     
                          range:NSMakeRange(0, 1)];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:kUIColorFromRGB(0x25ADE5)
     
                          range:NSMakeRange(0, 1)];
    
    textLabel.attributedText = AttributedStr;
}

#pragma mark ---- 自适应高度
- (CGFloat)hightForContent:(NSString *)content fontSize:(CGFloat)fontSize{
    CGSize size = [content boundingRectWithSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width-125, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    return size.height;
}

- (CGFloat)shightForContent:(NSString *)content fontSize:(CGFloat)fontSize{
    CGSize size = [content boundingRectWithSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width-125, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    return size.height;
}
- (CGFloat)sshightForContent:(NSString *)content fontSize:(CGFloat)fontSize{
    CGSize size = [content boundingRectWithSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width-125, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    return size.height;
}
#pragma mark --- cell返回高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [ParaTableViewCell cellHeight];
    }else if (indexPath.section == 1) {
        return [N_photoViewCell photocellHeight];
    }else if (indexPath.section == 2) {
        return [HMakeFriendCell makeFriendcellHeight] + h + 30;  // 自适应高度cell
    }else if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            return 37;
        }
        return [HTBasicdataCell basicdatacellHeight];
    }else if (indexPath.section == 4) {
        return [HAssetsCell assetscellHeight];
    }else if (indexPath.section == 5) {
        return [HPersonalityCell personacellHeight];
    }else if (indexPath.section == 6) {
        return [HPersonalityCell personacellHeight];
    }else if (indexPath.section == 7){

        return [HMakeFriendCell makeFriendcellHeight] + marriageHige + 30;

    }else {
        
        return [HMakeFriendCell makeFriendcellHeight] + makeFriend + 30;
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 8) {
        return 50;
    }else {
        return 0;
    }
}

#pragma mark --- section header
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return gotHeight(12);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y<0) {
        ParaTableViewCell *cell = [paraTabelView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        [cell updateHeightWithRect:CGRectMake(0, scrollView.contentOffset.y+64, self.view.frame.size.width, 110 - scrollView.contentOffset.y)];
    }
}

#pragma mark --- 选中cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
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
