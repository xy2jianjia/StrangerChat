//
//  DHMsgPlaySound.m
//  StrangerChat
//
//  Created by xy2 on 16/1/5.
//  Copyright © 2016年 long. All rights reserved.
//

#import "DHMsgPlaySound.h"

@implementation DHMsgPlaySound
- (id)initSystemShake
{
    self = [super init];
    if (self) {
        sound = kSystemSoundID_Vibrate;//震动
    }
    return self;
}

- (id)initSystemSoundWithName:(NSString *)soundName SoundType:(NSString *)soundType
{
    self = [super init];
    if (self) {
        NSString *path = [NSString stringWithFormat:@"/System/Library/Audio/UISounds/%@.%@",@"sms-received1",@"caf"];
        //[[NSBundle bundleWithIdentifier:@"com.apple.UIKit" ]pathForResource:soundName ofType:soundType];//得到苹果框架资源UIKit.framework ，从中取出所要播放的系统声音的路径
        //[[NSBundle mainBundle] URLForResource: @"tap" withExtension: @"aif"];  获取自定义的声音
        if (path) {
            OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&sound);
            if (error != kAudioServicesNoError) {//获取的声音的时候，出现错误
                sound = 0;
            }
        }
    }
    return self;
}

- (void)play
{
    AudioServicesPlaySystemSound(sound);
}
@end
