//
//  JQGesturesLockViewController.h
//  DigitalTreasure
//
//  Created by mac on 2019/8/29.
//  Copyright © 2019 hdyg. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GesturesLockStatus)
{
    GesturesLockStatusSetup,     //设置或者重置手势密码
    GesturesLockStatusValidation //验证手势密码
};

typedef void(^validationDone)(BOOL pass, NSString *payPwd);

@interface JQGesturesLockViewController : JQBaseViewController

@property (assign, nonatomic) GesturesLockStatus lockStatus;



- (void)validationDone:(validationDone)done;

@end

