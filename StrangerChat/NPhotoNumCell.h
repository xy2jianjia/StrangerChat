//
//  NPhotoNumCell.h
//  StrangerChat
//
//  Created by zxs on 15/11/27.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NPhotoNumCell : UITableViewCell {

    UILabel *textPhoto;
    UILabel *content;
    UILabel *downLine;
}
- (void)addWithtextPhoto:(NSString *)text content:(NSString *)acontent;
@end
