//
//  NSGetSystemTools.m
//  StrangerChat
//
//  Created by long on 15/11/6.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "NSGetSystemTools.h"

@implementation NSGetSystemTools

#pragma mark  ---默认消息---
+ (void)updateDefaultMessageWithDict:(NSMutableDictionary *)dict
{

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:dict forKey:@"default_message"];
    [userDefaults synchronize];
}

+ (NSDictionary *)getDefaultMessage
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    //读取数据
    NSDictionary *dict = [userDefaultes objectForKey:@"default_message"];
//    //NSLog(@"------------------------%@",dict);
    return dict;
}

#pragma mark  ---魅力部位---
+ (void)updatecharmPartWithDict:(NSMutableDictionary *)dict
{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:dict forKey:@"charmPart"];
    [userDefaults synchronize];
}

+ (NSDictionary *)getcharmPart
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    //读取数据
    NSDictionary *dict = [userDefaultes objectForKey:@"charmPart"];
//    //NSLog(@"------------------------%@",dict);
    return dict;
}


#pragma mark  ---婚姻状态---
+ (void)updatemarriageStatusWithDict:(NSMutableDictionary *)dict
{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:dict forKey:@"marriageStatus"];
    [userDefaults synchronize];
}

+ (NSDictionary *)getmarriageStatus
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    //读取数据
    NSDictionary *dict = [userDefaultes objectForKey:@"marriageStatus"];
    ////NSLog(@"------------------------%@",dict);
    return dict;
}


#pragma mark  ---婚前性行为---
+ (void)updatemarrySexWithDict:(NSMutableDictionary *)dict
{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:dict forKey:@"marrySex"];
    [userDefaults synchronize];
}

+ (NSDictionary *)getmarrySex
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    //读取数据
    NSDictionary *dict = [userDefaultes objectForKey:@"marrySex"];
    //NSLog(@"------------------------%@",dict);
    return dict;
}

#pragma mark  ---职业---
+ (void)updateprofessionDict:(NSMutableDictionary *)dict
{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:dict forKey:@"profession"];
    [userDefaults synchronize];
}
+ (void)updateprofessionArray:(NSArray *)array
{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:array forKey:@"profession"];
    [userDefaults synchronize];
}
+ (NSDictionary *)getprofession
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    //读取数据
    NSDictionary *dict = [userDefaultes objectForKey:@"profession"];
    //NSLog(@"------------------------%@",dict);
    return dict;
}
+ (NSDictionary *)getprofessionArray
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    //读取数据
    NSDictionary *dict = [userDefaultes objectForKey:@"profession"];
    //NSLog(@"------------------------%@",dict);
    return dict;
}

#pragma mark  ---喜欢的类型(女)---
+ (void)updateloveType2Dict:(NSMutableDictionary *)dict
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:dict forKey:@"loveType-2"];
    [userDefaults synchronize];
}

+ (NSDictionary *)getloveType2
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    //读取数据
    NSDictionary *dict = [userDefaultes objectForKey:@"loveType-2"];
    //NSLog(@"------------------------%@",dict);
    return dict;
}


#pragma mark  ---异地恋---
+ (void)updatehasLoveOtherWithDict:(NSMutableDictionary *)dict
{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:dict forKey:@"hasLoveOther"];
    [userDefaults synchronize];
}

+ (NSDictionary *)gethasLoveOther
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    //读取数据
    NSDictionary *dict = [userDefaultes objectForKey:@"hasLoveOther"];
    //NSLog(@"------------------------%@",dict);
    return dict;
}

#pragma mark  ---星座---
+ (void)updatestarWithDict:(NSMutableDictionary *)dict
{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:dict forKey:@"star"];
    [userDefaults synchronize];
}

+ (NSDictionary *)getstar
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    //读取数据
    NSDictionary *dict = [userDefaultes objectForKey:@"star"];
    //NSLog(@"------------------------%@",dict);
    return dict;
}

#pragma mark  ---父母同住---
+ (void)updateliveTogetherWithDict:(NSMutableDictionary *)dict
{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:dict forKey:@"liveTogether"];
    [userDefaults synchronize];
}

+ (NSDictionary *)getliveTogether
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    //读取数据
    NSDictionary *dict = [userDefaultes objectForKey:@"liveTogether"];
    //NSLog(@"------------------------%@",dict);
    return dict;
}

#pragma mark  ---喜欢的类型(男)---
+ (void)updateloveType1WithDict:(NSMutableDictionary *)dict
{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:dict forKey:@"loveType-1"];
    [userDefaults synchronize];
}

+ (NSDictionary *)getloveType1
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    //读取数据
    NSDictionary *dict = [userDefaultes objectForKey:@"loveType-1"];
    //NSLog(@"------------------------%@",dict);
    return dict;
}

#pragma mark  ---交友目的---
+ (void)updatepurposeWithDict:(NSMutableDictionary *)dict
{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:dict forKey:@"purpose"];
    [userDefaults synchronize];
}
+ (void)updatepurposeWithArray:(NSArray *)array
{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:array forKey:@"purpose"];
    [userDefaults synchronize];
}
+ (NSDictionary *)getpurpose
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    //读取数据
    NSDictionary *dict = [userDefaultes objectForKey:@"purpose"];
    return dict;
}
+ (NSArray *)getpurposeArray
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    //读取数据
    NSArray *dict = [userDefaultes objectForKey:@"purpose"];
    return dict;
}
#pragma mark  ---血型---
+ (void)updatebloodWithDict:(NSMutableDictionary *)dict
{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:dict forKey:@"blood"];
    [userDefaults synchronize];
}

+ (NSDictionary *)getblood
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    //读取数据
    NSDictionary *dict = [userDefaultes objectForKey:@"blood"];
   // //NSLog(@"------------------------%@",dict);
    return dict;
}

#pragma mark  ---车子---
+ (void)updatehasCarWithDict:(NSMutableDictionary *)dict
{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:dict forKey:@"hasCar"];
    [userDefaults synchronize];
}

+ (NSDictionary *)gethasCar
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    //读取数据
    NSDictionary *dict = [userDefaultes objectForKey:@"hasCar"];
    //NSLog(@"------------------------%@",dict);
    return dict;
}

#pragma mark  ---学历---
+ (void)updateeducationLevelWithDict:(NSMutableDictionary *)dict
{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:dict forKey:@"educationLevel"];
    [userDefaults synchronize];
}
+ (void)updateeducationLevelWithArray:(NSArray *)array
{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:array forKey:@"educationLevel"];
    [userDefaults synchronize];
}
+ (NSDictionary *)geteducationLevel
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    //读取数据
    NSDictionary *dict = [userDefaultes objectForKey:@"educationLevel"];
   // //NSLog(@"------------------------%@",dict);
    return dict;
}
+ (NSArray *)geteducationLevelArray
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    //读取数据
    NSArray *dict = [userDefaultes objectForKey:@"educationLevel"];
    // //NSLog(@"------------------------%@",dict);
    return dict;
}

#pragma mark  ---小孩---
+ (void)updatehasChildWithDict:(NSMutableDictionary *)dict
{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:dict forKey:@"hasChild"];
    [userDefaults synchronize];
}

+ (NSDictionary *)gethasChild
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    //读取数据
    NSDictionary *dict = [userDefaultes objectForKey:@"hasChild"];
    ////NSLog(@"------------------------%@",dict);
    return dict;
}

#pragma mark  ---系统参数---
+ (void)updatesystem_pmWithDict:(NSMutableDictionary *)dict
{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:dict forKey:@"system_pm"];
    [userDefaults synchronize];
}

+ (NSDictionary *)getsystem_pm
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    //读取数据
    NSDictionary *dict = [userDefaultes objectForKey:@"system_pm"];
    ////NSLog(@"------------------------%@",dict);
    return dict;
}

#pragma mark  ---兴趣爱好(女)---
+ (void)updatefavorite2WithDict:(NSMutableDictionary *)dict
{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:dict forKey:@"favorite-2"];
    [userDefaults synchronize];
}

+ (NSDictionary *)getfavorite2
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    //读取数据
    NSDictionary *dict = [userDefaultes objectForKey:@"favorite-2"];
    ////NSLog(@"------------------------%@",dict);
    return dict;
}


#pragma mark  ---兴趣爱好(男)---
+ (void)updatefavorite1WithDict:(NSMutableDictionary *)dict
{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:dict forKey:@"favorite-1"];
    [userDefaults synchronize];
}
+ (void)updatefavorite1WithArr:(NSArray *)array{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:array forKey:@"favorite-1"];
    [userDefaults synchronize];
}
+ (NSDictionary *)getfavorite1
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    //读取数据
    NSDictionary *dict = [userDefaultes objectForKey:@"favorite-1"];
    ////NSLog(@"------------------------%@",dict);
    return dict;
}
+ (NSArray *)getfavorite1Array
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    //读取数据
    NSArray *dict = [userDefaultes objectForKey:@"favorite-1"];
    ////NSLog(@"------------------------%@",dict);
    return dict;
}


#pragma mark  ---个性特征(男)---
+ (void)updatekidney1WithDict:(NSMutableDictionary *)dict
{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:dict forKey:@"kidney-1"];
    [userDefaults synchronize];
}

+ (NSDictionary *)getkidney1
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    //读取数据
    NSDictionary *dict = [userDefaultes objectForKey:@"kidney-1"];
   // //NSLog(@"------------------------%@",dict);
    return dict;
}

#pragma mark  ---个性特征(女)---
+ (void)updatekidney2WithDict:(NSMutableDictionary *)dict
{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:dict forKey:@"kidney-2"];
    [userDefaults synchronize];
}

+ (NSDictionary *)getkidney2
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    //读取数据
    NSDictionary *dict = [userDefaultes objectForKey:@"kidney-2"];
    ////NSLog(@"------------------------%@",dict);
    return dict;
}

#pragma mark  ---房子---
+ (void)updatehasRoomWithDict:(NSMutableDictionary *)dict
{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:dict forKey:@"hasRoom"];
    [userDefaults synchronize];
}

+ (NSDictionary *)gethasRoom
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    //读取数据
    NSDictionary *dict = [userDefaultes objectForKey:@"hasRoom"];
   // //NSLog(@"------------------------%@",dict);
    return dict;
}

#pragma mark  ---时间戳---
+ (void)updatetimestemWithDict:(NSMutableDictionary *)dict
{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:dict forKey:@"timestem"];
    [userDefaults synchronize];
}

+ (NSDictionary *)gettimestem
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    //读取数据
    NSDictionary *dict = [userDefaultes objectForKey:@"timestem"];
   // //NSLog(@"------------------------%@",dict);
    return dict;
}

// 年龄范围
+(NSArray *)getAgeData
{
    NSMutableArray *array = [NSMutableArray array];
    for (int a = 18; a <= 65; a++) {
        NSString *age = [NSString stringWithFormat:@"%d",a];
        [array addObject:age];
    }


    return array;
}

// 身高范围
+ (NSArray *)getBodyHeightData
{
    NSMutableArray *array = [NSMutableArray array];
    for (int a = 130; a <= 220; a++) {
        NSString *height = [NSString stringWithFormat:@"%d",a];
        [array addObject:height];
    }
    
    return array;
}

+(NSArray *)getWeight {   // 体重
    
    NSMutableArray *weight = [NSMutableArray array];
    for (int i = 40; i<= 100; i++) {
        NSString *str = [NSString stringWithFormat:@"%d",i];
        [weight addObject:str];
    }
    return weight;
}


@end
