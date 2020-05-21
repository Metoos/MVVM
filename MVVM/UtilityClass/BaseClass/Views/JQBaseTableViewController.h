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
/** 是否自动显示空数据界面 默认YES */
@property (nonatomic,assign) BOOL isAutoShowEmpty;
/** 显示空数据界面的提示图片   isAutoShowEmpty 为NO时 无效*/
@property (nonatomic,strong) NSString *showEmptyImageName;
/** 显示空数据界面的提示语   isAutoShowEmpty 为NO时 无效*/
@property (nonatomic,assign) NSString *showEmptyTips;

@property (nonatomic,assign) BOOL hideFooterLoadingMore;

@end
