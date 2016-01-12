//
//  SearchSetTableViewCell.m
//  StrangerChat
//
//  Created by long on 15/11/17.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "SearchSetTableViewCell.h"

@implementation SearchSetTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addAllViews];
    }
    
    return self;
}

- (void)addAllViews
{
   
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"area" ofType:@"plist"];
    areaDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    NSArray *components = [areaDic allKeys];
    NSArray *sortedArray = [components sortedArrayUsingComparator: ^(id obj1, id obj2) {
        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    NSMutableArray *provinceTmp = [[NSMutableArray alloc] init];
    for (int i=0; i<[sortedArray count]; i++) {
        NSString *index = [sortedArray objectAtIndex:i];
        NSArray *tmp = [[areaDic objectForKey: index] allKeys];
        [provinceTmp addObject: [tmp objectAtIndex:0]];
    }
    
    province = [[NSArray alloc] initWithArray: provinceTmp];

    NSString *index = [sortedArray objectAtIndex:0];
    NSString *selected = [province objectAtIndex:0];
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [[areaDic objectForKey:index]objectForKey:selected]];
    
    NSArray *cityArray = [dic allKeys];
    NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [cityArray objectAtIndex:0]]];
    city = [[NSArray alloc] initWithArray: [cityDic allKeys]];
    
    
    
    label2 = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-got(230), gotHeight(5), got(190), gotHeight(30))];
    label2.text = @"不限制";
    label2.textColor = kUIColorFromRGB(0xef4d6d);
    label2.textAlignment = NSTextAlignmentRight;
    //label2.backgroundColor = [UIColor grayColor];
//    label2.textColor = [UIColor blackColor];
    [self.contentView addSubview:label2];
}

- (UIToolbar *)inputAccessoryView
{
    if(!_inputAccessoryView)
    {
        // 建立 UIToolbar
        UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, got(320), gotHeight(44))];
        // 选取日期完成 并给他一个 selector
        //调整两个item之间的距离.flexible表示距离是动态的,fixed表示是固定的
        UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(canclePicker)];
        
        UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(surePicker)];
        //  UIToolbar
        toolBar.items = [NSArray arrayWithObjects:leftBtn,flexible,rightBtn,nil];
        
        
        return toolBar;
    }
    return _inputAccessoryView;
}

-(UIPickerView *)inputView
{
    if(!_inputView)
    {
        pickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, gotHeight(200), got(320), gotHeight(200))];
        pickView.delegate =self;
        pickView.dataSource = self;
        pickView.showsSelectionIndicator = YES;
        return pickView;
    }
    return _inputView;
}

// 取消
- (void)canclePicker
{
    [self resignFirstResponder];
}

// 确定
-(void)surePicker
{
    
    NSInteger fillingRow = [pickView selectedRowInComponent:0];//第一列选择的行
    NSString *filling = [province objectAtIndex:fillingRow];//fillingTypes为数组
    NSString *bread = nil;
    if (self.rowNum == 4) {
        //获取当前选择的内容
        
        NSInteger breadRow = [pickView selectedRowInComponent:1];//第二列选择的行
        bread  = [city objectAtIndex:breadRow];//breadTypes为数组
        
        label2.text = [NSString stringWithFormat:@"%@ %@",filling,bread];
         NSDictionary *dict2 = [NSGetTools getSearchSetDict];// 取出
        NSMutableDictionary *dict3 = [NSMutableDictionary dictionaryWithDictionary:dict2];
         NSLog(@"--dict3-%@--%ld",dict3,dict3.count);
        [dict3 setObject:label2.text forKey:@"地区"];// 添加
        [NSGetTools updateSearchSetWithDict:dict3];// 保存
         NSDictionary *dict4 = [NSGetTools getSearchSetDict];
        NSLog(@"--dict4-%@--%ld",dict4,dict4.count);
    }else if(self.rowNum == 0){
        
        NSInteger breadRow = [pickView selectedRowInComponent:1];//第二列选择的行
        bread  = [city objectAtIndex:breadRow];//breadTypes为数组

        label2.text = [NSString stringWithFormat:@"%@-%@",filling,bread];
        NSDictionary *dict2 = [NSGetTools getSearchSetDict];// 取出
        NSMutableDictionary *dict3 = [NSMutableDictionary dictionaryWithDictionary:dict2];
        [dict3 setObject:label2.text forKey:@"年龄"];// 添加
        [NSGetTools updateSearchSetWithDict:dict3];// 保存
    }else if(self.rowNum == 1){
        
        NSInteger breadRow = [pickView selectedRowInComponent:1];//第二列选择的行
        bread  = [city objectAtIndex:breadRow];//breadTypes为数组
        
        label2.text = [NSString stringWithFormat:@"%@-%@",filling,bread];
        NSDictionary *dict2 = [NSGetTools getSearchSetDict];// 取出
        NSMutableDictionary *dict3 = [NSMutableDictionary dictionaryWithDictionary:dict2];
        [dict3 setObject:label2.text forKey:@"身高"];// 添加
        [NSGetTools updateSearchSetWithDict:dict3];// 保存
    }else if(self.rowNum == 2){
        label2.text = [NSString stringWithFormat:@"%@",filling];
        NSDictionary *dict2 = [NSGetTools getSearchSetDict];// 取出
        NSMutableDictionary *dict3 = [NSMutableDictionary dictionaryWithDictionary:dict2];
        [dict3 setObject:label2.text forKey:@"婚姻"];// 添加
        [NSGetTools updateSearchSetWithDict:dict3];// 保存
    }else if(self.rowNum == 3){
        label2.text = [NSString stringWithFormat:@"%@",filling];
        NSDictionary *dict2 = [NSGetTools getSearchSetDict];// 取出
        NSMutableDictionary *dict3 = [NSMutableDictionary dictionaryWithDictionary:dict2];
        [dict3 setObject:label2.text forKey:@"学历"];// 添加
        [NSGetTools updateSearchSetWithDict:dict3];// 保存
    }
    
    
    
    NSLog(@"-选择的是-%@---%@---",filling,bread);
    
    [self resignFirstResponder];
    
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

#pragma mark-UIPickViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (self.rowNum == 4 || self.rowNum == 0 || self.rowNum == 1) {
        return 2;
    }else{
        return 1;
    }
}
// pickerView中的每列行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
       
        return [province count];
    }else {
        return [city count];
    }

}

// 原生自带的
//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    
//
//        
//        NSLog(@"-------%ld----",self.rowNum);
//        if (component == 0) {
//            
//            return [province objectAtIndex: row];
//        }else if (component == 1){
//            return [city objectAtIndex: row];
//        }else{
//            return 0;
//        }
//}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    
    if (self.rowNum == 4) {
        if (component == 0) {
            selectedProvince = [province objectAtIndex: row];
            NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [areaDic objectForKey: [NSString stringWithFormat:@"%ld", row]]];
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: selectedProvince]];
            NSArray *cityArray = [dic allKeys];
            NSArray *sortedArray = [cityArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
                
                if ([obj1 integerValue] > [obj2 integerValue]) {
                    return (NSComparisonResult)NSOrderedDescending;//递减
                }
                
                if ([obj1 integerValue] < [obj2 integerValue]) {
                    return (NSComparisonResult)NSOrderedAscending;//上升
                }
                return (NSComparisonResult)NSOrderedSame;
            }];
            
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (int i=0; i<[sortedArray count]; i++) {
                NSString *index = [sortedArray objectAtIndex:i];
                NSArray *temp = [[dic objectForKey: index] allKeys];
                [array addObject: [temp objectAtIndex:0]];
            }
            
            
            city = [[NSArray alloc] initWithArray: array];
            
            [pickView selectRow: 0 inComponent: 1 animated: YES];
            
            [pickView reloadComponent: 1];
            
        }

    }else{
        

        
    }
    
   
}

// 自定义的,可以设置颜色字体
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view

{
    
    UILabel *myView = nil;
    
    if (component == 0) {
        
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, got(180), 30)];
        
        myView.textAlignment = NSTextAlignmentCenter;
    
        myView.text = [province objectAtIndex:row];
        
        myView.font = [UIFont systemFontOfSize:got(15)];         //用label来设置字体大小
        
        myView.backgroundColor = [UIColor clearColor];
        
    }else {
        
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, got(140), 30)];
        
        myView.text = [city objectAtIndex:row];
        
        myView.textAlignment = NSTextAlignmentCenter;
        
        myView.font = [UIFont systemFontOfSize:got(15)];
        
        myView.backgroundColor = [UIColor clearColor];
        
    }
    
    return myView;
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component == 0)
    {
        return got(170);
    }else{
        return got(150);
    }
    
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
