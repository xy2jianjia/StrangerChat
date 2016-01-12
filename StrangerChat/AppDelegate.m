//
//  AppDelegate.m
//  StrangerChat
//
//  Created by long on 15/10/2.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "MainViewController.h"
#import "DHRegFirstViewController.h"
#import "DHLoginViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStateChange:) name:@"loginStateChange"object:nil];
    

    [self loginStateChange:nil];
    [self.window makeKeyAndVisible];
    [WXApi registerApp:@"wxc54fb6246e2e5fdf"];
    
    
    return YES;
}
#pragma mark ----重写微信 openURL（return是微信的方法） 和 handleOpenURL方法
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    return [WXApi handleOpenURL:url delegate:self];
}

#pragma mark  ----微信代理方法 实现和微信终端交互请求与回应
- (void)onReq:(BaseReq *)req {
    
    
}

- (void)onResp:(BaseResp *)resp {
    
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                break;
                
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
    }
    
    
}
//登陆状态改变
-(void)loginStateChange:(NSNotification *)notification
{
    UINavigationController *nav = nil;
    BOOL isLoad = NO;
    NSString *isLoaded = [NSGetTools getIsLoad];
    if ([isLoaded isEqualToString:@"isLoad"]) {
        isLoad = YES;
    }else if ([isLoaded isEqualToString:@"noLoad"]){
        isLoad = NO;
    }else{
        isLoad = NO;
    }
    if (isLoad) {
        
        [self loadMainControllers];
        
        ViewController *vc = [[ViewController alloc]init];
//        nav = [[UINavigationController alloc] initWithRootViewController:vc];
        self.window.rootViewController = vc;
    }else{
        MainViewController *mainVC = [MainViewController new];
        nav = [[UINavigationController alloc] initWithRootViewController:mainVC];
        self.window.rootViewController = nav;
        
    }
//    DHLoginViewController *vc = [[DHLoginViewController alloc]init];
//    nav = [[UINavigationController alloc]initWithRootViewController:vc];
//    nav.navigationBar.barTintColor = [UIColor redColor];
//    [nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
}
- (void)loadMainControllers{
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    // 连接通信服务器
    [[SocketManager shareInstance] ClientConnectServer];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
-(void)dealloc{
    [Mynotification removeObserver:self];
}
@end
