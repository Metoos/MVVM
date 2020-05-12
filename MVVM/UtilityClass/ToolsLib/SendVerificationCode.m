//
//  SendVerificationCode.m
//  ZongShengTrainVideo
//
//  Created by zjq on 2017/6/11.
//  Copyright © 2017年 zjq. All rights reserved.
//

#import "SendVerificationCode.h"
//static SendVerificationCode *sendVerCode = nil;
@implementation SendVerificationCode
{
    NSTimer *timer;
    int count;
    NSString *_msgVarCode;
}

- (void) sendVerCodeWithPhoneNum:(NSString *)phone;
{
    [self sendVerCodeWithPhoneNum:phone AndMsgType:0];
}

- (void) sendVerCodeWithPhoneNum:(NSString*)phone areaCode:(NSString *)areaCode;
{
    [self sendVerCodeWithPhoneNum:phone AndMsgType:0 otherParameter:areaCode];
}

- (void) sendVerCodeWithPhoneNum:(NSString*)phone AndMsgType:(MsgType)typeMsg
{
    [self sendVerCodeWithPhoneNum:phone AndMsgType:typeMsg otherParameter:nil];

}

- (void) sendVerCodeWithPhoneNum:(NSString*)phone AndMsgType:(MsgType)typeMsg otherParameter:(NSString*)otherParameter
{
    
    DLog(@"短信验证码");
    NSString *language = [[JQLanguageTool sharedInstance] currentLanguage];
    NSDictionary * parameters = @{@"phone":phone,@"quhao":otherParameter?:@"",@"lang":[self systemLanguageConverAPILanguageString:language]};
    
    //处理接口请求全局统一参数
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:(NSDictionary *)parameters copyItems:YES];
    NSString *timestamp = [UniversalManager getSyetemTimeInterval];
    //在参数中添加时间戳和签名字段
    [dic setObject:timestamp forKey:@"timestamp"];
    NSString *sign = [UniversalManager md5EncryptStrWithParam:dic];
    [dic setObject:sign forKey:@"sign"];
    parameters = dic;
    [[JQHttpClient defaultClient] requestWithPath:API_GET_VERCODE method:JQHttpRequestPostString parameters:parameters prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        DLog(@"responseObject = %@",responseObject);
        MsgCodeModel *msgCode = [MsgCodeModel mj_objectWithKeyValues:responseObject];
        if (msgCode.code == successed) {
            [self countDown];
            if (_delegate && [_delegate respondsToSelector:@selector(smsSendSuccess)]) {
                [_delegate smsSendSuccess];
            }
            
        }else
        {
            if (_delegate && [_delegate respondsToSelector:@selector(smsSendFail:)]) {
                [_delegate smsSendFail:msgCode.message];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error = %@",error);
        if (_delegate && [_delegate respondsToSelector:@selector(smsSendFail:)]) {
            [_delegate smsSendFail:nil];
        }
        
    }];
    
}
#pragma mark -  系统语言名称字符串转换成接口的语言表示字符串
- (NSString *)systemLanguageConverAPILanguageString:(NSString *)systemLanguage
{
    
    if ([systemLanguage hasPrefix:@"zh"]) {
        return @"zh_CN";
    }else if ([systemLanguage hasPrefix:@"en"]) {
        return @"en_US";
    }else if ([systemLanguage hasPrefix:@"ja"]) {
        return @"ja_JP";
    }else if ([systemLanguage hasPrefix:@"ko"]) {
        return @"ko_KP";
    }else if ([systemLanguage hasPrefix:@"ru"]) {
        return @"ru_RU";
    }
    return systemLanguage;
}

- (void)countDown
{
  
    [self invalidateTimer];
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                             target:self
                                           selector:@selector(updateTime)
                                           userInfo:nil
                                            repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
  
}


#pragma mark -销毁定时器
- (void)invalidateTimer
{
    [timer invalidate];
    timer = nil;
    count = 0;

}

-(void)updateTime
{
    count++;
    if (count>=MessageCodeTimer) {
        [timer invalidate];
        
        //清除上一次获取的验证码
        _msgVarCode = nil;
        if (_delegate && [_delegate respondsToSelector:@selector(VerificationCodeInvalid)]) {
            [_delegate VerificationCodeInvalid];
        }
        return;
    }else{
       
        
        if (_delegate && [_delegate respondsToSelector:@selector(CountdownWithCount:)]) {
            int Timeleft = MessageCodeTimer-count;
            [_delegate CountdownWithCount:Timeleft];
        }
        
    }
    
}

@end


@implementation MsgCodeModel

@end
