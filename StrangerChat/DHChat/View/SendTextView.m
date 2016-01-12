//
//  SendTextView.m
//  微信
//
//  Created by Think_lion on 15/7/6.
//  Copyright (c) 2015年 Think_lion. All rights reserved.
//

#import "SendTextView.h"
#import "HMEmotion.h"
#import "HMEmotionAttachment.h"

@implementation SendTextView

-(instancetype)init
{
    self=[super init];
    if(self){
        self.layer.borderColor=[UIColor lightGrayColor].CGColor;
        self.layer.borderWidth=0.5;
        self.layer.cornerRadius=5;
        self.returnKeyType=UIReturnKeySend; //发送按钮
        self.font=MyFont(16);
        //设置键盘自动判断有没有文本的属性
        self.enablesReturnKeyAutomatically=YES;
    }
    return self;
}


- (void)appendEmotion:(HMEmotion *)emotion
{
    if (emotion.emoji) { // emoji表情
        [self insertText:emotion.emoji];
    } else { // 图片表情
        //[self insertText:emotion.chs];
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
        
        // 创建一个带有图片表情的富文本
        HMEmotionAttachment *attach = [[HMEmotionAttachment alloc] init];
        attach.emotion = emotion;
        attach.bounds = CGRectMake(0, -3, self.font.lineHeight, self.font.lineHeight);
        NSAttributedString *attachString = [NSAttributedString attributedStringWithAttachment:attach];
        
        // 记录表情的插入位置
        int insertIndex = self.selectedRange.location;
        
        // 插入表情图片到光标位置
        [attributedText insertAttributedString:attachString atIndex:insertIndex];
        
        // 设置字体
        [attributedText addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, attributedText.length)];
        
        // 重新赋值(光标会自动回到文字的最后面)
        self.attributedText = attributedText;
        
        // 让光标回到表情后面的位置
        self.selectedRange = NSMakeRange(insertIndex + 1, 0);
    }
}

- (NSString *)realText
{
    // 1.用来拼接所有文字
    NSMutableString *string = [NSMutableString string];
    
    // 2.遍历富文本里面的所有内容
    [self.attributedText enumerateAttributesInRange:NSMakeRange(0, self.attributedText.length) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        HMEmotionAttachment *attach = attrs[@"NSAttachment"];
        if (attach) { // 如果是带有附件的富文本
            [string appendString:attach.emotion.chs];
        } else { // 普通的文本
            // 截取range范围的普通文本
            NSString *substr = [self.attributedText attributedSubstringFromRange:range].string;
            [string appendString:substr];
        }
    }];
    
    return string;
}



@end
