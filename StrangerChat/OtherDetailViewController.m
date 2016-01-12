//
//  OtherDetailViewController.m
//  StrangerChat
//
//  Created by long on 15/11/4.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "OtherDetailViewController.h"
#import "OTPageScrollView.h"
#import "OTPageView.h"
#import "ChatController.h"
@interface OtherDetailViewController () <UITableViewDataSource,UITableViewDelegate,OTPageScrollViewDataSource,OTPageScrollViewDelegate>
{
    NSDictionary *starDict;// 星座
    NSDictionary *bloodDict;// 血型
    NSDictionary *schoolDict;// 学历
    NSDictionary *workDict;// 职业
    NSDictionary *marrayDict;// 婚姻
    NSDictionary *homeDict;// 是否有房
    NSDictionary *carDict;// 是否有车
    NSDictionary *charmPartDict;// 魅力部位
    NSDictionary *hasLoveOtherDict;// 异地恋
    NSDictionary *loveTypeDict;// 喜欢异性类型
    NSDictionary *marrySexDict;// 婚前性行为
    NSDictionary *liveTogetherDict;// 和父母同住
    NSDictionary *hasChildDict;// 是否小孩
    NSDictionary *favoriteDict;// 兴趣爱好
    NSDictionary *kidneyDict;// 个性特征
    
    OTPageView *PScrollView;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIImageView *headImageView;

// 数据数组
@property (nonatomic,strong) NSDictionary *b112Dict;// 资料
@property (nonatomic,strong) NSArray *b113Array;// 相册
@property (nonatomic,strong) NSDictionary *b114Dict;// 择友条件

@end

@implementation OtherDetailViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"昵称";
    
 //   self.automaticallyAdjustsScrollViewInsets = NO;// 自动滚动调整，默认为YES
//    self.edgesForExtendedLayout = UIRectEdgeNone;// iOS7及以后的版本支持，self.view.frame.origin.y会下移64像素至navigationBar下方。
    // 星座
    starDict = [NSGetSystemTools getstar];
    // 血型
    bloodDict = [NSGetSystemTools getblood];
    // 学历
    schoolDict = [NSGetSystemTools geteducationLevel];
    // 职业
    workDict = [NSGetSystemTools getprofession];
    // 婚姻
    marrayDict = [NSGetSystemTools getmarriageStatus];
    // 房子
    homeDict = [NSGetSystemTools gethasRoom];
    // 车子
    carDict = [NSGetSystemTools gethasCar];
    // 魅力部位
    charmPartDict = [NSGetSystemTools getcharmPart];
    // 异地恋
    hasLoveOtherDict = [NSGetSystemTools gethasLoveOther];
    // 婚前性行为
    marrySexDict = [NSGetSystemTools getmarrySex];
    // 父母同住
    liveTogetherDict = [NSGetSystemTools getliveTogether];
    // 是否小孩
    hasChildDict = [NSGetSystemTools gethasChild];

    NSNumber *sexNum = [NSGetTools getUserSexInfo];
    if ([sexNum intValue] == 1) { //男
        // 喜欢的异性
        loveTypeDict = [NSGetSystemTools getloveType1];
        // 兴趣爱好
        favoriteDict = [NSGetSystemTools getfavorite1];
        // 个性特征
        kidneyDict = [NSGetSystemTools getkidney1];
    }else{
        // 喜欢的异性
        loveTypeDict = [NSGetSystemTools getloveType2];
        // 兴趣爱好
        favoriteDict = [NSGetSystemTools getfavorite2];
        // 个性特征
        kidneyDict = [NSGetSystemTools getkidney2];
    }
    
    [self addAllViews];
    [self getOtherDetailDataInfoWithP2:self.p2];
    
    

}

- (void)addAllViews
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-gotHeight(50))];
    self.tableView.backgroundColor = HexRGB(0Xeeeeee);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView=[[UIView alloc]init];
    
    // 打招呼
    UIButton *messageBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, ScreenHeight-gotHeight(50), got(155), gotHeight(50))];
    [messageBtn setImage:[UIImage imageNamed:@"btn-chat-n.png"] forState:UIControlStateNormal];
    [messageBtn addTarget:self action:@selector(messageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:messageBtn];
    
    // 关注
    UIButton *careBtn = [[UIButton alloc] initWithFrame:CGRectMake(got(165), ScreenHeight-gotHeight(50), got(155), gotHeight(50))];
    [careBtn setImage:[UIImage imageNamed:@"btn-care-off-h.png"] forState:UIControlStateNormal];
    [careBtn setImage:[UIImage imageNamed:@"btn-care-p.png"] forState:UIControlStateSelected];
    [careBtn addTarget:self action:@selector(careBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:careBtn];
    

}

- (void)addLabel2WithSuperView:(UIView *)view text:(id)text
{
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-got(200), gotHeight(10), got(190), gotHeight(30))];
    label2.text = [NSString stringWithFormat:@"%@",text];
    label2.textAlignment = NSTextAlignmentRight;
    //label2.backgroundColor = [UIColor grayColor];
    label2.textColor = [UIColor blackColor];
    [view addSubview:label2];
}


// 打招呼
- (void)messageBtnAction:(UIButton *)sender
{
//    Message *item=self.chatData[indexPath.row];
//    ChatController *chatVC = [ChatController new];
//    NSString *IDNum = [NSString stringWithFormat:@"%@",self.p2];
//    chatVC.item = IDNum;
//    [[SocketManager shareInstance] creatRoomWithString:nil account:IDNum];// 开房间
//    [self.navigationController pushViewController:chatVC animated:YES];
    
}

// 关注
- (void)careBtnAction:(UIButton *)sender
{
    NSLog(@"关注");
    sender.selected = YES;
}

// 用户详细信息
- (void)getOtherDetailDataInfoWithP2:(NSNumber *)p2
{
    NSString *p1 = [NSGetTools getUserSessionId];//sessionId
    NSString *appInfo = [NSGetTools getAppInfoString];// 公共参数
    
    NSString *url = [NSString stringWithFormat:@"%@f_108_13_1.service?p1=%@&p2=%@&%@",kServerAddressTest2,p1,p2,appInfo];
    
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSLog(@"用户资料URL--%@",url);
    [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        //NSLog(@"用户资料---%@--",infoDic);
        if ([infoDic[@"code"] integerValue] == 200) {
            NSDictionary *bodyDic = infoDic[@"body"];
            NSDictionary *dict112 = bodyDic[@"b112"];
            NSArray *array113 = bodyDic[@"b113"];
            NSDictionary *dict114 = bodyDic[@"b114"];
            self.b112Dict = [NSDictionary dictionaryWithDictionary:dict112];
            self.b113Array = [NSArray arrayWithArray:array113];
            self.b114Dict = [NSDictionary dictionaryWithDictionary:dict114];
            
        }
        
        NSLog(@"---112=%@---113=%@---114=%@",_b112Dict,_b113Array,_b114Dict);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 头区
            [self addHeaderViews];
            [self.tableView reloadData];
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"用户资料请求失败--%@-",error);
    }];
}


// 头区
- (void)addHeaderViews
{
    NSLog(@"b112--%@",_b112Dict);
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, gotHeight(150))];
    view2.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, got(65), got(65))];
    _headImageView.center = CGPointMake(ScreenWidth/2, gotHeight(40));
    _headImageView.layer.cornerRadius = got(65/2);
    _headImageView.clipsToBounds = YES;
    
    NSString *iconUrlStr = self.b112Dict[@"b57"];
    NSURL *iconUrl = [NSURL URLWithString:iconUrlStr];
    [_headImageView sd_setImageWithURL:iconUrl placeholderImage:[UIImage imageNamed:@"icon-boy.png"]];
    //_headImageView.image = [UIImage imageNamed:@"icon-boy.png"];
    [view2 addSubview:_headImageView];
   
    // 名字 身高  居住地
    NSNumber *ageNum = self.b112Dict[@"b1"];// 年龄
    NSNumber *bodyNum = self.b112Dict[@"b33"];// 身高
    NSNumber *cityCode = self.b112Dict[@"b9"];// 市编码
    NSNumber *provinceCode = self.b112Dict[@"b67"];// 省编码
    //获取plist中的数据
    NSDictionary *cityDict = [NSDictionary dictionary];
    NSDictionary *stateDict = [NSDictionary dictionary];
    cityDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"codeCity" ofType:@"plist"]];
    stateDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"codeProvince" ofType:@"plist"]];
    
    NSString *cityCodeStr = [NSString stringWithFormat:@"%@",cityCode];
    NSString *provinceCodeStr = [NSString stringWithFormat:@"%@",provinceCode];
    
    NSDictionary *cityNameDict = cityDict[cityCodeStr];
    NSDictionary *stateNameDict = stateDict[provinceCodeStr];
    
    
    NSString *cityName = cityNameDict[@"city_name"];// 城市
    cityName = [cityName substringToIndex:cityName.length - 1];
    NSString *provinceName = stateNameDict[@"province_name"];// 省
    provinceName = [provinceName substringToIndex:provinceName.length - 1];
    if (cityName.length == 0 || cityName == NULL) {
        cityName = @"";
    }
    if (provinceName.length == 0 || provinceName == NULL) {
        provinceName = @"";
    }
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, gotHeight(80), got(320), gotHeight(20))];
    nameLabel.text = [NSString stringWithFormat:@"%@岁 | %@cm | %@ %@",ageNum,bodyNum,provinceName,cityName];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.textColor = [UIColor blackColor];
    [view2 addSubview:nameLabel];
    // 最近登录时间
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, gotHeight(110), got(320), gotHeight(20))];
    NSString *timeStr = self.b112Dict[@"b44"];
    timeLabel.text = [NSString stringWithFormat:@"最近登录:%@",timeStr];
    timeLabel.font = [UIFont systemFontOfSize:got(14)];
    timeLabel.textColor = [UIColor grayColor];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    [view2 addSubview:timeLabel];
    
    self.tableView.tableHeaderView = view2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 2) {
        return 16;
    }else if (section == 3){
        return 5;
    }else{
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//    }
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        PScrollView = [[OTPageView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, gotHeight(100))];
        PScrollView.pageScrollView.dataSource = self;
        PScrollView.pageScrollView.delegate = self;
        PScrollView.pageScrollView.padding =5;
        PScrollView.pageScrollView.leftRightOffset = 1;
        PScrollView.pageScrollView.frame = CGRectMake(0, 0, got(320), gotHeight(100));
        PScrollView.backgroundColor = [UIColor whiteColor];
        
        [PScrollView.pageScrollView reloadData];
        
        [cell.contentView addSubview:PScrollView];
    }
    
    if (indexPath.section == 1) {
        
        NSString *moodStr = self.b112Dict[@"b17"];// 独白
        CGFloat height = [NSGetTools calsLabelHeightWithText:moodStr];
        UILabel *moodLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, got(315), height)];
        moodLabel.numberOfLines = 0;
        moodLabel.contentMode = UIViewContentModeTop;
        moodLabel.text = [NSString stringWithFormat:@"  %@",moodStr];
        moodLabel.textColor = [UIColor blackColor];
        [cell.contentView addSubview:moodLabel];
    }
    
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"星座";
            NSNumber *starNum = self.b112Dict[@"b74"];// 星座
            NSString *starNumStr = [NSString stringWithFormat:@"%@",starNum];
            NSString *starStr = starDict[starNumStr];
            if (starStr.length == 0 || starStr == NULL) {
                starStr = @"";
            }
            [self addLabel2WithSuperView:cell.contentView text:starStr];
        }else if (indexPath.row == 1){
            cell.textLabel.text = @"血型";
            NSNumber *bloodNum = self.b112Dict[@"b5"];// 血型
            NSString *bloodNumStr = [NSString stringWithFormat:@"%@",bloodNum];
            NSString *bloodStr = bloodDict[bloodNumStr];
            if (bloodStr.length == 0 || bloodStr == NULL) {
                bloodStr = @"";
            }
            [self addLabel2WithSuperView:cell.contentView text:bloodStr];
        }else if (indexPath.row == 2){
            cell.textLabel.text = @"学历";
            NSNumber *schoolNum = self.b112Dict[@"b19"];// 学历
            NSString *schoolNumStr = [NSString stringWithFormat:@"%@",schoolNum];
            NSString *schoolStr = schoolDict[schoolNumStr];
            if (schoolStr.length == 0 || schoolStr == NULL) {
                schoolStr = @"";
            }
            [self addLabel2WithSuperView:cell.contentView text:schoolStr];
        }else if (indexPath.row == 3){
            cell.textLabel.text = @"职业";
            NSNumber *workNum = self.b112Dict[@"b62"];// 职业
            NSString *workNumStr = [NSString stringWithFormat:@"%@",workNum];
            NSString *workStr = workDict[workNumStr];
            if (workStr.length == 0 || workStr == NULL) {
                workStr = @"";
            }
            [self addLabel2WithSuperView:cell.contentView text:workStr];
        }else if (indexPath.row == 4){
            cell.textLabel.text = @"月收入";
            NSNumber *largeMoneyNum = self.b112Dict[@"b86"];// 最高收入
            NSNumber *smallMoneyNum = self.b112Dict[@"b87"];// 最低收入
            NSString *moneyStr = [NSString stringWithFormat:@"%@-%@",smallMoneyNum,largeMoneyNum];
            if (largeMoneyNum == NULL || smallMoneyNum == NULL) {
                moneyStr = @"";
            }

            [self addLabel2WithSuperView:cell.contentView text:moneyStr];
        }else if (indexPath.row == 5){
            cell.textLabel.text = @"婚姻状况";
            NSNumber *marrayNum = self.b112Dict[@"b46"];// 婚姻
            NSString *marrayNumStr = [NSString stringWithFormat:@"%@",marrayNum];
            NSString *marrayStr = marrayDict[marrayNumStr];
            if (marrayStr.length == 0 || marrayStr == NULL) {
                marrayStr = @"";
            }
            [self addLabel2WithSuperView:cell.contentView text:marrayStr];
        }else if (indexPath.row == 6){
            cell.textLabel.text = @"是否有房";
            NSNumber *homeNum = self.b112Dict[@"b32"];// 房子
            NSString *homeNumStr = [NSString stringWithFormat:@"%@",homeNum];
            NSString *homeStr = homeDict[homeNumStr];
            if (homeStr.length == 0 || homeStr == NULL) {
                homeStr = @"";
            }
            [self addLabel2WithSuperView:cell.contentView text:homeStr];
            
        }else if (indexPath.row == 7){
            cell.textLabel.text = @"是否有车";
            NSNumber *carNum = self.b112Dict[@"b29"];// 车子
            NSString *carNumStr = [NSString stringWithFormat:@"%@",carNum];
            NSString *carStr = carDict[carNumStr];
            if (carStr.length == 0 || carStr == NULL) {
                carStr = @"";
            }
            [self addLabel2WithSuperView:cell.contentView text:carStr];
        }else if (indexPath.row == 8){
            cell.textLabel.text = @"魅力部位";
            NSNumber *bodySexNum = self.b112Dict[@"b8"];// 魅力部位
             NSString *bodyNumStr = [NSString stringWithFormat:@"%@",bodySexNum];
            NSString *bodyStr = charmPartDict[bodyNumStr];
            if (bodyStr.length == 0 || bodyStr == NULL) {
                bodyStr = @"";
            }
            [self addLabel2WithSuperView:cell.contentView text:bodyStr];
        }else if (indexPath.row == 9){
            cell.textLabel.text = @"是否接受异地恋";
            NSNumber *otherPlaceNum = self.b112Dict[@"b31"];// 异地恋
            NSString *otherPlaceStr = [NSString stringWithFormat:@"%@",otherPlaceNum];
            NSString *placeStr = hasLoveOtherDict[otherPlaceStr];
            if (placeStr.length == 0 || placeStr == NULL) {
                placeStr = @"";
            }
            [self addLabel2WithSuperView:cell.contentView text:placeStr];
        }else if (indexPath.row == 10){
            cell.textLabel.text = @"喜欢的异性类型";
            NSString *oppositeSex = self.b112Dict[@"b74"];// 异性类型
            NSString *oppositeSexStr = [NSString stringWithFormat:@"%@",oppositeSex];
            NSString *oppositeStr = loveTypeDict[oppositeSexStr];
            if (oppositeStr.length == 0 || oppositeStr == NULL) {
                oppositeStr = @"";
            }
            [self addLabel2WithSuperView:cell.contentView text:oppositeStr];
        }else if (indexPath.row == 11){
            cell.textLabel.text = @"婚前性行为";
            NSNumber *makeSexNum = self.b112Dict[@"b47"];// 婚前性行为
            NSString *makeSexNumStr = [NSString stringWithFormat:@"%@",makeSexNum];
            NSString *makeSexStr = marrySexDict[makeSexNumStr];
            if (makeSexStr.length == 0 || makeSexStr == NULL) {
                makeSexStr = @"";
            }
            [self addLabel2WithSuperView:cell.contentView text:makeSexStr];
        }else if (indexPath.row == 12){
            cell.textLabel.text = @"和父母同住";
            NSNumber *parentNum = self.b112Dict[@"b39"];// 父母同住
            NSString *parentNumStr = [NSString stringWithFormat:@"%@",parentNum];
            NSString *parentStr = liveTogetherDict[parentNumStr];
            if (parentStr.length == 0 || parentStr == NULL) {
                parentStr = @"";
            }
            [self addLabel2WithSuperView:cell.contentView text:parentStr];
        }else if (indexPath.row == 13){
            cell.textLabel.text = @"是否要小孩";
            NSNumber *babyNum = self.b112Dict[@"b30"];// 小孩
            NSString *babyNumStr = [NSString stringWithFormat:@"%@",babyNum];
            NSString *babyStr = hasChildDict[babyNumStr];
            if (babyStr.length == 0 || babyStr == NULL) {
                babyStr = @"";
            }
            [self addLabel2WithSuperView:cell.contentView text:babyStr];
            
        }else if (indexPath.row == 14){
            cell.textLabel.text = @"兴趣爱好";
            NSNumber *favoriteNum = self.b112Dict[@"b24"];// 兴趣
            NSString *favoriteNumStr = [NSString stringWithFormat:@"%@",favoriteNum];
            NSString *favoriteStr = favoriteDict[favoriteNumStr];
            if (favoriteStr.length == 0 || favoriteStr == NULL) {
                favoriteStr = @"";
            }
            [self addLabel2WithSuperView:cell.contentView text:favoriteStr];
        }else{
            cell.textLabel.text = @"个性特征";
            NSNumber *kidneyNum = self.b112Dict[@"b37"];// 个性
            NSString *kidneyNumStr = [NSString stringWithFormat:@"%@",kidneyNum];
            NSString *kidneyStr = kidneyDict[kidneyNumStr];
            if (kidneyStr.length == 0 || kidneyStr == NULL) {
                kidneyStr = @"";
            }
            [self addLabel2WithSuperView:cell.contentView text:kidneyStr];
        }
        
    }
    
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"年龄";
            NSString *ageText = self.b114Dict[@"b1"];
            if (ageText.length == 0 || ageText == NULL) {
                ageText = @"";
            }
            [self addLabel2WithSuperView:cell.contentView text:ageText];
        }else if (indexPath.row == 1){
            cell.textLabel.text = @"身高";
            NSString *bodyHText = self.b114Dict[@"b33"];
            if (bodyHText.length == 0 || bodyHText == NULL) {
                bodyHText = @"";
            }
            [self addLabel2WithSuperView:cell.contentView text:bodyHText];
        }else if (indexPath.row == 2){
            cell.textLabel.text = @"收入";
            NSString *moneyText = self.b114Dict[@"b85"];
            if (moneyText.length == 0 || moneyText == NULL) {
                moneyText = @"";
            }
            [self addLabel2WithSuperView:cell.contentView text:moneyText];
        }else if (indexPath.row == 3){
            cell.textLabel.text = @"最低学历";
            NSNumber *schoolNum = self.b114Dict[@"b19"];// 学历
            NSString *schoolNumStr = [NSString stringWithFormat:@"%@",schoolNum];
            NSString *schoolStr = schoolDict[schoolNumStr];
            if (schoolStr.length == 0 || schoolStr == NULL) {
                schoolStr = @"";
            }
            [self addLabel2WithSuperView:cell.contentView text:schoolStr];
        }else{
            cell.textLabel.text = @"居住地";
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return gotHeight(100);
    }else if (indexPath.section == 1){
        NSString *moodStr = self.b112Dict[@"b17"];// 独白
        if (moodStr.length == 0) {
            return gotHeight(80);
        }else{
        CGFloat height = [NSGetTools calsLabelHeightWithText:moodStr];
            NSLog(@"文字高度---%f",height);
            return height;
        }
            
    }else{
        return gotHeight(50);
    }
    
    
}
//
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        UILabel *titLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, got(320), gotHeight(30))];
        titLabel.text = @"  内心独白 1/1";
        titLabel.font = [UIFont systemFontOfSize:got(14)];
        return titLabel;
    }else if (section == 2){
        UILabel *titLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, got(320), gotHeight(30))];
        titLabel.text = @"  详细资料 9/16";
        titLabel.font = [UIFont systemFontOfSize:got(14)];
        return titLabel;
    }else if (section == 3){
        UILabel *titLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,got(320), gotHeight(30))];
        titLabel.text = @"  择友条件";
        titLabel.font = [UIFont systemFontOfSize:got(14)];
        return titLabel;
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }else{
        
        return gotHeight(30);
    }
}

#pragma OTPage-------------------横向滚动代理-----------------

- (NSInteger)numberOfPageInPageScrollView:(OTPageScrollView*)pageScrollView{
    
    if (_b113Array.count != 0) {
        return [_b113Array count];
    }else{
        return 0;
    }
    
}

- (UIView*)pageScrollView:(OTPageScrollView*)pageScrollView viewForRowAtIndex:(int)index{
    UIView *cell = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 80, 80)];
    //cell.backgroundColor = [UIColor redColor];
    
    UIImageView *photoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    if (_b113Array.count != 0) {
        NSDictionary *modelDict = _b113Array[index];
        NSURL *imageUrl = [NSURL URLWithString:modelDict[@"b58"]];
        [photoView sd_setImageWithURL:imageUrl];
        [cell addSubview:photoView];
    }
    
    return cell;
}

- (CGSize)sizeCellForPageScrollView:(OTPageScrollView*)pageScrollView
{
    return CGSizeMake(80, 80);
}

- (void)pageScrollView:(OTPageScrollView *)pageScrollView didTapPageAtIndex:(NSInteger)index{
    NSLog(@"点击了 %ld",index);
}

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
//    NSLog(@"滑动到 %ld",index);
//}


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
