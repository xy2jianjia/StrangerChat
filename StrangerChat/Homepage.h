//
//  Homepage.h
//  StrangerChat
//
//  Created by zxs on 15/11/25.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParaTableViewCell.h"
#import "N_photoViewCell.h"
#import "HMakeFriendCell.h"
#import "HTBasicdataCell.h"
#import "HAssetsCell.h"
#import "HPersonalityCell.h"
#import "HMarriageCell.h"
#import "HChooseCell.h"
#import "NPhotoController.h"
#import "NHome.h"
#import "NConditonModel.h"
#import "NVIpAssetsCell.h"
#import "EyeLuckModel.h"

#define KCell_A @"kcell_1"
#define KCell_B @"kcell_2"
#define KCell_C @"kcell_3"
#define KCell_D @"kcell_4"
#define KCell_E @"kcell_5"
#define KCell_F @"kcell_6"
#define KCell_G @"kcell_7"
#define KCell_H @"kcell_8"
#define KCell_J @"kcell_9"
@interface Homepage : UIViewController
@property (nonatomic,strong)NSString *touchP2;
@property (nonatomic,strong) DHUserForChatModel *item;

@end
