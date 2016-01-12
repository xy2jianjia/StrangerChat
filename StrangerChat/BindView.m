//
//  BindView.m
//  StrangerChat
//
//  Created by zxs on 15/11/28.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "BindView.h"

@implementation BindView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        photoImage = [[UIImageView alloc] init];
        [self addSubview:photoImage];
        
        bindNum = [[UILabel alloc] init];
        bindNum.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0f];
        bindNum.textAlignment = NSTextAlignmentCenter;
        [self addSubview:bindNum];
        
        _replacement = [[UIButton alloc] init];
        [_replacement.layer setMasksToBounds:true];
        [_replacement.layer setCornerRadius:7.0];
        [_replacement setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _replacement.titleLabel.font = [UIFont fontWithName:Typeface size:20.0f];
        _replacement.backgroundColor = kUIColorFromRGB(0xF04D6D);
        [self addSubview:_replacement];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    photoImage.frame = CGRectMake((self.bounds.size.width-110)/2+15, 64+40, 110, 155);
    bindNum.frame = CGRectMake(40, CGRectGetMaxY(photoImage.frame)+35, self.bounds.size.width - 40*2, 40);
    _replacement.frame = CGRectMake(30, CGRectGetMaxY(bindNum.frame)+70, self.bounds.size.width-30*2, 50);

}


- (void)addDataWithphotoImage:(NSString *)image bindNum:(NSString *)bind {

    photoImage.image = [UIImage imageNamed:image];
    bindNum.text = bind;
}

@end
