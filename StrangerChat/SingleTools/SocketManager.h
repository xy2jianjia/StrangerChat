//
//  SocketManager.h
//  StrangerChat
//
//  Created by long on 15/11/23.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Message.h"
typedef void (^ablock)(Message *model);

@interface SocketManager : NSObject <GCDAsyncSocketDelegate>

+(instancetype) shareInstance;
@property (nonatomic, strong) ablock block;// 回调用的
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) GCDAsyncSocket *client;


- (void)ClientConnectServer;


#pragma mark  ----房间和消息----
// 开房间
- (void)creatRoomWithString:(NSString *)string account:(NSString *)account;
// 退房间
- (void)exitRoomWithString:(NSString *)string account:(NSString *)account;
// 发消息
- (void)sendMessageWithMesssageModel:(Message *)model;
// 发送已读消息的信息
- (void)sendAlreadyReadMsgInfoWithModel:(Message *)model;
- (void)getMessageWithTargetId:(NSString *)userId;
/**
 *  离线消息
 *
 *  @param token 用户token
 */
//- (void)getOffLineMessageWithToken:(NSString *)token correntUserId:(NSString *)correntUserId;
/**
 *  获取机器人
 *
 *  @param token           用户token
 *  @param fromUserAccount 上个机器人的账号，第一次请求不传该字段
 */
- (void)getRobotWithToken:(NSString *)token fromUserAccount:(NSString *)fromUserAccount;

/**
 *  发送机器人消息
 */
- (void)sendRobotMessageWithToken:(NSString *)token;
/**
 *  发送读取消息到服务器
 *
 *  @param token     token
 *  @param messageId 消息id
 */
- (void)readMessageWithToken:(NSString *)token messageId:(NSString *)messageId;
@end
