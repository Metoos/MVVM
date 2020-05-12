//
//  JQTableViewModel.m
//  BBA
//
//  Created by life on 2018/1/24.
//  Copyright © 2018年 hdyg. All rights reserved.
//

#import "JQTableViewModel.h"

@interface JQTableViewModel ()

@property (nonatomic,strong) NSMutableArray *cellViewModels;

//@property (nonatomic,strong) NSNumber *currentPage; // 当前页面
//@property (nonatomic,assign) BOOL isNeedHiddenFooter; // 根据totalcount判断是否需要进行footer的隐藏

@end

@implementation JQTableViewModel

#pragma mark - override
/**
 调用下父类的方法
 */
- (void)jq_initialize
{
    [super jq_initialize];
    [self initRequestPullPage];
}

#pragma mark - protocal

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

#pragma mark - tableView的代理通过ViewModel来实现

- (UITableViewStyle)tableViewStyle
{
    return UITableViewStylePlain;
}

- (UITableViewCellSelectionStyle)tableViewCellSelectionStyle
{
    return UITableViewCellSelectionStyleNone;
}

//默认是一个section
- (NSInteger)numberOfSections
{
    return 1;
}

//headerView的默认是没有的
- (CGFloat)heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc]init];
}

 //footerView的默认是没有的
- (CGFloat)heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc]init];
}

#pragma mark - cellViewModelForRowAtIndexPath 子类必须实现

//子类必须实现（每个section多少rows）
- (NSInteger)numberOfRowInSection:(NSInteger)section
{
    @throw [NSException exceptionWithName:@"抽象方法未实现"
                                   reason:[NSString stringWithFormat:@"%@ 必须实现抽象方法 %@",[self class],NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

/*（返回数据请求回来之后放在cellViewModels数组里面的每个cell对应的cellViewModel）*/
- (JQTableViewCellViewModel *)cellViewModelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @throw [NSException exceptionWithName:@"抽象方法未实现"
                                   reason:[NSString stringWithFormat:@"%@ 必须实现抽象方法 %@",[self class],NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (id)tableViewDidSelectedRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return nil;
}


#pragma mark - getter

- (NSMutableArray *)cellViewModels
{
    if (_cellViewModels == nil) {
        _cellViewModels = [[NSMutableArray alloc] init];
    }
    return _cellViewModels;
}

@end
