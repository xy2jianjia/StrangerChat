//
//  PassView.h
//  StrangerChat
//
//  Created by zxs on 15/11/28.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PassView : UIView{
    
    UIView *allView;
    UILabel *upLine;
    UILabel *downLine;
    UILabel *photo;
    UILabel *verificat;
}

@property (nonatomic,strong)UITextField *photoNum;
@property (nonatomic,strong)UITextField *verification;  // 验证ma
- (void)addWithphoto:(NSString *)phototext verificat:(NSString *)verification;

@end
