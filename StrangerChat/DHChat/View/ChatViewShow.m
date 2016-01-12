//
//  ChatViewShow.m
//  微信
//
//  Created by Think_lion on 15/6/21.
//  Copyright (c) 2015年 Think_lion. All rights reserved.
//

#import "ChatViewShow.h"
#import "MessageFrameModel.h"
#import "MessageModel.h"

@interface ChatViewShow ()
//时间
@property (nonatomic,weak) UILabel *timeLabel;
//正文内容
@property (nonatomic,weak) UIButton *contentBtn;
//@property (nonatomic,strong) UILabel *contentLabel;
//头像
@property (nonatomic,strong) UIImageView *headImage;
//
@end

@implementation ChatViewShow

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if(self){
        //1.添加子控件
        [self setupChildView];
        
       
    }
    return self;
}
#pragma mark 添加子控件
-(void)setupChildView
{
   //1.时间
    UILabel *timeLabel=[[UILabel alloc]init];
    timeLabel.textColor=[UIColor lightGrayColor];
    timeLabel.font=MyFont(13);
    timeLabel.textAlignment=NSTextAlignmentCenter;
    timeLabel.textColor=[UIColor colorWithWhite:0.980 alpha:1];
    timeLabel.backgroundColor = [UIColor lightGrayColor];
    timeLabel.layer.cornerRadius = 8;
    timeLabel.layer.masksToBounds = YES;
    
    [self addSubview:timeLabel];
    self.timeLabel=timeLabel;
    //2.正文内容
    UIButton *contentBtn=[[UIButton alloc]init];
    [contentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    contentBtn.titleLabel.font=MyFont(14);
    contentBtn.titleLabel.numberOfLines=0;  //多行显示
    contentBtn.contentEdgeInsets=UIEdgeInsetsMake(20, 20, 30, 20);
    
//    _contentLabel = [[UILabel alloc]init];
//    _contentLabel.textColor = [UIColor blackColor];
//    _contentLabel.font=MyFont(15);
//    _contentLabel.numberOfLines=0;  //多行显示
    
    [self addSubview:contentBtn];
    self.contentBtn=contentBtn;
    //3.头像
    self.headImage=[[UIImageView alloc]init];
    [self addSubview:self.headImage];
    self.headImage.layer.masksToBounds = YES;
    self.headImage.layer.cornerRadius = 25;
    self.headImage.clipsToBounds = YES;
    self.headImage.contentMode = UIViewContentModeScaleAspectFill;
}

//传递模型
-(void)setFrameModel:(MessageFrameModel *)frameModel
{
    _frameModel=frameModel;
    //设置自己的frame
    self.frame=frameModel.chatF;
  
    //1.时间的frame
    self.timeLabel.frame=frameModel.timeF;
    self.timeLabel.text=[frameModel.messageModel.time substringFromIndex:11];
    //2头像的frame
    if(frameModel.messageModel.isCurrentUser){  //如果是自己
        UIImage *head=frameModel.messageModel.headImage?[UIImage imageWithData:frameModel.messageModel.headImage]:[UIImage imageNamed:@"list_item_icon.png"];
        self.headImage.image=head;
    }else{  //如果是聊天的用户
       self.headImage.image=frameModel.messageModel.otherPhoto?frameModel.messageModel.otherPhoto:[UIImage imageNamed:@"list_item_icon.png"];
    }
   
    self.headImage.frame=frameModel.headF;
    //3.内容的frame
    [self.contentBtn setAttributedTitle:frameModel.messageModel.attributedBody forState:UIControlStateNormal];
//    self.contentLabel.attributedText = frameModel.messageModel.attributedBody;
//    self.contentLabel.frame = frameModel.contentF;
//    [self.contentLabel sizeToFit];
    self.contentBtn.frame=frameModel.contentF;
    //4.设置聊天的背景图片
    if(frameModel.messageModel.isCurrentUser){  //如果是自己
//        self.contentLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"SenderTextNodeBkg"]];
        [self.contentBtn setBackgroundImage:[UIImage resizedImage:@"SenderTextNodeBkg"] forState:UIControlStateNormal];
    }else {  //别人的
//        self.contentLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ReceiverAppNodeBkg"]];
         [self.contentBtn setBackgroundImage:[UIImage resizedImage:@"ReceiverAppNodeBkg"] forState:UIControlStateNormal];
    }
    
}


@end
