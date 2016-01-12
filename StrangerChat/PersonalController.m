//
//  PersonalController.m
//  StrangerChat
//
//  Created by zxs on 15/11/24.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "PersonalController.h"
#import "PersonViewCell.h"
#import "LogeViewCell.h"
#import "NPOpinionController.h"
#import "NPAboutUsController.h"
#import "AccountController.h"


#define KCell_A @"kcell_1"
#define KCell_B @"kcell_2"
@interface PersonalController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UITableView *tempTableView;
    
}
@property (nonatomic,strong)NSArray *nameArray;
@property (nonatomic,strong)NSArray *versionArray;
@end

@implementation PersonalController

- (NSArray *)nameArray {

    return @[@"清理缓存",@"检查更新",@"意见反馈"];
}

- (NSArray *)versionArray {
    
    return @[@"",@"发现新版本",@""];
}
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutTempTableView];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-normal"] style:(UIBarButtonItemStylePlain) target:self action:@selector(leftAction)];
    
}

- (void)leftAction {

    [self.navigationController popToRootViewControllerAnimated:true];
}

- (void)layoutTempTableView
{
    tempTableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds];
//    tempTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    tempTableView.dataSource = self;
    tempTableView.delegate = self;
    [tempTableView registerClass:[PersonViewCell class] forCellReuseIdentifier:KCell_A];
    [tempTableView registerClass:[LogeViewCell class] forCellReuseIdentifier:KCell_B];
    
    [tempTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    tempTableView.tableFooterView = [[UIView alloc]init];
    tempTableView.backgroundColor = [UIColor colorWithWhite:0.960 alpha:1];
    [self.view addSubview:tempTableView];
    
}

#pragma mark - UITabelView dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 3;
    }else {
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        cell.textLabel.text = @"账号安全";
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            cell.textLabel.text = @"清理缓存";
        }else if(indexPath.row == 1){
            cell.textLabel.text = @"检查更新";
        }else{
           cell.textLabel.text = @"意见反馈";
        }
    }else if(indexPath.section == 2){
        cell.textLabel.text = @"关于我们";
    }else{
        cell.textLabel.text = @"退出登录";
    }
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark -------delegata Height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 35;
}

#pragma mark --- section header
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return gotHeight(10);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) { // 账号安全
        AccountController *account = [[AccountController alloc] init];
        account.title = @"账号安全";
        [self.navigationController pushViewController:account animated:YES];
    }else if (indexPath.section == 1 && indexPath.row == 0) {
        // 清理缓存
        NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"警告" message:[NSString stringWithFormat:@"缓存为%.2f M ,确定要清除么？",[self folderSizeAtPath:cachePath]] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }else if (indexPath.section == 1 && indexPath.row == 1) { // 意见反馈
        // 检查更新
    }else if (indexPath.section == 1 && indexPath.row == 2) {
        // 意见反馈
        NPOpinionController *opinion = [[NPOpinionController alloc] init];
        opinion.title = @"意见反馈";
        [self.navigationController pushViewController:opinion animated:YES];
    }else if (indexPath.section == 2) { // 关于我们
        NPAboutUsController *aboutUs = [[NPAboutUsController alloc] init];
        aboutUs.title = @"关于我们";
        [self.navigationController pushViewController:aboutUs animated:YES];
        
    }else if (indexPath.section == 3) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"loaded"];
        [Mynotification postNotificationName:@"loginStateChange" object:nil];
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        return;
    }else{
        NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        [self clearCache:cachePath];
    }
}

/**
 *  单个文件的大小
 *
 *  @param filePath 文件路径
 *
 *  @return 返回文件大小
 */
- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

/**
 *  遍历文件夹获得文件夹大小，返回多少M
 *
 *  @param folderPath 文件夹路径
 *
 *  @return 返回M
 */

- (float ) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}
- (void)clearCache:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            //过滤掉不想删除的文件
            if ([fileName rangeOfString:[NSString stringWithFormat:@"chat_"]].location == NSNotFound) {
                NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
                [fileManager removeItemAtPath:absolutePath error:nil];
            }
        }
    }
    [[SDImageCache sharedImageCache] cleanDisk];
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
