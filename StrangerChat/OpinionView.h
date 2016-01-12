//
//  OpinionView.h
//  StrangerChat
//
//  Created by zxs on 15/11/30.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OpinionView : UIView {

    UILabel *titleLabel;
    UILabel *topLine;
    UILabel *bottomLine;
    
}
@property (nonatomic,strong)UIButton *submit;
@property (nonatomic,strong)UITextView *feedback;
- (void)addDataWithtitle:(NSString *)title;
@end
