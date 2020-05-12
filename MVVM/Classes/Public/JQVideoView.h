//
//  JQVideoView.h
//  MVVM
//
//  Created by mac on 2019/10/10.
//  Copyright © 2019 hdyg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JQVideoView : UIView

- (void)pause;
- (void)play;
- (BOOL)isPause;

@end

NS_ASSUME_NONNULL_END
