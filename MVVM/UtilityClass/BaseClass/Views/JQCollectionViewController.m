//
//  JQCollectionViewController.m
//  BBA
//
//  Created by life on 2018/3/1.
//  Copyright © 2018年 hdyg. All rights reserved.
//

#import "JQCollectionViewController.h"
#import "JQBaseCollectionViewCell.h"
@interface JQCollectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

/**
 BaseTableViewController 的ViewModel，外部只是暴露getter属性
 */
@property (nonatomic,strong,readwrite) JQCollectionViewModel *viewModel;

@property (nonatomic,assign) BOOL isRefresh;

@property (nonatomic,strong) UICollectionView *collectionView; // 实例化的tableView


@end

@implementation JQCollectionViewController
@dynamic viewModel;

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    JQCollectionViewController *viewController = [super allocWithZone:zone];
    
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

- (instancetype)initWithViewModel:(id<JQCollectionViewModelProtocol>)viewModel {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.viewModel = (JQCollectionViewModel *)viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //声明tableView的位置 添加下面代码
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.collectionView.contentInset = UIEdgeInsetsMake([[UIApplication sharedApplication] statusBarFrame].size.height>=44?88.0f:64.0f, 0, 0, 0);
        self.collectionView.scrollIndicatorInsets = self.collectionView.contentInset;
    }
    
}

- (Class)cellClassForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    @throw [NSException exceptionWithName:@"抽象方法未实现"
                                   reason:[NSString stringWithFormat:@"%@ 必须实现抽象方法 %@",[self class],NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}





- (void)jq_addReturnKeyBoard {
    
}


- (void)jq_layoutNavigation {
    
    [super jq_layoutNavigation];
}


- (void)jq_setupBinding {
    
}


- (void)jq_setupData {
    
}


- (void)jq_setupViewLayout {
    
    [super jq_setupViewLayout];
    [self.view insertSubview:self.collectionView atIndex:0];
    WEAKIFY;
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONGIFY;
        make.edges.equalTo(self.view);
    }];
    
    // 添加头部刷新控件
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        STRONGIFY;
        self.isRefresh = YES;
        [self pullTableViewRequestData:self.isRefresh];
    }];
    
    // 添加尾部刷新控件
    self.collectionView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        STRONGIFY;
        self.isRefresh = NO;
        [self pullTableViewRequestData:self.isRefresh];
    }];
    
    
    ((MJRefreshNormalHeader*)self.collectionView.mj_header).stateLabel.textColor = kWhiteColor;
    ((MJRefreshNormalHeader*)self.collectionView.mj_header).lastUpdatedTimeLabel.hidden = YES;
    self.collectionView.mj_header.hidden = NO;
    self.collectionView.mj_footer.hidden = YES;
}

/**
 刷新的时候调用该方法
 */
- (void)pullTableViewRequestData:(BOOL)isRefresh {
    //子类实现，进行重写
  
}


#pragma mark - collection datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.viewModel numberOfItemsInSection:section];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JQBaseCollectionViewCell *cell = [[self cellClassForItemAtIndexPath:indexPath] itemForCollectionView:collectionView forIndexPath:indexPath viewModel:[self.viewModel cellViewModelForItemAtIndexPath:indexPath]];
    
    //cell中按钮点击的信号量监听
    WEAKIFY
    [[cell.cellButtonsSignal takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
        STRONGIFY
        [self collectionView:collectionView didSelectButtonInItemAtIndexPath:indexPath sender:x];
    }];
    return cell;
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.viewModel numberOfSections];
}

// The view that is returned must be retrieved from a call to -dequeueReusableSupplementaryViewOfKind:withReuseIdentifier:forIndexPath:
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        return [self.viewModel collectionView:collectionView viewForHeaderAtIndexPath:indexPath];
        
    }else if ([kind isEqualToString:UICollectionElementKindSectionFooter])
    {
        return [self.viewModel collectionView:collectionView viewForFooterAtIndexPath:indexPath];
    }
    
    return nil;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return [self.viewModel collectionView:collectionView sizeForItemAtIndexPath:indexPath];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return [self.viewModel collectionView:collectionView referenceSizeForHeaderInSection:section];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return [self.viewModel collectionView:collectionView referenceSizeForFooterInSection:section];
}

-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:[self.viewModel collectionViewLayout]];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = kTableViewBgColor;
        
    }
    return _collectionView;
}


//设置隐藏下拉刷新控件
- (void)hiddenHeaderRefresh
{
    self.collectionView.mj_header.hidden = YES;
}



//设置隐藏上拉加载更多控件
- (void)endRefreshingWithNoMoreData:(BOOL)hideFooterLoadingMore
{
    _hideFooterLoadingMore = hideFooterLoadingMore;
    
    hideFooterLoadingMore == NO ? : [self.collectionView.mj_footer endRefreshingWithNoMoreData];
}


- (void)endLoadingViewFooter
{
    if (self.viewModel.isSucceed) {
        self.hideFooterLoadingMore = self.viewModel.isNeedHiddenFooter;
    }
    else
    {
        NSLog(@"Show error");
    }
    [self endHeaderRefresh];
    [self endFooterRefresh];
}

- (void)endFooterRefresh
{
    [self.collectionView.mj_footer endRefreshing];
}

- (void)endHeaderRefresh
{
    [self.collectionView.mj_header endRefreshing];
}

@end
