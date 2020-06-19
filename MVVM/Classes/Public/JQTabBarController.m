//
//  JQTabBarController.m
//  ZongShengTrainVideo
//
//  Created by zjq on 2017/6/11.
//  Copyright © 2017年 zjq. All rights reserved.
//

#import "JQTabBarController.h"
#import "JQTabBar.h"
#import "JQNavigationController.h"
#import "UserDefaultStorage.h"
#import "HomeModel.h"
/**
 *import tabBar四大模块 .h
 */
#import "HomeViewController.h"
//#import "ServiceViewController.h"
//#import "ExchangeViewController.h"
//#import "BankViewController.h"
//#import "MyViewController.h"
//#import "TradingViewController.h"
//#import "ShareViewController.h"
//#import "FeedBackViewController.h"
//#import "MyViewController.h"
//#import "WebViewController.h"
//#import "WBQRCodeScanningVC.h"
//#import "TransferredOutViewController.h"
//#import "WebViewController.h"
@interface JQTabBarController ()<UITabBarControllerDelegate>


@end

@implementation JQTabBarController

+ (void)initialize
{
     if (@available(iOS 10.0, *)) {
          [[UITabBar appearance] setUnselectedItemTintColor:[UIColor grayColor]];
          [[UITabBar appearance]setTintColor:kThemeColor];
       } else{
          // 通过appearance统一设置所有UITabBarItem的文字属性
          UITabBarItem *tabBarItem = [UITabBarItem appearance];
          
          /** 设置默认状态 */
          NSMutableDictionary *norDict = @{}.mutableCopy;
          norDict[NSFontAttributeName] = [UIFont systemFontOfSize:12];
          norDict[NSForegroundColorAttributeName] = [UIColor grayColor];
          [tabBarItem setTitleTextAttributes:norDict forState:UIControlStateNormal];
          
          /** 设置选中状态 */
          NSMutableDictionary *selDict = @{}.mutableCopy;
          selDict[NSFontAttributeName] = norDict[NSFontAttributeName];
          selDict[NSForegroundColorAttributeName] = kThemeColor;
          [tabBarItem setTitleTextAttributes:selDict forState:UIControlStateSelected];
       }
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
//    //添加中间特殊按钮
//    JQTabBar *tabBar = [[JQTabBar alloc] initWithFrame:self.tabBar.frame];
//    tabBar.backgroundColor = [UIColor whiteColor];
//    [self setValue:tabBar forKeyPath:@"tabBar"];
//    self.delegate = self;
//
//    [self centerAction:tabBar];
    /*添加子控制器 */
    /** 首页 */
//    HomeViewModel *homeViewModel = [[HomeViewModel alloc]init];
//    [self setUpChildControllerWith:[[HomeViewController alloc]initWithViewModel:homeViewModel]
//                          norImage:[UIImage imageNamed:@"home_n"]
//                          selImage:[UIImage imageNamed:@"home_s"]
//                             title:JQGetStringWithKeyFromTable(@"小鸟集市", nil)];
    /** 服务中心 */
//    ServiceViewModel *serviceViewModel = [[ServiceViewModel alloc]init];
//    [self setUpChildControllerWith:[[ServiceViewController alloc]initStoryboardWithName:@"Service" identiffier:@"ServiceViewController" ViewModel:serviceViewModel]
//                          norImage:[UIImage imageNamed:@"service_n"]
//                          selImage:[UIImage imageNamed:@"service_s"]
//                             title:JQGetStringWithKeyFromTable(@"服务中心", nil)];
//    /** 闪兑 */
//    ExchangeViewModel *exchangeViewModel = [[ExchangeViewModel alloc]init];
//    ExchangeViewController *exchange = [[ExchangeViewController alloc]initStoryboardWithName:@"Market" identiffier:@"ExchangeViewController" ViewModel:exchangeViewModel];
//    [self setUpChildControllerWith:exchange
//                          norImage:[UIImage imageNamed:@"闪兑_暗"]
//                          selImage:[UIImage imageNamed:@"闪兑_亮"]
//                             title:JQGetStringWithKeyFromTable(@"闪兑", nil)];
//
//    /** 银行卡 */
//    BankViewModel *bankViewModel = [[BankViewModel alloc]init];
//    BankViewController *bank = [[BankViewController alloc]initStoryboardWithName:@"Bank" identiffier:@"BankViewController" ViewModel:bankViewModel];
//    [self setUpChildControllerWith:bank
//                          norImage:[UIImage imageNamed:@"银行卡_暗"]
//                          selImage:[UIImage imageNamed:@"银行卡_亮"]
//                             title:JQGetStringWithKeyFromTable(@"银行卡", nil)];
    
    /** 我的 */
//    MyViewModel *myViewModel = [[MyViewModel alloc]init];
//    [self setUpChildControllerWith:[[MyViewController alloc]initStoryboardWithName:@"My" identiffier:@"MyViewController" ViewModel:myViewModel]
//                          norImage:[UIImage imageNamed:@"my_n"]
//                          selImage:[UIImage imageNamed:@"my_s"]
//                             title:JQGetStringWithKeyFromTable(@"我的鸟窝", nil)];

//    [self setup];
    

    if (@available(iOS 13.0, *)) {
        UITabBarAppearance *tabBarAppearance = [self.tabBar.standardAppearance copy];
        [tabBarAppearance setBackgroundImage:[UIImage new]];
        [tabBarAppearance setShadowColor:[UIColor clearColor]];
        [self.tabBar setStandardAppearance:tabBarAppearance];
    } else {
        [self.tabBar setShadowImage:[UIImage new]];
        [self.tabBar setBackgroundImage:[UIImage new]];
    }
    
    [self.tabBar setBackgroundColor:COLORRGB(0xffffff)];
//    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:k_SHOW_LOGINVIEW object:nil] subscribeNext:^(NSNotification * _Nullable x) {
//        [[UserInfoEntity sharedUserInfoEntity] clearLoginData];
//        self.selectedIndex = 3;
//    }];
    // Do any additional setup after loading the view.
}

- (void)centerAction:(JQTabBar *)tabBar {
    
    [tabBar.centerButton setTitle:@"行情"];
    [tabBar.centerButton setImage:[UIImage imageNamed:@"交易行情_selected"]];
    [tabBar.centerButton setTitleFont:[UIFont systemFontOfSize:12]];
    [tabBar.centerButton setTitleColor:[UIColor grayColor]];
    tabBar.centerButton.imageAlignment = JQImageAlignmentTop;
    tabBar.centerButton.space = 5;
//    WEAKIFY;
    [[tabBar.centerButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
//        TradingViewModel *viewModel = [TradingViewModel new];
//        TradingViewController *trading = [[TradingViewController alloc]initStoryboardWithName:@"App" identiffier:@"TradingViewController" ViewModel:viewModel];
//        [[UniversalManager getCurrentViewController].navigationController pushViewController:trading animated:YES];
    }];
}

- (void)setup{

    
//
//    [[HomeEntity sharedHomeEntity].data.bottom enumerateObjectsUsingBlock:^(HomeBottomEntity * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//
//        if ([obj.type isEqualToString:@"1"]) {
//
//            HomeViewModel *homeViewModel = [[HomeViewModel alloc]initWithEntity:[HomeEntity sharedHomeEntity]];
//            HomeViewController *homeVC = [[HomeViewController alloc]initStoryboardWithName:@"Home" identiffier:@"HomeViewController" ViewModel:homeViewModel];
//            [self setUpChildControllerWith:homeVC
//                            normalImageUrl:obj.img_normal
//                    placeholderNormalImage:nil
//                          selectedImageUrl:obj.img_selected
//                  placeholderSelectedImage:nil
//                                     title:obj.name];
//        }else
//        {
//
//            WebViewController *webViewVC = [[WebViewController alloc]initWithURLString:obj.url];
//            webViewVC.isHiddenBackItem = YES;
//            [self setUpChildControllerWith:webViewVC
//                            normalImageUrl:obj.img_normal
//                    placeholderNormalImage:nil
//                          selectedImageUrl:obj.img_selected
//                  placeholderSelectedImage:nil
//                                     title:obj.name];
//
//        }
//
//
//    }];
}




- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    // 强制重新布局子控件（内部会调用layouSubviews）
    [self.tabBar setNeedsLayout];
}


- (UITabBarItem *)itemWithSelectedImage:(UIImage *)selectImage image:(UIImage *)image title:(NSString *)title{
    //设置image总是展示原图
    UIImage *im = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImage *sim = [selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:title image:im selectedImage:sim];
    
    return item;
}

- (void)setUpChildControllerWith:(UIViewController *)childVc norImage:(UIImage *)norImage selImage:(UIImage *)selImage title:(NSString *)title
{
    JQNavigationController *nav = [[JQNavigationController alloc] initWithRootViewController:childVc];
    nav.supportMaskAllButUpsideDown = NO;
    childVc.tabBarItem = [self itemWithSelectedImage:selImage image:norImage title:title];
    [self addChildViewController:nav];
    
}


- (void)setUpChildControllerWith:(UIViewController *)childVc
                normalImageUrl:(NSString *)normalImageUrl
          placeholderNormalImage:(UIImage *)normalImage
                selectedImageUrl:(NSString *)selectImageUrl
        placeholderSelectedImage:(UIImage *)selectedImage
                           title:(NSString *)title
{
    JQNavigationController *nav = [[JQNavigationController alloc] initWithRootViewController:childVc];
    nav.supportMaskAllButUpsideDown = NO;
    //设置image总是展示原图
    //    norImage = [norImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //    selImage = [selImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //    childVc.tabBarItem.title = title;
    //    childVc.tabBarItem.image = norImage;
    //    childVc.tabBarItem.selectedImage = selImage;
    
    
    WS(weakSelf);
    //设置image总是展示原图
    normalImage = [normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:normalImage selectedImage:selectedImage];
    
    UIImageView *normalWebImage = [[UIImageView alloc]initWithImage:normalImage];
    UIImageView *selectedWebImage = [[UIImageView alloc]initWithImage:selectedImage];
    [normalWebImage jq_setImageWithURL:normalImageUrl placeholderImage:normalImage completed:^(UIImage *image) {

        
        CGFloat originalWidth = image.size.width;
        CGFloat originalHeight = image.size.height;
        CGSize size = CGSizeMake(30.0f, 30.0f*originalHeight/originalWidth);  //固定宽 高按图片宽高比自动缩放
        normalWebImage.image = [UIImage resizedImage:normalWebImage.image toSize:size];
//
        childVc.tabBarItem =  [[UITabBarItem alloc] initWithTitle:title image:[normalWebImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:selectedWebImage.image];
    
        // 强制重新布局子控件（内部会调用layouSubviews）
        [weakSelf.tabBar setNeedsLayout];
    }];
    
    [selectedWebImage jq_setImageWithURL:selectImageUrl placeholderImage:selectedImage completed:^(UIImage *image) {
        
        selectedWebImage.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        CGFloat originalWidth = image.size.width;
        CGFloat originalHeight = image.size.height;
        CGSize size = CGSizeMake(30.0f, 30.0f*originalHeight/originalWidth);  //固定宽 高按图片宽高比自动缩放
        selectedWebImage.image = [UIImage resizedImage:selectedWebImage.image toSize:size];
        
        childVc.tabBarItem =  [[UITabBarItem alloc] initWithTitle:title image:normalWebImage.image selectedImage:[selectedWebImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        // 强制重新布局子控件（内部会调用layouSubviews）
        [weakSelf.tabBar setNeedsLayout];
    }];

    
    [self addChildViewController:nav];
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    if (self.supportPortraitOnly) {
        return UIInterfaceOrientationPortrait == toInterfaceOrientation;
    }else {
        return [self.selectedViewController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
    }
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (self.supportPortraitOnly) {
        return UIInterfaceOrientationMaskPortrait;
    }else{
        return [self.selectedViewController supportedInterfaceOrientations];
    }
}

// New Autorotation support.
- (BOOL)shouldAutorotate {
    if (self.supportPortraitOnly) {
        return NO;
    }else{
        return [self.selectedViewController shouldAutorotate];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
