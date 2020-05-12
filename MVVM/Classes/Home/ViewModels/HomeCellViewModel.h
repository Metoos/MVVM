//
//  HomeCellViewModel.h
//  MVVM
//
//  Created by mac on 2019/12/16.
//  Copyright © 2019 hdyg. All rights reserved.
//

#import "JQTableViewCellViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeCellViewModel : JQTableViewCellViewModel

- (NSString *)titleString;
/** 是否显示获取验证码按钮 */
- (BOOL)isCanGetCaptcha;


@end

NS_ASSUME_NONNULL_END
