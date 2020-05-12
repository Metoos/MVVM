//
//  JQTouchIDAndFaceIDManager.m
//  DigitalTreasure
//
//  Created by mac on 2019/9/12.
//  Copyright © 2019 hdyg. All rights reserved.
//

#import "JQTouchIDAndFaceIDManager.h"

@implementation JQTouchIDAndFaceIDManager


+ (void)jq_touchIDOrFaceIDLocalAuthenticationFallBackTitle:(NSString *)fallBackTitle
                                           localizedReason:(NSString *)reasonTitle
                                                  callBack:(void(^)(BOOL isSuccess,NSError *_Nullable error,NSString *message))fingerBlock
{
    //创建LAContext
    LAContext *context = [LAContext new]; //这个属性是设置指纹/面容输入失败之后的弹出框的选项
    context.localizedFallbackTitle = fallBackTitle;
    NSError *error = nil;
    BOOL isIphoneX = [self jq_isIphoneX];
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                             error:&error]) {
        
        NSLog(isIphoneX?@"支持面容识别":@"支持指纹识别");
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                localizedReason:reasonTitle reply:^(BOOL success, NSError * _Nullable error) {
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        fingerBlock(success,error,[self referenceErrorCode:error.code fallBack:fallBackTitle]);
                    }];
                    NSLog(isIphoneX?@"面容错误是:%@":@"指纹错误是:%@",error.localizedDescription);
                }];
        
    }else{
        
        if (error.code == LAErrorTouchIDLockout && [[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
            [context evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:@"重新开启TouchID功能" reply:^(BOOL success, NSError * _Nullable error) {
                
                if (success) {
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        [JQTouchIDAndFaceIDManager jq_touchIDOrFaceIDLocalAuthenticationFallBackTitle:fallBackTitle localizedReason:reasonTitle callBack:fingerBlock];
                    }];
                } NSLog(isIphoneX?@"[MHD_FingerPrintVerify]面容错误是:%@":@"[MHD_FingerPrintVerify]指纹错误是:%@",error.localizedDescription);
            }];
            return;
        }
        NSLog(isIphoneX?@"[MHD_FingerPrintVerify]不支持面容识别":@"[MHD_FingerPrintVerify]不支持指纹识别");
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            fingerBlock(false,error,[self referenceErrorCode:error.code fallBack:fallBackTitle]);
        }];
        
        NSLog(isIphoneX?@"[MHD_FingerPrintVerify]面容错误是:%@":@"[MHD_FingerPrintVerify]指纹错误是:%@",error.localizedDescription);
    }
}
#pragma mark 返回错误参考信息
+ (NSString *)referenceErrorCode:(NSInteger)errorCode fallBack:(NSString *)fallBackStr
{
    BOOL isIphoneX = [self jq_isIphoneX];
    switch (errorCode) {
        case LAErrorAuthenticationFailed:
            return @"授权失败,点击重试";
            break;
        case LAErrorUserCancel:
            return isIphoneX?@"用户取消验证Face ID":@"用户取消验证Touch ID";
            break;
        case LAErrorUserFallback:
            return fallBackStr;
            break;
        case LAErrorSystemCancel:
            return @"系统取消授权，可能其他APP切入";
            break;
        case LAErrorPasscodeNotSet:
            return @"系统未设置密码";
            break;
        case LAErrorTouchIDNotAvailable:
            //设备Touch ID/Face ID不可用，例如未打开
            return isIphoneX?@"设备Face ID不可用":@"设备Touch ID不可用";
            break;
        case LAErrorTouchIDNotEnrolled:
            return isIphoneX?@"设备Face ID不可用，用户未录入":@"设备Touch ID不可用，用户未录入";
            break;
        case LAErrorTouchIDLockout:
            //身份验证未成功,多次使用Touch ID/Face ID失败
            return isIphoneX?@"多次使用Face ID失败,点击验证系统密码重新开启Face ID":@"多次使用Touch ID失败，点击验证系统密码重新开启Touch ID";
            break;
        case LAErrorAppCancel:
            return @"认证被取消的应用";
            break;
        case LAErrorInvalidContext:
            return @"授权对象失效";
            break;
        case LAErrorNotInteractive:
            return @"APP未完全启动,调用失败";
            break;
            
        default:
            return @"验证成功";
            break;
    }
}
#pragma mark 是不是刘海屏手机
+ (BOOL)jq_isIphoneX
{
    BOOL jq_iPhoneX = NO;
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {//判断是否是手机
        return jq_iPhoneX;
    }
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            jq_iPhoneX = YES;
        }
    }
    return jq_iPhoneX;
}

@end
