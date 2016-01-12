//
//  HomeConstomView.m
//  微信
//
//  Created by Think_lion on 15/6/29.
//  Copyright (c) 2015年 Think_lion. All rights reserved.
//

#import "HomeConstomView.h"
#import "HomeModel.h"
#import "BadgeButton.h"

#define MarginLeft 10
#define headWidth 40
#define headHeight  headWidth

@interface HomeConstomView ()
//1.头像
@property (nonatomic,weak) UIImageView *head;
//2.title
@property (nonatomic,weak) UILabel *titleLabel;
//3.内容
@property (nonatomic,weak) UILabel *subTitleLabel;
//4.时间
@property (nonatomic,weak) UILabel *timeLabel;
//5.数字提醒按钮
@property (nonatomic,weak)BadgeButton *badgeButton;
@end

@implementation HomeConstomView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if(self){
        [self setupView];
    }
    return self;
}

-(void)setupView
{
    //1.头像
    UIImageView *head=[[UIImageView alloc]init];
    head.frame=CGRectMake(MarginLeft, MarginLeft, headWidth, headHeight);
    head.layer.cornerRadius=5;
    [self addSubview:head];
    self.head=head;
    //2.用户名
    UILabel *titleLabel=[[UILabel alloc]init];
    titleLabel.font=MyFont(17);
    titleLabel.textColor=[UIColor blackColor];
    [self addSubview:titleLabel];
    self.titleLabel=titleLabel;
    //3.内容
    UILabel *subTitleLabel=[[UILabel alloc]init];
    subTitleLabel.font=MyFont(14);
    subTitleLabel.textColor=[UIColor lightGrayColor];
    [self addSubview:subTitleLabel];
    self.subTitleLabel=subTitleLabel;
    //4.时间
    UILabel *timeLabel=[[UILabel alloc]init];
    timeLabel.font=MyFont(12);
    timeLabel.textColor=[UIColor lightGrayColor];
    [self addSubview:timeLabel];
//    timeLabel.backgroundColor = [UIColor blueColor];
//    timeLabel.layer.cornerRadius = 3;
    self.timeLabel=timeLabel;
    //5.提醒数字按钮
    BadgeButton *badgeBtn=[[BadgeButton alloc]init];
    [self addSubview:badgeBtn];
    self.badgeButton=badgeBtn;
}

//传递模型
-(void)setHomeModel:(HomeModel *)homeModel
{
    _homeModel=homeModel;

    //1.设置头像
    if(homeModel.headerIcon){
        self.head.image=[UIImage imageWithData:homeModel.headerIcon];
    }else{
        self.head.image=[UIImage imageNamed:@"list_item_icon.png"];
    }
    //2.设置用户名
    CGFloat nameY=MarginLeft;
    CGFloat nameX=CGRectGetMaxX(self.head.frame)+MarginLeft;
    CGSize nameSize=[homeModel.uname sizeWithAttributes:@{NSFontAttributeName:MyFont(17)}];
    self.titleLabel.frame=CGRectMake(nameX, nameY, nameSize.width, nameSize.height);
    self.titleLabel.text=homeModel.uname;
    //3.设置body聊天内容
    CGFloat bodyY=CGRectGetMaxY(self.titleLabel.frame);
    CGFloat bodyX=nameX;
    CGFloat bodyH=20;
    CGFloat bodyW=ScreenWidth-bodyX-MarginLeft*2;
    self.subTitleLabel.frame=CGRectMake(bodyX, bodyY, bodyW, bodyH);
    self.subTitleLabel.text=homeModel.body;
    //4.设置时间
    CGSize timeSize=[homeModel.time sizeWithAttributes:@{NSFontAttributeName:MyFont(12)}];
    CGFloat timeY=MarginLeft;
    CGFloat timeX=ScreenWidth-timeSize.width-MarginLeft;
    self.timeLabel.frame=CGRectMake(timeX, timeY, timeSize.width, timeSize.height);
    self.timeLabel.text=homeModel.time;
    
    //5.设置提醒数字按钮
   
    if(homeModel.badgeValue.length>0 && ![homeModel.badgeValue isEqualToString:@""]){
        self.badgeButton.badgeValue=homeModel.badgeValue;
        self.badgeButton.hidden=NO;
        CGFloat badgeX=CGRectGetMaxX(self.head.frame)-self.badgeButton.width*0.5;
        CGFloat badgeY=0;
        self.badgeButton.x=badgeX;
        self.badgeButton.y=badgeY;
        
    }else{
        self.badgeButton.hidden=YES;
    }
    
}

@end
