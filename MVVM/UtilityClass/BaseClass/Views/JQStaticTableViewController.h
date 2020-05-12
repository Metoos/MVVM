//
//  JQStaticTableViewController.h
//  BBA
//
//  Created by life on 2018/3/5.
//  Copyright © 2018年 hdyg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JQBaseViewModel.h"
#import "JQStaticTableViewControllerProtocol.h"
@interface JQStaticTableViewController : UITableViewController<JQStaticTableViewControllerProtocol>
// 每个VC对应的ViewModel
@property (nonatomic,strong,readonly) JQBaseViewModel *viewModel;

/** 是否将tableview 做子视图分离 */
@property (nonatomic,assign) BOOL isSubviewSeparation;

- (void)goBackAction;
/** 添加点击键盘以外空间回收键盘 */
- (void)jq_addReturnKeyBoard;

@end
