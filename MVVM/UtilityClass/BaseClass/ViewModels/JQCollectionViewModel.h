//
//  JQCollectionViewModel.h
//  BBA
//
//  Created by life on 2018/3/1.
//  Copyright © 2018年 hdyg. All rights reserved.
//

#import "JQBaseViewModel.h"
#import <UIKit/UIKit.h>
#import "JQCollectionCellViewModel.h"
#import "JQCollectionViewModelProtocol.h"
@interface JQCollectionViewModel : JQBaseViewModel<JQCollectionViewModelProtocol>

/**
 通过实体组装成cellViewModel
 */
@property (nonatomic,strong,readonly) NSMutableArray *cellViewModels;


/**
 外部通过监听该字段来判断是否需要刷新tableView
 */
@property (nonatomic,assign) BOOL isNeedRefresh;

/**
 表格分页时使用
 */
@property (nonatomic,strong,readonly) NSNumber *currentPage;
@property (nonatomic,assign,readonly) BOOL isNeedHiddenFooter;




@end
