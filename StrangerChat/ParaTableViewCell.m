//
//  ParaTableViewCell.m
//  ParallaxScroll_Demo
//
//  Created by Tom on 15/11/25.
//  Copyright © 2015年 Tom. All rights reserved.
//

#import "ParaTableViewCell.h"

@interface ParaTableViewCell()
{
    UIImageView *backImv;
    UIView *infoView;
    UIImageView *avaterImv;
    
    UILabel *titleLabel;
    UIImageView *smallImage;
    UILabel * ageLabel;
    UIImageView *addressImage;
    UILabel * addressLabel;
    UIImageView *clockImage;
    UILabel *clockLabel;
}
@end

@implementation ParaTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self n_layoutView];
    }
    return self;
}


- (void)n_layoutView {

    backImv = [[UIImageView alloc]init];
    backImv.clipsToBounds = YES;
    backImv.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:backImv];
    
    infoView = [[UIView alloc]init];
    [self.contentView addSubview:infoView];
    
    avaterImv = [[UIImageView alloc]init];
    avaterImv.backgroundColor = [UIColor whiteColor];
    avaterImv.contentMode = UIViewContentModeScaleAspectFill;  // 内容缩放以填充固定的方面
    avaterImv.clipsToBounds = YES;
    [infoView addSubview:avaterImv];

    _heartImage = [[UIImageView alloc] init];
    _heartImage.clipsToBounds = YES;
    _heartImage.contentMode = UIViewContentModeScaleAspectFill;
    [infoView addSubview:_heartImage];
    
    _wxImage = [[UIImageView alloc] init];
    _wxImage.clipsToBounds = YES;
    _wxImage.contentMode = UIViewContentModeScaleAspectFill;
    [infoView addSubview:_wxImage];
    
    titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont fontWithName:Typefaces size:18.0f];
    [infoView addSubview:titleLabel];
    
    smallImage = [[UIImageView alloc] init];
    smallImage.clipsToBounds = YES;
    smallImage.contentMode = UIViewContentModeScaleAspectFill;
    [infoView addSubview:smallImage];
    
    ageLabel = [[UILabel alloc] init];
    ageLabel.font = [UIFont fontWithName:Typefaces size:13.0f];
    [infoView addSubview:ageLabel];
    
    addressImage = [[UIImageView alloc] init];
    addressImage.clipsToBounds = YES;
    addressImage.contentMode = UIViewContentModeScaleAspectFit;
    [infoView addSubview:addressImage];
    
    addressLabel = [[UILabel alloc] init];
    addressLabel.font = [UIFont fontWithName:Typefaces size:13.0f];
    [infoView addSubview:addressLabel];
    
    clockImage = [[UIImageView alloc] init];
    clockImage.clipsToBounds = YES;
    clockImage.contentMode = UIViewContentModeScaleAspectFit;
    [infoView addSubview:clockImage];
    
    clockLabel = [[UILabel alloc] init];
    clockLabel.textAlignment = NSTextAlignmentRight;
    clockLabel.font = [UIFont fontWithName:Typefaces size:13];
    [infoView addSubview:clockLabel];
    
}

// heartImage wxImage titleLabel smallImage ageLabel addressImage addressLabel clockImage clockLabel
- (void)layoutSubviews {
    [super layoutSubviews];
    backImv.frame      = CGRectMake(0, 64, self.contentView.frame.size.width, 100);
    infoView.frame     = CGRectMake(0, CGRectGetMaxY(backImv.frame), self.contentView.frame.size.width, 110);
    avaterImv.frame    = CGRectMake(0, 0, 85, 85);
    avaterImv.center   = CGPointMake(CGRectGetMidX(infoView.bounds), CGRectGetMinY(infoView.bounds));
    avaterImv.layer.cornerRadius = CGRectGetWidth(avaterImv.frame)/2;
    _heartImage.frame   = CGRectMake(CGRectGetMinX(avaterImv.frame)-35-30, 15, 30, 30);
    _wxImage.frame      = CGRectMake(CGRectGetMaxX(avaterImv.frame)+30, 15, 30, 30);
    titleLabel.frame   = CGRectMake(self.bounds.size.width/2 -100, CGRectGetMaxY(_wxImage.frame), 200, 35);
    smallImage.frame   = CGRectMake(20, 110-18-5, 12, 12);
    ageLabel.frame     = CGRectMake(CGRectGetMaxX(smallImage.frame)+5, CGRectGetMinY(smallImage.frame)-3, 40, 18);
    addressImage.frame = CGRectMake(CGRectGetMaxX(ageLabel.frame), CGRectGetMinY(ageLabel.frame)+2, 10.5, 12.5);
    addressLabel.frame = CGRectMake(CGRectGetMaxX(addressImage.frame)+5, CGRectGetMinY(addressImage.frame)-2, 80, 18);
    clockLabel.frame   = CGRectMake(self.bounds.size.width-170-20, CGRectGetMinY(addressImage.frame)-2, 170, 18);
    clockImage.frame   = CGRectMake(CGRectGetMinX(clockLabel.frame)-18, CGRectGetMinY(clockLabel.frame)+2, 12, 12);
    
}

+(CGFloat)cellHeight
{
    return 274;
}

/*
 * groudImage 背景图
 * aimage     头像
 * heart      心形图
 * picture    微信图
 * nickname   昵称
 * image      年龄图
 * age        年龄
 * dreImage   地址图
 * address    地址
 * timeImage  时间图
 * time       时间
 **/

- (void)cellLoadDataWithBackground:(NSString *)groudImage heart:(NSString *)heart wxpic:(NSString *)picture ageImage:(NSString *)image age:(NSString *)age dressImage:(NSString *)dreImage address:(NSString *)address timeImage:(NSString *)timeImage time:(NSString *)time model:(NHome *)item{
    
    ageLabel.text     = age;
    clockLabel.text   = [NSString stringWithFormat:@"登陆时间: %@",time];
    addressLabel.text = address;
    _wxImage.image     = [UIImage imageNamed:picture];
    _heartImage.image  = [UIImage imageNamed:heart];
    smallImage.image  = [UIImage imageNamed:image];
    backImv.image     = [UIImage imageNamed:groudImage];
    clockImage.image  = [UIImage imageNamed:timeImage];
    addressImage.image = [UIImage imageNamed:dreImage];
    
}

- (void)cellLoadWithnickname:(NSString *)nickname model:(NHome *)item{
    if ([item.vip integerValue] == 1) {
        titleLabel.textColor = [UIColor colorWithRed:236/255.0 green:38/255.0 blue:68/255.0 alpha:1];
    }
    titleLabel.text   = nickname;
}

- (void)cellLoadWithurlStr:(NSURL *)url {
    
    [avaterImv sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"btn-love60x60-n"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
}

- (void)updateHeightWithRect:(CGRect)rect
{
    backImv.frame = rect;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
