//
//  SocketManager.m
//  StrangerChat
//
//  Created by long on 15/11/23.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "SocketManager.h"
//#import "RCDChatViewController.h"
#import "ChatController.h"
@implementation SocketManager

static SocketManager* _socketManager = nil;

+(instancetype) shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _socketManager = [[super allocWithZone:NULL] init] ;
    }) ;
    
    return _socketManager ;
}

+(id) allocWithZone:(struct _NSZone *)zone
{
    return [SocketManager shareInstance] ;
}

-(id) copyWithZone:(struct _NSZone *)zone
{
    return [SocketManager shareInstance] ;
}

// --------------------------------------------

#pragma mark --- 懒加载 ---
- (GCDAsyncSocket *)client {
    if (!_client) {
        _client = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)];
    }
    return _client;
}

- (void)ClientConnectServer
{
    //1.连接 -->三次握手
    //2.读 写 都是一样的,我们用一个timer去负责一致读取
    //3.端口  192.168.0.194:9066  -------->115.236.55.163
    NSError *error = nil;
//    [self.client connectToHost:@"115.236.55.163" onPort:9066 error:&error];
    [self.client connectToHost:@"192.168.0.195" onPort:9066 error:&error];
//    [self.client connectToHost:@"192.168.1.23" onPort:9066 error:&error];
    NSLog(@"----连接client--");
    // 添加心跳
    self.timer = [NSTimer scheduledTimerWithTimeInterval:50.0 target:self selector:@selector(heartBeatAction) userInfo:nil repeats:YES];
    

}

#pragma mark --- GCDAsyncSocket ---
/**
 *  成功连接 三次握手结束了
 *
 *  @param server 服务器的实例
 *  @param host 服务器的IP地址
 *  @param port 服务器的端口号
 */

- (void)socket:(GCDAsyncSocket *)server didConnectToHost:(NSString *)host port:(uint16_t)port {
    
//    NSLog(@"---连接-----");
    //开启timer 来读取 数据
    //    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(readDataFromServer) userInfo:nil repeats:YES];
    [self readDataFromServer];
}


- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    
    NSString * str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSRange range = [str rangeOfString:@"{"];//匹配得到的下标
    NSString *str3 = [str substringFromIndex:range.location];//截取下标2之后的字符串
    NSString *str4 = [str substringWithRange:NSMakeRange(1,6)];
    //NSLog(@"--str3-%@--str4-%@",str3,str4);
    NSDictionary *dict = [self dictionaryWithJsonString:str3];
    if ([str4 integerValue] == 101201) { // 登陆
        if ([dict[@"responseCode"] integerValue] == 200) {
            NSLog(@"服务器连接成功");
            [self sendRegristMessage];
            
        }
        
    }else if ([str4 integerValue] == 101202){ //注册成功
        if ([dict[@"responseCode"] integerValue] == 200) {
            NSDictionary *dict2 = dict[@"head"];
            NSString *token = dict2[@"token"];
            [NSGetTools updateTokenWithStr:token];
            [Mynotification postNotificationName:@"getOffLineMessage" object:nil];
            [Mynotification postNotificationName:@"getRoBotInfo" object:nil];
        }
    }else if ([str4 integerValue] == 102201){ // 开房间结果
        if ([dict[@"responseCode"] integerValue] == 200) {
            NSDictionary *dict3 = dict[@"body"];
            NSString *roomCode = dict3[@"roomCode"];
            [NSGetTools updateRoomCodeWithStr:roomCode];// 房间编号
            [Mynotification postNotificationName:@"createRoomForChat" object:dict];
            [Mynotification postNotificationName:@"createRoomForTouch" object:dict];
            [Mynotification postNotificationName:@"createRoomForTouchDetail" object:dict];
        }
        
    }else if ([str4 integerValue] == 102202){ // 退房结果
        if ([dict[@"responseCode"] integerValue] == 200) {
            NSLog(@"%s_%d_退房结果",__FUNCTION__,__LINE__);
        }
    }else if ([str4 integerValue] == 102203){ // 发送消息反馈
        if ([dict[@"responseCode"] integerValue] == 200) {
            NSLog(@"%s_%d_发送消息成功-",__FUNCTION__,__LINE__);
            NSDictionary *bodyDict = dict[@"body"];
            NSString *chatId = bodyDict[@"chatId"];
            NSDictionary *accountDict = bodyDict[@"to"];
            NSString *account =  accountDict[@"userAccount"];
            [DBManager updateSendMessagesToSucessWithAccount:account chatId:chatId];// 修改发送成功的消息
        }else{
            // 发送失败,提示用户--红点
        }
        [Mynotification postNotificationName:SendMessageResult object:dict];
    }else if ([str4 integerValue] == 102204){ // 收到消息,存到数据库
        if ([dict[@"responseCode"] integerValue] == 200) {
            [Mynotification postNotificationName:@"recieveOnLineMessage" object:dict];
            [Mynotification postNotificationName:@"recieveOnLineMessageOutOfChatVc" object:dict];
            
        }
    }else if ([str4 integerValue] == 102205){ // 已读消息的反馈
        NSLog(@"%s_%d_已阅读消息",__FUNCTION__,__LINE__);
        
    }else if ([str4 integerValue] == 103204){ // 接受离线消息
        [Mynotification postNotificationName:@"recieveOffLineMessage" object:dict];
    }else if ([str4 integerValue] == 101211) { // 续连反馈
        NSLog(@"续连");
    }else if ([str4 integerValue] == 100102) { // 心跳
        NSLog(@"心跳返回");
    }else if ([str4 integerValue] == 102207){
        // 发送反馈结果到界面。
//       反馈结果 $102207|154{"body":{"userAccount":"10414800"},"head":{"seqcode":2,"token":"b4b43969-c2fb-4978-b380-01317bcb8df3"},"responseCode":200,"responseMsg":"无聊天记录"}
        [Mynotification postNotificationName:GetMessageResult object:dict];
    }else if ([str4 integerValue] == 104201){
//      机器人反馈结果： $ 104201|len{"head":{"seqCode":4,"token":String},"body":{"fromUserAccount":String，"content":{" message":String ," messageType ":Integer,"timeStamp":String}content} 消息体}
        NSDictionary *resultDict = [dict objectForKey:@"body"];
        [[NSUserDefaults standardUserDefaults] setObject:resultDict forKey:@"rebotResult"];
        if (resultDict) {
            [Mynotification postNotificationName:@"sendRobotMessage" object:nil];
        }
    }else if ([str4 integerValue] == 104202){
        [Mynotification postNotificationName:@"recieveRobotMessage" object:dict];
    }
}

//(2.2)如客户端的socket连接im服务成功后，发送账号信息给im服务
- (void)sendRegristMessage
{
    NSNumber *account = [NSGetTools getUserID];
    NSNumber *vipNum = [NSGetTools getUserVipInfo];
    NSNumber *seqCodeNum = [NSNumber numberWithInt:1];
    NSNumber *userVisterNum  = [NSNumber numberWithInt:2];
    NSNumber *userStateNum = [NSNumber numberWithInt:1];
    NSNumber *userSexNum = [NSGetTools getUserSexInfo];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSDictionary *dict2 = [NSDictionary dictionaryWithObject:seqCodeNum forKey:@"seqCode"];
    NSDictionary *dict3 = [NSDictionary dictionaryWithObjectsAndKeys:account,@"userAccount",userVisterNum,@"userDevice",userStateNum,@"userState",userSexNum,@"sex",vipNum,@"userRole", nil];
    
    [dict setValue:dict2 forKey:@"head"];
    [dict setValue:dict3 forKey:@"body"];
    NSString *headStr = @"$101102|";
    //NSString *jsonStr = [self dictionaryToJson:dict];
    NSString *jsonStr = [dict JSONString];
    NSInteger lengthStr = [jsonStr length];
    NSString *regristStr = [NSString stringWithFormat:@"%@%ld%@\r\n",headStr,lengthStr,jsonStr];
    
    // 注册
    [NSGetTools updateChatRegistWithStr:@"isRegister"];
//    NSLog(@"发送验证---%@",regristStr);
    [self.client writeData:[regristStr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
}


/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

// 心跳

- (void)heartBeatAction
{

    NSNumber *num = [NSNumber numberWithInt:1];
    NSDictionary *heartDict = [NSDictionary dictionaryWithObject:num forKey:@"keepAlive"];
    NSString *headStr = @"$100101|";
    NSString *jsonStr = [heartDict JSONString];
    NSInteger lengthStr = [jsonStr length];
    NSString *messageStr = [NSString stringWithFormat:@"%@%ld%@\r\n",headStr,lengthStr,jsonStr];
    NSLog(@"发送心跳包---%@",messageStr);
    [self.client writeData:[messageStr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
}
#pragma mark --- 计时器 ---
- (void)readDataFromServer {
    [self.client readDataWithTimeout:-1 tag:0];
    //带1.0f秒延迟的递归
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self readDataFromServer];
    });
    
}

#pragma mark  ---- 开房间和发送消息----
// 开房间
- (void)creatRoomWithString:(NSString *)string account:(NSString *)account
{
    //NSString *userAccount = [NSGetTools getUserAccount];
    NSString *token = [NSGetTools getToken];
    NSLog(@"getToken:%@",token);
    NSNumber *seqCodeNum = [NSNumber numberWithInt:6];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSDictionary *dict2 = [NSDictionary dictionaryWithObjectsAndKeys:seqCodeNum,@"seqCode",token,@"token", nil];
    NSDictionary *dict3 = [NSDictionary dictionaryWithObjectsAndKeys:account,@"userAccount", nil];
    NSMutableDictionary *dict4 = [NSMutableDictionary dictionary];
    [dict4 setValue:dict3 forKey:@"to"];
    [dict setValue:dict2 forKey:@"head"];
    [dict setValue:dict4 forKey:@"body"];
    NSString *headStr = @"$102101|";
    //NSString *jsonStr = [self dictionaryToJson:dict];
    NSString *jsonStr = [dict JSONString];
    NSInteger lengthStr = [jsonStr length];
    NSString *roomStr = [NSString stringWithFormat:@"%@%ld%@\r\n",headStr,lengthStr,jsonStr];
    NSLog(@"---发送开房间消息--%@",roomStr);
    [self.client writeData:[roomStr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
}

// 退房间
- (void)exitRoomWithString:(NSString *)string account:(NSString *)account
{
    //NSString *userAccount = [NSGetTools getUserAccount];
    NSString *token = [NSGetTools getToken];
    NSNumber *seqCodeNum = [NSNumber numberWithInt:8];
    NSString *roomCode = [NSGetTools getRoomCode];// 房间号
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSDictionary *dict2 = [NSDictionary dictionaryWithObjectsAndKeys:seqCodeNum,@"seqCode",token,@"token", nil];
    
    NSMutableDictionary *dict4 = [NSMutableDictionary dictionaryWithObjectsAndKeys:roomCode,@"roomCode", nil];
    [dict setValue:dict2 forKey:@"head"];
    [dict setValue:dict4 forKey:@"body"];
    NSString *headStr = @"$102102|";
    NSString *jsonStr = [dict JSONString];
    NSInteger lengthStr = [jsonStr length];
    NSString *exitStr = [NSString stringWithFormat:@"%@%ld%@\r\n",headStr,lengthStr,jsonStr];
    NSLog(@"---退房间消息--%@",exitStr);
    [self.client writeData:[exitStr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
}

// 发送消息
- (void)sendMessageWithMesssageModel:(Message *)item
{
    NSString *token = [NSGetTools getToken];
    NSString *roomName = item.roomName;
    NSString *roomCode = item.roomCode;
    NSNumber *seqCodeNum = [NSNumber numberWithInt:10];
   // NSNumber *msgType = [NSNumber numberWithInt:1];// 消息类型 1:文本 2:语音 3:视频 4:普通文件
    // 最外层
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    // head
    NSDictionary *dict2 = [NSDictionary dictionaryWithObjectsAndKeys:seqCodeNum,@"seqCode",token,@"token", nil];
    // body
    NSMutableDictionary *dict4 = [NSMutableDictionary dictionary];
    // to
    NSDictionary *dict3 = [NSDictionary dictionaryWithObjectsAndKeys:item.toUserAccount,@"userAccount", nil];
    // content
    NSDictionary *dict5 = [NSDictionary dictionaryWithObjectsAndKeys:item.message,@"message",item.messageType,@"messageType", nil];
    
    [dict4 setValue:item.messageId forKey:@"chatId"];
    [dict4 setValue:dict3 forKey:@"to"];
    [dict4 setValue:dict5 forKey:@"content"];
    [dict4 setValue:roomName forKey:@"roomName"];
    [dict4 setValue:roomCode forKey:@"roomCode"];
    [dict setValue:dict2 forKey:@"head"];
    [dict setValue:dict4 forKey:@"body"];
    
    NSString *headStr = @"$102103|";
    //NSString *jsonStr = [self dictionaryToJson:dict];
    NSString *jsonStr = [dict JSONString];
    NSInteger lengthStr = [jsonStr length];
    NSString *messageStr = [NSString stringWithFormat:@"%@%ld%@\r\n",headStr,lengthStr,jsonStr];
    NSLog(@"---发送消息---%@",messageStr);
    [self.client writeData:[messageStr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
}

// 发送已读消息的信息
- (void)sendAlreadyReadMsgInfoWithModel:(Message *)model
{
    NSString *token = [NSGetTools getToken];
    NSNumber *seqCodeNum = [NSNumber numberWithInt:12];
    // 最外层
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    // head
    NSDictionary *dict2 = [NSDictionary dictionaryWithObjectsAndKeys:seqCodeNum,@"seqCode",token,@"token", nil];
    // body
    NSMutableDictionary *dict4 = [NSMutableDictionary dictionary];
    
    [dict4 setValue:model.messageId forKey:@"id"];
    [dict setValue:dict2 forKey:@"head"];
    [dict setValue:dict4 forKey:@"body"];
    
    NSString *headStr = @"$103102|";
    NSString *jsonStr = [dict JSONString];
    NSInteger lengthStr = [jsonStr length];
    NSString *messageStr = [NSString stringWithFormat:@"%@%ld%@\r\n",headStr,lengthStr,jsonStr];
    NSLog(@"---发送已读消息---%@",messageStr);
    [self.client writeData:[messageStr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    
}
//$102107|len{"head":{"seqCode":12,"token":String 令牌},"body":{"from":{"userAccount":String} "sendTime":String ->开始时间}协议体}
- (void)getMessageWithTargetId:(NSString *)userId{
    NSString *token = [NSGetTools getToken];
//    NSNumber *userId = [NSGetTools getUserID];
    // 最外层
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    // head
    NSDictionary *dict2 = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:12],@"seqCode",token,@"token",nil];
    // body
    NSMutableDictionary *dict4 = [NSMutableDictionary dictionary];
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    [fmt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *date = [fmt stringFromDate:[NSDate date]];
    NSDictionary *temp = [NSDictionary dictionaryWithObjectsAndKeys:userId,@"userAccount", nil];
    NSDictionary *temp1 = [NSDictionary dictionaryWithObjectsAndKeys:date,@"sendTime", nil];
    [dict4 setValue:temp1 forKey:@"sendTime"];
    [dict4 setValue:temp forKey:@"from"];
    [dict setValue:dict2 forKey:@"head"];
    [dict setValue:dict4 forKey:@"body"];
    
    NSString *headStr = @"$102107|";
    NSString *jsonStr = [dict JSONString];
    NSInteger lengthStr = [jsonStr length];
    NSString *messageStr = [NSString stringWithFormat:@"%@%ld%@\r\n",headStr,lengthStr,jsonStr];
//    NSLog(@"%@",messageStr);
    [self.client writeData:[messageStr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
}
//$103104|len{"head":{"seqCode":4,"token":String}，Body:{ "toUserAccount ":Stsring,}}
//- (void)getOffLineMessageWithToken:(NSString *)token correntUserId:(NSString *)correntUserId{
////$102107|107{"head":{"token":"1e6f4406-7b76-4d58-8a76-c811755a6509","seqCode":"4"},"body":{"toUserAccount":"10414800"}}
//    // 最外层
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    NSMutableDictionary *headDict = [NSMutableDictionary dictionary];
//    NSMutableDictionary *bodyDict = [NSMutableDictionary dictionary];
//    [headDict setObject:token forKey:@"token"];
//    [headDict setObject:@"4" forKey:@"seqCode"];
//    [bodyDict setObject:correntUserId forKey:@"toUserAccount"];
//    [dict setValue:headDict forKey:@"head"];
//    [dict setValue:bodyDict forKey:@"body"];
//    NSString *headStr = @"$103104|";
//    NSString *jsonStr = [dict JSONString];
//    NSInteger lengthStr = [jsonStr length];
//    NSString *messageStr = [NSString stringWithFormat:@"%@%ld%@\r\n",headStr,lengthStr,jsonStr];
//    [self.client writeData:[messageStr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
//}
//$ 104101|len{"head":{"seqCode":4,"token":String}，“body":{"fromUserAccount":String 上个机器人的账号，可以多个，最后一个账号去掉逗号}}
- (void)getRobotWithToken:(NSString *)token fromUserAccount:(NSString *)fromUserAccount{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSMutableDictionary *headDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *bodyDict = [NSMutableDictionary dictionary];
    [headDict setObject:token forKey:@"token"];
    [headDict setObject:@"4" forKey:@"seqCode"];
    // 第一次请求，不传该字段
    if ([fromUserAccount length] != 0) {
        [bodyDict setObject:fromUserAccount forKey:@"toUserAccount"];
    }else{
       [bodyDict setObject:@"" forKey:@"toUserAccount"];
    }
    
    [dict setValue:headDict forKey:@"head"];
    [dict setValue:bodyDict forKey:@"body"];
    NSString *headStr = @"$104101|";
    NSString *jsonStr = [dict JSONString];
    NSInteger lengthStr = [jsonStr length];
    NSString *messageStr = [NSString stringWithFormat:@"%@%ld%@\r\n",headStr,lengthStr,jsonStr];
    [self.client writeData:[messageStr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
}


// 发送机器人消息
//$ 104102|len{"head":{"seqCode":4,"token":String},"body":{"toUserAccount":String,机器人" contentType ":Integer ->机器人内容类别"content":{" message":String , 消息内容" messageType":Integer,消息类型"timeStamp":String 时间戳}}}
- (void)sendRobotMessageWithToken:(NSString *)token{
//$104102|203{"head":{"token":"1e6f4406-7b76-4d58-8a76-c811755a6509","seqCode":"4"},"body":{"contentType":1,"content":{"message":"机器人消息","timeStamp":"2015-12-29 11:43:35","messageType":1},"toUserAccount":"10414800"}}
    
    NSDictionary *robotDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"rebotResult"];
    NSDictionary *msgDict = [robotDict objectForKey:@"content"];
    // 最外层
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSMutableDictionary *headDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *bodyDict = [NSMutableDictionary dictionary];
    [headDict setObject:token forKey:@"token"];
    [headDict setObject:@"4" forKey:@"seqCode"];
    [bodyDict setObject:[robotDict objectForKey:@"toUserAccount"] forKey:@"toUserAccount"];
    [bodyDict setObject:[robotDict objectForKey:@"contentType"] forKey:@"contentType"];
    NSDictionary *contentDict = [NSDictionary dictionaryWithObjectsAndKeys:[msgDict objectForKey:@"message"],@"message",[msgDict objectForKey:@"messageType"], @"messageType",[msgDict objectForKey:@"timeStamp"],@"timeStamp", nil];
    [bodyDict setObject:contentDict forKey:@"content"];
    
    [dict setValue:headDict forKey:@"head"];
    [dict setValue:bodyDict forKey:@"body"];
    NSString *headStr = @"$104102|";
    NSString *jsonStr = [dict JSONString];
    NSInteger lengthStr = [jsonStr length];
    NSString *messageStr = [NSString stringWithFormat:@"%@%ld%@\r\n",headStr,lengthStr,jsonStr];
    [self.client writeData:[messageStr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
}
/**
 *  发送已阅$103102|len{"head":{"seqCode":12,"token":String 令牌},"body":{"id":long 消息id}协议体}
 *
 *  @param token
 *  @param messageId
 */
- (void)readMessageWithToken:(NSString *)token messageId:(NSString *)messageId{
    
    // 最外层
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSMutableDictionary *headDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *bodyDict = [NSMutableDictionary dictionary];
//    $103102|len{"head":{"seqCode":12,"token":String 令牌},"body":{"id":long 消息id}协议体}
    [headDict setObject:token forKey:@"token"];
    [headDict setObject:@"12" forKey:@"seqCode"];
    [bodyDict setObject:messageId forKey:@"id"];
    [dict setValue:headDict forKey:@"head"];
    [dict setValue:bodyDict forKey:@"body"];
    NSString *headStr = @"$103102|";
    NSString *jsonStr = [dict JSONString];
    NSInteger lengthStr = [jsonStr length];
    NSString *messageStr = [NSString stringWithFormat:@"%@%ld%@\r\n",headStr,lengthStr,jsonStr];
    [self.client writeData:[messageStr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
}

//获取当前屏幕显示的viewcontroller(聊天界面)
- (UIViewController *)activityViewController
{
    UIViewController *vc = nil;
    
    if ([[UIApplication sharedApplication].keyWindow.rootViewController isKindOfClass:[UINavigationController class]]) {
        vc = [(UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController visibleViewController];
    }
    
    return vc;
}

@end
