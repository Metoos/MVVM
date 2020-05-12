//
//  JQBaseViewControllerProtocol.h
//  BBA
//
//  Created by life on 2018/1/24.
//  Copyright © 2018年 hdyg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JQBaseViewModelProtocol.h"
@protocol JQBaseViewControllerProtocol <NSObject>

@optional
/**
 代码唯一初始化方法
 @param viewModel 传入ViewModel
 @return 实例化控制器对象
 */
- (instancetype)initWithViewModel:(id<JQBaseViewModelProtocol>)viewModel;
/**
 Storyboard唯一初始化方法
 @param viewModel 传入ViewModel
 @return 实例化控制器对象
 */
- (instancetype)initStoryboardWithName:(NSString *)name
                           identiffier:(NSString *)identiffier
                             ViewModel:(id<JQBaseViewModelProtocol>)viewModel;
/**
 布局UI
 */
- (void)jq_setupViewLayout;
/**
 布局导航栏
 */
- (void)jq_layoutNavigation;
/**
 绑定数据
 */
- (void)jq_setupBinding;
/**
 处理数据回调
 */
- (void)jq_setupData;
/**
 点击试图回收键盘
 */
- (void)jq_addReturnKeyBoard;
/** 主动调用 设置导航栏背景图 */
- (void)jq_navigationBarBackgroundImage:(UIImage *)image;
/**
 设置导航栏透明度
 */
- (void)jq_setNavBarBackgroundImageAlpha:(CGFloat)alpha;

@end
