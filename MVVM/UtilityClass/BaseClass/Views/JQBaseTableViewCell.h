//
//  JQBaseTableViewCell.h
//  BBA
//
//  Created by life on 2018/1/24.
//  Copyright © 2018年 hdyg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JQTableViewCellViewModel.h"
@interface JQBaseTableViewCell : UITableViewCell

@property (nonatomic,strong,readonly) JQTableViewCellViewModel *viewModel;


/**
 cell的初始化方法
 通过cellViewModel来创建一个cell 调用setupdata来绑定数据
 @param tableView tableView
 @param viewModel cellViewModel
 @return cell
 */
+ (instancetype)cellForTableView:(UITableView *)tableView viewModel:(JQTableViewCellViewModel *)viewModel;


/**
 cell中按钮点击的信号量监听
 */
@property (nonatomic,strong,readonly) RACSubject *cellButtonsSignal;
/**
 绑定
 */
- (void)jq_setupBinding;
/**
 处理数据回调
 */
- (void)jq_setupData;
/**
 布局UI
 */
- (void)jq_setupViewLayout;


// 用来计算高度
+(NSNumber *)calculateRowHeightWithViewModel:(JQTableViewCellViewModel *)viewModel;

@end
