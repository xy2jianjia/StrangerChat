//
//  DetailViewController.m
//  StrangerChat
//
//  Created by zxs on 15/11/19.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "DetailViewController.h"
#import "DetailCell.h"
#import "MailboxController.h"
#import "DetailObject.h"
#import "BasicObject.h"
#import "DHBasicModel.h"
#define KCell_A @"kcell_1"
@interface DetailViewController ()<UITableViewDataSource,UITableViewDelegate,DetaiSelectorDelegate,UIPickerViewDataSource,UIPickerViewDelegate>{
    
    NSInteger indexCell;
    NSInteger indexPathRow;
    UITableView *tempTable;
    NSIndexPath *indexPathItem;
    NSNumber *sexNum;
    
    NSString *intentionStr; // 意向
    NSString *marriageStr;  // 婚姻
    NSString *houseStr;     // 房子
    NSString *CarStr;       // 车子
    NSString *charmStr;     // 魅力
    NSString *relationStr;  // 异地恋
    NSString *specifGirl;   // 类型
    NSString *specifBoy;
    NSString *sexUal;       // 性行为
    NSString *parentStr;    // 父母同住
    NSString *childStr;     // 孩子
    
    NSMutableDictionary *childDic;
    NSMutableDictionary *parentDic;
    NSMutableDictionary *sexUalDic;
    NSMutableDictionary *typeGrilDic;
    NSMutableDictionary *typeBoyDic;
    NSMutableDictionary *relationDic;
    NSMutableDictionary *charmDic;
    NSMutableDictionary *carDic;
    NSMutableDictionary *homeDic;
    NSMutableDictionary *marriageDic;
    NSMutableDictionary *intentionDic;
}

@property (nonatomic,strong)NSArray *detaiArray;
@property (nonatomic,strong)NSMutableArray *titlePick;
@property (nonatomic,strong)NSString *titleStr;

@property (nonatomic,strong)NSArray *intention;                 // 交友意向
@property (nonatomic,strong)NSMutableArray * intentionM;
@property (nonatomic,strong)NSMutableArray *marriageM;          // 婚姻
@property (nonatomic,strong)NSArray *marriageAray;
@property (nonatomic,strong)NSMutableArray *homeM;              // 房子
@property (nonatomic,strong)NSArray *homeAray;
@property (nonatomic,strong)NSMutableArray *carM;               // 车
@property (nonatomic,strong)NSArray *carAray;
@property (nonatomic,strong)NSMutableArray *charmM;             // 魅力
@property (nonatomic,strong)NSArray *charmAray;
@property (nonatomic,strong)NSMutableArray *relationshipM;      // 异地恋
@property (nonatomic,strong)NSArray *relationshipAray;
#warning  值存入数据库 不然退出回来就没有值了
@property (nonatomic,strong)NSMutableArray *typeMboy;           // 类型(男)
@property (nonatomic,strong)NSArray *typeArayboy;
@property (nonatomic,strong)NSMutableArray *typeMgril;          // 类型(女)
@property (nonatomic,strong)NSArray *typeAraygril;
@property (nonatomic,strong)NSMutableArray *sexualM;            // 性行为
@property (nonatomic,strong)NSArray *sexualAray;
@property (nonatomic,strong)NSMutableArray *parentM;            // 父母同住
@property (nonatomic,strong)NSArray *parentAray;
@property (nonatomic,strong)NSMutableArray *childM;             // 小孩
@property (nonatomic,strong)NSArray *childAray;
@property (nonatomic,strong)NSMutableArray *pickerArray;        // 所有选择的结果
@end

@implementation DetailViewController




- (NSArray *)detaiArray {

    return @[@"邮箱",@"注册意向",@"婚姻状况",@"是否有房",@"是否有车",@"魅力部位",@"是否接受异地恋",@"喜欢的异性类型",@"婚前性行为",@"和父母同住",@"是否要小孩"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.pickerArray = [NSMutableArray arrayWithObjects:@"未填写",@"未填写",@"未填写",@"未填写",@"未填写",@"未填写",@"未填写",@"未填写",@"未填写",@"未填写",@"未填写", nil];
    self.titlePick = [NSMutableArray array];
    [self.titlePick addObject:self.detaiArray];
    
    sexNum = [NSGetTools getUserSexInfo];   // 1男 2女
    [self layoutTempTable];
    [self n_datePicks];
    [self n_getmarriage];
    [self n_gethome];
    [self n_getcat];
    [self n_getcharm];
    [self n_getrelationship];
    [self n_gettype];
    [self n_getmarrySex];
    [self n_getparent];
    [self n_getchild];
    [self n_getpurpose];
}

- (void)n_acquisition {

    [self replaceContentWithstring:[DetailObject getMailbox]      number:0];
    [self replaceContentWithstring:[DetailObject getIntention]    number:1];
    [self replaceContentWithstring:[DetailObject getMarriage]     number:2];
    [self replaceContentWithstring:[DetailObject getHouse]        number:3];
    [self replaceContentWithstring:[DetailObject getCar]          number:4];
    [self replaceContentWithstring:[DetailObject getcharm]        number:5];
    [self replaceContentWithstring:[DetailObject getRelationship] number:6];
    [self replaceContentWithstring:[DetailObject getSpecific]     number:7];
    [self replaceContentWithstring:[DetailObject getSexual]       number:8];
    [self replaceContentWithstring:[DetailObject getParent]       number:9];
    [self replaceContentWithstring:[DetailObject getChild]        number:10];
}

/**
 *  Description
 *
 *  @param data   获取选择器的内容
 *  @param number 替换数组中的第几个
 */
- (void)replaceContentWithstring:(NSString *)data number:(int)number {
    
    if (data.length > 0) {
        self.pickerArray[number] = data;
    }else {
        self.pickerArray[number] = @"未填写";
    }
}

#pragma mark --- 小孩
- (void)n_getchild {
    
    NSMutableArray *sort = [NSMutableArray array];
    self.childM   = [NSMutableArray array];
    NSDictionary *dic  = [NSGetSystemTools gethasChild];
    childDic = [NSMutableDictionary dictionary];
    for (NSString *s in dic) {
        
        NSString *value = [dic objectForKey:s];  // 倒放字典方便上传
        [childDic setValue:s forKey:value];
        
        int intString = [s intValue];  // 排序
        BasicObject *basic = [[BasicObject alloc] initWithCodeNum:intString];
        [sort addObject:basic];
    }
    [sort sortUsingSelector:@selector(compareUsingcodeblood:)];
    for (BasicObject *b in sort) {
        NSString *numStr = [NSString stringWithFormat:@"%@",b];
        NSString *valuestr = [dic objectForKey:numStr];
        [self.childM addObject:valuestr];
    }
    self.childAray = [NSArray arrayWithArray:self.childM];
}
#pragma mark --- 父母同住
- (void)n_getparent {
    
    NSMutableArray *sort = [NSMutableArray array];
    self.parentM    = [NSMutableArray array];
    NSDictionary *dic  = [NSGetSystemTools getliveTogether];
    parentDic = [NSMutableDictionary dictionary];
    for (NSString *s in dic) {
        
        NSString *value = [dic objectForKey:s];  // 倒放字典方便上传
        [parentDic setValue:s forKey:value];
        
        int intString = [s intValue];  // 排序
        BasicObject *basic = [[BasicObject alloc] initWithCodeNum:intString];
        [sort addObject:basic];
    }
    [sort sortUsingSelector:@selector(compareUsingcodeblood:)];
    for (BasicObject *b in sort) {
        NSString *numStr = [NSString stringWithFormat:@"%@",b];
        NSString *valuestr = [dic objectForKey:numStr];
        [self.parentM addObject:valuestr];
    }
    self.parentAray = [NSArray arrayWithArray:self.parentM];
}
#pragma mark --- 婚前性行为
- (void)n_getmarrySex {
    
    NSMutableArray *sort = [NSMutableArray array];
    self.sexualM    = [NSMutableArray array];
    NSDictionary *dic  = [NSGetSystemTools getmarrySex];
    sexUalDic = [NSMutableDictionary dictionary];
    for (NSString *s in dic) {
        
        NSString *value = [dic objectForKey:s];  // 倒放字典方便上传
        [sexUalDic setValue:s forKey:value];
        
        int intString = [s intValue];  // 排序
        BasicObject *basic = [[BasicObject alloc] initWithCodeNum:intString];
        [sort addObject:basic];
    }
    [sort sortUsingSelector:@selector(compareUsingcodeblood:)];
    for (BasicObject *b in sort) {
        NSString *numStr = [NSString stringWithFormat:@"%@",b];
        NSString *valuestr = [dic objectForKey:numStr];
        [self.sexualM addObject:valuestr];
    }
    self.sexualAray = [NSArray arrayWithArray:self.sexualM];
    
}
#pragma mark --- 喜欢的类型
- (void)n_gettype {
    
    
   if ([sexNum isEqualToNumber:[NSNumber numberWithInt:1]]) {  // 1为男 2为女
       
       NSMutableArray *sort = [NSMutableArray array];
       self.typeMboy    = [NSMutableArray array];
       NSDictionary *dic  = [NSGetSystemTools getloveType1];
       typeBoyDic = [NSMutableDictionary dictionary];
       for (NSString *s in dic) {
           
           NSString *value = [dic objectForKey:s];  // 倒放字典方便上传
           [typeBoyDic setValue:s forKey:value];
           
           int intString = [s intValue];  // 排序
           BasicObject *basic = [[BasicObject alloc] initWithCodeNum:intString];
           [sort addObject:basic];
       }
       [sort sortUsingSelector:@selector(compareUsingcodeblood:)];
       for (BasicObject *b in sort) {
           NSString *numStr = [NSString stringWithFormat:@"%@",b];
           NSString *valuestr = [dic objectForKey:numStr];
           [self.typeMboy addObject:valuestr];
       }
       self.typeArayboy = [NSArray arrayWithArray:self.typeMboy];
       
       
    }else {
        
        NSMutableArray *sort = [NSMutableArray array];
        self.typeMgril    = [NSMutableArray array];
        self.typeAraygril = [NSArray array];  // 最终的结果
        NSDictionary *dic  = [NSGetSystemTools getloveType2];
        typeGrilDic = [NSMutableDictionary dictionary];
        for (NSString *s in dic) {
            
            NSString *value = [dic objectForKey:s];  // 倒放字典方便上传
            [typeGrilDic setValue:s forKey:value];
            
            int intString = [s intValue];  // 排序
            BasicObject *basic = [[BasicObject alloc] initWithCodeNum:intString];
            [sort addObject:basic];
        }
        [sort sortUsingSelector:@selector(compareUsingcodeblood:)];
        for (BasicObject *b in sort) {
            NSString *numStr = [NSString stringWithFormat:@"%@",b];
            NSString *valuestr = [dic objectForKey:numStr];
            [self.typeMgril addObject:valuestr];
        }
        self.typeAraygril = [NSArray arrayWithArray:self.typeMgril];
    }
}
#pragma mark --- 异地恋
- (void)n_getrelationship {
    
    NSMutableArray *sort = [NSMutableArray array];
    self.relationshipM    = [NSMutableArray array];
    NSDictionary *dic  = [NSGetSystemTools gethasLoveOther];
    relationDic = [NSMutableDictionary dictionary];
    for (NSString *s in dic) {
        
        NSString *value = [dic objectForKey:s];  // 倒放字典方便上传
        [relationDic setValue:s forKey:value];
        
        int intString = [s intValue];  // 排序
        BasicObject *basic = [[BasicObject alloc] initWithCodeNum:intString];
        [sort addObject:basic];
    }
    [sort sortUsingSelector:@selector(compareUsingcodeblood:)];
    for (BasicObject *b in sort) {
        NSString *numStr = [NSString stringWithFormat:@"%@",b];
        NSString *valuestr = [dic objectForKey:numStr];
        [self.relationshipM addObject:valuestr];
    }
    self.relationshipAray = [NSArray arrayWithArray:self.relationshipM];
    
}
#pragma mark --- 魅力
- (void)n_getcharm {
    
    NSMutableArray *sort = [NSMutableArray array];
    self.charmM    = [NSMutableArray array];
    NSDictionary *dic  = [NSGetSystemTools getcharmPart];
    charmDic = [NSMutableDictionary dictionary];
    for (NSString *s in dic) {
        
        NSString *value = [dic objectForKey:s];  // 倒放字典方便上传
        [charmDic setValue:s forKey:value];
        
        int intString = [s intValue];  // 排序
        BasicObject *basic = [[BasicObject alloc] initWithCodeNum:intString];
        [sort addObject:basic];
    }
    [sort sortUsingSelector:@selector(compareUsingcodeblood:)];
    for (BasicObject *b in sort) {
        NSString *numStr = [NSString stringWithFormat:@"%@",b];
        NSString *valuestr = [dic objectForKey:numStr];
        [self.charmM addObject:valuestr];
    }
    self.charmAray = [NSArray arrayWithArray:self.charmM];
}
#pragma mark --- 车
- (void)n_getcat {
    
    NSMutableArray *sort = [NSMutableArray array];
    self.carM    = [NSMutableArray array];
    NSDictionary *dic  = [NSGetSystemTools gethasCar];
    carDic = [NSMutableDictionary dictionary];
    for (NSString *s in dic) {
        
        NSString *value = [dic objectForKey:s];  // 倒放字典方便上传
        [carDic setValue:s forKey:value];
        
        int intString = [s intValue];  // 排序
        BasicObject *basic = [[BasicObject alloc] initWithCodeNum:intString];
        [sort addObject:basic];
    }
    [sort sortUsingSelector:@selector(compareUsingcodeNum:)];
    for (BasicObject *b in sort) {
        NSString *numStr = [NSString stringWithFormat:@"%@",b];
        NSString *valuestr = [dic objectForKey:numStr];
        [self.carM addObject:valuestr];
    }
    self.carAray = [NSArray arrayWithArray:self.carM];
}
#pragma mark --- 房子
- (void)n_gethome {
    
    NSMutableArray *sort = [NSMutableArray array];
    self.homeM    = [NSMutableArray array];
    NSDictionary *dic  = [NSGetSystemTools gethasRoom];
    homeDic = [NSMutableDictionary dictionary];
    for (NSString *s in dic) {
        
        NSString *value = [dic objectForKey:s];  // 倒放字典方便上传
        [homeDic setValue:s forKey:value];
        
        int intString = [s intValue];  // 排序
        BasicObject *basic = [[BasicObject alloc] initWithCodeNum:intString];
        [sort addObject:basic];
    }
    [sort sortUsingSelector:@selector(compareUsingcodeNum:)];
    for (BasicObject *b in sort) {
        NSString *numStr = [NSString stringWithFormat:@"%@",b];
        NSString *valuestr = [dic objectForKey:numStr];
        [self.homeM addObject:valuestr];
    }
    self.homeAray = [NSArray arrayWithArray:self.homeM];
    
}
#pragma mark --- 婚姻
- (void)n_getmarriage {
    
    NSMutableArray *sort = [NSMutableArray array];
    self.marriageM    = [NSMutableArray array];
    NSDictionary *dic  = [NSGetSystemTools getmarriageStatus];
    marriageDic = [NSMutableDictionary dictionary];
    for (NSString *s in dic) {
        
        NSString *value = [dic objectForKey:s];  // 倒放字典方便上传
        [marriageDic setValue:s forKey:value];
        
        int intString = [s intValue];  // 排序
        BasicObject *basic = [[BasicObject alloc] initWithCodeNum:intString];
        [sort addObject:basic];
    }
    [sort sortUsingSelector:@selector(compareUsingcodeNum:)];
    for (BasicObject *b in sort) {
        NSString *numStr = [NSString stringWithFormat:@"%@",b];
        NSString *valuestr = [dic objectForKey:numStr];
        [self.marriageM addObject:valuestr];
    }
    self.marriageAray = [NSArray arrayWithArray:self.marriageM];
}

#pragma mark --- 交友意向
- (void)n_getpurpose {

    NSMutableArray *sort = [NSMutableArray array];
    self.intentionM    = [NSMutableArray array];
    NSDictionary *dic  = [NSGetSystemTools getpurpose];
    intentionDic = [NSMutableDictionary dictionary];
    for (NSString *s in dic) {
        
        NSString *value = [dic objectForKey:s];  // 倒放字典方便上传
        [intentionDic setValue:s forKey:value];
        
        int intString = [s intValue];  // 排序
        BasicObject *basic = [[BasicObject alloc] initWithCodeNum:intString];
        [sort addObject:basic];
    }
    [sort sortUsingSelector:@selector(compareUsingcodeblood:)];
    for (BasicObject *b in sort) {
        NSString *numStr = [NSString stringWithFormat:@"%@",b];
        NSString *valuestr = [dic objectForKey:numStr];
        [self.intentionM addObject:valuestr];
    }
    self.intention = [NSArray arrayWithArray:self.intentionM];
}

#pragma mark --- pick and 代理
- (void)n_datePicks {

    self.detaPick = [[DetaiPicker alloc] initWithFrame:CGRectZero];
    self.detaPick.backgroundColor = [UIColor whiteColor];
    self.detaPick.detaisDatagate        = self;
    self.detaPick.pickerView.delegate   = self;
    self.detaPick.pickerView.dataSource = self;
    [self.view addSubview:self.detaPick];
}
#pragma mark --- 代理方法
- (void)pickerDonBtnHaveClick:(DetaiPicker *)select resultString:(NSString *)resultString {


    switch (indexCell) { //  意向
        case 1: {
            if (intentionStr == nil) {
                [self pickerView:self.detaPick.pickerView didSelectRow:indexPathRow inComponent:0];
            }

            [DetailObject updateIntentionWithStr:intentionStr];
        }
            break;
        case 2: {  // 婚姻状况
            if (marriageStr == nil) {
                [self pickerView:self.detaPick.pickerView didSelectRow:indexPathRow inComponent:0];
            }

            [DetailObject updateMarriageWithStr:marriageStr];
        }
            break;
        case 3: {  // 是否有房
            if (houseStr == nil) {
                [self pickerView:self.detaPick.pickerView didSelectRow:indexPathRow inComponent:0];
            }

            [DetailObject updateHouseWithStr:houseStr];
        }
            break;
        case 4: {  // 是否有车
            if (CarStr == nil) {
                [self pickerView:self.detaPick.pickerView didSelectRow:indexPathRow inComponent:0];
            }

            [DetailObject updateCarWithStr:CarStr];
        }
            break;
        case 5: {  // 魅力部位
            if (charmStr == nil) {
                [self pickerView:self.detaPick.pickerView didSelectRow:indexPathRow inComponent:0];
            }

            [DetailObject updatecharmWithStr:charmStr];
        }
            break;
        case 6: { //  是否接受异地
            if (relationStr == nil) {
                [self pickerView:self.detaPick.pickerView didSelectRow:indexPathRow inComponent:0];
            }

            [DetailObject updateRelationshipmWithStr:relationStr];
        }
            break;
        case 7: { // 喜欢的异性类型
            
            
            if ([sexNum isEqualToNumber:[NSNumber numberWithInt:1]]) {
                if (specifBoy == nil) {
                    [self pickerView:self.detaPick.pickerView didSelectRow:indexPathRow inComponent:0];
                }
                
                [DetailObject updateSpecificWithStr:specifBoy];
            }else {
                if (specifGirl == nil) {
                    [self pickerView:self.detaPick.pickerView didSelectRow:indexPathRow inComponent:0];
                }
                
                [DetailObject updateSpecificWithStr:specifGirl];
            }
            
        }
            break;
        case 8: { // 婚前性行为
            if (sexUal == nil) {
                [self pickerView:self.detaPick.pickerView didSelectRow:indexPathRow inComponent:0];
            }

            [DetailObject updateSexualWithStr:sexUal];
        }
            break;
        case 9: { // 和父母同住
            if (parentStr == nil) {
                [self pickerView:self.detaPick.pickerView didSelectRow:indexPathRow inComponent:0];
            }

            [DetailObject updateParentWithStr:parentStr];
        }
            break;
        default: { // 是否要孩子
            if (childStr == nil) {
                [self pickerView:self.detaPick.pickerView didSelectRow:indexPathRow inComponent:0];
            }

            [DetailObject updateChildWithStr:childStr];
        }
            break;
    }
    [self n_acquisition];
    [tempTable reloadData];
    [self n_uploadWithString:@"未填写"];
}

#pragma mark --- 上传服务器保存用户修改的资料
- (void)n_uploadWithString:(NSString *)contentStr {
    
    NSString *p1 = [NSGetTools getUserSessionId];//sessionId
    NSNumber *p2 = [NSGetTools getUserID];//ID
    NSString *appInfo = [NSGetTools getAppInfoString];// 公共参数
    NSMutableDictionary *dicts = [NSMutableDictionary dictionary];
#pragma mark --- 注册邮箱
    [NSURLObject addDataWithUploadStr:self.pickerArray[0] originalStr:contentStr variableDic:dicts aNum:@"a146"];
#pragma mark --- 注册意向
    [NSURLObject addWithNString:self.pickerArray[1] secStr:contentStr flashDic:intentionDic variableDic:dicts aNum:@"a145"];
#pragma mark --- 婚姻状况
    [NSURLObject addWithNString:self.pickerArray[2] secStr:contentStr flashDic:marriageDic  variableDic:dicts aNum:@"a46"];
#pragma mark --- 是否有房
    [NSURLObject addWithNString:self.pickerArray[3] secStr:contentStr flashDic:homeDic      variableDic:dicts aNum:@"a32"];
#pragma mark --- 是否有车
    [NSURLObject addWithNString:self.pickerArray[4] secStr:contentStr flashDic:carDic       variableDic:dicts aNum:@"a29"];
#pragma mark --- 魅力部位
    [NSURLObject addWithNString:self.pickerArray[5] secStr:contentStr flashDic:charmDic     variableDic:dicts aNum:@"a8"];
#pragma mark --- 是否接受异地恋
    [NSURLObject addWithNString:self.pickerArray[6] secStr:contentStr flashDic:relationDic  variableDic:dicts aNum:@"a31"];
#pragma mark --- 婚前性行为
    [NSURLObject addWithNString:self.pickerArray[8] secStr:contentStr flashDic:sexUalDic    variableDic:dicts aNum:@"a47"];
#pragma mark --- 和父母同住
    [NSURLObject addWithNString:self.pickerArray[9] secStr:contentStr flashDic:parentDic    variableDic:dicts aNum:@"a39"];
#pragma mark --- 是否要孩子
    [NSURLObject addWithNString:self.pickerArray[10] secStr:contentStr flashDic:childDic    variableDic:dicts aNum:@"a30"];
#pragma mark --- 喜欢的异性类型
    [NSURLObject addSexWithUploadStr:self.pickerArray[7] originalStr:contentStr sexNum:sexNum flashDic:typeBoyDic variableDic:dicts aNum:@"a45"];
    
    [NSURLObject addWithVariableDic:dicts];
    [NSURLObject addWithdict:dicts urlStr:[NSString stringWithFormat:@"%@f_108_11_2.service?p1=%@&p2=%@&%@",kServerAddressTest2,p1,p2,appInfo]];  // 上传服务器
    
    
}

#pragma mark --- tempTable
- (void)layoutTempTable {
    
    tempTable = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    tempTable.separatorStyle = UITableViewCellEditingStyleNone;
    tempTable.delegate = self;
    tempTable.dataSource = self;
    [tempTable registerClass:[DetailCell class] forCellReuseIdentifier:KCell_A];
    [self.view addSubview:tempTable];
    [self n_acquisition];
}


#pragma mark - UITabelView dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.detaiArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailCell *cell = [tableView dequeueReusableCellWithIdentifier:KCell_A forIndexPath:indexPath];
    [cell addTxt:self.detaiArray[indexPath.row]];
    
    DHBasicModel *item = nil;
    if (self.dataArr.count > 0) {
        item = [self.dataArr objectAtIndex:0];
    }
    if (indexPath.row == 0) {
        cell.details.text = [item.email length] == 0?@"未填写":item.email;
    }else if (indexPath.row == 1){
        cell.details.text = [item.purpose length] == 0?@"未填写":item.purpose;
    }else if (indexPath.row == 2){
        cell.details.text = [item.marriage length] == 0?@"未填写":item.marriage;
    }else if (indexPath.row == 3){
        cell.details.text = [item.blood length] == 0?@"未填写":[NSString stringWithFormat:@"%@ ", item.hasRoom];
    }else if (indexPath.row == 4){
        cell.details.text = [item.hasCar length] == 0?@"未填写": [NSString stringWithFormat:@"%@",item.hasCar];
    }else if (indexPath.row == 5){
        cell.details.text = [item.charmPart length] == 0?@"未填写":[NSString stringWithFormat:@"%@", item.charmPart];
    }else if (indexPath.row == 6){
        cell.details.text = [item.LoveOther length] == 0?@"未填写":item.LoveOther;
    }else if (indexPath.row == 7){
        cell.details.text = [item.loveType length] == 0?@"未填写":item.loveType;
    }else if (indexPath.row == 8){
        cell.details.text = [NSString stringWithFormat:@"%@",[item.marrySex length] == 0?@"未填写":item.marrySex];
    }else if (indexPath.row == 9){
        cell.details.text = [NSString stringWithFormat:@"%@",[item.together length] == 0?@"未填写":item.together];
    }else if (indexPath.row == 10){
        cell.details.text = [NSString stringWithFormat:@"%@",[item.hasChild length] == 0?@"未填写":item.hasChild];
    }
    
    if (indexPath.row == 0) {
        cell.upLine.frame   = CGRectMake( 0,  0, [[UIScreen mainScreen] bounds].size.width   , 0.5);
        cell.downLine.frame = CGRectMake(25, 49, [[UIScreen mainScreen] bounds].size.width-30, 0.5);
    }else if (indexPath.row == 10) {
        cell.downLine.frame = CGRectMake( 0, 49, [[UIScreen mainScreen] bounds].size.width   , 0.5);
    }else {
        cell.upLine.frame   = CGRectMake(25, 49, [[UIScreen mainScreen] bounds].size.width-30, 0.5);
    }
    
    return cell;
}

#pragma mark -------delegata Height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        return [DetailCell detaiCellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
        return gotHeight(15);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
        return 175;
}

#pragma mark -----选中cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.detaPick.pickerView reloadAllComponents];
    indexPathItem = indexPath;
    indexCell = indexPath.item;
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    [self.detaPick.nextBtn setTitle:self.detaiArray[indexPath.row]];
    if (indexPath.row == 6) {
        self.detaPick.fixedTanhuang.width = ([[UIScreen mainScreen] bounds].size.width - 195)/2;
    }
    if (indexPath.section == 0) {
        
        switch (indexPath.row) { // 选择器
            case 0:
            {
                MailboxController *mail = [[MailboxController alloc] init];
                mail.mb = ^(NSString *s){
                    
                   NSString *mailbox = s;  // 上传邮箱
                    if (mailbox == nil && mailbox == NULL) {
                        
                    }else {
                        [DetailObject updateMailboxWithStr:mailbox]; // 存储
                        [self n_uploadWithString:@"未填写"];
                    }
                   
                   [tempTable reloadData];
                   [self n_acquisition];
                   
                };
                [self.navigationController pushViewController:mail animated:true];
            }
               break;
            case 1: {
                [self show];
                [self.detaPick.pickerView reloadAllComponents];
            }
                break;
            case 2: {
                [self show];
                [self.detaPick.pickerView reloadAllComponents];
            }
                break;
            case 3: {
                [self show];
                [self.detaPick.pickerView reloadAllComponents];
            }
                break;
            case 4: {
                [self show];
                [self.detaPick.pickerView reloadAllComponents];
            }
                break;
            case 5: {
                [self show];
                [self.detaPick.pickerView reloadAllComponents];
            }
                break;
            case 6: {
                [self show];
                [self.detaPick.pickerView reloadAllComponents];
            }
                break;
            case 7: {
                [self show];
                [self.detaPick.pickerView reloadAllComponents];
            }
                break;
            case 8: {
                [self show];
                [self.detaPick.pickerView reloadAllComponents];
            }
                break;
            case 9: {
                [self show];
                [self.detaPick.pickerView reloadAllComponents];
            }
                break;
            default: {
                [self show];
                [self.detaPick.pickerView reloadAllComponents];
            }
                break;
        }
    }
}

/**
 *  show  显示picker
 */
- (void)show {
    
    self.detaPick.frame = CGRectMake(0,ZHHeight - ZHAllViewHeight-175, ZHWidth, ZHAllViewHeight);
}

#pragma mark ---- pickerDatagate
// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    
    switch (indexCell) {
        case 1: {
            return self.intention.count;
        }
            break;
        case 2: {
            return self.marriageAray.count;
        }
            break;
        case 3: {
            return self.homeAray.count;
        }
            break;
        case 4: {
            return self.carAray.count;
        }
            break;
        case 5: {
            return self.charmAray.count;
        }
            break;
        case 6: {
            return self.relationshipAray.count;
        }
            break;
        case 7: {
            if ([sexNum isEqualToNumber:[NSNumber numberWithInt:1]]) {
                return self.typeArayboy.count;
            }else {
                return self.typeAraygril.count;
            }
        }
            break;
        case 8: {
            return self.sexualAray.count;
        }
            break;
        case 9: {
            return self.parentAray.count;
        }
            break;
        
        default: {
            return self.childAray.count;
        }
            break;
    }
}

// 选中传值
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    indexPathRow = row;
    switch (indexCell) {
        case 1: {
             intentionStr = self.intention[row];
        }
            break;
        case 2: {
            marriageStr = self.marriageAray[row];
        }
            break;
        case 3: {
            houseStr = self.homeAray[row];
        }
            break;
        case 4: {
            CarStr = self.carAray[row];
        }
            break;
        case 5: {
            charmStr = self.charmAray[row];
        }
            break;
        case 6: {
            relationStr = self.relationshipAray[row];
        }
            break;
        case 7: {
            if ([sexNum isEqualToNumber:[NSNumber numberWithInt:1]]) {
                specifBoy = self.typeArayboy[row];
            }else {
                specifGirl = self.typeAraygril[row];
            }
        }
            break;
        case 8: {
            sexUal = self.sexualAray[row];
        }
            break;
        case 9: {
            parentStr = self.parentAray[row];
        }
            break;
         default: {
            childStr = self.childAray[row];
        }
            break;
    }
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (indexCell) {
        case 1: {
            return [self.intention objectAtIndex:row];
        }
            break;
        case 2: {
            return [self.marriageAray objectAtIndex:row];
        }
            break;
        case 3: {
            return [self.homeAray objectAtIndex:row];
        }
            break;
        case 4: {
            return [self.carAray objectAtIndex:row];
        }
            break;
        case 5: {
            return [self.charmAray objectAtIndex:row];
        }
            break;
        case 6: {
           return [self.relationshipAray objectAtIndex:row];
        }
            break;
        case 7: {
            if ([sexNum isEqualToNumber:[NSNumber numberWithInt:1]]) {
                return [self.typeArayboy objectAtIndex:row];
            }else {
                return [self.typeAraygril objectAtIndex:row];
            }
        }
            break;
        case 8: {
            return [self.sexualAray objectAtIndex:row];
        }
            break;
        case 9: {
            return [self.parentAray objectAtIndex:row];
        }
            break;
        default: {
            return [self.childAray objectAtIndex:row];
        }
            break;
    }
    
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
