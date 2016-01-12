//
//  ChatController.m
//  微信
//
//  Created by Think_lion on 15/6/18.
//  Copyright (c) 2015年 Think_lion. All rights reserved.
//

#import "ChatController.h"
#import "ChatBottomView.h"
#import "ChatViewCell.h"
//#import "XMPPJID.h"
#import "MessageModel.h"
#import "MessageFrameModel.h"
#import "SendTextView.h"
#import "HMEmotion.h"
#import "HMEmotionKeyboard.h"
#import "HMEmotionTool.h"
#import "UIView+MJ.h"

@interface ChatController ()<UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,ChatBottomViewDelegate>

//底部工具栏
@property (nonatomic,weak) ChatBottomView *chatBottom;
//查询结果集合
//@property (nonatomic,strong)  NSFetchedResultsController *resultController;
//定义一个表视图
@property (nonatomic,weak) UITableView *table;
//存放messageFrameModel的数组
@property (nonatomic,strong) NSMutableArray *frameModelArr;
//内容输入框
@property (nonatomic,weak) SendTextView *bottomInputView;
//表情键盘
@property (nonatomic, strong) HMEmotionKeyboard *kerboard;
//用户自己的头像
@property (nonatomic,strong) NSData *headImage;

@property (nonatomic,assign) BOOL isChangeHeight;
//表视图的高
@property (nonatomic,assign) CGFloat tableViewHeight;

//是否改变键盘样式
@property (nonatomic,assign) BOOL  changeKeyboard;
/**
 *  消息model
 */
@property (nonatomic,strong) Message *msg;
@end


@implementation ChatController

-(NSMutableArray *)frameModelArr
{
    if(_frameModelArr==nil){
        _frameModelArr=[NSMutableArray array];
    }
    return _frameModelArr;
}

- (HMEmotionKeyboard *)kerboard
{
    if (!_kerboard) {
        self.kerboard = [HMEmotionKeyboard keyboard];
        self.kerboard.width = ScreenWidth;
        self.kerboard.height = 216;
    }
    return _kerboard;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = YES;
    self.view.backgroundColor = [UIColor colorWithWhite:0.900 alpha:1];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyBoard)];
    [self.view addGestureRecognizer:tap];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation-normal"] style:(UIBarButtonItemStylePlain) target:self action:@selector(backAction)];
    //设置背景颜色
    self.view.backgroundColor=[UIColor whiteColor];
    [self createRoom];
    //1 添加表示图
    [self setupTableView];
    //2.加载聊天数据
    [self loadChatData];
    //3.添加底部view
    [self setupBottomView];
    // 监听表情选中的通知
    [Mynotification addObserver:self selector:@selector(emotionDidSelected:) name:HMEmotionDidSelectedNotification object:nil];
    // 监听删除按钮点击的通知
    [Mynotification addObserver:self selector:@selector(emotionDidDeleted:) name:HMEmotionDidDeletedNotification object:nil];
    //监听表情发送按钮点击
    [Mynotification addObserver:self selector:@selector(faceSend) name:FaceSendButton object:nil];
    [Mynotification addObserver:self selector:@selector(sendMessageResult:) name:SendMessageResult object:nil];
    [Mynotification addObserver:self selector:@selector(gethistoryMessageResult:) name:GetMessageResult object:nil];
    [Mynotification addObserver:self selector:@selector(recieveOnLineMessage:) name:RecieveOnLineMessage object:nil];
}


- (void)createRoom{
    [Mynotification addObserver:self selector:@selector(createRoomForChat:) name:@"createRoomForChat" object:nil];
    DHUserForChatModel *userinfo = [DBManager getUserWithCurrentUserId:self.item.fromUserAccount];
    [[SocketManager shareInstance] creatRoomWithString:[NSString stringWithFormat:@"%@",userinfo.b52] account:userinfo.b80];// 开房间
}
- (void)createRoomForChat:(NSNotification *)notifi{
    NSDictionary *dict = notifi.object;
    self.item.roomCode = [[dict objectForKey:@"body"] objectForKey:@"roomCode"];
//    self.item.roomName = [[dict objectForKey:@"body"] objectForKey:@"roomName"];
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"charRoomInfo"];
    if (![DBManager checkMessageWithMessageId:_item.messageId targetId:_item.targetId]) {
        [DBManager insertMessageDataDBWithModel:_item userId:[NSString stringWithFormat:@"%@",[NSGetTools getUserID]]];
    }
}
/**
 *  接收在线消息
 *
 *  @param notifi
 */
- (void)recieveOnLineMessage:(NSNotification *)notifi{
    NSDictionary *dict = notifi.object;
    NSDictionary *bodyDict = [dict objectForKey:@"body"];
    NSDictionary *contentDict = [bodyDict objectForKey:@"content"];
    NSDictionary *fromDict = [bodyDict objectForKey:@"from"];
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    [fmt setDateFormat:@"yyyyMMddHHmmsssss"];
    NSString *messageId = [fmt stringFromDate:[NSDate date]];
    Message *item = [[Message alloc]init];
    item.messageId = messageId;
    [item setValuesForKeysWithDictionary:contentDict];
//    [item setValuesForKeysWithDictionary:fromDict];
    item.fromUserAccount = [fromDict objectForKey:@"userAccount"];
    item.fromUserDevice =[fromDict objectForKey:@"userDevice"];
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    item.toUserAccount = userId;
    [item setValuesForKeysWithDictionary:[dict objectForKey:@"head"]];
    [item setValuesForKeysWithDictionary:[dict objectForKey:@"body"]];
    item.userId = userId;
    item.roomCode = _item.roomCode;
    item.roomName = _item.roomName;
    item.targetId = self.userInfo.b80;
    if (![DBManager checkMessageWithMessageId:item.messageId targetId:item.targetId]) {
        [DBManager insertMessageDataDBWithModel:item userId:[NSString stringWithFormat:@"%@",userId]];
    }
    DHUserForChatModel *userInfo = [DBManager getUserWithCurrentUserId:item.fromUserAccount];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:userInfo.b57]]];
    NSString *imageurl = [NSGetTools getIconB57];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageurl]];
    MessageModel *msgModel=[[MessageModel alloc]init];
    msgModel.body=item.message;
    msgModel.attributedBody = [[NSAttributedString alloc]initWithString:item.message];
    msgModel.time=item.timeStamp;
    msgModel.hiddenTime = NO;
    msgModel.to=item.toUserAccount;
    msgModel.otherPhoto=image;
    msgModel.headImage=data; //获得用户自己的头像
    msgModel.messageId = item.messageId;
    //是不是当前用户
    msgModel.isCurrentUser=NO;
    //根据frameModel模型设置frame
    MessageFrameModel *frameModel=[[MessageFrameModel alloc]init];
    frameModel.messageModel=msgModel;
    if (![self.frameModelArr containsObject:frameModel]) {
        [self.frameModelArr addObject:frameModel];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.table reloadData];
    });
}
- (void)getOffMessageAction:(NSTimer *)timer{
    NSString *token = [NSGetTools getToken];
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
//    [[SocketManager shareInstance] getOffLineMessageWithToken:token correntUserId:userId];
}
- (void)gethistoryMessageResult:(NSNotification *)notifi{
//    $102207|154{"body":{"userAccount":"10414800"},"head":{"seqcode":2,"token":"b4b43969-c2fb-4978-b380-01317bcb8df3"},"responseCode":200,"responseMsg":"无聊天记录"}
    NSDictionary *dict = notifi.object;
    NSDictionary *dict3 = dict[@"body"];
    NSString *roomCode = dict3[@"roomCode"];
    NSString *msg = dict[@"responseMsg"];
    // 没有记录
    if (msg) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [NSGetTools showAlert:msg];
        });
    }
    
}
- (void)backAction{
    dispatch_async(dispatch_get_main_queue(), ^{
       [self.navigationController popViewControllerAnimated:YES]; 
    });
    
}

- (void)hideKeyBoard{
    [self.bottomInputView resignFirstResponder];
}
#pragma mark 加载聊天数据
-(void)loadChatData{
    
//    [[SocketManager shareInstance] getMessageWithTargetId:self.jid];
    NSArray *array = [DBManager selectMessageDBWithRoomCode:self.item.roomCode targetId:_item.targetId];
    DHUserForChatModel *userInfo = self.userInfo;
//    [DBManager getUserWithCurrentUserId:self.item.toUserAccount];
    NSString *headerUrl = userInfo.b57;
    self.navigationItem.title = userInfo.b52;
    NSData *headerData = [NSData dataWithContentsOfURL:[NSURL URLWithString:headerUrl]];
    UIImage *image = [UIImage imageWithData:headerData];
    NSString *imageurl = [NSGetTools getIconB57];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageurl]];
//    self.headImage = data;
    for (Message *item in array) {
        MessageModel *msgModel=[[MessageModel alloc]init];
        msgModel.body=item.message;
        msgModel.attributedBody = [[NSAttributedString alloc]initWithString:item.message];
        msgModel.time=item.timeStamp;
        msgModel.hiddenTime = NO;
        msgModel.to=item.toUserAccount;
        msgModel.otherPhoto=image;
        msgModel.headImage=data; //获得用户自己的头像
        //是不是当前用户
        NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
        if ([item.fromUserAccount isEqualToString:userId]) {
            msgModel.isCurrentUser=YES;
        }else{
            msgModel.isCurrentUser=NO;
        }
        
        //根据frameModel模型设置frame
        MessageFrameModel *frameModel=[[MessageFrameModel alloc]init];
        frameModel.messageModel=msgModel;
        [self.frameModelArr addObject:frameModel];
    }
    [self.table reloadData];
}
#pragma mark 把聊天数据转成模型
-(void)dataToModel
{
    //
 
}

#pragma mark 添加表视图
-(void)setupTableView
{
    if(self.table==nil) {
        UITableView *table=[[UITableView alloc]init];
        table.allowsSelection=NO;  //单元不可以被选中
        table.separatorStyle=UITableViewCellSeparatorStyleNone;  //去掉线
        CGFloat tableH= ScreenHeight-64;
        self.tableViewHeight=tableH;  //表示图的高
        table.frame=CGRectMake(0, 0, ScreenWidth, tableH);
        table.delegate=self;
        table.dataSource=self;
        [self.view addSubview:table];
        self.table=table;
    }
}
#pragma mark 返回有多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return  self.frameModelArr.count  ;
}
#pragma mark 输入框的代理方法
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
   //写这个是为了不会在keyboardWillShow里面在调整tableView的高度(否则会错乱)
    self.isChangeHeight=YES;
    NSString *body=[self trimStr:textView.text];
    if([text isEqualToString:@"\n"]){
        //如果没有要发送的内容返回空
        if([body isEqualToString:@""]) return NO;
        //发送消息
        [self sendMsgWithText:_bottomInputView.realText bodyType:@"text"];
        self.bottomInputView.text=nil;
        return NO;
    }
    return YES;
}


//#pragma mark 发送聊天消息
-(void)sendMsgWithText:(NSString *)text bodyType:(NSString*)bodyType{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a = [dat timeIntervalSince1970]*1000;
    long long b = a;
    NSString *timeString = [NSString stringWithFormat:@"%lld", b];//转为字符型
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    [fmt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *fmtDate = [fmt stringFromDate:dat];
    _msg = [[Message alloc] init];
    _msg.toUserAccount = self.item.targetId;
//    @"101111601";
//    self.item.targetId;
    _msg.roomName = self.navigationItem.title;
    _msg.roomCode = [NSGetTools getRoomCode];
    _msg.message = text;
    _msg.fromUserDevice = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:2]];// 1:安卓 2:苹果 3:windowPhone
    _msg.timeStamp = fmtDate;
//    _msg.icon = self.photoUrl;
//    _msg.type = 0;//自己发的
    NSString *userId = [NSString stringWithFormat:@"%@",[NSGetTools getUserID]];
    _msg.fromUserAccount = userId;
    _msg.messageType = @"1";
    _msg.messageId = timeString;// 消息ID
    _msg.token = [NSGetTools getToken];
    _msg.roomCode = _item.roomCode;
    _msg.roomName = _item.roomName;
    _msg.targetId = self.item.targetId;
//    _msg.myIcon = [NSGetTools getIconB57];
    // 存储到数据库
    if (![DBManager checkMessageWithMessageId:_msg.messageId targetId:_msg.targetId]) {
        [DBManager insertMessageDataDBWithModel:_msg userId:[NSString stringWithFormat:@"%@",userId]];
    }
    DHUserForChatModel *userInfo = self.userInfo;
//    [DBManager getUserWithCurrentUserId:self.item.fromUserAccount];
    NSString *headerUrl = userInfo.b57;
    NSData *headerData = [NSData dataWithContentsOfURL:[NSURL URLWithString:headerUrl]];
    UIImage *image = [UIImage imageWithData:headerData];
    
    [[SocketManager shareInstance] sendMessageWithMesssageModel:_msg];// 发送消息
    NSString *imageurl = [NSGetTools getIconB57];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageurl]];
    self.headImage = data;
    MessageModel *msgModel=[[MessageModel alloc]init];
    msgModel.body=text;
    msgModel.attributedBody = [[NSAttributedString alloc]initWithString:text];
    msgModel.time=fmtDate;
    msgModel.hiddenTime = NO;
    msgModel.to=self.item.fromUserAccount;
    msgModel.otherPhoto=image;
    msgModel.headImage=self.headImage; //获得用户自己的头像
    //NSLog(@"%@",self.photo);
//    msgModel.hiddenTime=YES; //隐藏时间
    //是不是当前用户
    msgModel.isCurrentUser=YES;
    //根据frameModel模型设置frame
    MessageFrameModel *frameModel=[[MessageFrameModel alloc]init];
    frameModel.messageModel=msgModel;
    //把frameModel添加到数组中
    [self.frameModelArr addObject:frameModel];
    [self.table reloadData];
}
#pragma mark 表情按钮点击发送
-(void)faceSend
{
    
    NSString *str=[self trimStr:_bottomInputView.text];
    if(str.length<1) return;
    //发送消息
    [self sendMsgWithText:_bottomInputView.realText bodyType:@"text"];
     self.bottomInputView.text=nil;
}
// 发送消息得到结果
- (void)sendMessageResult:(NSNotification *)notifi{
    NSLog(@"%@",notifi.object);
    NSDictionary *dict = notifi.object;
    NSDictionary *bodyDict = dict[@"body"];
    NSString *chatId = bodyDict[@"chatId"];
    NSDictionary *accountDict = bodyDict[@"to"];
    NSString *account =  accountDict[@"userAccount"];
    
    [self.table reloadData];
    
}
#pragma mark 表示图单元
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatViewCell *cell=[ChatViewCell cellWithTableView:tableView indentifier:@"chatViewCell"];
    //传递模型
    MessageFrameModel *frameModel=self.frameModelArr[indexPath.row];
    cell.frameModel=frameModel;    
    return cell;

}
#pragma mark 返回单元格的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageFrameModel *frameModel=self.frameModelArr[indexPath.row];
    return frameModel.cellHeight;

}
#pragma mark 添加底部的view
-(void)setupBottomView
{
   
    ChatBottomView *bottom=[[ChatBottomView alloc]init];
    bottom.BottominputView.delegate=self; //实现输入框的代理
    bottom.delegate=self;
    bottom.x=0;
    bottom.y=self.view.height-bottom.height;
    [self.view addSubview:bottom];
    self.chatBottom=bottom;
    //传递输入框
    self.bottomInputView=bottom.BottominputView;
    //监听键盘的移动
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keybordAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keybordHide:) name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark 底部工具栏按钮的点击
-(void)chatbottomView:(ChatBottomView *)bottomView buttonTag:(BottomButtonType)buttonTag
{
    switch (buttonTag) {
        case BottomButtonTypeEmotion:  //打开表情键盘
            [self openEmotion];
            break;
        case BottomButtonTypeAddPicture:  //打开添加图片键盘
            [self addPicture];
            break;
        case BottomButtonTypeAudio:  //
            
            break;
      
    }
}
#pragma mark 打开表情键盘
-(void)openEmotion
{
    //切换键盘
    self.changeKeyboard=YES;
    if(self.bottomInputView.inputView){  //自定义的键盘
        self.bottomInputView.inputView=nil;
        self.chatBottom.emotionStatus=NO;
    }else{  //系统自带的键盘
        
        self.bottomInputView.inputView=self.kerboard;
        self.chatBottom.emotionStatus=YES;
    }
    
    
    [self.bottomInputView resignFirstResponder];
    //切换完成
    self.changeKeyboard=NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.bottomInputView becomeFirstResponder];
    });

}
#pragma mark 打开添加图片的键盘
-(void)addPicture
{
    
//    NSLog(@"addPicture");
//    if (mFaceView)
//    {//如果当前还在显示表情视图，则隐藏他先
//        [self faceBtnClick:self.mFaceBtn];
//    }
//    
//    if (sender.selected)
//    {//隐藏更多界面，显示键盘输入
//        
//        [mMoreView removeFromSuperview];
//        mMoreView = nil;
//        
//        mBottomConstraintTextView.constant = -kDefaultBottomTextView_SupView;
//        
//        [self.mInputTextView becomeFirstResponder];
//    }else
//    {//隐藏键盘，显示更多界面
//        
//        mMoreView = [[WSChatMessageMoreView alloc]init];
//        mMoreView.translatesAutoresizingMaskIntoConstraints = NO;
//        
//        [self addSubview:mMoreView];
//        
//        
//        [mMoreView autoPinEdgeToSuperviewEdge:ALEdgeLeading];
//        [mMoreView autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
//        [mMoreView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.mInputTextView withOffset:6];
//        
//        mBottomConstraintTextView.constant = -(kDefaultBottomTextView_SupView+[mMoreView intrinsicContentSize].height);
//        
//        [self.mInputTextView resignFirstResponder];
//    }
//    
//    [self invalidateIntrinsicContentSize];
//    
//    sender.selected = !sender.selected;
    
    
}
#pragma mark  键盘将要出现的时候
-(void)keybordAppear:(NSNotification*)note
{
    double duration=[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
   
    CGRect keyboardF=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:duration animations:^{
        //滚回最后一行
        [self scrollToBottom];
        
        self.chatBottom.transform=CGAffineTransformMakeTranslation(0, -keyboardF.size.height);
        //如果数组中的模型大于5个的话 不需要改变高度 只改变位置
        if(self.frameModelArr.count>5){
            self.table.transform=CGAffineTransformMakeTranslation(0, -keyboardF.size.height);
            return;
        }
         //数组中得模型数量小于等于5的话 才改变tableView的高度
        if(self.isChangeHeight==NO){
           
            if(ScreenHeight<568){ //是iphone4s/4
                self.table.height=self.table.height-keyboardF.size.height;
                
            }else{  //是iphone5/5s/6/6plus
               self.table.height=self.table.height-BottomHeight*0.5-keyboardF.size.height;
                //NSLog(@"iphone5/5s/6/6plus");
            }

            self.isChangeHeight=YES;
        }
//
 
  
    }];
}
#pragma mark 键盘将要隐藏的时候
-(void)keybordHide:(NSNotification*)note
{
    if(self.changeKeyboard) return ;
    
    double duration=[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //CGRect keyboardF=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:duration animations:^{
        self.chatBottom.transform=CGAffineTransformIdentity;
        //如果数组中的模型大于5个的话 不需要改变高度 只改变位置
        if(self.frameModelArr.count>5){
            self.table.transform=CGAffineTransformIdentity;
        }
        if(self.table.height<self.tableViewHeight){
              self.table.height=self.tableViewHeight;  //tableView回到原来的高度
        }
      
        self.isChangeHeight=NO; //设置NO当键盘keybordAppear 就又可以调整tableView的高度了
    }];
}


#pragma mark  当表情选中的时候调用
- (void)emotionDidSelected:(NSNotification *)note
{
    HMEmotion *emotion = note.userInfo[HMSelectedEmotion];
    
    // 1.拼接表情
    [self.bottomInputView appendEmotion:emotion];
    
    // 2.检测文字长度
    [self textViewDidChange:self.bottomInputView];
}


#pragma mark  当点击表情键盘上的删除按钮时调用

- (void)emotionDidDeleted:(NSNotification *)note
{
    // 往回删
    [self.bottomInputView deleteBackward];
}


#pragma mark  当textView的文字改变就会调用
- (void)textViewDidChange:(UITextView *)textView
{
    //self.navigationItem.rightBarButtonItem.enabled = textView.hasText;
}


#pragma mark 当时图开始滚动的时候  隐藏键盘
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
#pragma mark 去掉两边空格的方法
-(NSString*)trimStr:(NSString*)str
{
    str=[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return str;
}
#pragma mark 滚到最后一行的方法
-(void)scrollToBottom
{
    //如果数组李米娜没有值 返回
    if(!self.frameModelArr.count) return;
    // 2.让tableveiw滚动到最后一行
    NSIndexPath *path = [NSIndexPath indexPathForRow:self.frameModelArr.count -1 inSection:0];
    
    /*
     AtIndexPath: 要滚动到哪一行
     atScrollPosition:滚动到哪一行的什么位置
     animated:是否需要滚动动画
     */
   // NSLog(@"%zd  数组个数%zd",path.row,self.frameModelArr.count);

 [self.table scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
}

#pragma  mark 去掉@符号
-(NSString*)cutStr:(NSString*)str
{
    NSArray *arr=[str componentsSeparatedByString:@"@"];
    return arr[0];
}

-(void)dealloc
{
    [Mynotification removeObserver:self];
   
}

@end
