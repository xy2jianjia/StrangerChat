//
//  NSURLObject.m
//  StrangerChat
//
//  Created by zxs on 15/12/23.
//  Copyright © 2015年 long. All rights reserved.
//

#import "NSURLObject.h"

@implementation NSURLObject


+ (void)addWithVariableDic:(NSMutableDictionary *)variabledic {

    [variabledic setObject:[NSGetTools getB34] forKey:@"a34"];          // a34 ID
    [variabledic setObject:[NSGetTools getUserSexInfo] forKey:@"a69"];  // 性别
    [variabledic setObject:[NSGetTools getUserAccount] forKey:@"a52"];  // 昵称
    
}


+ (void)addWithdict:(NSMutableDictionary *)dict urlStr:(NSString *)urlStr{

    
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSString *url = urlStr;
    NSLog(@"%@",urlStr);
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [manger POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSData *datas = responseObject;
        NSString *result = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [NSGetTools DecryptWith:result];// 解密
        NSDictionary *infoDic = [NSGetTools parseJSONStringToNSDictionary:jsonStr];// 转字典
        for (NSString *keys in infoDic) {
            NSLog(@"错误信息----->:%@ 错误条件----->:%@",keys,[infoDic objectForKey:keys]);
        }
        NSNumber *codeNum = infoDic[@"code"];
        if ([codeNum intValue] == 200) {
            NSDictionary *dict2 = infoDic[@"body"];
            NSNumber *b34 = dict2[@"b34"];
            NSLog(@"%@",b34);
            [NSGetTools upDateB34:b34];
        }
        NSLog(@"---提交用户信息--%@",infoDic);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"===error-%@",error);
    }];

}


/**
 *  Description
 *
 *  @param contentStr  上传的内容
 *  @param str         空值是否改变
 *  @param flashDict   倒叙的字典方便上传编号
 *  @param variableDic 可变字典用于上传服务器
 *  @param aNum        上传对应的编号
 */
+ (void)addWithNString:(NSString *)contentStr secStr:(NSString *)str flashDic:(NSMutableDictionary *)flashDict variableDic:(NSMutableDictionary *)variableDic aNum:(NSString *)aNum {

    if (![contentStr isEqualToString:str]) {
        
        NSString *intenCode = [flashDict objectForKey:contentStr];
        [variableDic setObject:intenCode forKey:aNum];
        NSLog(@"上传的内容:%@ 对应的编号:%@",contentStr,intenCode);
    }
}
/**
 *  Description
 *
 *  @param UploadStr   上传的内容
 *  @param Original    空值是否改变
 *  @param variableDic 存入字典上传服务器
 *  @param aNum        上传对应的编号
 */
+ (void)addDataWithUploadStr:(NSString *)UploadStr originalStr:(NSString *)Original variableDic:(NSMutableDictionary *)variableDic aNum:(NSString *)aNum{

    if (![UploadStr isEqualToString:Original]) {
        [variableDic setObject:UploadStr forKey:aNum];
        NSLog(@"上传的内容:%@ ",UploadStr);
    }

}
#pragma mark --- 喜欢的异性类型
+ (void)addSexWithUploadStr:(NSString *)UploadStr originalStr:(NSString *)Original sexNum:(NSNumber *)sexNum flashDic:(NSMutableDictionary *)flashDict variableDic:(NSMutableDictionary *)variableDic aNum:(NSString *)aNum{

    if (![UploadStr isEqualToString:Original]) { // 喜欢的异性类型
        
        if ([sexNum isEqualToNumber:[NSNumber numberWithInt:1]]) { // 1男 2女
            NSString *typeStr = [flashDict objectForKey:UploadStr];
            [variableDic setObject:typeStr forKey:aNum];
            NSLog(@"上传的内容:%@ 对应的编号:%@",flashDict,typeStr);
        }else {
            NSString *typeStr = [flashDict objectForKey:UploadStr];
            [variableDic setObject:typeStr forKey:aNum];
            NSLog(@"上传的内容:%@ 对应的编号:%@",flashDict,typeStr);
        }
    }

}

#pragma mark --- 出生日期
+ (void)addWithhBronUploadStr:(NSString *)UploadStr originalStr:(NSString *)Original variableDic:(NSMutableDictionary *)variableDic aNum:(NSString *)aNum{

    if (![UploadStr isEqualToString:Original]) {  // 出生日期
        NSString *bronDay   = UploadStr;
        NSArray *yearArray  = [bronDay       componentsSeparatedByString:@"年"];
        NSArray *mouthArray = [yearArray[1]  componentsSeparatedByString:@"月"];
        NSArray *dayArray   = [mouthArray[1] componentsSeparatedByString:@"日"];
        NSString *dataStr   = [NSString stringWithFormat:@"%@-%@-%@",yearArray[0],mouthArray[0],dayArray[0]];
        [variableDic setValue:dataStr forKey:aNum];
        NSLog(@"上传的内容:%@ ",dataStr);
    }
}
#pragma mark --- 居住地
+ (void)addWithLiveUploadStr:(NSString *)UploadStr originalStr:(NSString *)Original variableDic:(NSMutableDictionary *)variableDic aNum:(NSString *)aproNum acityNum:(NSString *)acityNum{

    if (![UploadStr isEqualToString:Original]) {  // 居住地
        
        NSDictionary *proDic  = [ConditionObject provinceDict];  // 省
        NSDictionary *cityDic = [ConditionObject obtainDict];    // 市
        
        NSArray *yearArray  = [UploadStr componentsSeparatedByString:@"-"];
        NSString *proKey    = [proDic objectForKey:yearArray[0]];
        NSString *cityKey   = [cityDic objectForKey:yearArray[1]];
        
        [variableDic setValue:proKey forKey:aproNum];
        [variableDic setValue:cityKey forKey:acityNum];
        
        NSLog(@"上传的城市:%@ 对应的编号:%@ 省份编号:%@",UploadStr,cityKey,proKey);
    }
}
/**
 *  Description
 *
 *  @param UploadStr   上传内容
 *  @param variableDic 可变字典
 *  @param maxNum      最高收入
 *  @param minNim      最低收入
 */
+ (void)addWithIncomeUploadStr:(NSString *)UploadStr originalStr:(NSString *)Original variableDic:(NSMutableDictionary *)variableDic maxNum:(NSString *)maxNum minNum:(NSString *)minNim{
    
    if (![UploadStr isEqualToString:Original]) {  // 月收入
        
        NSArray *incomeArray  = [UploadStr componentsSeparatedByString:@"至"];
        [variableDic setObject:incomeArray[0] forKey:maxNum];
        [variableDic setObject:incomeArray[1] forKey:minNim];
        NSLog(@"最高收入:%@ 最低收入:%@",incomeArray[0],incomeArray[1]);
    }
}

#pragma mark  ---择友o(>﹏<)o需要的b34
+ (void)updateConditFriendWithStr:(NSString *)Condit
{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:Condit forKey:@"conditionFriend"];
    [userDefaults synchronize];
}

#pragma mark ---获取token---
+ (NSString *)getConditFriend
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaultes objectForKey:@"conditionFriend"];
    return token;
}





@end
