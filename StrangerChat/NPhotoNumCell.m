//
//  NPhotoNumCell.m
//  StrangerChat
//
//  Created by zxs on 15/11/27.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "NPhotoNumCell.h"

@implementation NPhotoNumCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        textPhoto = [[UILabel alloc] init];
        textPhoto.font = [UIFont fontWithName:Typefaces size:18.0f];
        [self.contentView addSubview:textPhoto];
        
        content = [[UILabel alloc] init];
        content.font = [UIFont fontWithName:Typefaces size:14.0f];
        content.textAlignment = NSTextAlignmentRight;
        content.textColor = kUIColorFromRGB(0xB3B3B3);
        [self.contentView addSubview:content];
        
        downLine = [[UILabel alloc] init];
        downLine.backgroundColor = kUIColorFromRGB(0xD0D0D0);
        [self.contentView addSubview:downLine];
    }
    return self;
}

- (void)layoutSubviews {

    [super layoutSubviews];
    textPhoto.frame = CGRectMake(15, 10, 80, 35);
    content.frame = CGRectMake(self.bounds.size.width - 230 - 30, 10, 230, 35);
    downLine.frame = CGRectMake(0, 54.5, self.bounds.size.width, 0.5);
}

- (void)addWithtextPhoto:(NSString *)text content:(NSString *)acontent {

    textPhoto.text = text;
    content.text = acontent;
}

@end
