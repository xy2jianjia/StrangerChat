//
//  PassWordCell.h
//  StrangerChat
//
//  Created by zxs on 15/11/27.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PassWordCell : UITableViewCell {

    UILabel *password;
    UILabel *number;
    UIImageView *numImage;
    UILabel *gmLabel;
    UILabel *upLine;
}
@property (nonatomic,strong)UILabel *downLine;
- (void)addpassWord:(NSString *)passwrods number:(NSString *)num numImage:(NSString *)image gmLabel:(NSString *)title;
+ (CGFloat)PassWordCellHeight;
@end
