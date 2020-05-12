//
//  PasswordKeyboardView.h
//  LKC
//
//  Created by life on 2018/9/12.
//  Copyright © 2018年 hdyg. All rights reserved.
//

#import "JQBaseView.h"

typedef void(^InputPasswordDone)(NSString *password);

@interface PasswordKeyboardView : JQBaseView

@property (copy, nonatomic) InputPasswordDone inputPasswordDone;

- (void)showWithDone:(InputPasswordDone)inputPasswordDone;
- (void)dismess;

@end
