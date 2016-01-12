//
//  DHTableViewCell.m
//  StrangerChat
//
//  Created by zxs on 16/1/7.
//  Copyright © 2016年 long. All rights reserved.
//

#import "DHTableViewCell.h"

@implementation DHTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self n_payViewlayOut];
    }
    return self;
}


- (void)n_payViewlayOut {

    payTitle = [[UILabel alloc] init];
    payTitle.font = [UIFont systemFontOfSize:16.0f];
    [self.contentView addSubview:payTitle];
    
    self.payContent = [[UILabel alloc] init];
    self.payContent.font = [UIFont systemFontOfSize:16.0f];
    [self.contentView addSubview:self.payContent];

    
    topLine = [[UILabel alloc] init];
    topLine.backgroundColor = kUIColorFromRGB(0xD0D0D0);
    [self.contentView addSubview:topLine];
    self.belowLine = [[UILabel alloc] init];
    self.belowLine.backgroundColor = kUIColorFromRGB(0xD0D0D0);
    [self.contentView addSubview:self.belowLine];
    
}

- (void)layoutSubviews {

    CGFloat paywidth = [self stringWidth:payTitle.text];
    payTitle.frame = CGRectMake(10, 10, paywidth, 30);
    CGFloat secwidth = [self stringWidth:self.payContent.text];
    self.payContent.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width - secwidth - 20, 10, secwidth, 30);
    topLine.frame   = CGRectMake(0,    0, [[UIScreen mainScreen] bounds].size.width, 0.3);
    self.belowLine.frame = CGRectMake(0, 49.7, [[UIScreen mainScreen] bounds].size.width, 0.3);
}

- (void)setTitle:(NSString *)title {
    
    payTitle.text = title;
}

- (CGFloat)stringWidth:(NSString *)aString{
    
    CGRect r = [aString boundingRectWithSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f]} context:nil];
    return r.size.width;
}

+ (CGFloat)payViewCellHeight {
    
    return 50;
}
@end
