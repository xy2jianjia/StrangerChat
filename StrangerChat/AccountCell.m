//
//  AccountCell.m
//  StrangerChat
//
//  Created by zxs on 15/11/27.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "AccountCell.h"

@implementation AccountCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        idLabel = [[UILabel alloc] init];
        idLabel.font = [UIFont fontWithName:Typefaces size:18.0f];
        [self.contentView addSubview:idLabel];
        
        photoNum = [[UILabel alloc] init];
        photoNum.font = [UIFont fontWithName:Typefaces size:16.0f];
        photoNum.textAlignment = NSTextAlignmentRight;
        photoNum.textColor = kUIColorFromRGB(0xB3B3B3);
        [self.contentView addSubview:photoNum];
        
        upLine = [[UILabel alloc] init];
        upLine.backgroundColor = kUIColorFromRGB(0xD0D0D0);
        [self.contentView addSubview:upLine];
        _downLine = [[UILabel alloc] init];
        _downLine.backgroundColor = kUIColorFromRGB(0xD0D0D0);
        [self.contentView addSubview:_downLine];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    idLabel.frame = CGRectMake(15, 10, 50, 35);
    photoNum.frame = CGRectMake(self.bounds.size.width-200-20, 10, 200, 35);
    upLine.frame = CGRectMake(0, 0, self.bounds.size.width, 0.5);
}

+ (CGFloat)accountCellHeight {
    return 35;
}
- (void)addWithidLabel:(NSString *)idtitle photoNum:(NSString *)number {
    
    idLabel.text = idtitle;
    photoNum.text = number;
}

@end
