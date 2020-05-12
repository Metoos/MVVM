//
//  JQNavigationController.m
//  ZongShengTrainVideo
//
//  Created by zjq on 2017/6/11.
//  Copyright © 2017年 zjq. All rights reserved.
//

#import "JQNavigationController.h"

@interface JQNavigationController ()

@end

@implementation JQNavigationController

//-(id)initWithRootViewController:(UIViewController *)rootViewController{
//    self = [super initWithRootViewController:rootViewController];
//    if (self) {
//                rootViewController.edgesForExtendedLayout = UIRectEdgeAll;
//        CGRect frame = self.navigationBar.frame;
//        self.alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height+20)];
//        self.alphaView.backgroundColor = kNavBgColor;
//        [self.view insertSubview:self.alphaView belowSubview:self.navigationBar];
//        self.navigationBar.backgroundColor = kClearColor;
//        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"bigShadow.png"] forBarMetrics:UIBarMetricsCompact];
//        self.navigationBar.barStyle = UIBarStyleDefault;
//        self.navigationBar.layer.masksToBounds = YES;
//
//    }
//    return self;
//}
//
//-(void)setNavigationBarHidden:(BOOL)navigationBarHidden
//{
//    [super setNavigationBarHidden:navigationBarHidden];
//
//    self.alphaView.hidden = navigationBarHidden;
//
//}
//
//
//- (void)setAlpha:(CGFloat)alpha
//{
//    [self setAlpha:alpha animated:YES];
//}
//- (void)setAlpha:(CGFloat)alpha animated:(BOOL)animated
//{
//    if (animated) {
//        [UIView animateWithDuration:0.5 animations:^{
//
//            self.alphaView.alpha = alpha;
//
//        } completion:^(BOOL finished) {
//
//        }];
//    }else
//    {
//        self.alphaView.alpha = alpha;
//    }
//
//}
//
//
//
//
//-(void)setAlphaHidden:(BOOL)hidden{
//
//
//    if (hidden) {
//        [UIView animateWithDuration:0.5 animations:^{
//            self.alphaView.alpha = 0.0;
//        } completion:^(BOOL finished) {
//
//        }];
//
//    }else{
//        [UIView animateWithDuration:0.5 animations:^{
//            self.alphaView.alpha = 1.0;
//        } completion:^(BOOL finished) {
//
//        }];
//    }
//
//
//
//}
//
//
////iOS 10
//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleLightContent;
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // 自定义UINavigationBar,将私有类_UIBarBackground中的UIVisualEffectView从navigationBar中删除
//    for (UIView *view in self.navigationBar.subviews) {
//        if ([view isKindOfClass:NSClassFromString(@"_UIBarBackground")]) {
//            for (UIView *subView in view.subviews) {
//                if ([subView isKindOfClass:[UIVisualEffectView class]]) {
//                    UIVisualEffectView *eview = (UIVisualEffectView*)subView;
//                    eview.hidden = YES;
//                }
//            }
//        }
//    }
//    self.navigationBar.backgroundColor = kClearColor;
//
//    // Do any additional setup after loading the view.
//}



#pragma mark 一个类只会调用一次
+ (void)initialize
{
    
    // 1.取出设置主题的对象
    UINavigationBar *navBar = [UINavigationBar appearance];
    UIBarButtonItem *barItem = [UIBarButtonItem appearance];
    
    
//    if (systemversion>7.0) { // 判断是否是IOS7
//        navBar.tintColor = [UIColor whiteColor];;
////        navBar.barTintColor = [UIColor whiteColor];
//    }
//
//    navBar.shadowImage = [UIImage new];
  
 
   
    
    
    // 3.设置导航栏标题颜色为自定义颜色
    [navBar setTitleTextAttributes:@{
                                     NSFontAttributeName:[UIFont systemFontOfSize:17.0f],
                                     NSForegroundColorAttributeName : kWhiteColor
                                     }];
//
//    // 4.设置导航栏按钮文字颜色为白色
    [barItem setTitleTextAttributes:@{
                                      NSForegroundColorAttributeName : kWhiteColor,
                                      //                                      UITextAttributeFont : [UIFont systemFontOfSize:13]
                                      NSFontAttributeName:[UIFont systemFontOfSize:15.0f]
                                      } forState:UIControlStateNormal];
    
    [barItem setTitleTextAttributes:@{
                                      NSForegroundColorAttributeName : kWhiteColor,
                                      //                                      UITextAttributeFont : [UIFont systemFontOfSize:13]
                                      NSFontAttributeName:[UIFont systemFontOfSize:15.0f]
                                      } forState:UIControlStateHighlighted];
}

//push的时候判断到子控制器的数量。当大于零时隐藏BottomBar 也就是UITabBarController 的tababar
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if(self.viewControllers.count>0){
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    
    [super pushViewController:viewController animated:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    if (!self.supportMaskAllButUpsideDown) {
        return UIInterfaceOrientationPortrait == toInterfaceOrientation;
    }else {
        return [self.topViewController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
    }
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (!self.supportMaskAllButUpsideDown) {
        return UIInterfaceOrientationMaskPortrait;
    }else{
        return [self.topViewController supportedInterfaceOrientations];
    }
}

// New Autorotation support.
- (BOOL)shouldAutorotate {
    if (!self.supportMaskAllButUpsideDown) {
        return NO;
    }else{
        return [self.topViewController shouldAutorotate];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
