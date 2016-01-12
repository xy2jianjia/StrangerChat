//
//  PassView.m
//  StrangerChat
//
//  Created by zxs on 15/11/28.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "PassView.h"

@implementation PassView

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
    _photoNum.placeholder = @"密码长度6~16位,由数字和字母组成";
    _photoNum.clearButtonMode =  UITextFieldViewModeAlways;
    _photoNum.keyboardType = UIKeyboardTypeASCIICapable;
    _photoNum.returnKeyType = UIReturnKeyDone;
    _photoNum.textAlignment = NSTextAlignmentLeft;
    _photoNum.font = [UIFont systemFontOfSize:17.0f];
    [allView addSubview:_photoNum];
    
    _verification = [[UITextField alloc] init];
    _verification.placeholder = @"再次输入密码";
    _verification.clearButtonMode =  UITextFieldViewModeAlways;
    _verification.keyboardType = UIKeyboardTypeASCIICapable;
    _verification.returnKeyType = UIReturnKeyDone;
    _verification.textAlignment = NSTextAlignmentLeft;
    _verification.font = [UIFont systemFontOfSize:17.0f];
    [allView addSubview:_verification];
    
    
    upLine = [[UILabel alloc] init];
    upLine.backgroundColor = kUIColorFromRGB(0xD0D0D0);
    [allView addSubview:upLine];
    
    downLine = [[UILabel alloc] init];
    downLine.backgroundColor = kUIColorFromRGB(0xD0D0D0);
    [allView addSubview:downLine];
    
    
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    allView.frame = CGRectMake(0, 64, self.bounds.size.width, 180);
    photo.frame = CGRectMake(15, 40, 55, 40);
    verificat.frame = CGRectMake(15, 130, 85, 40);
    _photoNum.frame = CGRectMake(CGRectGetMaxX(photo.frame)+5,40, self.bounds.size.width - 15 - 55 - 5, 40);
    _verification.frame = CGRectMake(CGRectGetMaxX(verificat.frame)+5,130, self.bounds.size.width - 15 - 85 - 5, 40);
    upLine.frame = CGRectMake(15, 89.5, self.bounds.size.width, 0.5);
    downLine.frame = CGRectMake(15, 179.5, self.bounds.size.width, 0.5);
    
}

- (void)addWithphoto:(NSString *)phototext verificat:(NSString *)verification {
    
    photo.text = phototext;
    verificat.text = verification;
}

@end
