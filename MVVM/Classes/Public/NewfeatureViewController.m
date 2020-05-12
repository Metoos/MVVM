//
//  NewfeatureViewController.m
//  FJLottery
//
//  Created by 沧海小鱼 on 15/7/22.
//  Copyright (c) 2015年 FuJu Technology Co.,Ltd. All rights reserved.
//

#import "NewfeatureViewController.h"
//#import "LoginViewController.h"
#import "JQNavigationController.h"
#define kNewfeatureImageCount 3
#define kCurrentPageIndicatorTintColor kColorRGB(255, 255, 255,1)
#define kPageIndicatorTintColor kColorRGB(255, 255, 255, 0.3)

@interface NewfeatureViewController () <UIScrollViewDelegate>

@property (nonatomic, weak) UIPageControl *pageControl;
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, strong) UIButton *skipBtn;

@end

@implementation NewfeatureViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // 1.添加UISrollView
    [self setupScrollView];
    
    // 2.添加pageControl
//    [self setupPageControl];
    //3.添加跳过引导页按钮
    [self setupSkipButton];
    
}

- (void)setupSkipButton
{
    [self skipBtn];
}

- (UIButton *)skipBtn
{
    if (!_skipBtn) {
        //跳过引导按钮
        _skipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _skipBtn.backgroundColor = kClearColor;
//        _skipBtn.alpha = 0.5;
        _skipBtn.frame = CGRectMake(10, kViewHeight-(100*kScreenHeightRatio)-20, self.view.frame.size.width-20, 120*kScreenHeightRatio);
        [_skipBtn addTarget:self action:@selector(skipAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_skipBtn];
        _skipBtn.hidden = YES;
    }
    return _skipBtn;
}

/**
 *  添加pageControl
 */
- (void)setupPageControl {
    
    // 1.添加
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = kNewfeatureImageCount;
    CGFloat centerX = self.view.frame.size.width * 0.5;
    CGFloat centerY = self.view.frame.size.height - 30;
    pageControl.center = CGPointMake(centerX, centerY);
    pageControl.bounds = CGRectMake(0, 0, 100, 30);
    pageControl.userInteractionEnabled = NO;
    [self.view addSubview:pageControl];
    self.pageControl = pageControl;
    
    // 2.设置圆点的颜色
    pageControl.currentPageIndicatorTintColor = kCurrentPageIndicatorTintColor;
    pageControl.pageIndicatorTintColor = kPageIndicatorTintColor;
}

/**
 *  添加UISrollView
 */
- (void)setupScrollView {
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    // 2.添加图片
    CGFloat imageW = scrollView.frame.size.width;
    CGFloat imageH = scrollView.frame.size.height;
    
    for (int index = 0; index < kNewfeatureImageCount; index++) {
        
        UIImageView *imageView = [[UIImageView alloc] init];
        
        imageView.userInteractionEnabled = YES;
        NSString *name = nil;
        if (iPhone4) {
            // 设置图片
            name = [[NSString alloc] initWithFormat:@"guide_%d_960", index + 1];
        }else if (iPhoneX)
        {
            name = [[NSString alloc] initWithFormat:@"guide_%d_2436", index + 1];
        }else
        {
            name = [[NSString alloc] initWithFormat:@"guide_%d_2208", index + 1];
        }
        NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"png"];
        if (path) {
            imageView.image = [UIImage imageWithContentsOfFile:path];
        }
        
        // 设置frame
        CGFloat imageX = index * imageW;
        imageView.frame = CGRectMake(imageX, 0, imageW, imageH);
        
        [scrollView addSubview:imageView];
        
         //在最后一个图片上面添加点击事件
        if (index == kNewfeatureImageCount - 1) {
            
            self.imageView = imageView;
            
//            UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(start)];
//            [imageView addGestureRecognizer:recognizer];
        }
    }
    
    // 3.设置滚动的内容尺寸
    scrollView.contentSize = CGSizeMake(imageW * kNewfeatureImageCount, 0);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = YES;
}

- (void)skipAction:(id)sender
{
    [self start];
}

/**
 *  点击进入首页
 */
- (void)start {
    // 显示状态栏
    [UIApplication sharedApplication].statusBarHidden = NO;
    // 切换窗口的根控制器

//    LoginViewController *login = [UniversalManager getControllerByStoryboardName:@"Personal" identiffier:@"LoginViewController"];
//    JQNavigationController *nav = [[JQNavigationController alloc] initWithRootViewController:login];
//    self.view.window.rootViewController = nav;
}

/**
 *  只要UIScrollView滚动了,就会调用
 *
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // 1.取出水平方向上滚动的距离
    CGFloat offsetX = scrollView.contentOffset.x;
    
    // 2.求出页码
    double pageDouble = offsetX / scrollView.frame.size.width;
    int pageInt = (int)(pageDouble + 0.5);
    self.pageControl.currentPage = pageInt;
    
    if (pageInt == kNewfeatureImageCount-1) { //最后一页显示跳过按钮
        self.skipBtn.hidden = NO;
    }else
    {
        self.skipBtn.hidden = YES;
    }
    CGFloat imageW = scrollView.frame.size.width;
    CGFloat contentWidth = imageW * kNewfeatureImageCount+30;
    if (offsetX+imageW > contentWidth) {
        [self start];
    }
}

@end
