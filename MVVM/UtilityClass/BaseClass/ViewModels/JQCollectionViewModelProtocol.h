//
//  JQCollectionViewModelProtocol.h
//  BBA
//
//  Created by life on 2018/3/1.
//  Copyright © 2018年 hdyg. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JQCollectionCellViewModel;
@protocol JQCollectionViewModelProtocol <NSObject>

@optional

/**
 给每个ViewModel里面的cellViewModel数组装载通过实体对象初始化的cellViewModel
 这个方法是默认给一个Section的时候进行调用的，如果是分页的话需要在封装一层，外部进行代码的分离，然后根据currentPage进行数组的清空还是继续加载
 */
- (void)handleMutableArrayEntites:(NSArray *)entities
               cellViewModelClass:(Class)cellViewModelClass;
/**
 在 handleMutableArrayEntites:cellViewModelClass: 的基础上 包装一层再次通过current的page来进行更改
 @param entities 请求回来的实体数组
 @param dataPage 当前数据的页码
 @param totalCount 总数量
 @param cellViewModelClass cellViewModel类型 初始化用
 */
- (void)handlePagingEntities:(NSArray *)entities
                    dataPage:(NSUInteger)dataPage
                  totalCount:(NSNumber *)totalCount
          cellViewModelClass:(Class)cellViewModelClass;


/**
 给每个ViewModel里面的cellViewModel数组装载通过实体对象初始化的cellViewModel
 @param entities 请求回来的实体数组
 @param cellViewModelClass cellViewModel类型 初始化用
 @param object obj参数
 */
- (void)handleMutableArrayEntites:(NSArray *)entities
               cellViewModelClass:(Class)cellViewModelClass
                           object:(id)object;

/**
 在 handleMutableArrayEntites:cellViewModelClass: 的基础上 包装一层再次通过current的page来进行更改
 @param entities 请求回来的实体数组
 @param dataPage 当前数据的页码
 @param totalCount 总数量
 @param cellViewModelClass cellViewModel类型 初始化用
 @param object obj参数
 */
//- (void)handlePagingEntities:(NSArray *)entities
//                  totalCount:(NSNumber *)totalCount
//          cellViewModelClass:(Class)cellViewModelClass
//                      object:(id)object;

- (void)handlePagingEntities:(NSArray *)entities
                    dataPage:(NSUInteger)dataPage
                  totalCount:(NSNumber *)totalCount
          cellViewModelClass:(Class)cellViewModelClass
                      object:(id)object;

/**
 下拉刷新的回调实现在控制器中，判断是否isRefresh来进行是否把currentPage清0
 */
- (void)initRequestPullPage;

#pragma mark - UICollectionView的代理通过ViewModel来实现

/**
 UICollectionView的Layout
 */
- (UICollectionViewLayout*)collectionViewLayout;

/**
 返回对应section的头部View
 */
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
                    viewForHeaderAtIndexPath:(NSIndexPath *)indexPath;

/**
 返回对应section的底部View
 */
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
                    viewForFooterAtIndexPath:(NSIndexPath *)indexPath;

/**
 多少section
 */
- (NSInteger)numberOfSections;

/**
 返回对应的Item size
 */
- (CGSize)collectionView:(UICollectionView *)collectionView sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

/**
 返回对应的Header size
 */
- (CGSize)collectionView:(UICollectionView *)collectionView referenceSizeForHeaderInSection:(NSInteger)section;

/**
 返回对应的Footer size
 */
- (CGSize)collectionView:(UICollectionView *)collectionView referenceSizeForFooterInSection:(NSInteger)section;

/**
 对应的collectionView:didSelectItemAtIndexPath:给对应的cell点击回调
 */
- (id)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@required
/**
 对应的section返回多少Items
 */
- (NSInteger)numberOfItemsInSection:(NSInteger)section;

/**
 返回对应的cellViewModel给对应的cell初始化
 */
- (JQCollectionCellViewModel *)cellViewModelForItemAtIndexPath:(NSIndexPath *)indexPath;




@end
