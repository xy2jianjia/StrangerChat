//
//  BasicNineCell.m
//  StrangerChat
//
//  Created by zxs on 15/11/19.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "BasicNineCell.h"

@implementation BasicNineCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    
    leftLabel = [[UILabel alloc] init];
    leftLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:leftLabel];
    
    self.rightLabel = [[UILabel alloc] init];
    self.rightLabel.font = [UIFont systemFontOfSize:14];
    self.rightLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.rightLabel];
    
    self.upLine = [[UILabel alloc] init];
    self.upLine.backgroundColor = kUIColorFromRGB(0xD0D0D0);
    [self.contentView addSubview:self.upLine];
    
    self.downLine = [[UILabel alloc] init];
    self.downLine.backgroundColor = kUIColorFromRGB(0xD0D0D0);
    [self.contentView addSubview:self.downLine];
    
}

- (void)layoutSubviews {
    
    leftLabel.frame = CGRectMake(25, 10, 90, 30);
    self.rightLabel.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width-270-20, 10, 270, 30);
    
}


+ (CGFloat)basicNineCellHeight {

    return 50;
}
- (void)addTxtleft:(NSString *)name {

    leftLabel.text = name;
    
}

@end
