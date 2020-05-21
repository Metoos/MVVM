//
//  JQBaseTableViewController.m
//  BBA
//
//  Created by life on 2018/1/24.
//  Copyright © 2018年 hdyg. All rights reserved.
//

#import "JQBaseTableViewController.h"
#import <MJRefresh/MJRefresh.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "JQBaseTableViewCell.h"

#define k_isIPhoneX (([[UIApplication sharedApplication] statusBarFrame].size.height)>=44)
#define k_StatusBarBottom [[UIApplication sharedApplication] statusBarFrame].size.height

#define k_navigationBarAndStatusBarHeight  (k_isIPhoneX?88.0f:64.0f)

@interface JQBaseTableViewController ()<UIGestureRecognizerDelegate>

/**
 BaseTableViewController 的ViewModel，外部只是暴露getter属性
 */
@property (nonatomic,strong,readwrite) JQTableViewModel *viewModel;

@property (nonatomic,assign) BOOL isRefresh;

@end

@implementation JQBaseTableViewController

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    JQBaseTableViewController *viewController = [super allocWithZone:zone];
    
    @weakify(viewController)
    
    [[viewController rac_signalForSelector:@selector(viewDidLoad)] subscribeNext:^(id x) {
        
        @strongify(viewController)
        [viewController jq_layoutNavigation];
        [viewController jq_setupViewLayout];
        [viewController jq_setupBinding];
        [viewController jq_setupData];
    }];
    
    return viewController;
}

- (instancetype)initWithViewModel:(id<JQTableViewModelProtocol>)viewModel {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _viewModel = (JQTableViewModel *)viewModel;
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
        _viewModel = (JQTableViewModel*)viewModel;
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
        self.tableView.contentInset = UIEdgeInsetsMake(k_navigationBarAndStatusBarHeight, 0, 0, 0);
        self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    }
    
}

- (Class)cellClassForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    @throw [NSException exceptionWithName:@"抽象方法未实现"
                                   reason:[NSString stringWithFormat:@"%@ 必须实现抽象方法 %@",[self class],NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}







- (void)jq_layoutNavigation {
    
}


- (void)jq_setupBinding {
    
}


- (void)jq_setupData {
    
}


- (void)jq_setupViewLayout {
    WEAKIFY;
    // 添加头部刷新控件
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        STRONGIFY;
        self.isRefresh = YES;
        [self pullTableViewRequestData:self.isRefresh];
    }];
    
    
    // 添加尾部刷新控件
    self.tableView.mj_footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        STRONGIFY;
        self.isRefresh = NO;
        [self pullTableViewRequestData:self.isRefresh];
    }];
    
    self.tableView.mj_header.hidden = NO;
    self.tableView.mj_footer.hidden = NO;
}

/**
 刷新的时候调用该方法
 */
- (void)pullTableViewRequestData:(BOOL)isRefresh {
    //子类实现，进行重写
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JQBaseTableViewCell *cell = [[self cellClassForRowAtIndexPath:indexPath] cellForTableView:tableView viewModel:[self.viewModel cellViewModelForRowAtIndexPath:indexPath]];
    cell.selectionStyle = [self.viewModel tableViewCellSelectionStyle];
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


//设置隐藏上拉加载更多控件
- (void)endRefreshingWithNoMoreData:(BOOL)hideFooterLoadingMore
{
    _hideFooterLoadingMore = hideFooterLoadingMore;
 
    hideFooterLoadingMore == NO ? : [self.tableView.mj_footer endRefreshingWithNoMoreData];
}


- (void)endFooterRefresh
{
    [self.tableView.mj_footer endRefreshing];
}

- (void)endHeaderRefresh
{
    [self.tableView.mj_header endRefreshing];
}

/**
 点击试图回收键盘 子类调用执行功能
 */
- (void)jq_addReturnKeyBoard {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [tap.rac_gestureSignal subscribeNext:^(id x) {
        [[[UIApplication sharedApplication] delegate].window endEditing:YES];
    }];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}

- (void)endLoadingViewFooter {
    
}


#pragma mark-手势代理
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([gestureRecognizer.view isEqual:[UITableViewCell class]]) {
        return NO;
    }
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






@end
