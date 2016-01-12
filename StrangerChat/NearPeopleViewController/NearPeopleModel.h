//
//  NearPeopleModel.h
//  StrangerChat
//
//  Created by long on 15/11/12.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NearPeopleModel : NSObject

@property (nonatomic,strong) NSNumber *b1;// 年龄
@property (nonatomic,strong) NSNumber *b143;// 用户类型 1:注册用户,2机器人
@property (nonatomic,strong) NSNumber *b144;// 是否vip 1:vip 2:非vip
@property (nonatomic,strong) NSNumber *b19;//学历 1:初中及以下 2:高中 3:专科 4:本科 5:研究生 6:博士及以上
@property (nonatomic,strong) NSString *b24;// 兴趣爱好-----
@property (nonatomic,strong) NSNumber *b29;// 是否有车
@property (nonatomic,strong) NSNumber *b32;// 是否有房
@property (nonatomic,strong) NSNumber *b33;// 身高
@property (nonatomic,strong) NSString *b37;// 个性特征-----
@property (nonatomic,strong) NSNumber *b46;// 婚姻状态
@property (nonatomic,copy) NSString *b52;// 昵称
@property (nonatomic,copy) NSString *b57;// 头像连接
@property (nonatomic,strong) NSNumber *b62;// 职业--
@property (nonatomic,strong) NSNumber *b67;// 省份
@property (nonatomic,strong) NSNumber *b69;// 性别
@property (nonatomic,strong) NSNumber *b75;// 呢成审核状态 1:通过 2:待审核 3:未通过
@property (nonatomic,strong) NSNumber *b80;// 用户ID
@property (nonatomic,strong) NSNumber *b86;// 最高收入
@property (nonatomic,strong) NSNumber *b87;// 最低收入
@property (nonatomic,strong) NSNumber *b9;// 城市
@property (nonatomic,strong) NSNumber *b94;// 距离  /m

@property (nonatomic,strong) NSNumber *b116; // 是否被关注过


@end
