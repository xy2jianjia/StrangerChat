//

//  RCloudMessage
//
//  Created by wjb on 15/6/3.
//  Copyright (c) 2015年 wbj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Message.h"
#import "DHUserForChatModel.h"
@interface DBManager : NSObject
/**
 *  单例
 *
 *  @return 返回DBManager对象
 */
+ (DBManager *)shareInstance;

// 插入聊天数据
+ (void)insertMessageDataDBWithModel:(Message *)model userId:(NSString *)userId;
// 修改发送成功的消息
+ (void)updateSendMessagesToSucessWithAccount:(NSString *)account chatId:(NSString *)chatId;
/**
 *  聊天过程，某条消息是否存在记录
 *
 *  @param messageId 消息id
 *  @param fromUserAccount 谁发给我（那个人的id）
 *
 *  @return BOOL
 */
+ (BOOL) checkMessageWithMessageId:(NSString *)messageId targetId:(NSString *)targetId;
// 查询某人消息列表
+ (NSMutableArray *)selectMessageDBWithRoomCode:(NSString *)roomCode targetId:(NSString *)targetId;
/**
 *  获取当前用户聊天列表
 *
 *  @return 
 */
+ (NSMutableArray *)getChatListWithUserId:(NSString *)targetId roomCode:(NSString *)roomCode;
/**
 *  获取当前用户下所有的消息列表
 *
 *  @param userId
 *
 *  @return
 */
+ (NSMutableArray *)getChatListWithCurrentUserId:(NSString *)userId;
/**
 *  将要聊天的用户信息插入数据库
 *
 *  @param item
 *  @param userId 当前用户信息
 */
+ (void) insertChatToDBWithTargetId:(NSString *)targetId tagetName:(NSString *)targetName headerImage:(NSString *)headerImage time:(NSString *)createTime body:(NSString *)body currentUserId:(NSString *)userId;
/**
 *  当前聊天对象是否存在记录
 *
 *  @param targetId 聊天对象id
 *  @param userId 当前用户
 *
 *  @return BOOL
 */
+ (BOOL) checkChatWithTargetId:(NSString *)targetId userId:(NSString *)userId;
/**
 *  用户是否存在
 *
 *  @param userId
 *
 *  @return
 */
+ (BOOL) checkUserWithUsertId:(NSString *)userId;
/**
 *  插入用户数据
 *
 *  @param item
 */
+ (void) insertUserToDBWithItem:(DHUserForChatModel *)item;
/**
 *  获取某人数据
 *
 *  @param userId
 *
 *  @return
 */
+ (DHUserForChatModel *)getUserWithCurrentUserId:(NSString *)userId;

@end
