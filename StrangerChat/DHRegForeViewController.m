//
//  DHRegForeViewController.m
//  StrangerChat
//
//  Created by xy2 on 15/12/22.
//  Copyright © 2015年 long. All rights reserved.
//

#import "DHRegForeViewController.h"
#import "HobbyCell.h"
#import "HeaderReusableView.h"
#import "FootReusableView.h"
#import "DHRegFiveViewController.h"

#define SizeNum [[UIScreen mainScreen] bounds].size.width/20
#define WIDTH [[UIScreen mainScreen] bounds].size.width
@interface DHRegForeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UIView *topbgView;
@property (weak, nonatomic) IBOutlet UIView *headerBgView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageV;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIView *topStepLineView;

@property (strong ,nonatomic) UICollectionView *collectionV;
@end

@implementation DHRegForeViewController
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
    [self setcollection];
}
/**
 *   下一步
 */
- (void)nextStep{
    DHRegFiveViewController *vc = [[DHRegFiveViewController alloc]init];
    vc.gender = _gender;
    vc.selectAge = _selectAge;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)setcollection {
    
#pragma mark -- layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];  // item大小
    layout.itemSize = CGSizeMake((WIDTH-SizeNum*2)/4.5, 40);  // w  h
    layout.minimumLineSpacing = 10;  //  上下间距
    layout.minimumInteritemSpacing = 10;  // 左右
    layout.scrollDirection = UICollectionViewScrollDirectionVertical; // 设置滚动方向
    layout.sectionInset = UIEdgeInsetsMake(20, SizeNum, 20, SizeNum);
    _collectionV = [[UICollectionView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.view.bounds), CGRectGetMaxY(_topbgView.frame)+0, CGRectGetWidth([[UIScreen mainScreen] bounds]), CGRectGetHeight(self.view.bounds)-CGRectGetHeight(_topbgView.frame)-100) collectionViewLayout:layout];
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
    NSArray *dict = [NSGetSystemTools geteducationLevelArray];
    return dict.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HobbyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kcellIdentifier forIndexPath:indexPath];
    cell.collectionLabel.layer.borderColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]CGColor];
    NSArray *dict = [NSGetSystemTools geteducationLevelArray];
    cell.collectionLabel.text = [dict[indexPath.row] objectForKey:@"b21"];
    cell.collectionLabel.font = [UIFont systemFontOfSize:12];
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
            headerV.nameLabel.text = @"学历";
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
    
    DHRegFiveViewController *vc = [[DHRegFiveViewController alloc]init];
    vc.gender = _gender;
    vc.selectAge = _selectAge;
    [self.navigationController pushViewController:vc animated:YES];
    NSArray *dict = [NSGetSystemTools geteducationLevelArray];
    // 保存注册学历
    [[NSUserDefaults standardUserDefaults] setObject:dict[indexPath.item] forKey:@"regEducation"];
    
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
