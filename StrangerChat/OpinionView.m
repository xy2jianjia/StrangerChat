//
//  OpinionView.m
//  StrangerChat
//
//  Created by zxs on 15/11/30.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "OpinionView.h"

@implementation OpinionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutViews];
    }
    return self;
}

- (void)layoutViews {

    self.backgroundColor = kUIColorFromRGB(0xEEEEEE);
    self.feedback = [[UITextView alloc] init];
    self.feedback.font = [UIFont fontWithName:@"Arial" size:18.0f];
    self.feedback.backgroundColor = kUIColorFromRGB(0xFFFFFF);
    [self addSubview:self.feedback];
    
    self.submit = [[UIButton alloc] init];
    [self.submit.layer setMasksToBounds:true];
    [self.submit.layer setCornerRadius:5.0];
    self.submit.titleLabel.font = [UIFont fontWithName:Typeface size:20.0f];
    [self.submit setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    self.submit.backgroundColor = kUIColorFromRGB(0xf04d6d);
    [self addSubview:self.submit];
    
    titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont fontWithName:@"Arial" size:16.0f];
    titleLabel.textAlignment = NSTextAlignmentRight;
    titleLabel.textColor = kUIColorFromRGB(0x999999);
    [self addSubview:titleLabel];
    
    topLine = [[UILabel alloc] init];
    topLine.backgroundColor = kUIColorFromRGB(0xD0D0D0);
    [self.feedback addSubview:topLine];
    bottomLine = [[UILabel alloc] init];
    bottomLine.backgroundColor = kUIColorFromRGB(0xD0D0D0);
    [self.feedback addSubview:bottomLine];
    
    [self.feedback mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(0);
        make.top.equalTo(self.mas_top).offset(79);
        make.right.equalTo(self.mas_right).offset(0);
        make.height.mas_equalTo(250);
    }];
    
    [self.submit mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(30);
        make.right.equalTo(self.mas_right).offset(-30);
        make.bottom.equalTo(self.feedback.mas_bottom).offset(140);
        make.height.mas_equalTo(55);
    }];
    
    [titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self.mas_right).offset(-10);
        make.bottom.equalTo(self.feedback.mas_bottom).offset(-7);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
}

- (void)layoutSubviews {

    [super layoutSubviews];
    topLine.frame = CGRectMake(0, 0, self.bounds.size.width, 0.5);
    bottomLine.frame = CGRectMake(0, 249.5, self.bounds.size.width, 0.5);
}

- (void)addDataWithtitle:(NSString *)title {
    
    titleLabel.text = title;
}
@end
