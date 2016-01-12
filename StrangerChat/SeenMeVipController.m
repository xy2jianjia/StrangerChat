//
//  SeenMeVipController.m
//  StrangerChat
//
//  Created by zxs on 15/12/1.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "SeenMeVipController.h"
#import "SeenVipView.h"
@interface SeenMeVipController ()
@property (nonatomic,strong)SeenVipView *tv;
@end

@implementation SeenMeVipController
- (void)loadView {
    
    self.tv = [[SeenVipView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = self.tv;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self n_layoutView];
}
- (void)n_layoutView {
    
    [self.tv addWithcupImage:@"kanguowo-normal" nameLabel:@"李梅" crown:@"crown-normal" someBoy:@"想知道是谁在悄悄触动你吗?" vip:@"成为会员享受实时访客列表查看功能"];
    [self.tv.vipButton setImage:[UIImage imageNamed:@"button--normal"] forState:(UIControlStateNormal)];
    [self.tv.vipButton addTarget:self action:@selector(vipButtonAction) forControlEvents:(UIControlEventTouchUpInside)];
    
#pragma mark --- 改变字体颜色
    NSString *day = @"7";
    NSString *num = @"22";
    self.tv.numLabel.text = [NSString stringWithFormat:@"最近%@天,有%@人来触动过你",day,num];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:self.tv.numLabel.text];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:kUIColorFromRGB(0x1b77bb)
     
                          range:NSMakeRange(2, day.length)];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:[UIColor redColor]
     
                          range:NSMakeRange(5+day.length, num.length)];
    self.tv.numLabel.attributedText = AttributedStr;
    
    
}
#pragma mark --- 成为会员
- (void)vipButtonAction {
    
    NSLog(@"成为会员");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
