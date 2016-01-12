//
//  HeaderReusableView.m
//  StrangerChat
//
//  Created by zxs on 15/11/20.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "HeaderReusableView.h"

@implementation HeaderReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self p_setupView];
    }
    return self;
}
// @"Helvetica-Bold"
- (void)p_setupView {

    view = [[UIView alloc] initWithFrame:self.bounds];
    view.backgroundColor = kUIColorFromRGB(0xEEEEEE);
    [self addSubview:view];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont fontWithName:Typefaces size:18.0f];
    self.nameLabel.textColor = kUIColorFromRGB(0x999999);
    [view addSubview:self.nameLabel];
    
    self.secUpdate = [[UIButton alloc] init];
    [view addSubview:self.secUpdate];
    
    self.update = [[UIButton alloc] init];
    [view addSubview:self.update];
    
    self.footButton = [[UIButton alloc] init];
    [view addSubview:self.footButton];
    
    self.secFootButton = [[UIButton alloc] init];
    [view addSubview:self.secFootButton];
    
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.nameLabel.frame = CGRectMake(15, 10, 120, 40);
    self.secUpdate.frame = CGRectMake(self.frame.size.width - 40-15, 10, 40, 40);
    self.update.frame = CGRectMake(self.frame.size.width - 40-15, 10, 40, 40);
    self.footButton.frame = CGRectMake(self.frame.size.width - 40-15, 10, 40, 40);
    self.secFootButton.frame = CGRectMake(self.frame.size.width - 40-15, 10, 40, 40);
}

@end
