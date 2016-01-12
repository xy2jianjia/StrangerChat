//
//  HAssetsCell.h
//  StrangerChat
//
//  Created by zxs on 15/11/25.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HAssetsCell : UITableViewCell {

    UILabel *assets;
    UIImageView *monthImage;
    UILabel *month;
    UIImageView *propertyImage;  // 房产
    UILabel *property;
    UIImageView *carImage;
    UILabel *car;
    UIImageView *vipImage;
    UILabel *upLine;
    UILabel *downLine;
}

- (void)addDataWithassets:(NSString *)assetsTitle monthImage:(NSString *)monImage month:(NSString *)mon propertyImage:(NSString *)proImage property:(NSString *)proper carImage:(NSString *)carImag car:(NSString *)cars vipImage:(NSString *)vip;

+ (CGFloat)assetscellHeight;
@end
