//
//  CaptchaButton.h
//  MVVM
//
//  Created by mac on 2019/12/16.
//  Copyright © 2019 hdyg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CaptchaButton : UIButton

/**
 * 发送短信
 * @par phone 手机号
 * @par areaCode 区号
 **/
- (void)sendSmsWithPhoneNumber:(NSString *)phone
                      areaCode:(NSString *)areaCode;


@end

NS_ASSUME_NONNULL_END
