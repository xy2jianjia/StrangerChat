//
//  DHRegThirdViewController.m
//  StrangerChat
//
//  Created by xy2 on 15/12/22.
//  Copyright © 2015年 long. All rights reserved.
//

#import "DHRegThirdViewController.h"
#import "NSGetSystemTools.h"
#import "HobbyCell.h"
#import "HeaderReusableView.h"
#import "FootReusableView.h"
#import "DHRegForeViewController.h"
@interface DHRegThirdViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UIView *topbgView;
@property (weak, nonatomic) IBOutlet UIView *headerBgView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageV;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIView *topStepLineView;

@property (strong ,nonatomic) UICollectionView *collectionV;

@end

@implementation DHRegThirdViewController
static NSString *kcellIdentifier = @"collectionCellID";
static NSString *kheaderIdentifier = @"headerIdentifier";
static NSString *kfooterIdentifier = @"footerIdentifier";

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (iPhone4) {
        self.infoLabel.font = [UIFont systemFontOfSize:10];
    }else if (iPhonePlus){
        self.infoLabel.font = [UIFont systemFontOfSize:14];
    }
    self.topbgView.backgroundColor = [UIColor clearColor];
    UIImageView *topimageV = [[UIImageView alloc]init];
    topimageV.frame = CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), 200);
    topimageV.image = [UIImage imageNamed:@"regbackground.png"];
    [self.topbgView addSubview:topimageV];
    [self.topbgView sendSubviewToBack:topimageV];
    UIImageView *imageV = [[UIImageView alloc]init];
    imageV.frame = CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds])-66, 50);
    imageV.image = [UIImage imageNamed:@"head-background-writing.png"];
    self.headerBgView.backgroundColor = [UIColor clearColor];
    [self.headerBgView sendSubviewToBack:imageV];
    [self.headerBgView addSubview:imageV];
    self.headerImageV.layer.masksToBounds = YES;
    self.headerImageV.layer.cornerRadius = CGRectGetWidth(_headerImageV.frame)/2;
    self.infoLabel.backgroundColor = [UIColor clearColor];
    self.headerImageV.layer.masksToBounds = YES;
    self.headerImageV.layer.cornerRadius = CGRectGetWidth(_headerImageV.frame)/2;
    self.infoLabel.backgroundColor = [UIColor clearColor];
    _topStepLineView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"reg_line.png"]];
    // 男
    if (_gender == 1) {
        _headerImageV.image = [UIImage imageNamed:@"headerimage_f_1.png"];
    }else{
        _headerImageV.image = [UIImage imageNamed:@"headerimage_m_1.png"];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"跳过" style:UIBarButtonItemStylePlain target:self action:@selector(nextStep)];
    [self getData];
    
}
/**
 *   下一步
 */
- (void)nextStep{
    DHRegForeViewController *vc = [[DHRegForeViewController alloc]init];
    vc.gender = _gender;
    vc.selectAge = _selectAge;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)getData{
    NSDictionary *regUser = [[NSUserDefaults standardUserDefaults] objectForKey:@"regUser"];
    
    NSString *p1 = [regUser objectForKey:@"sessionId"];//sessionId
    NSString *p2 = [regUser objectForKey:@"userId"];
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
//                    NSMutableDictionary *professionDict = [NSMutableDictionary dictionary];
//                    for (NSDictionary *dict2 in b98Arr) {
//                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b22"]];
//                        [professionDict setValue:dict2[@"b21"] forKey:keyStr];
//                    }
                    NSArray *arr = [dict objectForKey:@"b98"];
                    // 保存
                    [NSGetSystemTools updateprofessionArray:arr];
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
//                    NSMutableDictionary *purposeDict = [NSMutableDictionary dictionary];
//                    for (NSDictionary *dict2 in b98Arr) {
//                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b22"]];
//                        [purposeDict setValue:dict2[@"b21"] forKey:keyStr];
//                    }
                    NSArray *arr = [dict objectForKey:@"b98"];
                    // 保存
                    [NSGetSystemTools updatepurposeWithArray:arr];
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
//                    NSLog(@"%@",hasCarDict);
                    // 保存
                    [NSGetSystemTools updatehasCarWithDict:hasCarDict];
                }else if ([dict[@"b20"] isEqualToString:@"educationLevel"]){
//                    NSMutableDictionary *educationLevelDict = [NSMutableDictionary dictionary];
//                    for (NSDictionary *dict2 in b98Arr) {
//                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b22"]];
//                        [educationLevelDict setValue:dict2[@"b21"] forKey:keyStr];
//                    }
                    NSArray *arr = [dict objectForKey:@"b98"];
                    // 保存
                    [NSGetSystemTools updateeducationLevelWithArray:arr];
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
//                    NSMutableDictionary *favorite1Dict = [NSMutableDictionary dictionary];
//                    for (NSDictionary *dict2 in b98Arr) {
//                        NSString *keyStr = [NSString stringWithFormat:@"%@",dict2[@"b22"]];
//                        [favorite1Dict setValue:dict2[@"b21"] forKey:keyStr];
//                    }
                    NSArray *arr = [dict objectForKey:@"b98"];
                    
                    // 保存
                    [NSGetSystemTools updatefavorite1WithArr:arr];
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
        [self setcollectio];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)setcollectio {
    
#pragma mark -- layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];  // item大小
    layout.itemSize = CGSizeMake((WIDTH-SizeNum*2)/4.5, 40);  // w  h
    layout.minimumLineSpacing = 10;  //  上下间距
    layout.minimumInteritemSpacing = 10;  // 左右
    layout.scrollDirection = UICollectionViewScrollDirectionVertical; // 设置滚动方向
    layout.sectionInset = UIEdgeInsetsMake(20, SizeNum, 20, SizeNum);
    _collectionV = [[UICollectionView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.view.bounds), CGRectGetMaxY(_topbgView.frame)+0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-CGRectGetHeight(_topbgView.frame)-100) collectionViewLayout:layout];
    _collectionV.backgroundColor = [UIColor whiteColor];
    // 数据源和代理
    _collectionV.dataSource = self;
    _collectionV.delegate   = self;
    [self.view addSubview:_collectionV];
    
#pragma mark -- 注册cell视图
    [_collectionV registerClass:[HobbyCell class] forCellWithReuseIdentifier:kcellIdentifier];
#pragma mark -- 注册头部视图
    [_collectionV registerClass:[HeaderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kheaderIdentifier];
#pragma mark -- 注册尾部视图
    [_collectionV registerClass:[FootReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
    
    
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    NSArray *dict = [NSGetSystemTools getfavorite1Array];
    NSArray *dict1 = [NSGetSystemTools getprofessionArray];
    
    return dict1.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    HobbyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kcellIdentifier forIndexPath:indexPath];
    cell.collectionLabel.layer.borderColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]CGColor];
//    NSArray *dict = [NSGetSystemTools getfavorite1Array];
    NSArray *dict = [NSGetSystemTools getprofessionArray];
    cell.collectionLabel.text = [dict[indexPath.row] objectForKey:@"b21"];
    if ([[dict[indexPath.row] objectForKey:@"b21"] length] > 7) {
        cell.collectionLabel.font = [UIFont systemFontOfSize:8];
    }else{
      cell.collectionLabel.font = [UIFont systemFontOfSize:12];
    }
    
    return cell;
}


//设置头尾部内容
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
#pragma mark -- 定制头部视图的内容
    if (kind == UICollectionElementKindSectionHeader) {
        HeaderReusableView *headerV = (HeaderReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kheaderIdentifier forIndexPath:indexPath];
        headerV.nameLabel.font = [UIFont systemFontOfSize:15];
        if (indexPath.section == 0 ) {
            headerV.nameLabel.text = @"职业";
            [headerV.footButton setHidden:true];
            [headerV.secFootButton setHidden:true];
            
        }else {
            headerV.nameLabel.text = @"兴趣爱好";
            [headerV.update setHidden:true];
            [headerV.secUpdate setHidden:true];
        }
        reusableView = headerV;
    }
    
#pragma mark -- 定制尾部视图的内容
    if (kind == UICollectionElementKindSectionFooter){
        FootReusableView *footerV = (FootReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        footerV.view.text = @"";
        reusableView = footerV;
    }
    return reusableView;
}

/**
 *  Description
 *
 *  @param button    显示button
 *  @param secbutton 隐藏button
 *  @param selector  点击事件
 */
- (void)setbutton:(UIButton *)button secButton:(UIButton *)secbutton selector:(SEL)selector {
    
    [button setHidden:false];
    [secbutton setHidden:true];
    [button setImage:[UIImage imageNamed:@"btn-refresh-n"] forState:(UIControlStateNormal)];
    [button addTarget:self action:selector forControlEvents:(UIControlEventTouchUpInside)];
}
//返回头headerView的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size = CGSizeMake([[UIScreen mainScreen] bounds].size.width, 60);
    return size;
    
}
//返回头footerView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    CGSize size = CGSizeMake([[UIScreen mainScreen] bounds].size.width, 0);
    return size;
}

#pragma mark --- 选中
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HobbyCell *cell = (HobbyCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    DHRegForeViewController *vc = [[DHRegForeViewController alloc]init];
    vc.gender = _gender;
    vc.selectAge = _selectAge;
    [self.navigationController pushViewController:vc animated:YES];
    NSArray *dict = [NSGetSystemTools getprofessionArray];
    // 保存注册职业
    [[NSUserDefaults standardUserDefaults] setObject:dict[indexPath.item] forKey:@"regProfession"];
    
}

- (void)addWithArray:(NSMutableArray *)keyArray value:(NSMutableArray *)valueArray {
    
    if (keyArray.count > 3 || valueArray.count > 3) {
        
        NSString *keyStr = keyArray[0];
        NSArray *tempArr = [keyStr componentsSeparatedByString:@":"];
        HobbyCell *clearColorCell = (HobbyCell *)[_collectionV cellForItemAtIndexPath:[NSIndexPath indexPathForItem:[tempArr[1] integerValue] inSection:[tempArr[0] integerValue]]];
        clearColorCell.collectionLabel.layer.borderColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]CGColor];
        [keyArray   removeObjectAtIndex:0];
        [valueArray removeObjectAtIndex:0];
        
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
