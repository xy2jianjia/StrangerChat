//
//  AccountCell.h
//  StrangerChat
//
//  Created by zxs on 15/11/27.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountCell : UITableViewCell {
    
    UILabel *idLabel;
    UILabel *photoNum;
    UILabel *upLine;
}
@property (nonatomic,strong)UILabel *downLine;
+ (CGFloat)accountCellHeight;
- (void)addWithidLabel:(NSString *)idtitle photoNum:(NSString *)number;
@end
