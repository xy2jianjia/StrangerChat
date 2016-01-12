//
//  DHUserForChatModel.h
//  StrangerChat
//
//  Created by xy2 on 16/1/9.
//  Copyright © 2016年 long. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DHUserForChatModel : NSObject
@property (nonatomic,strong) NSString *b1;// 年龄
@property (nonatomic,strong) NSString *b143;// 用户类型 1:注册用户,2机器人
@property (nonatomic,strong) NSString *b144;// 是否vip 1:vip 2:非vip
@property (nonatomic,strong) NSString *b19;//学历 1:初中及以下 2:高中 3:专科 4:本科 5:研究生 6:博士及以上
@property (nonatomic,strong) NSString *b24;// 兴趣爱好-----
@property (nonatomic,strong) NSString *b29;// 是否有车
@property (nonatomic,strong) NSString *b32;// 是否有房
@property (nonatomic,strong) NSString *b33;// 身高
@property (nonatomic,strong) NSString *b37;// 个性特征-----
@property (nonatomic,strong) NSString *b46;// 婚姻状态
@property (nonatomic,copy) NSString *b52;// 昵称
@property (nonatomic,copy) NSString *b57;// 头像连接
@property (nonatomic,strong) NSString *b62;// 职业--
@property (nonatomic,strong) NSString *b67;// 省份
@property (nonatomic,strong) NSString *b69;// 性别
@property (nonatomic,strong) NSString *b75;// 呢成审核状态 1:通过 2:待审核 3:未通过
@property (nonatomic,strong) NSString *b80;// 用户ID
@property (nonatomic,strong) NSString *b86;// 最高收入
@property (nonatomic,strong) NSString *b87;// 最低收入
@property (nonatomic,strong) NSString *b9;// 城市
@property (nonatomic,strong) NSString *b94;// 距离  /m

@property (nonatomic,strong) NSString *b116;

@end
