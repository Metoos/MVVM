//
//  JQBaseTableViewController.h
//  BBA
//
//  Created by life on 2018/1/24.
//  Copyright © 2018年 hdyg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JQTableViewModel.h"
#import "JQBaseTableViewControllerProtocol.h"
@interface JQBaseTableViewController : UITableViewController<JQBaseTableViewControllerProtocol>

// 每个VC对应的ViewModel
@property (nonatomic,strong,readonly) JQTableViewModel *viewModel;

@property (nonatomic,assign,readonly) BOOL isRefresh;

@property (nonatomic,assign) BOOL hideFooterLoadingMore;

@end
