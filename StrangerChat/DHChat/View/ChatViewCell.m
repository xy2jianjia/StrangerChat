//
//  ChatViewCell.m
//  微信
//
//  Created by Think_lion on 15/6/19.
//  Copyright (c) 2015年 Think_lion. All rights reserved.
//

#import "ChatViewCell.h"
#import "MessageFrameModel.h"
#import "ChatViewShow.h"

@interface ChatViewCell ()
@property (nonatomic,weak)  ChatViewShow *viewShow;

@end

@implementation ChatViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
      
        //1.添加子控件
        [self setupFirst];
        
    }
    return self;
}

-(void)setupFirst
{
    ChatViewShow *viewShow=[[ChatViewShow alloc]init];

    [self.contentView addSubview:viewShow];
    self.viewShow=viewShow;
}



+(instancetype)cellWithTableView:(UITableView *)tableView indentifier:(NSString *)indentifier
{
    ChatViewCell *cell=[tableView dequeueReusableCellWithIdentifier:indentifier];
    if(cell==nil){
        cell=[[ChatViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    return cell;
}

-(void)setFrameModel:(MessageFrameModel *)frameModel
{
    self.viewShow.frameModel=frameModel;
}


@end
