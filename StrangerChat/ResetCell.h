//
//  ResetCell.h
//  StrangerChat
//
//  Created by zxs on 15/11/27.
//  Copyright (c) 2015年 long. All rights reserved.
//  verification

#import <UIKit/UIKit.h>

@interface ResetCell : UITableViewCell {


    
    UILabel *upLine;
    
}
@property (nonatomic,strong)UILabel *photo;
@property (nonatomic,strong)UILabel *downLine;
@property (nonatomic,strong)UIButton *obtain; // 获取验证
@property (nonatomic,strong)UITextField *photoNum;
@property (nonatomic,strong)UIButton *seconds;
+ (CGFloat)resetCellHeight;

@end
