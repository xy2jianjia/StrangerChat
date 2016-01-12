//
//  MineViewController.m
//  StrangerChat
//
//  Created by long on 15/10/2.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "MineViewController.h"
#import "MyDataViewController.h"
#import "MyPhotoViewController.h"
#import "FriendController.h"
#import "PersonalController.h"
#import "Homepage.h"
#import "ConditionController.h"
#import "MeTouchController.h"
#import "TouchMeController.h"
#import "SeenMeController.h"
#import "NoVipController.h"
#import "SeenMeVipController.h"
#import "HFVipViewController.h"
@interface MineViewController () <UITableViewDataSource,UITableViewDelegate> {

    NSInteger *integerFir;
}

@property (nonatomic,strong) UIImageView *headImageView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *IDLabel;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) MyDataViewController *mydata;

@end

@implementation MineViewController
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
    [self getUserHeaderImage];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getPersonalDetailInfo];
    
    // Do any additional setup after loading the view.
    
//    [self addHeaderView];
   
}
/**
 *  获取用户头像LP-file-msc/f_107_11_1.service？a78-->156,120,90,72,1000(原图) （不传提取所有）
 */
- (void)getUserHeaderImage{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSString *appinfoStr = [NSGetTools getAppInfoString];
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"regUser"];
    NSString *userId= [NSString stringWithFormat:@"%@",[dict objectForKey:@"userId"]];
    NSString *sessionId= [NSString stringWithFormat:@"%@",[dict objectForKey:@"sessionId"]];
    NSString *url = [NSString stringWithFormat:@"%@f_107_11_1.service?a78=%@&p2=%@&p1=%@&%@",kServerAddressTest3,@"",userId,sessionId,appinfoStr];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
//        NSNumber *codeNum = infoDic[@"code"];
        NSArray *bodyArr = [infoDic objectForKey:@"body"];
//        NSDictionary *resultDict = [bodyDict objectForKey:@"b112"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self addHeaderView:bodyArr];
            
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
- (void)getPersonalDetailInfo{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSString *appinfoStr = [NSGetTools getAppInfoString];
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"regUser"];
    NSString *userId= [NSString stringWithFormat:@"%@",[dict objectForKey:@"userId"]];
    NSString *sessionId= [NSString stringWithFormat:@"%@",[dict objectForKey:@"sessionId"]];
    NSString *url = [NSString stringWithFormat:@"%@f_108_13_1.service?p2=%@&p1=%@&%@",kServerAddressTest2,userId,sessionId,appinfoStr];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *datas = responseObject;
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        NSNumber *codeNum = infoDic[@"code"];
        NSDictionary *bodyDict = [infoDic objectForKey:@"body"];
        NSDictionary *resultDict = [bodyDict objectForKey:@"b112"];
        if ([codeNum integerValue] == 200) {
            [[NSUserDefaults standardUserDefaults] setObject:resultDict forKey:@"personalDetailInfo"];
        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            // 头区
//            [self addHeaderView];
//        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 1) {
        return 4;
    }else{
        return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        cell.imageView.image = [UIImage imageNamed:@"icon-vip.png"];
        cell.textLabel.text = @"开通VIP";
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.imageView.image = [UIImage imageNamed:@"icon-data.png"];
            cell.textLabel.text = @"我的资料";
//            CGRectMake(got(5), gotHeight(0), got(80), gotHeight(20))
            UILabel *introduceLabel = [[UILabel alloc] initWithFrame:CGRectMake(got(210), gotHeight(7.5), got(80), gotHeight(20))];
//            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(got(210), gotHeight(5), got(80), gotHeight(20))];
//            imageView.image = [UIImage imageNamed:@"bg-percentage.png"];
            [cell.contentView addSubview:introduceLabel];
            introduceLabel.backgroundColor = [UIColor colorWithRed:236/255.0 green:49/255.0 blue:88/255.0 alpha:1];
            introduceLabel.layer.masksToBounds = YES;
            introduceLabel.layer.cornerRadius = 10;
            introduceLabel.text = @"资料100%";
            introduceLabel.textAlignment = NSTextAlignmentCenter;
            introduceLabel.font = [UIFont systemFontOfSize:got(11)];
            introduceLabel.textColor = [UIColor whiteColor];
//            [cell.contentView addSubview:imageView];
        }
        if (indexPath.row == 1) {
            cell.imageView.image = [UIImage imageNamed:@"icon-photo.png"];
            cell.textLabel.text = @"我的相册";
        }
        if (indexPath.row == 2) {
            cell.imageView.image = [UIImage imageNamed:@"icon-declaration.png"];
            cell.textLabel.text = @"交友宣言";
        }
        if (indexPath.row == 3) {
            cell.imageView.image = [UIImage imageNamed:@"icon-conditions.png"];
            cell.textLabel.text = @"择友条件";
        }
    }
    if (indexPath.section == 2) {
        cell.imageView.image = [UIImage imageNamed:@"icon-set.png"];
        cell.textLabel.text = @"系统设置";
    }
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    return cell;
    
}
#pragma mark --- 开通Vip
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) { // vip会员
        HFVipViewController *vip = [[HFVipViewController alloc] init];
        [self.navigationController pushViewController:vip animated:YES];
    }
    
    if (indexPath.section == 1 && indexPath.row == 0) { // 资料
        MyDataViewController *myDataVC = [MyDataViewController new];
        [self.navigationController pushViewController:myDataVC animated:YES];
    }
    if (indexPath.section == 1 && indexPath.row == 1) { // 相册
        MyPhotoViewController *myPhotoVC = [MyPhotoViewController new];
        [self.navigationController pushViewController:myPhotoVC animated:YES];
    }
    if (indexPath.section == 1 && indexPath.row == 2) { // 交友宣言
        FriendController *friend = [FriendController new];
        [self.navigationController pushViewController:friend animated:YES];
    }
    if (indexPath.section == 1 && indexPath.row == 3) { // 交友宣言
        ConditionController *condition = [ConditionController new];
        [self.navigationController pushViewController:condition animated:YES];
    }
    if (indexPath.section == 2) {  // 系统
        PersonalController *person = [[PersonalController alloc] init];
        person.title = @"系统设置";
        [self.navigationController pushViewController:person animated:YES];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return gotHeight(35);
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 15;
    }else{
      return gotHeight(15);
    }
    
}

#pragma mark --- headerView
- (void)addHeaderView:(NSArray *)dict{
    self.view.backgroundColor = [UIColor colorWithWhite:0.980 alpha:1];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, gotHeight(64), self.view.bounds.size.width, self.view.bounds.size.height-gotHeight(10))];
    self.tableView.backgroundColor = HexRGB(0Xeeeeee);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView=[[UIView alloc]init];
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, gotHeight(130))];
    view2.backgroundColor = [UIColor whiteColor];
    
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(got(10), gotHeight(15), got(65), got(65))];

    _headImageView.layer.cornerRadius = got(65/2);
    _headImageView.clipsToBounds = YES;
    _headImageView.contentMode = UIViewContentModeScaleAspectFill;
    if (dict.count > 0) {
       [_headImageView sd_setImageWithURL:[NSURL URLWithString:[dict[0] objectForKey:@"b57"]] placeholderImage:[UIImage imageNamed:@"list_item_icon.png"]];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[dict[0] objectForKey:@"b57"]]];
            UIImage *image = [UIImage imageWithData:data];
            [[DHTool shareTool] saveImage:image withName:@"headerImage.jpg"];
        });
    }else{
        _headImageView.image = [UIImage imageNamed:@"list_item_icon.png"];
    }
    
    [view2 addSubview:_headImageView];
    
    // 名字
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(got(80), gotHeight(25), got(100), gotHeight(20))];
    NSString *nickName = [[NSUserDefaults standardUserDefaults] objectForKey:@"nickName"];
//    [dict objectForKey:@"b52"];
//    [[NSUserDefaults standardUserDefaults] objectForKey:@"nickName"];
    _nameLabel.text = nickName;
    _nameLabel.font = [UIFont systemFontOfSize:15];
    _nameLabel.textColor = HexRGB(0X000000);
    [view2 addSubview:_nameLabel];
    // ID
    _IDLabel = [[UILabel alloc] initWithFrame:CGRectMake(got(80), gotHeight(51), got(150), gotHeight(20))];
    NSNumber *p2 = [NSGetTools getUserID];//ID
    _IDLabel.textColor = HexRGB(0X666666);
    _IDLabel.text = [NSString stringWithFormat:@"ID号 : %@",p2];
    _IDLabel.font = [UIFont systemFontOfSize:13];
    [view2 addSubview:_IDLabel];
#pragma mark ------- 个人资料
    UIButton *personBtn = [[UIButton alloc] initWithFrame:CGRectMake(got(230), gotHeight(40), got(70), gotHeight(20))];
    [personBtn setImage:[UIImage imageNamed:@"btn-home-page-n.png"] forState:UIControlStateNormal];
    [personBtn addTarget:self action:@selector(personAction) forControlEvents:(UIControlEventTouchUpInside)];
    [view2 addSubview:personBtn];
    
    // 我关注的
    UIButton *myCareLabel = [[UIButton alloc] initWithFrame:CGRectMake(got(15), gotHeight(105), got(80), gotHeight(20))];
//    myCareLabel.backgroundColor = [UIColor greenColor];
    [myCareLabel setTitle:@"我触动的" forState:(UIControlStateNormal)];
    myCareLabel.titleLabel.font = [UIFont systemFontOfSize:14];
    [myCareLabel setTitleColor:HexRGB(0X000000) forState:(UIControlStateNormal)];
    [myCareLabel addTarget:self action:@selector(myCareLabelAction) forControlEvents:(UIControlEventTouchUpInside)];
    [view2 addSubview:myCareLabel];
    
    // 关注我的
    UIButton *careMeLabel = [[UIButton alloc] initWithFrame:CGRectMake(got(130), gotHeight(105), got(80), gotHeight(20))];
    [careMeLabel setTitle:@"触动我的" forState:(UIControlStateNormal)];
    careMeLabel.titleLabel.font = [UIFont systemFontOfSize:14];
    [careMeLabel setTitleColor:HexRGB(0X000000) forState:(UIControlStateNormal)];
    [careMeLabel addTarget:self action:@selector(careMeLabelAction) forControlEvents:(UIControlEventTouchUpInside)];
    [view2 addSubview:careMeLabel];
    
    // 谁看过我
    UIButton *lookMeLabel = [[UIButton alloc] initWithFrame:CGRectMake(got(235), gotHeight(105), got(80), gotHeight(20))];
    [lookMeLabel setTitle:@"谁看过我" forState:(UIControlStateNormal)];
    lookMeLabel.titleLabel.font = [UIFont systemFontOfSize:14];
    [lookMeLabel setTitleColor:HexRGB(0X000000) forState:(UIControlStateNormal)];
    [lookMeLabel addTarget:self action:@selector(lookMeLabelAction) forControlEvents:(UIControlEventTouchUpInside)];
    [view2 addSubview:lookMeLabel];

    // 分割线
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, gotHeight(100), ScreenWidth,1)];
    lineLabel.backgroundColor = HexRGB(0Xd0d0d0);
    [view2 addSubview:lineLabel];
    
    UILabel *lineLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(got(110), gotHeight(100), 1,gotHeight(30))];
    lineLabel2.backgroundColor = HexRGB(0Xd0d0d0);
    [view2 addSubview:lineLabel2];

    UILabel *lineLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(got(220), gotHeight(100), 1,gotHeight(30))];
    lineLabel3.backgroundColor = HexRGB(0Xd0d0d0);
    [view2 addSubview:lineLabel3];
    self.tableView.tableHeaderView = view2;
}

#pragma mark --- button
- (void)myCareLabelAction {
    
    MeTouchController *mec = [[MeTouchController alloc] init];
    mec.title = @"我触动的";
    [self.navigationController pushViewController:mec animated:YES];
}

- (void)careMeLabelAction {
    
    BOOL vip = true;
    if (vip) {   // 会员
        TouchMeController *touch = [[TouchMeController alloc] init];
        touch.title = @"触动我的";
        [self.navigationController pushViewController:touch animated:YES];
    }else {      // 不是会员
        NoVipController *vip = [[NoVipController alloc] init];
        vip.title = @"触动我的";
        [self.navigationController pushViewController:vip animated:YES];
    }
}

- (void)lookMeLabelAction {
    
    BOOL vip = true;
    if (vip) {  // 会员
        SeenMeController *seen = [[SeenMeController alloc] init];
        seen.title = @"谁看过我";
        [self.navigationController pushViewController:seen animated:YES];
    }else {     // 不是会员
        
        SeenMeVipController *vip = [[SeenMeVipController alloc] init];
        vip.title = @"谁看过我";
        [self.navigationController pushViewController:vip animated:YES];
    }
}

- (void)personAction {

    NSNumber *p2 = [NSGetTools getUserID];//ID
    Homepage *home = [[Homepage alloc] init];
    home.touchP2 = p2;
    [self.navigationController pushViewController:home animated:false];
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
