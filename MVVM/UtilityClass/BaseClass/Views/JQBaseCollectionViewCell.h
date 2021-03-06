//
//  JQBaseCollectionViewCell.h
//  BBA
//
//  Created by life on 2018/3/1.
//  Copyright © 2018年 hdyg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JQCollectionCellViewModel.h"
@interface JQBaseCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong,readonly) JQCollectionCellViewModel *viewModel;


/**
 cell的初始化方法
 通过cellViewModel来创建一个cell 调用setupdata来绑定数据
 @param collectionView collectionView
 @param indexPath  indexPath
 @param viewModel cellViewModel
 @return cell
 */
+ (instancetype)itemForCollectionView:(UICollectionView *)collectionView
                         forIndexPath:(NSIndexPath *)indexPath
                            viewModel:(JQCollectionCellViewModel *)viewModel;

@property (nonatomic,strong,readonly) NSIndexPath *indexPath;
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
+ (CGSize)calculateItemSizeWithViewModel:(JQCollectionCellViewModel *)viewModel;

@end
