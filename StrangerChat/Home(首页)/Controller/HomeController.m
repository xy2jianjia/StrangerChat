//
//  HomeController.m
//  微信
//
//  Created by Think_lion on 15-6-14.
//  Copyright (c) 2015年 Think_lion. All rights reserved.
//

#import "HomeController.h"
#import "UIBarButtonItem+CH.h"
#import "HomeViewCell.h"
#import "HomeModel.h"
//#import "FmdbTool.h"
#import "ChatController.h"
#import "FmbdMessage.h"
#import "NSGetTools.h"

@interface HomeController ()<UISearchBarDelegate>
@property (nonatomic,assign)int messageCount; //未读的消息总数
@property (nonatomic,strong) NSMutableArray *searchList;

@property (nonatomic,strong) UIImageView *imageV;
@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) UIButton *btn;
@end

@implementation HomeController


-(instancetype)init
{
    self=[super initWithStyle:UITableViewStyleGrouped];
    if(self){
    }
    return self;
}
//-(NSMutableArray *)chatData
//{
//    if(!_chatData){
//        _chatData=[NSMutableArray array];
//    }
//    return _chatData;
//}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.searchList = [NSMutableArray array];
    //2.从本地数据库中读取正在聊天的好友数据
    [self readChatData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"信箱";
    // 每隔一秒获取消息
   //1.添加搜索栏
//    [self setupSearchBar];
//    //2.从本地数据库中读取正在聊天的好友数据
//    [self readChatData];
    //3.添加导航栏右侧的按钮
    [self setupRightButtun];
    
    
    //监听消息来得通知
    [Mynotification addObserver:self selector:@selector(messageCome:) name:SendMsgName object:nil];
    //监听删除好友时发出的通知
    [Mynotification addObserver:self selector:@selector(deleteFriend:) name:DeleteFriend object:nil];
}
/**
 *  收到消息
 *
 *  @param notifi
 */
- (void)getOffLineMessageInChat:(NSNotification *)notifi{
    NSDictionary *dict = notifi.object;
    NSDictionary *contentDict = [dict objectForKey:@"content"];
    Message *item = [[Message alloc]init];
    [item setValuesForKeysWithDictionary:contentDict];
    [item setValuesForKeysWithDictionary:[dict objectForKey:@"from"]];
    [item setValuesForKeysWithDictionary:[dict objectForKey:@"head"]];
    [item setValuesForKeysWithDictionary:[dict objectForKey:@"body"]];
    NSNumber *userId = [NSGetTools getUserID];
    if (![DBManager checkMessageWithMessageId:item.messageId targetId:item.fromUserAccount]) {
        [DBManager insertMessageDataDBWithModel:item userId:[NSString stringWithFormat:@"%@",userId]];
    }
//    MessageModel *msgModel=[[MessageModel alloc]init];
//    msgModel.body=item.message;
//    msgModel.attributedBody = [[NSAttributedString alloc]initWithString:item.message];
//    msgModel.time=item.timeStamp;
//    msgModel.hiddenTime = NO;
//    msgModel.to=item.toUserAccount;
//    msgModel.otherPhoto=[UIImage imageNamed:@""];
//    msgModel.headImage=[NSData dataWithContentsOfURL:[NSURL URLWithString:@""]]; //获得用户自己的头像
//    msgModel.messageId = item.messageId;
//    //是不是当前用户
//    msgModel.isCurrentUser=NO;
//    //根据frameModel模型设置frame
//    MessageFrameModel *frameModel=[[MessageFrameModel alloc]init];
//    frameModel.messageModel=msgModel;
//    if (![self.frameModelArr containsObject:frameModel]) {
//        [self.frameModelArr addObject:frameModel];
//    }
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.table reloadData];
//    });
//    NSString *token = [NSGetTools getToken];
//    [[SocketManager shareInstance] readMessageWithToken:token messageId:msgModel.messageId];
    
}
#pragma mark   从本地数据库中读取正在聊天的好友数据
-(void)readChatData
{
    self.chatData = [NSMutableArray array];
//    for (Message *item in self.chatDataArr) {
//        if (![self.chatData containsObject:item]) {
//           [self.chatData addObject:item];
//        }
//    }
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    NSArray *arr = [DBManager getChatListWithUserId:userId roomCode:nil];
    for (int i = 0; i < arr.count; i ++) {
        if (![self.chatData containsObject:arr[i]]) {
            [self.chatData addObject:arr[i]];
        }
    }
    // 没有数据
    if (self.chatData.count == 0) {
        _imageV = [[UIImageView alloc]init];
        _imageV.frame = CGRectMake(CGRectGetMidX([[UIScreen mainScreen] bounds])-71.5, 102-64, 143, 156);
        _imageV.image = [UIImage imageNamed:@"mailbox-pattern.png"];
        [self.view addSubview:_imageV];
        
        _label = [[UILabel alloc]init];
        _label.frame = CGRectMake(CGRectGetMinX(_imageV.frame), CGRectGetMaxY(_imageV.frame)+31, CGRectGetWidth(_imageV.frame), 30);
        _label.textAlignment = NSTextAlignmentCenter;
        _label.text = @"还没有人勾搭你";
        [self.view addSubview:_label];
        
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn.frame = CGRectMake(CGRectGetMidX([[UIScreen mainScreen] bounds])-55, CGRectGetMaxY(_label.frame)+18, 109.5, 39);
        [_btn setBackgroundImage:[UIImage imageNamed:@"button-data.png"] forState:UIControlStateNormal];
        [_btn setTitle:@"完善资料试试" forState:UIControlStateNormal];
        _btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_btn addTarget:self action:@selector(toInfoDetailVc:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.view addSubview:_btn];
    }else{
        [_btn removeFromSuperview];
        [_label removeFromSuperview];
        [_imageV removeFromSuperview];
    }
    //如果消息数大于0
    if(self.messageCount>0){
        //如果消息总数大于99
        if(self.messageCount>=99){
            self.tabBarItem.badgeValue=@"99+";
        }else{
            self.tabBarItem.badgeValue=[NSString stringWithFormat:@"%d",self.messageCount];
        }
        
    }else{
        
        
    }
    [self.tableView reloadData];
}
// 完善信息
- (void)toInfoDetailVc:(UIButton *)sender{
    
}
#pragma mark 有消息来的时候
-(void)messageCome:(NSNotification*)note
{
    NSDictionary *dict=[note object];
    NSLog(@"%@",dict[@"user"]);
    //设置未读消息总数消息 ([dict[@"user"]如果是正在和我聊天的用户才设置badgeValue)
    if([dict[@"user"] isEqualToString:@"other"]){
        dispatch_async(dispatch_get_main_queue(), ^{
            self.messageCount++;
            if(self.messageCount>=99){
                self.tabBarItem.badgeValue=@"99+";
            }else{
                self.tabBarItem.badgeValue=[NSString stringWithFormat:@"%d",self.messageCount];
            }
            
        });
    }
    //修改信息  在主线程中执行（速度快）
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateMessage:note];
    });
    
}
-(void)updateMessage:(NSNotification*)note
{
    NSDictionary *dict=[note object];
    NSString *uname=[dict objectForKey:@"uname"]; //获得用户名
    NSString *body=[dict objectForKey:@"body"];
//    XMPPJID *jid =[dict objectForKey:@"jid"];
    NSString *time=[dict objectForKey:@"time"];
    NSString *user=[dict objectForKey:@"user"];
}
#pragma mark 删除好友时同步的聊天数据
-(void)deleteFriend:(NSNotification*)note
{
    NSString *uname=[note object];
    //初始化模型的索引
    NSInteger index=0;
    for(HomeModel *model in self.chatData){
        if([model.uname isEqualToString:uname]){
            NSLog(@"%@     %@",model.uname, uname);
            [_chatData removeObjectAtIndex:index];
            //从本地数据库清除
//            [FmdbTool deleteWithName:uname];
            //重新刷新标示图
            [self.tableView reloadData];
        }
        index++;
    }
    
}
#pragma mark 添加搜索栏
-(void)setupSearchBar
{
    UISearchBar *search=[[UISearchBar alloc]init];
    
    search.frame=CGRectMake(10, 5, ScreenWidth-20, 25);
    search.barStyle=UIBarStyleDefault;
    search.backgroundColor=[UIColor whiteColor];
  
    //实例化一个搜索栏
    //取消首字母吧大写
    search.autocapitalizationType=UITextAutocapitalizationTypeNone;
    search.autocorrectionType=UITextAutocorrectionTypeNo;
    //代理
    search.placeholder=@"搜索";
    search.layer.borderWidth=0;
    
    UIView *searchV=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 35)];
    searchV.backgroundColor=[UIColor colorWithWhite:0.890 alpha:0.7];
    [searchV addSubview:search];
    search.delegate=self;
    self.tableView.tableHeaderView=searchV;
    
    
    
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
}
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    
    
    return YES;
}
-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self searchBar:searchBar textDidChange:@""];
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [self searchBar:searchBar textDidChange:@""];
    [searchBar resignFirstResponder];
}
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchString];
    if (self.searchList!= nil) {
        [self.searchList removeAllObjects];
    }
    //过滤数据
    self.searchList= [NSMutableArray arrayWithArray:[self.chatData filteredArrayUsingPredicate:preicate]];
    //刷新表格
    return YES;
}
#pragma mark
-(void)setupRightButtun
{
    self.navigationItem.rightBarButtonItem=[UIBarButtonItem itemWithIcon:@"barbuttonicon_add" highIcon:nil target:self action:@selector(rightClick)];

}
-(void)rightClick
{
    NSLog(@"sss");
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.searchList count];
    }else{
        return self.chatData.count;
    }
    
}
#pragma mark 单元格的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}
#pragma mark 设置单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    HomeViewCell *cell=[HomeViewCell cellWithTableView:tableView cellWithIdentifier:@"homeCell"];
    Message *item=self.chatData[indexPath.row];
    HomeModel *model = [[HomeModel alloc]init];
//    SELECT * FROM USERTABLE where b80='1004462'
    DHUserForChatModel *userInfo = [DBManager getUserWithCurrentUserId:item.targetId];
    model.jid = userInfo.b80;
    model.uname =  userInfo.b52;
    model.headerIcon = [NSData dataWithContentsOfURL:[NSURL URLWithString:userInfo.b57]];
    model.body = item.message;
    model.time = item.timeStamp;
    if (tableView==self.searchDisplayController.searchResultsTableView) {
        [cell.textLabel setText:self.searchList[indexPath.row]];
    }
    //传递模型
    cell.homeModel=model;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
#pragma mark 单元格的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //隐藏对象的小红点
    Message *item=self.chatData[indexPath.row];
    DHUserForChatModel *userinfo = [DBManager getUserWithCurrentUserId:item.targetId];
//    HomeModel *model = [[HomeModel alloc]init];
//    model.jid = [dict objectForKey:@"targetId"];
//    model.uname = [dict objectForKey:@"targetName"];
//    
//    model.headerIcon = [NSData dataWithContentsOfURL:[NSURL URLWithString:[dict objectForKey:@"headerImage"]]];
    //标签栏数字按钮减少
//    self.messageCount=self.messageCount-[model.badgeValue intValue];
    //如果消息数大于0
    if(self.messageCount>0){
        self.tabBarItem.badgeValue=[NSString stringWithFormat:@"%d",self.messageCount];
    }else{
        self.tabBarItem.badgeValue=nil;
    }
    //清除模型中得数据
//    model.badgeValue=nil;
    //重新刷新表视图
    [self reloadData];
    
//    [FmdbTool clearRedPointwithName:homeModel.uname];//清除数据库中的数据
    ChatController *chat=[[ChatController alloc]init];
    chat.item = item;
    chat.userInfo = userinfo;
//    [[SocketManager shareInstance] creatRoomWithString:nil account:[NSString stringWithFormat:@"%@",item.fromUserAccount]];// 开房间
    [self.navigationController pushViewController:chat animated:YES];
    
    
    
}

-(void)reloadData
{
    
    [self.tableView reloadData];
}
#pragma mark 滑动删除单元格
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
#pragma mark 改变删除单元格按钮的文字
-(NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
#pragma mark 单元格删除的点击事件
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeModel *homeModel=self.chatData[indexPath.row];
    NSString *name=homeModel.uname;
    //当点击删除按钮的时候执行
    if(editingStyle==UITableViewCellEditingStyleDelete){
        //删除对应的红色提醒按钮
        int badge=[homeModel.badgeValue intValue];
        if(badge>0){
            _messageCount=_messageCount-badge;
            self.tabBarItem.badgeValue=[NSString stringWithFormat:@"%d",_messageCount];
        }
        
        //删除该好友所有的聊天数据
        NSLog(@"%@",homeModel.jid);
        [FmbdMessage deleteChatData:[NSString stringWithFormat:@"%@@ios268",homeModel.uname]];
//        
        NSInteger count=indexPath.row;
        //删除模型
        [self.chatData removeObjectAtIndex:count];
        [self.tableView reloadData];
        //删除首页的聊天数据模型
        //删除数据库中的好友的数据
//        [FmdbTool deleteWithName:name];
        
       
    }
}

//滚动视图停止编辑
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
-(void)dealloc
{
    [Mynotification removeObserver:self];
    NSLog(@"销毁了");
}



@end
