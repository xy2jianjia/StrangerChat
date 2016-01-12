//
//  ReplaceView.m
//  StrangerChat
//
//  Created by zxs on 15/11/30.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "ReplaceView.h"

@implementation ReplaceView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self n_layOut];
    }
    return self;
}


- (void)n_layOut {
    
    
    allView = [[UIView alloc] init];
    allView.backgroundColor = [UIColor whiteColor];
    [self addSubview:allView];
    
    
    photo = [[UILabel alloc] init];
    photo.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.0f];
    [allView addSubview:photo];
    
    verificat = [[UILabel alloc] init];
    verificat.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.0f];
    [allView addSubview:verificat];
    
    _photoNum = [[UITextField alloc] init];
    _photoNum.placeholder = @"请输入手机号码";
    _photoNum.clearButtonMode =  UITextFieldViewModeAlways;
    _photoNum.keyboardType = UIKeyboardTypeASCIICapable;
    _photoNum.returnKeyType = UIReturnKeyDone;
    _photoNum.textAlignment = NSTextAlignmentLeft;
    _photoNum.font = [UIFont systemFontOfSize:17.0f];
    [allView addSubview:_photoNum];
    
    _verification = [[UITextField alloc] init];
    _verification.placeholder = @"请输入验证码";
    _verification.clearButtonMode =  UITextFieldViewModeAlways;
    _verification.keyboardType = UIKeyboardTypeASCIICapable;
    _verification.returnKeyType = UIReturnKeyDone;
    _verification.textAlignment = NSTextAlignmentLeft;
    _verification.font = [UIFont systemFontOfSize:17.0f];
    [allView addSubview:_verification];
    
    
    _obtain = [[UIButton alloc] init];
    [_obtain.layer setMasksToBounds:true];
    [_obtain.layer setCornerRadius:3.0];
    [_obtain setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    _obtain.titleLabel.font = [UIFont fontWithName:Typeface size:15.0f];
    _obtain.backgroundColor = kUIColorFromRGB(0xf04d6d);
    [allView addSubview:_obtain];
    
    upLine = [[UILabel alloc] init];
    upLine.backgroundColor = kUIColorFromRGB(0xD0D0D0);
    [allView addSubview:upLine];
    
    downLine = [[UILabel alloc] init];
    downLine.backgroundColor = kUIColorFromRGB(0xD0D0D0);
    [allView addSubview:downLine];
    
    _seconds = [[UIButton alloc] init];
    [_seconds.layer setMasksToBounds:true];
    [_seconds.layer setCornerRadius:3.0];
    [_seconds setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    _seconds.titleLabel.font = [UIFont fontWithName:Typeface size:15.0f];
    _seconds.backgroundColor = kUIColorFromRGB(0xF04D6D);
    [allView addSubview:_seconds];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    allView.frame = CGRectMake(0, 64, self.bounds.size.width, 180);
    photo.frame = CGRectMake(15, 40, 55, 40);
    verificat.frame = CGRectMake(15, 130, 55, 40);
    _photoNum.frame = CGRectMake(CGRectGetMaxX(photo.frame)+5,40, 150, 40);
    _verification.frame = CGRectMake(CGRectGetMaxX(verificat.frame)+5,130, 150, 40);
    _obtain.frame = CGRectMake(self.bounds.size.width - 100 - 15, 40, 100, 40);
    upLine.frame = CGRectMake(15, 89.5, self.bounds.size.width, 0.5);
    downLine.frame = CGRectMake(15, 179.5, self.bounds.size.width, 0.5);
    
}

- (void)addWithphoto:(NSString *)phototext verificat:(NSString *)verification {
    
    photo.text = phototext;
    verificat.text = verification;
}

@end
