//
//  JQBaseCollectionViewController.h
//  BBA
//
//  Created by life on 2018/3/1.
//  Copyright © 2018年 hdyg. All rights reserved.
//

#import "JQBaseViewController.h"
#import "JQCollectionViewModel.h"
#import "JQCollectionViewControllerProtocol.h"
@interface JQCollectionViewController : JQBaseViewController<JQCollectionViewControllerProtocol>

@property (nonatomic,strong,readonly) UICollectionView *collectionView; // 实例化的tableView
// 每个VC对应的ViewModel
@property (nonatomic,strong,readonly) JQCollectionViewModel *viewModel;

@property (nonatomic,assign,readonly) BOOL isRefresh;

@property (nonatomic,assign) BOOL hideFooterLoadingMore;

@end
