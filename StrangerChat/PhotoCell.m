//
//  PhotoCell.m
//  StrangerChat
//
//  Created by zxs on 15/11/24.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "PhotoCell.h"

@implementation PhotoCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _simage = [[UIImageView alloc] initWithFrame:self.bounds];
        _simage.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_simage];
    }
    return self;
}
@end
