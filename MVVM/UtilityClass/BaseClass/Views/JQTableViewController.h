//
//  JQTableViewController.h
//  BBA
//
//  Created by life on 2018/1/24.
//  Copyright © 2018年 hdyg. All rights reserved.
//

#import "JQBaseViewController.h"
#import "JQTableViewModel.h"
#import "JQBaseTableViewControllerProtocol.h"

@interface JQTableViewController : JQBaseViewController<JQBaseTableViewControllerProtocol,UITableViewDelegate,UITableViewDataSource>

// 每个VC对应的ViewModel
@property (nonatomic,strong,readonly) JQTableViewModel *viewModel;

@property (nonatomic,strong,readonly) UITableView *tableView;

@property (nonatomic,assign,readonly) BOOL isRefresh;

/** 是否自动显示空数据界面 默认YES */
@property (nonatomic,assign) BOOL isAutoShowEmpty;
/** 显示空数据界面的提示图片   isAutoShowEmpty 为NO时 无效*/
@property (nonatomic,strong) NSString *showEmptyImageName;
/** 显示空数据界面的提示语   isAutoShowEmpty 为NO时 无效*/
@property (nonatomic,assign) NSString *showEmptyTips;

/** 是否显示没有更多数据加载 */
@property (nonatomic,assign) BOOL showNotDataFooterLoadingMore;

//设置隐藏下拉刷新控件
- (void)hiddenHeaderRefresh;
//设置隐藏上来加载更多控件
- (void)hiddenFooterRefresh;


@end
