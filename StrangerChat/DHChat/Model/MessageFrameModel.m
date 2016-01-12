//
//  MessageFrameModel.m
//  微信
//
//  Created by Think_lion on 15/6/21.
//  Copyright (c) 2015年 Think_lion. All rights reserved.
//

#import "MessageFrameModel.h"
#import "MessageModel.h"
//头像的宽度
#define headIconW 50
#define contentFont MyFont(14)
//聊天内容的文字距离四边的距离
#define ContentEdgeInsets 20

@implementation MessageFrameModel



//根据模型设置frame
-(void)setMessageModel:(MessageModel *)messageModel
{
    _messageModel=messageModel;
    CGFloat padding =10;  //间距为10
    
    //1.设置时间的frame (不需要隐藏时间)
    if(messageModel.hiddenTime==NO){
        CGFloat timeX=140;
        CGFloat timeY=5;
        CGFloat timeW=ScreenWidth-280;
        CGFloat timeH=20;
        _timeF=CGRectMake(timeX, timeY, timeW, timeH);
    }
    //2.设置头像
    CGFloat iconW=headIconW;
    CGFloat iconH=iconW;
    CGFloat iconX=0;
    CGFloat iconY=CGRectGetMaxY(_timeF)+padding;
    //如果是自己
    if(messageModel.isCurrentUser){
        iconX=ScreenWidth-iconW-padding;
    }else{  //是正在和自己聊天的用户
         iconX=padding;
    }
    _headF=CGRectMake(iconX, iconY, iconW, iconH);
    //3.设置聊天内容的frame  (聊天内容的宽度最大100  高不限)
    CGSize contentSize=CGSizeMake(200, MAXFLOAT);
    CGSize contentR;
    //如果有表情的话
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString:messageModel.attributedBody];
    NSString *string = [NSString stringWithFormat:@"%@",text];
    contentR= [self hightForContent:string fontSize:14 size:contentSize];
//    [text boundingRectWithSize:contentSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
//    }else{
//        contentR=[messageModel.body boundingRectWithSize:contentSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:contentFont} context:nil];
//    }
    CGFloat contentW=contentR.width+ContentEdgeInsets*2;
    CGFloat contentH=contentR.height+10;
    CGFloat contentY=iconY+2;
    CGFloat contentX=0;
    //如果是自己
    if(messageModel.isCurrentUser){
        contentX=iconX-padding-contentW;
    }else{  //如果是聊天用户
        contentX=CGRectGetMaxX(_headF)+padding;
    }
    _contentF=CGRectMake(contentX, contentY, contentW, contentH);
    //单元格的高度
    CGFloat maxIconY=CGRectGetMaxY(_headF);
    CGFloat maxContentY=CGRectGetMaxY(_contentF);
    
    _cellHeight=MAX(maxIconY, maxContentY)+padding;
    //4.聊天单元view的frame
    _chatF=CGRectMake(0, 0, ScreenWidth, _cellHeight);
}

- (CGSize)hightForContent:(NSString *)content fontSize:(CGFloat)fontSize size:(CGSize)size{
    CGSize resultSize = [content boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    return resultSize;
}

@end
