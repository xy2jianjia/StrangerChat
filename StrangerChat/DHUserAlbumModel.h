//
//  DHUserAlbumModel.h
//  StrangerChat
//
//  Created by xy2 on 16/1/7.
//  Copyright © 2016年 long. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DHUserAlbumModel : NSObject
/**
 *  数据库记录id
 */
@property (nonatomic,copy) NSString *b34;
/**
 *  用户照片
 */
@property (nonatomic,copy) NSString *b58;
/**
 *  用户照片小
 */
@property (nonatomic,copy) NSString *b59;
/**
 *  用户照片小
 */
@property (nonatomic,copy) NSString *b60;
/**
 *  相册状态:1:通过  2：待审核 3:未通过
 */
@property (nonatomic,copy) NSString *b75;
/**
 *  分类 1：眼缘大图 2：普通
 */
@property (nonatomic,copy) NSString *b78;
/**
 *  用户id
 */
@property (nonatomic,copy) NSString *b80;
@end
