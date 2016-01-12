//
//  SearchSetViewController.m
//  StrangerChat
//
//  Created by long on 15/11/11.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "SearchSetViewController.h"
#import "SearchSetTableViewCell.h"
@interface SearchSetViewController () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation SearchSetViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"搜索条件";
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.980 alpha:1];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
//    self.tableView.tableFooterView=[[UIView alloc]init];
    
    

    // 返回
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-normal.png"] style:UIBarButtonItemStyleDone target:self action:@selector(backAction)];
    // 重置
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-Refresh.png"] style:UIBarButtonItemStyleDone target:self action:@selector(setAllBack)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    
//    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, gotHeight(420), got(320), gotHeight(140))];
//    imageView2.image = [UIImage imageNamed:@"btnBig02.png"];
//    
//    [self.view addSubview:imageView2];
    UIView *footView = [[UIView alloc]init];
    
    footView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-5*40);
//    footView.backgroundColor = [UIColor yellowColor];
    self.tableView.tableFooterView = footView;
    //搜索按钮
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeSystem];
    searchButton.backgroundColor = HexRGB(0Xf04d6d);
    searchButton.frame = CGRectMake(got(30), gotHeight(32), got(260), gotHeight(40));
    [searchButton setTitle:@"搜 索" forState:UIControlStateNormal];
    [footView addSubview:searchButton];
    [searchButton setTitleColor:HexRGB(0XFFFFFF) forState:UIControlStateNormal];
    searchButton.titleLabel.font = [UIFont systemFontOfSize:19];
    searchButton.layer.cornerRadius = got(5);
    searchButton.clipsToBounds = YES;
    [searchButton addTarget:self action:@selector(searchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *incomeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    incomeBtn.frame = CGRectMake(66, CGRectGetMaxY(searchButton.frame)+19, 42, 42);
    [incomeBtn setBackgroundImage:[UIImage imageNamed:@"icon-income.png"] forState:(UIControlStateNormal)];
    [footView addSubview:incomeBtn];
    
    UILabel *incomeLabel = [[UILabel alloc]init];
    incomeLabel.frame = CGRectMake(CGRectGetMinX(incomeBtn.frame), CGRectGetMaxY(incomeBtn.frame)+11, CGRectGetWidth(incomeBtn.frame), 20);
    incomeLabel.text = @"收入";
    incomeLabel.font = [UIFont systemFontOfSize:14];
    incomeLabel.textAlignment = NSTextAlignmentCenter;
    incomeLabel.textColor = HexRGB(0x727272);
    [footView addSubview:incomeLabel];
    
    UIButton *estateBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    estateBtn.frame = CGRectMake(CGRectGetMidX([[UIScreen mainScreen] bounds])-21, CGRectGetMinY(incomeBtn.frame), CGRectGetWidth(incomeBtn.frame), CGRectGetWidth(incomeBtn.frame));
    [estateBtn setBackgroundImage:[UIImage imageNamed:@"icon-Estate.png"] forState:(UIControlStateNormal)];
    [footView addSubview:estateBtn];
    
    UILabel *estateLabel = [[UILabel alloc]init];
    estateLabel.frame = CGRectMake(CGRectGetMinX(estateBtn.frame), CGRectGetMaxY(estateBtn.frame)+11, CGRectGetWidth(estateBtn.frame), CGRectGetHeight(incomeLabel.frame));
    estateLabel.text = @"房产";
    estateLabel.font = [UIFont systemFontOfSize:14];
    estateLabel.textAlignment = NSTextAlignmentCenter;
    estateLabel.textColor = HexRGB(0x727272);
    [footView addSubview:estateLabel];
    
    UIButton *carBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    carBtn.frame = CGRectMake(CGRectGetMaxX([[UIScreen mainScreen] bounds])-66-42,CGRectGetMinY(incomeBtn.frame), CGRectGetWidth(incomeBtn.frame), CGRectGetWidth(incomeBtn.frame));
    [carBtn setBackgroundImage:[UIImage imageNamed:@"icon-car.png"] forState:(UIControlStateNormal)];
    [footView addSubview:carBtn];
    
    UILabel *carLabel = [[UILabel alloc]init];
    carLabel.frame = CGRectMake(CGRectGetMinX(carBtn.frame), CGRectGetMaxY(carBtn.frame)+11, CGRectGetWidth(carBtn.frame), CGRectGetHeight(incomeLabel.frame));
    carLabel.text = @"车产";
    carLabel.font = [UIFont systemFontOfSize:14];
    carLabel.textAlignment = NSTextAlignmentCenter;
    carLabel.textColor = HexRGB(0x727272);
    [footView addSubview:carLabel];
    
    UIImageView *vipImageV = [[UIImageView alloc]init];
    vipImageV.frame = CGRectMake(100, CGRectGetMaxY(carLabel.frame)+49, 15, 12);
    vipImageV.image = [UIImage imageNamed:@"icon-vip-search.png"];
    [footView addSubview:vipImageV];
    UIButton *becomeVipBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    becomeVipBtn.frame = CGRectMake(CGRectGetMaxX(vipImageV.frame)+4, CGRectGetMinY(vipImageV.frame)-5, 49, 22);
    [becomeVipBtn setTitleColor:HexRGB(0xee4e6d) forState:(UIControlStateNormal)];
    [becomeVipBtn setTitle:@"成为VIP" forState:(UIControlStateNormal)];
    becomeVipBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [footView addSubview:becomeVipBtn];
    
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(CGRectGetMaxX(becomeVipBtn.frame), CGRectGetMinY(becomeVipBtn.frame), ScreenWidth-200-15-4-49, CGRectGetHeight(becomeVipBtn.frame));
    label.text = @"搜索条件更丰富";
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = HexRGB(0x010101);
    [footView addSubview:label];
    
    
    
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

// 重置
- (void)setAllBack
{
    NSMutableDictionary *searDict = [NSMutableDictionary dictionary];
    [NSGetTools updateSearchSetWithDict:searDict];
    [self.tableView reloadData];
    
}

// 点击搜索并返回
- (void)searchButtonAction:(UIButton *)sender
{
    // 试试通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"searchSetData" object:@YES];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark --- TableViewDelegate-------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return gotHeight(40);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier2";
    SearchSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[SearchSetTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSArray *titleArray = [NSArray arrayWithObjects:@"年龄范围",@"身高范围",@"婚姻状况",@"学历",@"所在地区", nil];
    cell.textLabel.text = titleArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    NSDictionary *dict = [NSGetTools getSearchSetDict];// 搜索条件
    if (indexPath.row == 0) {
        NSString *ageStr = dict[@"年龄"];
        if (ageStr != nil) {
            cell->label2.text = ageStr;
        }else{
            cell->label2.text = @"不限制";
        }
    }else if (indexPath.row == 1){
        NSString *bodyStr = dict[@"身高"];
        if (bodyStr != nil) {
            cell->label2.text = bodyStr;
        }else{
            cell->label2.text = @"不限制";
        }
    }else if (indexPath.row == 2){
        NSString *marrStr = dict[@"婚姻"];
        if (marrStr != nil) {
            cell->label2.text = marrStr;
        }else{
            cell->label2.text = @"不限制";
        }
        
    }else if (indexPath.row == 3){
        NSString *eduStr = dict[@"学历"];
        if (eduStr != nil) {
            cell->label2.text = eduStr;
        }else{
            cell->label2.text = @"不限制";
        }
        
    }else if (indexPath.row == 4){
        NSString *addressStr = dict[@"地区"];
        if (addressStr != nil) {
            cell->label2.text = addressStr;
        }else{
            cell->label2.text = @"不限制";
        }
        
    }
    cell->label2.font = [UIFont systemFontOfSize:13];
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchSetTableViewCell * cell = (SearchSetTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    [cell becomeFirstResponder];
    
    if (indexPath.row == 0) {// 年龄
        cell.rowNum = indexPath.row;
//        NSLog(@"-age-%@--",[NSGetSystemTools getAgeData]);
        cell->province = [NSGetSystemTools getAgeData];
        cell->city = [NSGetSystemTools getAgeData];
       
        
    }else if (indexPath.row == 1){// 身高
        cell.rowNum = indexPath.row;
        cell->province = [NSGetSystemTools getBodyHeightData];
        cell->city = [NSGetSystemTools getBodyHeightData];
       
        
    }else if (indexPath.row == 2){// 婚姻
        cell.rowNum = indexPath.row;
        
        NSDictionary *dict = [NSGetSystemTools getmarriageStatus];
        NSArray *allValues = [dict allValues];
        cell->province = allValues;
        cell->city = nil;
        
    }else if (indexPath.row == 3){// 学历
        cell.rowNum = indexPath.row;
        NSDictionary *dict = [NSGetSystemTools geteducationLevel];
        NSArray *allValues = [dict allValues];
        cell->province = allValues;
        cell->city = nil;
        
    }else if (indexPath.row == 4) {// 地区
        cell.rowNum = indexPath.row;
        
    }
    [cell->pickView reloadAllComponents];
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
