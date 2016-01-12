//
//  HobbyViewController.m
//  StrangerChat
//
//  Created by zxs on 15/11/19.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "HobbyViewController.h"
#import "HobbyCell.h"
#import "HeaderReusableView.h"
#import "FootReusableView.h"
#import "DHBasicModel.h"
@interface HobbyViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout> {
    
    NSInteger integer;
    NSInteger secIntger;
    UICollectionView *collectionViews;
    NSIndexPath *cellIndexPaht;
    
    NSMutableDictionary *flashLity;   // 倒序放的个性特征
    NSMutableDictionary *flashInter;  // 倒序放的兴趣爱好
    
}
@property (nonatomic,strong)NSMutableArray *personalitym;  // 个性 (总数 删除后只剩后面几个（需要更新）)
@property (nonatomic,strong)NSArray *personalityArray;
@property (nonatomic,strong)NSMutableArray *beforeNine;    // 前12个个性

@property (nonatomic,strong)NSMutableArray *interestm;     // 兴趣 (总数 删除后只剩后面几个（需要更新）)
@property (nonatomic,strong)NSArray *interestArray;
@property (nonatomic,strong)NSMutableArray *beforeinter;   // 前12个兴趣



@property (nonatomic,strong)NSMutableArray *keyArray;
@property (nonatomic,strong)NSMutableArray *valueArray;
@property (nonatomic,strong)NSMutableArray *keyBreak;     // 刷新后的数据
@property (nonatomic,strong)NSMutableArray *valueBreak;
@property (nonatomic,strong)NSMutableArray *keyErgodic;
@property (nonatomic,strong)NSMutableArray *valueErgodic;


@property (nonatomic,strong)NSMutableArray *secKeyArray;
@property (nonatomic,strong)NSMutableArray *secValueArray;
@property (nonatomic,strong)NSMutableArray *secKeyBreak;     // 刷新后的数据
@property (nonatomic,strong)NSMutableArray *secValueBreak;

@end

@implementation HobbyViewController

static NSString *kcellIdentifier   = @"collectionCellID";
static NSString *kheaderIdentifier = @"headerIdentifier";
static NSString *kfooterIdentifier = @"footerIdentifier";

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    for (UIView *view in collectionViews.subviews) {
        [view removeFromSuperview];
    }
//    [ makeObjectsPerformSelector:@selector(removeFromSuperview)];
}
- (void)viewDidLoad {
     [super viewDidLoad];
    
     [self setcollectio];
     [self n_personality];
     [self n_interst];
    
    
     self.keyArray      = [NSMutableArray array];
     self.valueArray    = [NSMutableArray array];
     self.keyBreak      = [NSMutableArray array];
     self.valueBreak    = [NSMutableArray array];
     self.keyErgodic    = [NSMutableArray array];
     self.valueErgodic  = [NSMutableArray array];
    
     self.secKeyArray   = [NSMutableArray array];
     self.secValueArray = [NSMutableArray array];
     self.secKeyBreak   = [NSMutableArray array];
     self.secValueBreak = [NSMutableArray array];
}

#pragma mark --- 个性特征
- (void)n_personality {
    
    flashLity = [NSMutableDictionary dictionary];
    self.personalitym = [NSMutableArray array];
    self.beforeNine   = [NSMutableArray array];
    NSNumber *sexNum = [NSGetTools getUserSexInfo];
    if ([sexNum isEqualToNumber:[NSNumber numberWithInt:1]]) {  // 男
        
        NSDictionary *dic = [NSGetSystemTools getkidney1];
        for (NSString *s in dic) {
            
            NSString *value = [dic objectForKey:s];
            [self.personalitym addObject:value];
            [flashLity setObject:s forKey:value];
        }
        self.personalityArray = [NSArray arrayWithArray:self.personalitym];
        for (int i = 0; i <= 11; i++) { // 前12个
            NSString *str = [self.personalityArray objectAtIndex:i];
            [self.beforeNine addObject:str];
        }
        [self.personalitym removeObjectsInArray:self.beforeNine];  // 后面的
        
    }else {  // 女
        
        NSDictionary *dic = [NSGetSystemTools getkidney2];
        for (NSString *s in dic) {
            
            NSString *value = [dic objectForKey:s];
            [self.personalitym addObject:value];
            [flashLity setObject:s forKey:value];
        }
        self.personalityArray = [NSArray arrayWithArray:self.personalitym];
        for (int i = 0; i <= 11; i++) { // 前12个
            NSString *str = [self.personalityArray objectAtIndex:i];
            [self.beforeNine addObject:str];
        }
       [self.personalitym removeObjectsInArray:self.beforeNine];  // 后面的
        
    }
}

#pragma mark --- 兴趣爱好
- (void)n_interst {
    
    flashInter         = [NSMutableDictionary dictionary];
    self.interestm     = [NSMutableArray array];
    self.beforeinter   = [NSMutableArray array];
    NSNumber *sexNum = [NSGetTools getUserSexInfo];
    if ([sexNum isEqualToNumber:[NSNumber numberWithInt:1]]) {  // 男
        
        NSDictionary *dic  = [NSGetSystemTools getfavorite1];
        for (NSString *s in dic) {
            
            NSString *value = [dic objectForKey:s];
            [self.interestm addObject:value];
            [flashInter setObject:s forKey:value];
        }
        self.interestArray = [NSArray arrayWithArray:self.interestm];
        for (int i = 0; i <= 11; i++) { // 前12个
            
            NSString *str = [self.interestArray objectAtIndex:i];
            [self.beforeinter addObject:str];
        }
        [self.interestm removeObjectsInArray:self.beforeinter];  // 删除前面12个元素
        
    }else { // 女
        
        NSDictionary *dic  = [NSGetSystemTools getfavorite2];
        for (NSString *s in dic) {
            
            NSString *value = [dic objectForKey:s];
            [self.interestm addObject:value];
            [flashInter setObject:s forKey:value];
            
        }
        self.interestArray = [NSArray arrayWithArray:self.interestm];
        for (int i = 0; i <= 11; i++) { // 前12个
            
            NSString *str = [self.interestArray objectAtIndex:i];
            [self.beforeinter addObject:str];
        }
        [self.interestm removeObjectsInArray:self.beforeinter];  // 删除前面12个元素
    }
}
#pragma mark -- collectionViews
- (void)setcollectio {
    
#pragma mark -- layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];  // item大小
    layout.itemSize = CGSizeMake((WIDTH-SizeNum*2)/4.5, 40);  // w  h
    layout.minimumLineSpacing = 10;  //  上下间距
    layout.minimumInteritemSpacing = 10;  // 左右
    layout.scrollDirection = UICollectionViewScrollDirectionVertical; // 设置滚动方向
    layout.sectionInset = UIEdgeInsetsMake(20, SizeNum, 20, SizeNum);
    
    collectionViews = [[UICollectionView alloc] initWithFrame:[[UIScreen mainScreen] bounds] collectionViewLayout:layout];
    collectionViews.backgroundColor = [UIColor whiteColor];
    // 数据源和代理
    collectionViews.dataSource = self;
    collectionViews.delegate   = self;
    [self.view addSubview:collectionViews];
    
#pragma mark -- 注册cell视图
    [collectionViews registerClass:[HobbyCell class] forCellWithReuseIdentifier:kcellIdentifier];
#pragma mark -- 注册头部视图
    [collectionViews registerClass:[HeaderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kheaderIdentifier];
#pragma mark -- 注册尾部视图
    [collectionViews registerClass:[FootReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
}

#pragma mark dataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        
        if (integer == 1) {
            return self.personalitym.count;
        }else {
            return self.beforeNine.count;
        }
        
    }else {
        
        if (secIntger == 1) {
            return self.interestm.count;
        }else {
            return self.beforeinter.count;
        }
        
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HobbyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kcellIdentifier forIndexPath:indexPath];
    NSMutableArray *codeArr = nil;
    DHBasicModel *item = nil;
    if (_dataArr.count > 0) {
       item = [self.dataArr objectAtIndex:0];
    }
    if (indexPath.section == 0) {
        if (integer == 1) {
            NSString *labelText = self.personalitym[indexPath.row];
            cell.collectionLabel.text = labelText;
            NSString *keycode = [flashLity objectForKey:self.personalitym[indexPath.row]];
            NSString *intreCode = item.kidney;
            if ([intreCode length] == 0) {
                
            }else{
                codeArr = [intreCode componentsSeparatedByString:@"-"].mutableCopy;
                if ([codeArr containsObject:@""]) {
                    [codeArr removeLastObject];
                }
            }
//            NSArray *codeArr = [intreCode componentsSeparatedByString:@"-"];
            if ([codeArr containsObject:keycode]) {
//                NSLog(@"1=2%@---%@",labelText,indexPath);
//                cell.collectionLabel.layer.borderColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]CGColor];
                cell.collectionLabel.layer.borderColor = [[UIColor colorWithRed:236/255.0 green:19/255.0 blue:68/255.0 alpha:1]CGColor];
                cell.collectionLabel.textColor = [UIColor colorWithRed:236/255.0 green:19/255.0 blue:68/255.0 alpha:1];
            }else{
                cell.collectionLabel.layer.borderColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]CGColor];
                cell.collectionLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
            }
        }else {
            NSString *labelText = self.beforeNine[indexPath.row];
            cell.collectionLabel.text = labelText;
            NSString *keycode = [flashLity objectForKey:self.beforeNine[indexPath.row]];
            NSString *intreCode = item.kidney;
            if ([intreCode length] == 0) {
                
            }else{
                codeArr = [intreCode componentsSeparatedByString:@"-"].mutableCopy;
                if ([codeArr containsObject:@""]) {
                    [codeArr removeLastObject];
                }
            }
            if ([codeArr containsObject:keycode]) {
//                NSLog(@"1=1%@---%@",labelText,indexPath);
//                cell.collectionLabel.layer.borderColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]CGColor];
                cell.collectionLabel.layer.borderColor = [[UIColor colorWithRed:236/255.0 green:19/255.0 blue:68/255.0 alpha:1]CGColor];
                cell.collectionLabel.textColor = [UIColor colorWithRed:236/255.0 green:19/255.0 blue:68/255.0 alpha:1];
            }else{
                cell.collectionLabel.layer.borderColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]CGColor];
                cell.collectionLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
            }
        }
        
    }else {
       if (secIntger == 1) {
           NSString *labelText = self.interestm[indexPath.row];
           
           cell.collectionLabel.text = labelText;
           NSString *keycode = [flashInter objectForKey:self.interestm[indexPath.row]];
           NSString *intreCode = item.favorite;
           if ([intreCode length] == 0) {
               
           }else{
               codeArr = [intreCode componentsSeparatedByString:@"-"].mutableCopy;
               if ([codeArr containsObject:@""]) {
                   [codeArr removeLastObject];
               }
           }
           if ([codeArr containsObject:keycode]) {
//               NSLog(@"2=2%@---%@",labelText,indexPath);
//               cell.collectionLabel.layer.borderColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]CGColor];
               cell.collectionLabel.layer.borderColor = [[UIColor colorWithRed:236/255.0 green:19/255.0 blue:68/255.0 alpha:1]CGColor];
               cell.collectionLabel.textColor = [UIColor colorWithRed:236/255.0 green:19/255.0 blue:68/255.0 alpha:1];
           }else{
               cell.collectionLabel.layer.borderColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]CGColor];
               cell.collectionLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
           }
       }else {
//           cell.collectionLabel.text = self.beforeinter[indexPath.row];
           NSString *labelText = self.beforeinter[indexPath.row];
           
           cell.collectionLabel.text = labelText;
           NSString *keycode = [flashInter objectForKey:self.beforeinter[indexPath.row]];
           NSString *intreCode = item.favorite;
           if ([intreCode length] == 0) {
               
           }else{
               codeArr = [intreCode componentsSeparatedByString:@"-"].mutableCopy;
               if ([codeArr containsObject:@""]) {
                   [codeArr removeLastObject];
               }
           }
           if ([codeArr containsObject:keycode]) {
//               NSLog(@"2=1%@---%@",labelText,indexPath);
//               cell.collectionLabel.layer.borderColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]CGColor];
               cell.collectionLabel.layer.borderColor = [[UIColor colorWithRed:236/255.0 green:19/255.0 blue:68/255.0 alpha:1]CGColor];
               cell.collectionLabel.textColor = [UIColor colorWithRed:236/255.0 green:19/255.0 blue:68/255.0 alpha:1];
           }else{
               cell.collectionLabel.layer.borderColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]CGColor];
               cell.collectionLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
           }
       }
    }
    return cell;
}


//设置头尾部内容
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
 #pragma mark -- 定制头部视图的内容
    if (kind == UICollectionElementKindSectionHeader) {
        HeaderReusableView *headerV = (HeaderReusableView *)[collectionViews dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kheaderIdentifier forIndexPath:indexPath];
        if (indexPath.section == 0 ) {
            headerV.nameLabel.text = @"个性特征";
            [headerV.footButton setHidden:true];
            [headerV.secFootButton setHidden:true];
            if (integer == 1) {
                [self setbutton:headerV.secUpdate secButton:headerV.update selector:@selector(secheaderupdateAction:)];
            }else {
                [self setbutton:headerV.update secButton:headerV.secUpdate selector:@selector(headerupdateAction:)];
            }
            
        }else {
            
            headerV.nameLabel.text = @"兴趣爱好";
            [headerV.update setHidden:true];
            [headerV.secUpdate setHidden:true];
            if (secIntger == 1) {
                [self setbutton:headerV.secFootButton secButton:headerV.footButton selector:@selector(secFootButtonAction:)];
            }else {
                [self setbutton:headerV.footButton secButton:headerV.secFootButton selector:@selector(footButtonAction:)];
            }
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


#pragma mark --- 第一分区
- (void)headerupdateAction:(UIButton *)sender {
    
    integer = 1;
//    [collectionViews.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self viewWillAppear:YES];
    [collectionViews reloadData];
   
}

- (void)secheaderupdateAction:(UIButton *)sender {
    integer = 2;
    [self viewWillAppear:YES];
    [collectionViews reloadData];
}

- (void)footButtonAction:(UIButton *)sender {
    secIntger = 1;
//    for (UIView *aview in collectionViews.subviews) {
//        [aview removeFromSuperview];
//    }
    [self viewWillAppear:YES];
    [collectionViews reloadData];
}

- (void)secFootButtonAction:(UIButton *)sender {
    secIntger = 2;
//    for (UIView *aview in collectionViews.subviews) {
//        [aview removeFromSuperview];
//    }
    [self viewWillAppear:YES];
    [collectionViews reloadData];
}



//返回头headerView的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{

        CGSize size = CGSizeMake([[UIScreen mainScreen] bounds].size.width, 60);
        return size;
    
}
//返回头footerView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        CGSize size = CGSizeMake([[UIScreen mainScreen] bounds].size.width, 0);
        return size;
    }else {
        CGSize size = CGSizeMake([[UIScreen mainScreen] bounds].size.width, 170);
        return size;
    }
    
}

#pragma mark --- 选中
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    cellIndexPaht = indexPath;
    HobbyCell *cell = (HobbyCell *)[collectionViews cellForItemAtIndexPath:indexPath];
    NSString *p1 = [NSGetTools getUserSessionId];//sessionId
    NSNumber *p2 = [NSGetTools getUserID];//ID
    NSString *appInfo = [NSGetTools getAppInfoString];// 公共参数
    if (indexPath.section == 0) {
        
        if (integer == 1) {
            
            NSMutableArray *temps = [NSMutableArray array]; // 存储用户选择的个性特征
            NSMutableDictionary *dics = [NSMutableDictionary dictionary];
            cell.collectionLabel.layer.borderColor = [UIColor redColor].CGColor;
            [self addWithCharacterStr:self.personalitym[indexPath.item] integerNum:indexPath.section secInteger:indexPath.item variableKey:self.keyBreak variableValue:self.valueBreak];
            
            for (NSString *uploadStr in self.valueBreak) {
                
                NSString *uploadValue = [flashLity objectForKey:uploadStr];
                [temps addObject:uploadValue];
            }
            if (temps.count == 1) {
                [dics setObject:temps[0] forKey:@"a37"];
            }else if (temps.count == 2){
                [dics setObject:[NSString stringWithFormat:@"%@-%@",temps[0],temps[1]]forKey:@"a37"];
            }else if (temps.count == 3){
                [dics setObject:[NSString stringWithFormat:@"%@-%@-%@",temps[0],temps[1],temps[2]]forKey:@"a37"];
            }
            [NSURLObject addWithVariableDic:dics];
            [NSURLObject addWithdict:dics urlStr:[NSString stringWithFormat:@"%@f_108_11_2.service?p1=%@&p2=%@&%@",kServerAddressTest2,p1,p2,appInfo]];  // 上传服务器
            
        }else {
            
            NSMutableArray *temps = [NSMutableArray array]; // 存储用户选择的个性特征
            NSMutableDictionary *dics = [NSMutableDictionary dictionary];
            cell.collectionLabel.layer.borderColor = [UIColor redColor].CGColor;
            [self addWithCharacterStr:self.beforeNine[indexPath.item] integerNum:indexPath.section secInteger:indexPath.item variableKey:self.keyArray variableValue:self.valueArray];
            
            for (NSString *uploadStr in self.valueArray) {
                
                NSString *uploadValue = [flashLity objectForKey:uploadStr];
                [temps addObject:uploadValue];
            }
            if (temps.count == 1) {
                [dics setObject:temps[0] forKey:@"a37"];
            }else if (temps.count == 2){
                [dics setObject:[NSString stringWithFormat:@"%@-%@",temps[0],temps[1]]forKey:@"a37"];
            }else if (temps.count == 3){
                [dics setObject:[NSString stringWithFormat:@"%@-%@-%@",temps[0],temps[1],temps[2]]forKey:@"a37"];
                
            }
            [NSURLObject addWithVariableDic:dics];
            [NSURLObject addWithdict:dics urlStr:[NSString stringWithFormat:@"%@f_108_11_2.service?p1=%@&p2=%@&%@",kServerAddressTest2,p1,p2,appInfo]];  // 上传服务器
         }
        
        
    }else {
    
        if (secIntger == 1) {
            
            NSMutableArray *temps = [NSMutableArray array]; // 存储用户选择的兴趣爱好
            NSMutableDictionary *dics = [NSMutableDictionary dictionary];
            cell.collectionLabel.layer.borderColor = [UIColor redColor].CGColor;
            [self addWithCharacterStr:self.interestm[indexPath.item] integerNum:indexPath.section secInteger:indexPath.item variableKey:self.secKeyBreak variableValue:self.secValueBreak];
            
            for (NSString *uploadStr in self.secValueBreak) {
                
                NSString *uploadValue = [flashInter objectForKey:uploadStr];
                [temps addObject:uploadValue];
            }
            if (temps.count == 1) {
                [dics setObject:temps[0] forKey:@"a24"];
            }else if (temps.count == 2){
                [dics setObject:[NSString stringWithFormat:@"%@-%@",temps[0],temps[1]]forKey:@"a24"];
            }else if (temps.count == 3){
                [dics setObject:[NSString stringWithFormat:@"%@-%@-%@",temps[0],temps[1],temps[2]]forKey:@"a24"];
            }
            [NSURLObject addWithVariableDic:dics];
            [NSURLObject addWithdict:dics urlStr:[NSString stringWithFormat:@"%@f_108_11_2.service?p1=%@&p2=%@&%@",kServerAddressTest2,p1,p2,appInfo]];  // 上传服务器
            
        }else {
            
            NSMutableArray *temps = [NSMutableArray array]; // 存储用户选择的兴趣爱好
            NSMutableDictionary *dics = [NSMutableDictionary dictionary];
            cell.collectionLabel.layer.borderColor = [UIColor redColor].CGColor;
            [self addWithCharacterStr:self.beforeinter[indexPath.item] integerNum:indexPath.section secInteger:indexPath.item variableKey:self.secKeyArray variableValue:self.secValueArray];
            for (NSString *uploadStr in self.secValueArray) {
                
                NSString *uploadValue = [flashInter objectForKey:uploadStr];
                [temps addObject:uploadValue];
            }
            if (temps.count == 1) {
                [dics setObject:temps[0] forKey:@"a24"];
            }else if (temps.count == 2){
                [dics setObject:[NSString stringWithFormat:@"%@-%@",temps[0],temps[1]]forKey:@"a24"];
            }else if (temps.count == 3){
                [dics setObject:[NSString stringWithFormat:@"%@-%@-%@",temps[0],temps[1],temps[2]]forKey:@"a24"];
                NSLog(@"%@-----%@-------%@",temps[0],temps[1],temps[2]);
            }
             NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"nickName"]);
            [NSURLObject addWithVariableDic:dics];
            [NSURLObject addWithdict:dics urlStr:[NSString stringWithFormat:@"%@f_108_11_2.service?p1=%@&p2=%@&%@",kServerAddressTest2,p1,p2,appInfo]];  // 上传服务器
        }
    }
}






/**
 *  Description
 *
 *  @param character     所有的内容
 *  @param integerNum    分区
 *  @param secInteger    选中的cellItem
 *  @param variable      根据key去删除响应的内容
 *  @param variableValue value
 */
- (void)addWithCharacterStr:(NSString *)character integerNum:(NSInteger)integerNum secInteger:(NSInteger)secInteger variableKey:(NSMutableArray *)variable variableValue:(NSMutableArray *)variableValue{

    NSString *str = character;
    NSString *str2 = [NSString stringWithFormat:@"%ld:%ld",(long)integerNum,(long)secInteger];
   
    if (![variable containsObject:str2]) {
        [variable  addObject:str2];
        [variableValue addObject:str];
    }
    [self addWithArray:variable value:variableValue];

}

/**
 *  Description
 *
 *  @param keyArray   存储key的数组
 *  @param valueArray 存储value的数组
 */
- (void)addWithArray:(NSMutableArray *)keyArray value:(NSMutableArray *)valueArray {

    if (keyArray.count == 4 || valueArray.count == 4) {
        
        NSString *keyStr = keyArray[0];
        NSArray *tempArr = [keyStr componentsSeparatedByString:@":"];
        HobbyCell *clearColorCell = (HobbyCell *)[collectionViews cellForItemAtIndexPath:[NSIndexPath indexPathForItem:[tempArr[1] integerValue] inSection:[tempArr[0] integerValue]]];
        clearColorCell.collectionLabel.layer.borderColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]CGColor];
        [keyArray   removeObjectAtIndex:0];
        [valueArray removeObjectAtIndex:0];
        
    }
}

/**
 *  Description
 *
 *  @param array        需要遍历的数组
 *  @param ergodicArray 遍历后取出重复元素的数组
 */
- (void)ergodicWithArray:(NSMutableArray *)array  ergodicArray:(NSMutableArray *)ergodicArray{

    [array enumerateObjectsUsingBlock:^(NSString *heroString, NSUInteger idx, BOOL *stop) {
        
        __block BOOL isContain = NO;
        
        [ergodicArray enumerateObjectsUsingBlock:^(NSString *desString, NSUInteger idx, BOOL *stop) {
            
            if (NSOrderedSame == [heroString compare:desString options:NSCaseInsensitiveSearch]) {
                
                isContain = YES;
                
            }}];
        
        if (NO == isContain) {
            
            [ergodicArray addObject:heroString];
            
        }}];

}



- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}



@end
