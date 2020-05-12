//
//  PayPasswordKeyboard.h
//  MVVM
//
//  Created by mac on 2019/8/7.
//  Copyright © 2019 hdyg. All rights reserved.
//

#import "JQBaseView.h"

typedef void(^InputPasswordDone)(NSString *password);

@interface PayPasswordKeyboard : JQBaseView

@property (copy, nonatomic) InputPasswordDone inputPasswordDone;

- (void)showWithDone:(InputPasswordDone)inputPasswordDone;
- (void)dismess;

@end
