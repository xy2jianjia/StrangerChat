//
//  DHAlbumModel.h
//  StrangerChat
//
//  Created by xy2 on 15/12/30.
//  Copyright © 2015年 long. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DHAlbumModel : NSObject
/**
 *  图片描述
 */
@property (nonatomic,copy) NSString *b17;
/**
 *  数据库记录id
 */
@property (nonatomic,copy) NSString *b34;
/**
 *  图片url
 */
@property (nonatomic,copy) NSString *b58;
/**
 *  缩略图1
 */
@property (nonatomic,copy) NSString *b59;
/**
 *  缩略图2
 */
@property (nonatomic,copy) NSString *b60;
/**
 *  排序
 */
@property (nonatomic,copy) NSString *b73;
/**
 *  分类 分类 1：眼缘大图 2：普通
 */
@property (nonatomic,copy) NSString *b78;
/**
 *  用户id
 */
@property (nonatomic,copy) NSString *b80;

@end
