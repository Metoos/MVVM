//
//  JQStaticTableViewController.m
//  BBA
//
//  Created by life on 2018/3/5.
//  Copyright © 2018年 hdyg. All rights reserved.
//

#import "JQStaticTableViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
@interface JQStaticTableViewController ()<UIGestureRecognizerDelegate>

/**
 BaseViewController 的ViewModel，外部只是暴露getter属性
 */
@property (nonatomic,strong) JQBaseViewModel *viewModel;

/** 添加导航栏背景图片 */
@property (nonatomic,strong) UIImageView *navigationBarImage;


@end

@implementation JQStaticTableViewController
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    JQStaticTableViewController *viewController = [super allocWithZone:zone];
    
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

- (instancetype)initStoryboardWithName:(NSString *)name
                           identiffier:(NSString *)identiffier
                             ViewModel:(id<JQBaseViewModelProtocol>)viewModel {
    
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        UIStoryboard *board = [UIStoryboard storyboardWithName:name bundle:nil];
        self = [board instantiateViewControllerWithIdentifier:identiffier];
        _viewModel = (JQBaseViewModel*)viewModel;
    }
    return self;
}


- (void)dealloc {
    
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //声明tableView的位置 添加下面代码
//    if (@available(iOS 11.0, *)) {
//        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//        self.tableView.contentInset = UIEdgeInsetsMake([[UIApplication sharedApplication] statusBarFrame].size.height>=44?88.0f:64.0f, 0, 0, 0);
//        self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
//    }
    
    // 这里的基类ViewModel实现的title是nil，子类实现，获取到对应的子类控制器标题
    //    self.navigationItem.title = self.viewModel.title;
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"backWhite"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(goBackAction)];
    
    self.navigationItem.leftBarButtonItem = backBtn;
    
    self.tableView.backgroundColor = kTableViewBgColor;
    
    // Do any additional setup after loading the view.
}

- (void)goBackAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setIsSubviewSeparation:(BOOL)isSubviewSeparation
{
    _isSubviewSeparation = isSubviewSeparation;
    
    if (isSubviewSeparation) {
        [self subviewSeparation];
    }
}

- (void)subviewSeparation
{
    
    UITableView *tableView = (UITableView *)self.view;
    self.view = [[UIView alloc] init];
    tableView.frame = self.view.bounds;
    self.tableView = tableView;
}

//tableviewt与view分离 必要步骤 重写self.tableView的get方法和set方法
- (void)setTableView:(UITableView *)tableView {
    if (self.isSubviewSeparation) {
        [self.tableView removeFromSuperview];
        [self.view addSubview:tableView];
    }else
    {
        self.view = tableView;
    }
    
}

- (UITableView *)tableView {
    
    if (self.isSubviewSeparation) {
        for (UIView *v in self.view.subviews) {
            if ([v isKindOfClass:[UITableView class]]) {
                return (UITableView *)v;
            }
        }
        return nil;
    }else
    {
        return (UITableView*)self.view;
    }
    
}

- (void)jq_setNavBarBackgroundImageAlpha:(CGFloat)alpha
{
    self.navigationBarImage.alpha = alpha;
}

- (void)jq_navigationBarBackgroundImage:(UIImage *)image
{
    self.navigationBarImage.image = image;
}

- (void)jq_layoutNavigation {
    
    // 布局导航栏 子类实现
    [self.view addSubview:self.navigationBarImage];
}

- (UIImageView *)navigationBarImage
{
    if (!_navigationBarImage) {
        _navigationBarImage = [[UIImageView alloc]init];
        _navigationBarImage.image = [UIImage imageNamed:@"头部背景"];
        _navigationBarImage.frame = CGRectMake(0, 0, kViewWidth, kNavigationBarAndStatusBarHeight);
        _navigationBarImage.contentMode = UIViewContentModeScaleAspectFill;
        _navigationBarImage.clipsToBounds = YES;
    }
    return _navigationBarImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)jq_setupViewLayout {
    // 布局UI 子类实现
}

- (void)jq_setupBinding {
    // 绑定数据 子类实现
}

- (void)jq_setupData {
    // 处理数据回调 子类实现
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

#pragma mark-手势代理
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([gestureRecognizer.view isEqual:[UITableViewCell class]]) {
        return NO;
    }
    return YES;
}

@end
