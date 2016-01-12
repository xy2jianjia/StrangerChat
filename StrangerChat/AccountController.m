//
//  AccountController.m
//  StrangerChat
//
//  Created by zxs on 15/11/27.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "AccountController.h"
#import "PersonalController.h"
#import "AccountCell.h"
#import "NPhotoNumCell.h"
#import "PassWordCell.h"
#import "NResetController.h"
#import "BindingController.h"
#import "DHAccountCell.h"
#import "DHPassWordCell.h"

#define KCell_A @"cell_1"
#define KCell_B @"cell_2"
#define KCell_C @"cell_3"
@interface AccountController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *paraTabelView;
    
}

@end

@implementation AccountController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutParallax];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-normal"] style:(UIBarButtonItemStylePlain) target:self action:@selector(leftAction)];
}
- (void)leftAction {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)layoutParallax
{
    paraTabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:(UITableViewStylePlain)];
//    paraTabelView.separatorStyle = UITableViewCellSelectionStyleNone;
    paraTabelView.delegate = self;
    paraTabelView.dataSource = self;
    paraTabelView.backgroundColor = [UIColor colorWithWhite:0.960 alpha:1];
    [paraTabelView registerClass:[AccountCell class] forCellReuseIdentifier:KCell_A];
    [paraTabelView registerClass:[NPhotoNumCell class] forCellReuseIdentifier:KCell_B];
    [paraTabelView registerClass:[PassWordCell class] forCellReuseIdentifier:KCell_C];
    [paraTabelView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    paraTabelView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:paraTabelView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        // 账号
        if (indexPath.row == 0) {
            DHAccountCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"DHAccountCell" owner:self options:nil] lastObject];
            cell.nameLabel.text = @"账       号";
            NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
            cell.phoneOrIdLabel.text = userId;
            return cell;
        }else if(indexPath.row == 1){
            // 密码
            DHPassWordCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"DHPassWordCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.selected = NO;
            BOOL isShowPassWord = [[NSUserDefaults standardUserDefaults] boolForKey:@"isShowPassWord"];
            if (isShowPassWord) {
                NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"regUser"];
                NSString *password = [dict objectForKey:@"password"];
                cell.passwordLabel.text = password;
                cell.eyeImageV.image = [UIImage imageNamed:@"show_pwd.png"];
            }else{
              cell.passwordLabel.text = @"******";
                cell.eyeImageV.image = [UIImage imageNamed:@"dismiss_pwd.png"];
            }
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeShowPasswordStyle:)];
            cell.eyeImageV.userInteractionEnabled = YES;
            [cell.eyeImageV addGestureRecognizer:tap];
            return cell;
        }else{
            return nil;
        }
    }else{
        // 账号
        if (indexPath.row == 0) {
            DHAccountCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"DHAccountCell" owner:self options:nil] lastObject];
            cell.nameLabel.text = @"手  机  号";
//            NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
            NSString *bindPhone = [[NSUserDefaults standardUserDefaults] objectForKey:@"bindPhone"];
            cell.phoneOrIdLabel.text = bindPhone;
            cell.phoneOrIdLabel.textColor = [UIColor colorWithRed:245/255.0 green:3/255.0 blue:6/255.0 alpha:1];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }else if(indexPath.row == 1){
            UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            cell.textLabel.text = @"重置密码";
            cell.textLabel.font = [UIFont systemFontOfSize:13];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }else{
           return nil;
        }
    }
}
- (void)changeShowPasswordStyle:(UITapGestureRecognizer *)sender{
    DHPassWordCell *cell = (DHPassWordCell *)[[sender.view superview] superview];
    BOOL isShowPassWord = [[NSUserDefaults standardUserDefaults] boolForKey:@"isShowPassWord"];
    if (isShowPassWord) {
        cell.passwordLabel.text = @"******";
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isShowPassWord"];
        cell.eyeImageV.image = [UIImage imageNamed:@"dismiss_pwd.png"];
    }else{
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"regUser"];
        NSString *password = [dict objectForKey:@"password"];
        cell.passwordLabel.text = password;
        cell.eyeImageV.image = [UIImage imageNamed:@"show_pwd.png"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isShowPassWord"];
    }
}
#pragma mark --- cell返回高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 1) {
        return 55;
    }else{
       return 35;
    }
    
}

#pragma mark --- section header
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    if (section == 0) {
//        return @"账号";
//    }else{
//        return <#expression#>
//    }
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//
//    if (section == 0) {
//        return [self addtext:@"账号"];
//        
//    }else {
//        return [self addtext:@"安全"];
//        
//    }
//    
//}
//
///*
// * text 文字
// */
//- (UIView *)addtext:(NSString *)text {
//
//    UIView *allView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    allView.backgroundColor = kUIColorFromRGB(0xEEEEEE);
//    UILabel *account = [[UILabel alloc] initWithFrame:CGRectMake(10, 2.5, 40, 35)];
//    account.text = text;
//    [account.font fontWithSize:20.0f];
//    account.textColor = kUIColorFromRGB(0x999999);
//    [allView addSubview:account];
//    return allView;
//}

#pragma mark --- 选中cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1 && indexPath.row == 0) {
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"bindPhone"];
        NSString *bindPhone = [[NSUserDefaults standardUserDefaults] objectForKey:@"bindPhone"];
        if (bindPhone) {
            BindingController *bind = [[BindingController alloc] init];
            bind.title = @"已绑定手机号";
            [self.navigationController pushViewController:bind animated:YES];
        }else{
            NResetController *reset = [[NResetController alloc] init];
            reset.title = @"绑定手机号";
            reset.msgType = @"3";
            [self.navigationController pushViewController:reset animated:YES];
        }
    }else if (indexPath.section == 1 && indexPath.row == 1) {
        NResetController *reset = [[NResetController alloc] init];
        reset.title = @"重置密码";
        reset.msgType = @"2";
        [self.navigationController pushViewController:reset animated:YES];
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
