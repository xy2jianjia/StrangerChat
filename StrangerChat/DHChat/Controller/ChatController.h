//
//  ChatController.h
//  微信
//
//  Created by Think_lion on 15/6/18.
//  Copyright (c) 2015年 Think_lion. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ChatController : UIViewController

//@property (nonatomic,strong) NSString *jid;
////聊天用户的 头像
//@property (nonatomic,weak) UIImage *photo;
//@property (nonatomic,copy) NSString *photoUrl;

@property (nonatomic ,strong)Message *item;
//
@property (nonatomic,strong) DHUserForChatModel *userInfo;
@end
