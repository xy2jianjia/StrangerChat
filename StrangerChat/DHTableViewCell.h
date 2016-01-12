//
//  DHTableViewCell.h
//  StrangerChat
//
//  Created by zxs on 16/1/7.
//  Copyright © 2016年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DHTableViewCell : UITableViewCell {

    UILabel *topLine;
    UILabel *payTitle;
}

@property (nonatomic,strong)UILabel *payContent;
@property (nonatomic,strong)UILabel *belowLine;
- (void)setTitle:(NSString *)title;
+ (CGFloat)payViewCellHeight;
@end
