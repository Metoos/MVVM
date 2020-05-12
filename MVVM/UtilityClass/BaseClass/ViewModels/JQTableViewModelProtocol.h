//
//  JQTableViewModelProtocol.h
//  BBA
//
//  Created by life on 2018/1/24.
//  Copyright © 2018年 hdyg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class JQTableViewCellViewModel;
@protocol JQTableViewModelProtocol <NSObject>

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



#pragma mark - tableView的代理通过ViewModel来实现

/**
 UITableView的属性 plain or group
 */
- (UITableViewStyle)tableViewStyle;

/**
 tableViewCell的点击状态
 */
- (UITableViewCellSelectionStyle)tableViewCellSelectionStyle;

/**
 多少section
 */
- (NSInteger)numberOfSections;

/**
 对应section的header高度
 */
- (CGFloat)heightForHeaderInSection:(NSInteger)section;

/**
 返回对应section的头部View
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;

/**
 对应section的footer高度
 */
- (CGFloat)heightForFooterInSection:(NSInteger)section;

/**
 返回对应section的头部View
 */
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;


@required
/**
 对应的section返回多少Rows
 */
- (NSInteger)numberOfRowInSection:(NSInteger)section;

/**
 返回对应的cellViewModel给对应的cell初始化
 */
- (JQTableViewCellViewModel *)cellViewModelForRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 对应的tableViewDidSelectedRowAtIndexPath给对应的cell点击回调
 */
- (id)tableViewDidSelectedRowAtIndexPath:(NSIndexPath *)indexPath;

@end
