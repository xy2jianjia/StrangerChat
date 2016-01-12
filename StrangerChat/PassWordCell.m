//
//  PassWordCell.m
//  StrangerChat
//
//  Created by zxs on 15/11/27.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "PassWordCell.h"

@implementation PassWordCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        password = [[UILabel alloc] init];
        password.font = [UIFont fontWithName:Typefaces size:18.0f];
        [self.contentView addSubview:password];
        
        number = [[UILabel alloc] init];
        number.font = [UIFont fontWithName:Typefaces size:14.0f];
        number.textAlignment = NSTextAlignmentRight;
        number.textColor = kUIColorFromRGB(0xB3B3B3);
        [self.contentView addSubview:number];
        
        numImage = [[UIImageView alloc] init];
        [self.contentView addSubview:numImage];
        
        gmLabel = [[UILabel alloc] init];
        gmLabel.font = [UIFont fontWithName:Typefaces size:12.0f];
        gmLabel.textColor = kUIColorFromRGB(0xF04D6D);
        [self.contentView addSubview:gmLabel];
        
        _downLine = [[UILabel alloc] init];
        _downLine.backgroundColor = kUIColorFromRGB(0xD0D0D0);
        [self.contentView addSubview:_downLine];
        
        upLine = [[UILabel alloc] init];
        upLine.backgroundColor = kUIColorFromRGB(0xD0D0D0);
        [self.contentView addSubview:upLine];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    password.frame = CGRectMake(15, 10, 80, 35);
    numImage.frame = CGRectMake(self.bounds.size.width - 25 - 20, 20, 25, 15);
    number.frame = CGRectMake(self.bounds.size.width - 200 - 30 - 30, 10, 200, 35);
    gmLabel.frame = CGRectMake(15, CGRectGetMaxY(password.frame), self.bounds.size.width-15, 20);
    upLine.frame = CGRectMake(0, 0, self.bounds.size.width, 0.5);
}

- (void)addpassWord:(NSString *)passwrods number:(NSString *)num numImage:(NSString *)image gmLabel:(NSString *)title {

    password.text = passwrods;
    number.text = num;
    numImage.image = [UIImage imageNamed:image];
    gmLabel.text = title;
}
+ (CGFloat)PassWordCellHeight {
    
    return 75;
}

@end
