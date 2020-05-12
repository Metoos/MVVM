//
//  CaptchaButton.m
//  MVVM
//
//  Created by mac on 2019/12/16.
//  Copyright © 2019 hdyg. All rights reserved.
//

#import "CaptchaButton.h"
#import "SendVerificationCode.h"


@interface CaptchaButton()<SendVerificationCodeDelegate>

@property (strong,nonatomic)  SendVerificationCode *sendVerCode;

@end

@implementation CaptchaButton

#pragma mark - 发送短信
- (void)sendSmsWithPhoneNumber:(NSString *)phone
                      areaCode:(NSString *)areaCode
{
    if ([phone isEqualToString:@""]) {
        [UniversalManager showWithErrorMessage:@"请输入手机号"];
    }else
    {
        [self.sendVerCode sendVerCodeWithPhoneNum:phone areaCode:areaCode];
        [self setTitle:@"发送中..." forState:UIControlStateNormal];
        self.userInteractionEnabled = NO;
    }
}

#pragma mark - 验证码回调
- (void)smsSendSuccess;
{
    DLog(@"发送成功");
    
}
- (void)smsSendFail:(NSString*)msg//发送验证码失败
{
    DLog(@"发送失败");
    
    [UniversalManager showWithErrorMessage:msg?msg:@"发送验证码失败"];
    [self setTitle:@"重新发送" forState:UIControlStateNormal];
    self.userInteractionEnabled = YES;
}
- (void)VerificationCodeInvalid//验证码时失效回调
{
    [self setTitle:@"重新发送" forState:UIControlStateNormal];
    self.userInteractionEnabled = YES;
    //清除上一次获取的验证码
}
- (void)CountdownWithCount:(int)count//倒计时时间回调
{
    //    counts = count;
    self.userInteractionEnabled = NO;
    //NSLog(@"更新时间");
    NSString *timeStr =[NSString stringWithFormat:@"%ds",count];
    
    [self setTitle:timeStr forState:UIControlStateNormal];
    
}

- (SendVerificationCode *)sendVerCode
{
    if (!_sendVerCode) {
        _sendVerCode = [[SendVerificationCode alloc]init];
        _sendVerCode.delegate = self;
    }
    return _sendVerCode;
}

@end
