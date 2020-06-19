//
//  JQTableViewController.m
//  BBA
//
//  Created by life on 2018/1/24.
//  Copyright © 2018年 hdyg. All rights reserved.
//

#import "JQTableViewController.h"
#import <Masonry/Masonry.h>
#import <MJRefresh/MJRefresh.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "JQBaseTableViewCell.h"

@interface JQTableViewController ()
// 每个VC对应的ViewModel
@property (nonatomic,strong) JQTableViewModel *viewModel;

@property (nonatomic,strong) UITableView *tableView; // 实例化的tableView

@property (nonatomic,assign) BOOL isRefresh;

@end

@implementation JQTableViewController
@dynamic viewModel;

#pragma mark - lifecycle

- (instancetype)initWithViewModel:(id<JQTableViewModelProtocol>)viewModel {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.viewModel = (JQTableViewModel *)viewModel;
        self.showEmptyImageName = @"loadEmpty.png";
        self.showEmptyTips      = @"";
        self.isAutoShowEmpty    = YES;
    }
    return self;
}

- (instancetype)initStoryboardWithName:(NSString *)name
                           identiffier:(NSString *)identiffier
                             ViewModel:(id<JQBaseViewModelProtocol>)viewModel {
    
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        UIStoryboard *board = [UIStoryboard storyboardWithName:name bundle:nil];
        self = [board instantiateViewControllerWithIdentifier:identiffier];
        self.viewModel = (JQTableViewModel*)viewModel;
        
        self.showEmptyImageName = @"loadEmpty.png";
        self.showEmptyTips      = @"";
        self.isAutoShowEmpty    = YES;
  
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //声明tableView的位置 添加下面代码
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.tableView.contentInset = UIEdgeInsetsMake([[UIApplication sharedApplication] statusBarFrame].size.height>=44?88.0f:64.0f, 0, 0, 0);
        self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    }
    @weakify(self);
    [RACObserve(self.viewModel, isNeedHiddenFooter) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self setShowNotDataFooterLoadingMore:[x boolValue]];
    }];
    
}

#pragma mark - override & protocal

- (void)jq_layoutNavigation {
    [super jq_layoutNavigation];
 
}

- (void)jq_setupViewLayout {
   [super jq_setupViewLayout];
    
    [self.view insertSubview:self.tableView atIndex:0];
    @weakify(self);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self.view);
    }];
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.backgroundColor = kTableViewBgColor;
    // 添加头部刷新控件
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        self.isRefresh = YES;
        [self pullTableViewRequestData:self.isRefresh];
    }];
    
//    ((MJRefreshNormalHeader*)self.tableView.mj_header).stateLabel.textColor = kWhiteColor;
//    ((MJRefreshNormalHeader*)self.tableView.mj_header).stateLabel.shadowOffset = CGSizeMake(1, 1);
//    
//    ((MJRefreshNormalHeader*)self.tableView.mj_header).stateLabel.shadowColor = kBlackColor;
    ((MJRefreshNormalHeader*)self.tableView.mj_header).lastUpdatedTimeLabel.hidden = YES;
    // 添加尾部刷新控件
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        @strongify(self);
        self.isRefresh = NO;
        [self pullTableViewRequestData:self.isRefresh];
    }];
//    ((MJRefreshAutoStateFooter*)self.tableView.mj_footer).stateLabel.textColor = kWhiteColor;
//    ((MJRefreshAutoStateFooter*)self.tableView.mj_footer).stateLabel.shadowOffset = CGSizeMake(1, 1);
//
//    ((MJRefreshAutoStateFooter*)self.tableView.mj_footer).stateLabel.shadowColor = kBlackColor;
    
    
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    
    
}

- (void)jq_setupBinding {
    
    
    
    
}


- (void)jq_setupData {
    
}

- (void)jq_addReturnKeyBoard {
    
}

- (Class)cellClassForRowAtIndexPath:(NSIndexPath *)indexPath {
    @throw [NSException exceptionWithName:@"抽象方法未实现"
                                   reason:[NSString stringWithFormat:@"%@ 必须实现抽象方法 %@",[self class],NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

/** 子类实现 */
- (void)tableView:(UITableView *)tableView didSelectButtonInCellAtIndexPath:(NSIndexPath *)indexPath sender:(UIButton *)button{
    
}
/**
 上下拉刷新的回调， YES是下拉刷新  NO上拉加载更多 子类可进行重写自定义
 */
- (void)pullTableViewRequestData:(BOOL)isRefresh
{
    // 下拉刷新的额时候重新刷新pagecount为0
    if (isRefresh) {
        [self.viewModel initRequestPullPage];
    }
    [self jq_setupData];
}


//设置隐藏下拉刷新控件
- (void)hiddenHeaderRefresh
{
    self.tableView.mj_header.hidden = YES;
}

//设置隐藏上来加载更多控件
- (void)hiddenFooterRefresh
{
    self.tableView.mj_footer = nil;
}

- (void)endLoadingViewFooter
{
    if (self.viewModel.isSucceed) {
        self.showNotDataFooterLoadingMore = self.viewModel.isNeedHiddenFooter;
    }
    else
    {
        NSLog(@"Show error");
    }
    [self endHeaderRefresh];
    [self endFooterRefresh];
}

#pragma mark - private methods

//设置显示没有更多数据
- (void)setShowNotDataFooterLoadingMore:(BOOL)showNotDataFooterLoadingMore
{
    _showNotDataFooterLoadingMore = showNotDataFooterLoadingMore;
    if (showNotDataFooterLoadingMore) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

- (void)endFooterRefresh
{
    [self.tableView.mj_footer endRefreshing];
}

- (void)endHeaderRefresh
{
    [self.tableView.mj_header endRefreshing];
}

#pragma mark - tableView datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.viewModel numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isAutoShowEmpty) {
        
        [tableView showEmptyDataTipsViewForRowCount:[self.viewModel numberOfRowInSection:section] andFrame:CGRectMake(0, 0, tableView.width, tableView.height) imageNamed:self.showEmptyImageName tipsTitle:self.showEmptyTips withTipsTitleColor:kBlackColor withTipsTitleFont:kFont(14.0f)];
        
        if (tableView.emptyView) {
            WEAKIFY
            tableView.tapRefreshBlock = ^{
                STRONGIFY
                [self.tableView.mj_header beginRefreshing];
            };
        }
    }
    
    return [self.viewModel numberOfRowInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [self.viewModel heightForHeaderInSection:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self.viewModel tableView:tableView viewForHeaderInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return [self.viewModel heightForFooterInSection:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [self.viewModel tableView:tableView viewForFooterInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JQTableViewCellViewModel *cellViewModel = [self.viewModel cellViewModelForRowAtIndexPath:indexPath];
    JQBaseTableViewCell *cell = [[self cellClassForRowAtIndexPath:indexPath] cellForTableView:tableView viewModel:cellViewModel indexPath:indexPath];
    cell.selectionStyle = [self.viewModel tableViewCellSelectionStyle];
    
    //cell中按钮点击的信号量监听
    @weakify(self)
    [[cell.cellButtonsSignal takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
        @strongify(self)
        [self tableView:tableView didSelectButtonInCellAtIndexPath:indexPath sender:x];
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = tableView.rowHeight;
    NSNumber *calculateHeight = [[self cellClassForRowAtIndexPath:indexPath] calculateRowHeightWithViewModel:[self.viewModel cellViewModelForRowAtIndexPath:indexPath]];
    if (calculateHeight) {
        height = calculateHeight.floatValue;
    }
    return height;
}


#pragma mark - getter

- (UITableView *)tableView
{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:[self.viewModel tableViewStyle]];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 80.0f;
        
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = kClearColor;
    }
    return _tableView;
}

@end
