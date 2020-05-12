//
//  JQBaseTableViewControllerProtocol.h
//  BBA
//
//  Created by life on 2018/1/24.
//  Copyright © 2018年 hdyg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol JQBaseTableViewControllerProtocol <NSObject>
//@optional
/**
 唯一初始化方法
 @param viewModel 传入ViewModel
 @return 实例化控制器对象
 */
- (instancetype)initWithViewModel:(id<JQTableViewModelProtocol>)viewModel;
/**
 Storyboard唯一初始化方法
 @param viewModel 传入ViewModel
 @return 实例化控制器对象
 */
- (instancetype)initStoryboardWithName:(NSString *)name
                           identiffier:(NSString *)identiffier
                             ViewModel:(id<JQBaseViewModelProtocol>)viewModel;
/**
 进行数据的请求
 */
- (void)pullTableViewRequestData:(BOOL)isRefresh;
/**
 获取cell数据
 */
- (Class)cellClassForRowAtIndexPath:(NSIndexPath *)indexPath;

/** cell中按钮点击回调 */
- (void)tableView:(UITableView *)tableView didSelectButtonInCellAtIndexPath:(NSIndexPath *)indexPath sender:(UIButton *)button;

/**
 结束所有加载数据中状态
 */
- (void)endLoadingViewFooter;
/**
 结束下拉刷新
 */
- (void)endHeaderRefresh;
/**
  结束上提加载更多数据刷新
 */
- (void)endFooterRefresh;
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

@end
