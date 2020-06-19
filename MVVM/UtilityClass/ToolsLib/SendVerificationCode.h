//
//  SendVerificationCode.h
//  ZongShengTrainVideo
//
//  Created by zjq on 2017/6/11.
//  Copyright © 2017年 zjq. All rights reserved.
//

typedef NS_ENUM(NSInteger,MsgType) {
    
    RegisterMsg = 1, //注册
    WithdrawalMsg = 2,//提现验证码
    BankCardMsg = 3,//绑定银行卡验证码
    ReplaceBankCardMsg = 4,//换绑获取验证码
    RetrievePasswordMsg,//找回密码验证码
    RealnameMsg,//实名认证验证码
    ForgetPayPwd ,//找回支付密码验证码
    BindCreditCardMsg,//绑定信用卡验证码
    PayCreditCardMsg,//信用卡支付验证码
    LoanMsg,//贷款验证码
//    OrdinaryMsg,//普通短信验证码
    
};


@protocol SendVerificationCodeDelegate <NSObject>
@optional
- (void)smsSendSuccessWithMsgVarCode:(NSString*)msgVarCode;//发送验证码成功

- (void)smsSendSuccess;//发送成功回调
- (void)smsSendFail:(NSString*)msg;//发送验证码失败
- (void)VerificationCodeInvalid;//验证码时失效回调
- (void)CountdownWithCount:(int)count;//倒计时回调

@end


#import <Foundation/Foundation.h>

#define MessageCodeTimer 60//短信验证码有效时间（秒）



@interface SendVerificationCode : NSObject

 

@property (weak, nonatomic)id<SendVerificationCodeDelegate> delegate;

/** 发送验证码 
 * @Param phone 手机号
 */
- (void) sendVerCodeWithPhoneNum:(NSString*)phone;
- (void) sendVerCodeWithPhoneNum:(NSString*)phone areaCode:(NSString *)areaCode;
- (void) sendVerCodeWithPhoneNum:(NSString*)phone AndMsgType:(MsgType)typeMsg;
- (void) sendVerCodeWithPhoneNum:(NSString*)phone AndMsgType:(MsgType)typeMsg otherParameter:(NSString*)otherParameter;

/** 销毁定时器 */
- (void)invalidateTimer;

@end


@interface MsgCodeModel : NSObject

@property (assign, nonatomic) NSInteger code;

@property (copy,   nonatomic) NSString *message;

@property (strong, nonatomic) NSDictionary *data;
@end
