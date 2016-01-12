//
//  VerificationCell.m
//  StrangerChat
//
//  Created by zxs on 15/11/27.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "VerificationCell.h"

@implementation VerificationCell

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
    _photoNum.placeholder = @"请输入验证码";
    _photoNum.textAlignment = NSTextAlignmentLeft;
    _photoNum.font = [UIFont systemFontOfSize:17.0f];
    [self.contentView addSubview:_photoNum];
    
    upLine = [[UILabel alloc] init];
    upLine.backgroundColor = kUIColorFromRGB(0xD0D0D0);
    [self.contentView addSubview:upLine];
    
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _photoNum.frame = CGRectMake(CGRectGetMaxX(_photo.frame)+5,40, 150, 40);
    upLine.frame = CGRectMake(15, 89.5, self.bounds.size.width, 0.7);

}
@end
