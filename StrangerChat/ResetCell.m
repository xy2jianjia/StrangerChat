//
//  ResetCell.m
//  StrangerChat
//
//  Created by zxs on 15/11/27.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "ResetCell.h"

@implementation ResetCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self n_layOut];
    }
    return self;
}



- (UILabel *)photo
{
    if (_photo == nil) {
        
        _photo= [[UILabel alloc] init];
        _photo.frame = CGRectMake(15, 40, 55, 40);
        _photo.font = [UIFont fontWithName:Typefaces size:17.0f];
        [self.contentView addSubview:_photo];
    }
    return _photo;
}


- (void)n_layOut {

    
    _photoNum = [[UITextField alloc] init];
    _photoNum.placeholder = @"请输入手机号码";
    _photoNum.textAlignment = NSTextAlignmentLeft;
    _photoNum.font = [UIFont systemFontOfSize:17.0f];
    [self.contentView addSubview:_photoNum];
    
    _obtain = [[UIButton alloc] init];
    [_obtain.layer setMasksToBounds:true];
    [_obtain.layer setCornerRadius:3.0];
    [_obtain setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    _obtain.titleLabel.font = [UIFont fontWithName:Typefaces size:15.0f];
    _obtain.backgroundColor = kUIColorFromRGB(0xf04d6d);
    [self.contentView addSubview:_obtain];
    
    _seconds = [[UIButton alloc] init];
    [_seconds.layer setMasksToBounds:true];
    [_seconds.layer setCornerRadius:3.0];
    [_seconds setTitle:@"60s后重新发送" forState:(UIControlStateNormal)];
    [_seconds setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    _seconds.titleLabel.font = [UIFont fontWithName:Typefaces size:15.0f];
    _seconds.backgroundColor = kUIColorFromRGB(0xf04d6d);
    [self.contentView addSubview:_seconds];
    
    
    
    
    upLine = [[UILabel alloc] init];
    upLine.backgroundColor = kUIColorFromRGB(0xD0D0D0);
    [self.contentView addSubview:upLine];
    
    _downLine = [[UILabel alloc] init];
    _downLine.backgroundColor = kUIColorFromRGB(0xD0D0D0);
    [self.contentView addSubview:_downLine];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _photoNum.frame = CGRectMake(CGRectGetMaxX(_photo.frame)+5,40, 150, 40);
    _obtain.frame = CGRectMake(self.bounds.size.width - 100 - 15, 40, 100, 40);
    _seconds.frame = CGRectMake(self.bounds.size.width - 130 - 15, 40, 130, 40);
    upLine.frame = CGRectMake(0, 0, self.bounds.size.width, 0.5);
    _downLine.frame = CGRectMake(15, 89.5, self.bounds.size.width, 0.5);
}

+ (CGFloat)resetCellHeight {
    return 90;
}


@end
