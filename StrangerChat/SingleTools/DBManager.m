//
//  RCloudMessage
//
//  Created by wbj on 15/6/3.
//  Copyright (c) 2015年 wbj. All rights reserved.
//

#import "DBManager.h"
#import "DBHelper.h"
@implementation DBManager

static NSString * const MESSAGETABLE   = @"MESSAGETABLE";
static NSString * const CHATLISTTABLE = @"CHATLISTTABLE";
static NSString * const USERTABLE = @"USERTABLE";
#pragma mark -
#pragma mark - Private Methods

//创建用户存储表
-(void)createUserTable{
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
//        if (![DBHelper isTableOK: MESSAGETABLE withDB:db]) {
//            NSString *createTableSQL = @"CREATE TABLE MESSAGETABLE (chatId text,icon text,myIcon text,account text,userDevice text,content text,createtime text,msgId text,msgType text,roomCode text,type text,mark text,userId text)";
//            [db executeUpdate:createTableSQL];
//        }
        if (![DBHelper isTableOK: MESSAGETABLE withDB:db]) {
            NSString *createTableSQL = @"CREATE TABLE MESSAGETABLE (messageId text,messageType text,message text,timeStamp text,fromUserAccount text,fromUserDevice text,toUserAccount text,token text,roomCode text,roomName text,userId text,targetId text)";
            [db executeUpdate:createTableSQL];
        }
        if (![DBHelper isTableOK: CHATLISTTABLE withDB:db]) {
            NSString *createTableSQL = @"CREATE TABLE CHATLISTTABLE (targetId text,targetName text,headerImage text,body text,time text ,userId text)";
            [db executeUpdate:createTableSQL];
        }
        if (![DBHelper isTableOK: USERTABLE withDB:db]) {
            NSString *createTableSQL = @"CREATE TABLE USERTABLE (b1 text,b143 text,b144 text,b19 text,b24 text,b29 text,b32 text,b33 text,b37 text,b46 text,b52 text,b57 text,b62 text,b67 text,b69 text,b75 text,b80 text,b86 text,b87 text,b9 text,b94 text)";
            [db executeUpdate:createTableSQL];
        }
        
    }];
}
//@property (nonatomic,strong) NSString *b1;// 年龄
//@property (nonatomic,strong) NSString *b143;// 用户类型 1:注册用户,2机器人
//@property (nonatomic,strong) NSString *b144;// 是否vip 1:vip 2:非vip
//@property (nonatomic,strong) NSString *b19;//学历 1:初中及以下 2:高中 3:专科 4:本科 5:研究生 6:博士及以上
//@property (nonatomic,strong) NSString *b24;// 兴趣爱好-----
//@property (nonatomic,strong) NSString *b29;// 是否有车
//@property (nonatomic,strong) NSString *b32;// 是否有房
//@property (nonatomic,strong) NSString *b33;// 身高
//@property (nonatomic,strong) NSString *b37;// 个性特征-----
//@property (nonatomic,strong) NSString *b46;// 婚姻状态
//@property (nonatomic,copy) NSString *b52;// 昵称
//@property (nonatomic,copy) NSString *b57;// 头像连接
//@property (nonatomic,strong) NSString *b62;// 职业--
//@property (nonatomic,strong) NSString *b67;// 省份
//@property (nonatomic,strong) NSString *b69;// 性别
//@property (nonatomic,strong) NSString *b75;// 呢成审核状态 1:通过 2:待审核 3:未通过
//@property (nonatomic,strong) NSString *b80;// 用户ID
//@property (nonatomic,strong) NSString *b86;// 最高收入
//@property (nonatomic,strong) NSString *b87;// 最低收入
//@property (nonatomic,strong) NSString *b9;// 城市
//@property (nonatomic,strong) NSString *b94;// 距离  /m
#pragma mark -
#pragma mark - Singleton
+ (DBManager*)shareInstance{
    static DBManager* instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
        [instance createUserTable];
    });
    return instance;
}
/**
 *  聊天过程，某条消息是否存在记录
 *
 *  @param chatId 消息id
 *  @param userId 当前用户id
 *
 *  @return BOOL
 */
+ (BOOL) checkMessageWithMessageId:(NSString *)messageId targetId:(NSString *)targetId{
    return [[DBManager shareInstance] checkMessageWithMessageId:messageId targetId:targetId];
}
//messageId text,messageType text,timeStamp text,fromUserAccount text,fromUserDevice text,toUserAccount text,token text,userId text
- (BOOL) checkMessageWithMessageId:(NSString *)messageId targetId:(NSString *)targetId{
    NSString *sql10 = [NSString stringWithFormat:@"SELECT * FROM MESSAGETABLE WHERE messageId = '%@' AND targetId = '%@'",messageId,targetId];
    __block BOOL flag = NO;
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql10];
        while ([rs next]) {
            flag = YES;
        }
        [rs close];
    }];
    return flag;
}
// 插入聊天数据
+ (void)insertMessageDataDBWithModel:(Message *)item userId:(NSString *)userId{
    [[DBManager shareInstance] insertMessageDataDBWithModel:item userId:userId];
}
- (void)insertMessageDataDBWithModel:(Message *)item userId:(NSString *)userId{
    NSString * insertSql = [NSString stringWithFormat:@"INSERT INTO MESSAGETABLE (messageId ,messageType ,message ,timeStamp ,fromUserAccount ,fromUserDevice ,toUserAccount ,token, roomCode ,roomName ,userId ,targetId) VALUES  ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",item.messageId,item.messageType,item.message,item.timeStamp,item.fromUserAccount,item.fromUserDevice,item.toUserAccount,item.token,item.roomCode,item.roomName,userId,item.targetId];
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:insertSql];
    }];
}
+ (NSMutableArray *)getChatListWithUserId:(NSString *)targetId roomCode:(NSString *)roomCode{
    return [[DBManager shareInstance] getChatListWithUserId:targetId roomCode:roomCode];
}
- (NSMutableArray *)getChatListWithUserId:(NSString *)targetId roomCode:(NSString *)roomCode{
    NSMutableArray *allMutableArray = [NSMutableArray array];
    NSString * sql=[NSString stringWithFormat:@"select *from messagetable where userId = '%@' group by toUserAccount order by timeStamp desc",targetId];
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:sql];
        while ([result next]) {
            Message *item = [Message new];
            // messageId ,messageType ,message ,timeStamp ,fromUserAccount ,fromUserDevice ,toUserAccount ,token ,userId
            item.messageId = [result stringForColumn:@"messageId"];
            item.messageType = [result stringForColumn:@"messageType"];
            item.message = [result stringForColumn:@"message"];
            item.timeStamp = [result stringForColumn:@"timeStamp"];
            item.fromUserDevice = [result stringForColumn:@"fromUserDevice"];
            item.fromUserAccount = [result stringForColumn:@"fromUserAccount"];
            item.toUserAccount = [result stringForColumn:@"toUserAccount"];
            item.token = [result stringForColumn:@"token"];
            item.roomCode = [result stringForColumn:@"roomCode"];
            item.roomName = [result stringForColumn:@"roomName"];
            item.userId = [result stringForColumn:@"userId"];
            item.targetId = [result stringForColumn:@"targetId"];
            [allMutableArray addObject:item];
        }
        [result close];
    }];
    return allMutableArray;
}





// 修改发送成功的消息
+ (void)updateSendMessagesToSucessWithAccount:(NSString *)account chatId:(NSString *)chatId{
    [[DBManager shareInstance] updateSendMessagesToSucessWithAccount:account chatId:chatId];
}
- (void)updateSendMessagesToSucessWithAccount:(NSString *)account chatId:(NSString *)chatId{
    NSString * str=[NSString stringWithFormat:@"update MESSAGETABLE set mark = '%d' where chatId = '%@'",1,chatId];
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:str];
    }];
}

// 查询某人消息列表
+ (NSMutableArray *)selectMessageDBWithRoomCode:(NSString *)roomCode targetId:(NSString *)targetId{
    return [[DBManager shareInstance] selectMessageDBWithRoomCode:roomCode targetId:targetId];
    
}
- (NSMutableArray *)selectMessageDBWithRoomCode:(NSString *)roomCode targetId:(NSString *)targetId{
    NSMutableArray *allMutableArray = [NSMutableArray array];
    NSString * sql=[NSString stringWithFormat:@"SELECT * FROM MESSAGETABLE where roomCode='%@' and targetId='%@'",roomCode,targetId];
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:sql];
        while ([result next]) {
            Message *item = [Message new];
            // messageId ,messageType ,message ,timeStamp ,fromUserAccount ,fromUserDevice ,toUserAccount ,token ,userId
            item.messageId = [result stringForColumn:@"messageId"];
            item.messageType = [result stringForColumn:@"messageType"];
            item.message = [result stringForColumn:@"message"];
            item.timeStamp = [result stringForColumn:@"timeStamp"];
            item.fromUserDevice = [result stringForColumn:@"fromUserDevice"];
            item.fromUserAccount = [result stringForColumn:@"fromUserAccount"];
            item.toUserAccount = [result stringForColumn:@"toUserAccount"];
            item.token = [result stringForColumn:@"token"];
            item.roomCode = [result stringForColumn:@"roomCode"];
            item.roomName = [result stringForColumn:@"roomName"];
            item.userId = [result stringForColumn:@"userId"];
            item.targetId = [result stringForColumn:@"targetId"];
            [allMutableArray addObject:item];
        }
        [result close];
    }];
    return allMutableArray;
}

/**
 *  当前聊天对象是否存在记录
 *
 *  @param targetId 聊天对象id
 *  @param userId 当前用户
 *
 *  @return BOOL
 */
+ (BOOL) checkChatWithTargetId:(NSString *)targetId userId:(NSString *)userId{
    return [[DBManager shareInstance] checkChatWithTargetId:targetId userId:userId];
}
- (BOOL) checkChatWithTargetId:(NSString *)targetId userId:(NSString *)userId{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM CHATLISTTABLE WHERE targetId = '%@' AND userId = '%@'",targetId,userId];
    __block BOOL flag = NO;
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            flag = YES;
        }
        [rs close];
    }];
    return flag;
}
/**
 *  将要聊天的用户信息插入数据库
 *
 *  @param item
 *  @param userId 当前用户信息
 */
+ (void) insertChatToDBWithTargetId:(NSString *)targetId tagetName:(NSString *)targetName headerImage:(NSString *)headerImage time:(NSString *)createTime body:(NSString *)body currentUserId:(NSString *)userId{
    [[DBManager shareInstance] insertChatToDBWithTargetId:targetId tagetName:targetName headerImage:headerImage time:createTime body:body currentUserId:userId];
}
- (void) insertChatToDBWithTargetId:(NSString *)targetId tagetName:(NSString *)targetName headerImage:(NSString *)headerImage time:(NSString *)createTime body:(NSString *)body currentUserId:(NSString *)userId{
    NSString * insertSql = [NSString stringWithFormat:@"INSERT INTO CHATLISTTABLE (targetId ,targetName ,headerImage ,body ,time  ,userId ) VALUES  ('%@','%@','%@','%@','%@','%@')",targetId,targetName,headerImage,body,createTime,userId];
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:insertSql];
    }];
}



/**
 *  获取当前用户下所有的消息列表
 *
 *  @param userId
 *
 *  @return
 */
+ (NSMutableArray *)getChatListWithCurrentUserId:(NSString *)userId{
    return [[DBManager shareInstance] getChatListWithCurrentUserId:userId];
}
- (NSMutableArray *)getChatListWithCurrentUserId:(NSString *)userId{
    NSMutableArray *allMutableArray = [NSMutableArray array];
    NSString * sql=[NSString stringWithFormat:@"SELECT * FROM CHATLISTTABLE where userId='%@'",userId];
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:sql];
        while ([result next]) {
            NSString *targetId = [result stringForColumn:@"targetId"];
            NSString *targetName = [result stringForColumn:@"targetName"];
            NSString *headerImage = [result stringForColumn:@"headerImage"];
            NSString *body = [result stringForColumn:@"body"];
            NSString *createTime = [result stringForColumn:@"time"];
            NSString *userId = [result stringForColumn:@"userId"];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:targetId forKey:@"targetId"];
            [dict setObject:targetName forKey:@"targetName"];
            [dict setObject:headerImage forKey:@"headerImage"];
            [dict setObject:body forKey:@"body"];
            [dict setObject:createTime forKey:@"time"];
            [dict setObject:userId forKey:@"userId"];
            [allMutableArray addObject:dict];
        }
        [result close];
    }];
    return allMutableArray;
}
+ (BOOL) checkUserWithUsertId:(NSString *)userId{
    return [[DBManager shareInstance] checkUserWithUsertId:userId];
}
- (BOOL) checkUserWithUsertId:(NSString *)userId{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM USERTABLE WHERE b80 = '%@'",userId];
    __block BOOL flag = NO;
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            flag = YES;
        }
        [rs close];
    }];
    return flag;
}
/**
 *  插入用户数据
 *
 *  @param item
 */
+ (void) insertUserToDBWithItem:(DHUserForChatModel *)item{
    [[DBManager shareInstance] insertUserToDBWithItem:item];
}
- (void) insertUserToDBWithItem:(DHUserForChatModel *)item{
    NSString * insertSql = [NSString stringWithFormat:@"INSERT INTO USERTABLE (b1 ,b143 ,b144 ,b19 ,b24 ,b29 ,b32 ,b33 ,b37 ,b46 ,b52 ,b57 ,b62 ,b67 ,b69 ,b75 ,b80 ,b86 ,b87 ,b9 ,b94 ) VALUES  ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",item.b1,item.b143,item.b144,item.b19,item.b24,item.b29,item.b32,item.b33,item.b37,item.b46,item.b52,item.b57,item.b62,item.b67,item.b69,item.b75,item.b80,item.b86,item.b87,item.b9,item.b94];
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:insertSql];
    }];
}
/**
 *  获取某人数据
 *
 *  @param userId
 *
 *  @return
 */
+ (DHUserForChatModel *)getUserWithCurrentUserId:(NSString *)userId{
    return [[DBManager shareInstance] getUserWithCurrentUserId:userId];
}
- (DHUserForChatModel *)getUserWithCurrentUserId:(NSString *)userId{
    NSString * sql=[NSString stringWithFormat:@"SELECT * FROM USERTABLE where b80='%@'",userId];
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    __block DHUserForChatModel *item = nil;
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:sql];
        while ([result next]) {
            item = [[DHUserForChatModel alloc]init];
            item.b1 = [result stringForColumn:@"b1"];
            item.b143 = [result stringForColumn:@"b143"];
            item.b144 = [result stringForColumn:@"b144"];
            item.b19 = [result stringForColumn:@"b19"];
            item.b24 = [result stringForColumn:@"b24"];
            item.b29 = [result stringForColumn:@"b29"];
            item.b32 = [result stringForColumn:@"b32"];
            item.b33 = [result stringForColumn:@"b33"];
            item.b37 = [result stringForColumn:@"b37"];
            item.b46 = [result stringForColumn:@"b46"];
            item.b52 = [result stringForColumn:@"b52"];
            item.b57 = [result stringForColumn:@"b57"];
            item.b62 = [result stringForColumn:@"b62"];
            item.b67 = [result stringForColumn:@"b67"];
            item.b69 = [result stringForColumn:@"b69"];
            item.b75 = [result stringForColumn:@"b75"];
            item.b80 = [result stringForColumn:@"b80"];
            item.b86 = [result stringForColumn:@"b86"];
            item.b87 = [result stringForColumn:@"b87"];
            item.b9 = [result stringForColumn:@"b9"];
            item.b94 = [result stringForColumn:@"b94"];
        }
        [result close];
    }];
    return item;
}



@end
