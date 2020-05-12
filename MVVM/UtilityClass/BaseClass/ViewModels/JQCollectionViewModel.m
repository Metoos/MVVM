//
//  JQCollectionViewModel.m
//  BBA
//
//  Created by life on 2018/3/1.
//  Copyright © 2018年 hdyg. All rights reserved.
//

#import "JQCollectionViewModel.h"
@interface JQCollectionViewModel ()

@property (nonatomic,strong) NSMutableArray *cellViewModels;

@property (nonatomic,strong) NSNumber *currentPage; // 当前页面
@property (nonatomic,assign) BOOL isNeedHiddenFooter; // 根据totalcount判断是否需要进行footer的隐藏

@end

@implementation JQCollectionViewModel

/**
 调用下父类的方法
 */
- (void)jq_initialize
{
    [super jq_initialize];
    [self initRequestPullPage];
}

- (void)initRequestPullPage{
    self.currentPage = @(1);
}

- (void)handleMutableArrayEntites:(NSArray *)entities
               cellViewModelClass:(Class)cellViewModelClass{
    [self handleMutableArrayEntites:entities cellViewModelClass:cellViewModelClass object:nil];
}

- (void)handlePagingEntities:(NSArray *)entities
                    dataPage:(NSUInteger)dataPage
                  totalCount:(NSNumber *)totalCount
          cellViewModelClass:(Class)cellViewModelClass{
    [self handlePagingEntities:entities dataPage:dataPage totalCount:totalCount cellViewModelClass:cellViewModelClass object:nil];
}

- (void)handleMutableArrayEntites:(NSArray *)entities
               cellViewModelClass:(Class)cellViewModelClass
                           object:(id)object{
    [self.cellViewModels removeAllObjects];
    [self processEntites:entities cellViewModelClass:cellViewModelClass object:object];
}

//- (void)handlePagingEntities:(NSArray *)entities
//                  totalCount:(NSNumber *)totalCount
//          cellViewModelClass:(Class)cellViewModelClass
//                      object:(id)object{
//
//    if ([self.currentPage isEqualToNumber:@0] || [self.currentPage isEqualToNumber:@1]) {
//        [self.cellViewModels removeAllObjects];
//    }
//    [self processEntites:entities cellViewModelClass:cellViewModelClass object:object];
//    self.isNeedHiddenFooter = !(totalCount.integerValue > self.cellViewModels.count);
//    self.currentPage = @(self.currentPage.integerValue + 1);
//}

- (void)handlePagingEntities:(NSArray *)entities
                    dataPage:(NSUInteger)dataPage
                  totalCount:(NSNumber *)totalCount
          cellViewModelClass:(Class)cellViewModelClass
                      object:(id)object{
    self.currentPage = @(dataPage);
    if ([self.currentPage isEqualToNumber:@0] || [self.currentPage isEqualToNumber:@1]) {
        [self.cellViewModels removeAllObjects];
    }
    [self processEntites:entities cellViewModelClass:cellViewModelClass object:object];
    self.isNeedHiddenFooter = !(totalCount.integerValue > self.cellViewModels.count);
    self.currentPage = @(self.currentPage.integerValue + 1);
}

- (void)processEntites:(NSArray *)entities cellViewModelClass:(Class)cellViewModelClass object:(id)object{
    NSMutableArray *cellViewModes = [NSMutableArray array];
    [entities enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JQTableViewCellViewModel *cellVM =  [[cellViewModelClass alloc] initWithEntity:obj];
        cellVM.object = object;
        [cellViewModes addObject:cellVM];
    }];
    [self.cellViewModels addObjectsFromArray:cellViewModes];
}


- (UICollectionViewLayout *)collectionViewLayout
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    return flowLayout;
}

- (NSInteger)numberOfSections
{
    return 1;
}
/**
 返回对应section的头部View
 */
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
                    viewForHeaderAtIndexPath:(NSIndexPath *)indexPath
{
    return [UICollectionReusableView new];
}

/**
 返回对应section的底部View
 */
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
                    viewForFooterAtIndexPath:(NSIndexPath *)indexPath
{
    return [UICollectionReusableView new];
}



/**
 返回对应的Item size 子类重写设置 sizeForItem
 */
- (CGSize)collectionView:(UICollectionView *)collectionView sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kViewWidth/2-20, kViewWidth/2);
}

/**
 返回对应的Header size 默认无Header
 */
- (CGSize)collectionView:(UICollectionView *)collectionView referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeZero;
}

/**
 返回对应的Footer size 默认无Footer
 */
- (CGSize)collectionView:(UICollectionView *)collectionView referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeZero;
}

#pragma mark - cellViewModelForItemAtIndexPath 子类必须实现
/*（返回数据请求回来之后放在cellViewModels数组里面的每个cell对应的cellViewModel）*/
- (JQCollectionCellViewModel *)cellViewModelForItemAtIndexPath:(NSIndexPath *)indexPath {
   
    @throw [NSException exceptionWithName:@"抽象方法未实现"
                                   reason:[NSString stringWithFormat:@"%@ 必须实现抽象方法 %@",[self class],NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (id)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    
    @throw [NSException exceptionWithName:@"抽象方法未实现"
                                   reason:[NSString stringWithFormat:@"%@ 必须实现抽象方法 %@",[self class],NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}


- (NSMutableArray *)cellViewModels
{
    if (_cellViewModels == nil) {
        _cellViewModels = [[NSMutableArray alloc] init];
    }
    return _cellViewModels;
}

@end

