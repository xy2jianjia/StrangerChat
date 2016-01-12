//
//  DetailCell.m
//  StrangerChat
//
//  Created by zxs on 15/11/19.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "DetailCell.h"

@implementation DetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    
    nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:nameLabel];
    
    _details = [[UILabel alloc] init];
    _details.font = [UIFont systemFontOfSize:14];
    _details.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_details];
    
    _downLine = [[UILabel alloc] init];
    [_downLine setBackgroundColor:kUIColorFromRGB(0xD0D0D0)];
    [self.contentView addSubview:_downLine];
    
    _upLine = [[UILabel alloc] init];
    [_upLine setBackgroundColor:kUIColorFromRGB(0xD0D0D0)];
    [self.contentView addSubview:_upLine];
    
}

- (void)layoutSubviews {
    
    nameLabel.frame = CGRectMake(25, 10, 150, 30);
    _details.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width-210-20, 10, 210, 30);
    
}

+ (CGFloat)detaiCellHeight {

    return 50;
}

- (void)addTxt:(NSString *)name {
    
    nameLabel.text = name;
    
    
}

@end
