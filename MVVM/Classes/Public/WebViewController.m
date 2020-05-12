//
//  WebViewController.m
//  LKC
//
//  Created by life on 2018/4/16.
//  Copyright © 2018年 hdyg. All rights reserved.
//

#import "WebViewController.h"
#import "JQWebView.h"
#import "UserDefaultStorage.h"
@interface WebViewController ()<JQWebViewDelegate>


@property (nonatomic, strong) NSString *originalUrl;

@property (strong, nonatomic) JQWebView *webView;

@property (strong, nonatomic) UILabel *errorLab;

@property (strong, nonatomic) UIBarButtonItem *backBtn;
@property (strong, nonatomic) UIBarButtonItem *closeBtn;

//@property (strong, nonatomic) NSString *urlString;
@property (strong, nonatomic) NSString *htmlString;

/** 导航标题 showsPageTitleInNavigationBar = NO 时 有效 */
@property (strong, nonatomic) NSString *navigationTitleString;
/** 显示每个网页的标题 默认 YES*/
@property (nonatomic, assign) BOOL showsPageTitleInNavigationBar;

/** 返回按钮图片 */
@property (nonatomic, strong) UIImage *backButtonImage;
/** 进度条背景颜色 */
@property (nonatomic, strong) UIColor *loadingTrackTintColor;
/** 进度条进度值颜色 */
@property (nonatomic, strong) UIColor *loadingTintColor;
//@property (nonatomic, strong) UIColor *barTintColor;
/** 关闭全部网页按钮是否隐藏 默认显示 */
@property (nonatomic, assign) BOOL closeButtonHidden;
//@property (nonatomic, assign) BOOL showsURLInNavigationBar;
/** 是否需要自动刷新界面 */
@property (nonatomic, assign) BOOL isNotRefershWebView;

@end

@implementation WebViewController

-(instancetype)initWithURLString:(NSString *)urlString
{
    self = [super init];
    if (self) {
        self.urlString = urlString;
        self.originalUrl = urlString;
        self.showsPageTitleInNavigationBar = YES;
        self.backButtonImage = [UIImage imageNamed:@"jq_back"];
    }
    
    return self;
}

- (instancetype) initWithHTMLString:(NSString *)htmlString
{
    self = [super init];
    if (self) {
        self.htmlString = htmlString;
        self.showsPageTitleInNavigationBar = YES;
        self.backButtonImage = [UIImage imageNamed:@"jq_back"];
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UIImageView *bg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"my_bg"]];
    bg.frame = self.view.bounds;
    [self.view insertSubview:bg atIndex:0];
    
    self.view.backgroundColor = COLORRGB(0x2b2c30);
    self.webView.wkWebView.scrollView.showsVerticalScrollIndicator = NO;
    self.webView.wkWebView.scrollView.showsHorizontalScrollIndicator = NO;
    
    self.backBtn = [[UIBarButtonItem alloc]initWithImage:self.backButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(goBackAction)];
    
    self.closeBtn = [[UIBarButtonItem alloc]initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeAction)];
    self.navigationItem.leftBarButtonItems = @[self.backBtn];
    
    if (@available(iOS 11.0, *)) {
        self.webView.wkWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.webView.wkWebView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.webView.wkWebView.scrollView.scrollIndicatorInsets = self.webView.wkWebView.scrollView.contentInset;
        
    }else
    {
        //这里的self是控制器
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
    [self.webView.wkWebView setOpaque:NO];
    self.webView.wkWebView.backgroundColor = kClearColor;
    self.webView.backgroundColor = kClearColor;
    
    /// 用于进行添加 httpheader 写入 cookies
    NSString *cookieStr = [NSString stringWithFormat:@"%@",[UserDefaultStorage webCookies]];
    NSString *source = [NSString stringWithFormat:@"document.cookie='%@;path=/';", cookieStr];
    WKUserScript *wkUScriptNew = [[WKUserScript alloc] initWithSource:source injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
    [self.webView.wkWebView.configuration.userContentController addUserScript:wkUScriptNew];
    
    
    /** 添加js可调用的原生方法 */
    [self nativeConverJSFunction];
    
    if (self.urlString)
    {   //开始加载网页链接
        [self loadRequest:self.urlString];
        
    }else if (self.htmlString)
    {
        //开始加载网页代码
        [self.webView loadHTMLString:self.htmlString];
    }
    
   
    
    self.view.stateView.backgroundColor = kNavBgColor;
    //使用自定义GIF图片作为加载状态显示
    [self.view.stateView setImages:[self loadingImages] duration:2.25f];
    [self.view showLoadStateWithFrame:CGRectMake(0, -(kNavigationBarAndStatusBarHeight), kViewWidth, kViewHeight+kNavigationBarAndStatusBarHeight) maskViewStateType:viewStateWithLoading];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.9 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.view dismessStateView];
//    });
    WEAKIFY
    [self.view loadStateReturnBlock:^(ViewStateReturnType viewStateReturnType) {
        STRONGIFY
        if (viewStateReturnType == ViewStateReturnReloadViewDataType) {
           [self.view showLoadStateWithMaskViewStateType:viewStateWithLoading];
           [self loadRequest:self.urlString];
        }
        
    }];
    
    // Do any additional setup after loading the view.
}


- (void)jq_layoutNavigation
{
    [super jq_layoutNavigation];
}

/** 添加js可调用的原生方法 */
- (void)nativeConverJSFunction
{
    //返回原生上一页方法
    WEAKIFY;
    [self.webView addScriptMessageWithName:@"goAppBack" handler:^(id data) {
        STRONGIFY;
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    /** 导航栏添加右边按钮 */
    [self.webView addScriptMessageWithName:@"setRightBar" handler:^(id data) {
        STRONGIFY;
        if ([data isKindOfClass:NSString.class]) {
            NSString *str = (NSString*)data;
            //JSON字符串转化为字典
            NSDictionary *dic = [UniversalManager dictionaryWithJsonString:str];
            if (dic) {
                data = data;
            }
        }
        if ([data isKindOfClass:NSDictionary.class]) {
            NSString *title = [(NSDictionary*)data toString:@"title"];
            NSString *url = [(NSDictionary*)data toString:@"url"];
            if (title && url) {
                WEAKIFY;
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:title Click:^{
                    STRONGIFY;
                   WebViewController *web = [[WebViewController alloc]initWithURLString:url];
                    [self.navigationController pushViewController:web animated:YES];
                }];
            }
            
            
        }
    }];
    
}



- (void)dealloc {
  
    [[_webView.wkWebView configuration].userContentController removeScriptMessageHandlerForName:@"goAppBack"];
    _webView.delegate = nil;
}






- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.webView removeFromSuperview];
//     [self.view insertSubview:self.webView atIndex:0];
    if (_isHiddenBackItem) {
        self.navigationController.navigationBarHidden = YES;
        
    }
    
    if (!self.webView.wkWebView.isLoading) {
        if (!self.isNotRefershWebView) {
            [self.view showLoadStateWithFrame:CGRectMake(0, -(kNavigationBarAndStatusBarHeight), kViewWidth, kViewHeight+kNavigationBarAndStatusBarHeight) maskViewStateType:viewStateWithLoading];
            [self loadRequest:self.urlString];
        }else
        {
            self.isNotRefershWebView = NO;
        }
        

//        [self.webView reload];

    }
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_isHiddenBackItem) {
        self.navigationController.navigationBarHidden = NO;
    }
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

    DLog(@"界面 = %@",NSStringFromClass([UniversalManager getCurrentViewController].class));
    NSString *vcname = NSStringFromClass([UniversalManager getCurrentViewController].class);
    if ([vcname isEqualToString:@"PUPhotoPickerHostViewController"] || //进入系统相册界面标记不刷新
        [vcname isEqualToString:@"CAMImagePickerCameraViewController"]|| //进入系统拍照界面标记不刷新
        [vcname isEqualToString:@"UIDocumentPickerViewController"]) { //进入系统文件界面标记不刷新
        self.isNotRefershWebView = YES;
    }else
    {
        self.isNotRefershWebView = NO;
    }
}


- (void)setNavigationTitleString:(NSString *)navigationTitleString
{
    _navigationTitleString = navigationTitleString;
    self.title = navigationTitleString;
}

- (void)loadRequest:(NSString *)urlString
{    
    self.urlString = urlString;
    
    /** 同步多个webview cookie数据 */
    // 在此处获取返回的cookie
    NSMutableDictionary *cookieDic = [NSMutableDictionary dictionary];
    NSMutableString *cookieValue = [NSMutableString stringWithFormat:@""];
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    

    NSMutableArray *cookies = [NSMutableArray arrayWithArray:[cookieJar cookiesForURL:[NSURL URLWithString:self.urlString]]];
    [cookies addObjectsFromArray: [cookieJar cookies]];
    for (NSHTTPCookie *cookie in cookies) {
        [cookieDic setObject:cookie.value forKey:cookie.name];

    }
    // cookie重复，先放到字典进行去重，再进行拼接
    for (NSString *key in cookieDic) {
        NSString *appendString = [NSString stringWithFormat:@"%@=%@;", key, [cookieDic valueForKey:key]];
        [cookieValue appendString:appendString];
    }
    
    [UserDefaultStorage saveWebCookies:cookieValue];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request addValue:cookieValue forHTTPHeaderField:@"Cookie"];
    //开始加载网页链接
    [self.webView loadRequest:request];
    
}

- (void)setLoadingTintColor:(UIColor *)loadingTintColor
{
    _loadingTintColor = loadingTintColor;
    
    self.webView.tintColor = loadingTintColor;
    
}
- (void)setLoadingTrackTintColor:(UIColor *)loadingTrackTintColor
{
    _loadingTrackTintColor = loadingTrackTintColor;
    self.webView.trackTintColor = loadingTrackTintColor;
}

- (void)goBackAction
{
//    if ([self.webView canGoBack]) {
//        [self.webView goBack];
//    }
//    else
//    {
        [self.navigationController popViewControllerAnimated:YES];
//    }
    
}


#pragma mark - JQWebViewDelegate
- (void)JQWebView:(JQWebView *)webview didFinishLoadingURL:(NSURL *)URL
{
    [self.view dismessStateView];
    
    if (self.showsPageTitleInNavigationBar) {
        NSString *title = [webview getHTMLDocumentTitle];
        if (title.length>0) {
            self.navigationItem.title = title;
        }
    }
    
//    if ([self.webView canGoBack] && !self.closeButtonHidden) {
//        self.navigationItem.leftBarButtonItems = @[self.backBtn,self.closeBtn];
//    }else
//    {
//        if (!_isHiddenBackItem) {
//           self.navigationItem.leftBarButtonItems = @[self.backBtn];
//        }
//    }
    

//    if (!_isHiddenBackItem) {
//        self.navigationItem.leftBarButtonItems = @[self.backBtn];
//    }
    
    
}
- (void)JQWebView:(JQWebView *)webview didFailToLoadURL:(NSURL *)URL error:(NSError *)error
{
    [self.view showLoadStateWithFrame:CGRectMake(0, -(kNavigationBarAndStatusBarHeight), kViewWidth, kViewHeight+kNavigationBarAndStatusBarHeight) maskViewStateType:viewStateWithLoadError];
    if (!self.urlString) {
        self.urlString = self.originalUrl;
    }

}

//- (BOOL)JQWebView:(JQWebView *)webview shouldStartLoadWithURL:(NSURL *)URL
//{
//    DLog(@"urlbaseURL = %@ \n 请求URL = %@",URL.baseURL,URL.absoluteString);
//    if ([k_WEBVIEW_JUMP_LOGOUT isEqualToString:URL.absoluteString]) {
//        //token失效或主动退出
//        [[NSNotificationCenter defaultCenter] postNotificationName:k_SHOW_LOGINVIEW object:nil];
//        return NO;
//    }
//
//
//
//
//    __block BOOL isreturnNO = NO;
//    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//         //判断网页是否已打开 已打开则返回打开页
//        if ([obj isKindOfClass:self.class]) {
//            DLog(@"((WebViewController*)obj).urlString = %@",((WebViewController*)obj).urlString);
//             if ([((WebViewController*)obj).urlString isEqualToString:URL.absoluteString] && ![self.urlString isEqualToString:URL.absoluteString]) {
//                 [self.navigationController popToViewController:obj animated:YES];
//
//                 isreturnNO = YES;
//             }
//        }
//    }];
//    if (isreturnNO) {
//        return NO;
//    }
//
//
//    if (!webview.wkWebView.isLoading) {
//        if (![self.urlString isEqualToString:URL.absoluteString]) {
//            WebViewController *webViewVC = [[WebViewController alloc]initWithURLString:URL.absoluteString];
//            [self.navigationController pushViewController:webViewVC animated:YES];
//            return NO;
//        }
//    }
//
//
//
//
//    return YES;
//}

- (BOOL)JQWebView:(JQWebView *)webview shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(NSInteger)navigationType
{
    NSURL *URL = request.URL;
    if ([k_WEBVIEW_JUMP_LOGOUT isEqualToString:URL.absoluteString]) {
        //token失效
        [[NSNotificationCenter defaultCenter] postNotificationName:k_SHOW_LOGINVIEW object:nil];
        return NO;
    }
    
    if ([k_WEBVIEW_JUMP_LOGOUTTWO isEqualToString:URL.absoluteString]) {
        //主动退出
        [[NSNotificationCenter defaultCenter] postNotificationName:k_SHOW_LOGINVIEW object:@(2)];
        return NO;
    }
    
    
    if ([k_WEBVIEW_JUMP_GOBACK isEqualToString:URL.absoluteString]) {
        [self goBackAction];
        return NO;
    }
    
    if (navigationType == WKNavigationTypeReload) {
        return YES;
    }
    DLog(@"urlbaseURL = %@ \n 请求URL = %@ \n navigationType = %ld \n self.urlString = %@",URL.baseURL,URL.absoluteString,navigationType,self.urlString);
    
    if (navigationType == WKNavigationTypeOther && [self.urlString containsString:@"autologin"] && [self.urlString isEqualToString:URL.absoluteString]) {
        self.urlString = nil;
    }else if(!self.urlString)
    {
        self.urlString = URL.absoluteString;
    }
    
    
    
    __block BOOL isreturnNO = NO;
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //判断网页是否已打开 已打开则返回打开页
        if ([obj isKindOfClass:self.class]) {
            if ([((WebViewController*)obj).urlString isEqualToString:URL.absoluteString] && ![self.urlString isEqualToString:URL.absoluteString]) {
                [self.navigationController popToViewController:obj animated:YES];
                isreturnNO = YES;
            }
            
        }
    }];
    if (isreturnNO) {
        return NO;
    }
    
    DLog(@"webview.wkWebView.isLoading = %d",webview.wkWebView.isLoading);
    if (!webview.wkWebView.isLoading) {
        if (![self.urlString isEqualToString:URL.absoluteString]) {
            
            
            
//            if (navigationType == WKNavigationTypeOther) {
//                return NO;
//            }
//            //加载的链接有重定向时，解决中间空界面或多重界面加载问题
//            NSURLSessionDataTask *sessionDataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//                if (error || ([response respondsToSelector:@selector(statusCode)] && [((NSHTTPURLResponse *)response) statusCode] != 200 && [((NSHTTPURLResponse *)response) statusCode] != 302 && [((NSHTTPURLResponse *)response) statusCode] != 403)) {
//                    //Show error message
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        NSLog(@"statusCode = %ld",[((NSHTTPURLResponse *)response) statusCode]);
//                        [self.view showLoadStateWithMaskViewStateType:viewStateWithLoadError];
//                    });
//
//                }else {
//
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        WebViewController *webViewVC = [[WebViewController alloc]initWithURLString:URL.absoluteString];
//                        [self.navigationController pushViewController:webViewVC animated:YES];
//                    });
//
//                }
//            }];
//            [sessionDataTask resume];
            
            WebViewController *webViewVC = [[WebViewController alloc]initWithURLString:URL.absoluteString];
            [self.navigationController pushViewController:webViewVC animated:YES];
            return NO;
        }
    }
    return YES;
}
- (void)JQWebViewDidStartLoad:(JQWebView *)webview
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (JQWebView *)webView
{
    if (_webView == nil) {
        UIImageView *topImg = [[UIImageView alloc] init];
        topImg.frame = CGRectMake(0, 0, kViewWidth, kStatusBarBottom);
        topImg.image = [UIImage jq_imageWithColor:kNavBgColor];
        [self.view addSubview:topImg];
        
        CGFloat height = kNavigationBarAndStatusBarHeight;
//        CGFloat tabbar = self.tabBarController.tabBar.height;
//        if (self.hidesBottomBarWhenPushed) {
//            tabbar = 0.0f;
//        }
        if (_isHiddenBackItem) {
            height = kStatusBarBottom;
        }
        _webView = [[JQWebView alloc]initWithFrame:self.view.bounds];
        _webView.y = height;
        _webView.height = kViewHeight - height;
        _webView.delegate = self;
        _webView.progressView.y = 0.0f;
        [self.view addSubview:_webView];
    }
    
    return _webView;
}

- (NSArray *)loadingImages
{
    NSMutableArray *ary = [NSMutableArray arrayWithCapacity:47];
    for (int i=0; i<44; i++)
    {
        NSString *imageNamed = [[NSString alloc]initWithFormat:@"gif_%d",i];
        UIImage *image = [UIImage imageNamed:imageNamed];
        if (image) {
            [ary addObject:image];
        }
    }
    return ary;
    
}

@end
