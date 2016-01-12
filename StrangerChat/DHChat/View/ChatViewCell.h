//
//  ChatViewCell.h
//  微信
//
//  Created by Think_lion on 15/6/19.
//  Copyright (c) 2015年 Think_lion. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MessageFrameModel;


@interface ChatViewCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView*)tableView indentifier:(NSString*)indentifier;

@property (nonatomic,strong) MessageFrameModel *frameModel;

@end
