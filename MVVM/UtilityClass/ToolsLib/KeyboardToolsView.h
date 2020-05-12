//
//  KeyboardToolsView.h
//  BBA
//
//  Created by life on 2018/3/16.
//  Copyright © 2018年 hdyg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KeyboardToolsView : UIView

+ (instancetype)instancekeyboardToolsView;
//安装键盘工具栏
- (void)install;
//卸载键盘工具栏
- (void)uninstall;

//键盘回收回调
- (void)returnKeyBoardBlock:(void(^)(void))block;

@end
