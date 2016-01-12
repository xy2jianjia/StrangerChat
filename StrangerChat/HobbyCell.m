//
//  HobbyCell.m
//  StrangerChat
//
//  Created by zxs on 15/11/20.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "HobbyCell.h"

@implementation HobbyCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self p_setupView];
    }
    return self;
}

- (void)p_setupView
{
    // @"Helvetica-Bold"
    
    self.collectionLabel = [[UILabel alloc] initWithFrame:self.contentView.bounds];
    self.collectionLabel.backgroundColor = [UIColor whiteColor];
    self.collectionLabel.layer.borderColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]CGColor];
    self.collectionLabel.font = [UIFont systemFontOfSize:14.0f];
    self.collectionLabel.textAlignment = NSTextAlignmentCenter;
    self.collectionLabel.layer.borderWidth = 0.5f;
    self.collectionLabel.layer.cornerRadius =3.0;
    self.collectionLabel.layer.masksToBounds = YES;
    [self.contentView addSubview:self.collectionLabel];
    
}


- (void)layoutSubviews {

    [super layoutSubviews];

    self.collectionLabel.frame = self.bounds;

}






@end
