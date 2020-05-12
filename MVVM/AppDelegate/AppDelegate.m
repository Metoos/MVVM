//
//  AppDelegate.m
//  ZongShengTrainVideo
//
//  Created by zjq on 2017/6/9.
//  Copyright © 2017年 zjq. All rights reserved.
//

#import "AppDelegate.h"
#import "JQTabBarController.h"
#import "HomeViewController.h"
#import "WRNavigationBar.h"
#import "JQNavigationController.h"
//#import "LoginEntity.h"
#import "UIView+Internationalization.h"
#import <WebKit/WebKit.h>
#import "JQWebViewController.h"
#import <IQKeyboardManager.h>
#import <Bugly/Bugly.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    [UIView internationalizationEnable:YES];

    [self initSDK];
    [self setNavBarAppearence];
//    [self getAreaCode];
//    [self getNewsVersion];
    
    if (@available(iOS 9.0, *)) {
        // 清除部分，可以自己设置
        // NSSet *websiteDataTypes= [NSSet setWithArray:types];
        // 清除所有
        NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
        //// Date from
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        //// Execute
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            
            // Done
            NSLog(@"清楚缓存完毕");
            
        }];
    }else
    {
        // 清除缓存
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        [[NSURLCache sharedURLCache] setDiskCapacity:0];
        [[NSURLCache sharedURLCache] setMemoryCapacity:0];
    }
    
    
    /** 监测网络变化 */
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(netWorkError:) name:TEXT_NETWORK_ERROR object:nil];
    [[JQHttpClient defaultClient] connectionAvailablewithSuccessBlock:NULL];
    
//    [self reLogin];

//    UIViewController *gifView = [[UIViewController alloc]init];
//    UIImageView *imageViewGif = [[UIImageView alloc]initWithFrame:gifView.view.bounds];
//    [gifView.view addSubview:imageViewGif];
//    imageViewGif.image = [UIImage animatedGIFNamed:@"Launch"];
//    self.window.rootViewController = gifView;
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        HomeViewController *home =  [[HomeViewController alloc]initStoryboardWithName:@"Home" identiffier:@"HomeViewController" ViewModel:[[HomeViewModel alloc]init]];
    HomeViewController *home =  [[HomeViewController alloc]initWithViewModel:[[HomeViewModel alloc]init]];
    JQNavigationController *nav = [[JQNavigationController alloc]initWithRootViewController:home];
    self.window.rootViewController = nav;
//    });
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)reLogin{
    
//    WEAKIFY;
//    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:k_SHOW_LOGINVIEW object:nil] subscribeNext:^(NSNotification * _Nullable x) {
//        STRONGIFY;
//        WEAKIFY;
//        if ([x.object intValue] == 1) {
//            [UniversalManager showWithTipsMessage:@"修改成功，请重新登录！"];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [LoginEntity sharedLoginEntity].data = nil;
//                LoginViewController *login = [[LoginViewController alloc]initStoryboardWithName:@"My" identiffier:@"LoginViewController" ViewModel:[[LoginViewModel alloc]init]];
//                JQNavigationController *nav = [[JQNavigationController alloc]initWithRootViewController:login];
//                self.window.rootViewController = nav;
//            });
//        }if ([x.object intValue] == 2) {
//
//            [LoginEntity sharedLoginEntity].data = nil;
//            LoginViewController *login = [[LoginViewController alloc]initStoryboardWithName:@"My" identiffier:@"LoginViewController" ViewModel:[[LoginViewModel alloc]init]];
//            JQNavigationController *nav = [[JQNavigationController alloc]initWithRootViewController:login];
//            self.window.rootViewController = nav;
//
//        }else
//        {
//            [UniversalManager showAlertWithTitle:JQGetStringWithKeyFromTable(@"通知", nil) Message:JQGetStringWithKeyFromTable(@"您的账号登录已过期或者已经在其他地方登录", nil) cancelButton:JQGetStringWithKeyFromTable(@"重新登录", nil) ClickBlock:^(NSInteger index) {
//                STRONGIFY;
//                [LoginEntity sharedLoginEntity].data = nil;
//                LoginViewController *login = [[LoginViewController alloc]initStoryboardWithName:@"My" identiffier:@"LoginViewController" ViewModel:[[LoginViewModel alloc]init]];
//                JQNavigationController *nav = [[JQNavigationController alloc]initWithRootViewController:login];
//                self.window.rootViewController = nav;
//            }];
//        }
//
//    }];
}


- (void)getNewsVersion
{
    //获取程序当前版本信息
    //    NSString *currVersions = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    
    //处理接口请求全局统一参数
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:(NSDictionary *)@{@"type":@"2"} copyItems:YES];
    NSString *timestamp = [UniversalManager getSyetemTimeInterval];
    //在参数中添加时间戳和签名字段
    [dic setObject:timestamp forKey:@"timestamp"];
    NSString *sign = [UniversalManager md5EncryptStrWithParam:dic];
    [dic setObject:sign forKey:@"sign"];
    
    [[JQHttpClient defaultClient] requestWithPath:API_UPDATE method:JQHttpRequestPostString parameters:dic prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        DLog(@"responseObject = %@",responseObject);
        JQBaseModel *model = [JQBaseModel mj_objectWithKeyValues:responseObject];
        if (model.code == successed) {
            NSString *upUrl = nil;
            NSString *version = nil;
            NSString *status  = nil;
            NSDictionary *dic = responseObject[@"data"];
            if (dic) {
                version   = [dic toString:@"version"];
                upUrl     = [dic toString:@"url"];
                status    = [dic toString:@"switch"];
            }
            
            DLog(@"version = %@ \n currVersions = %@,",version,kCurrentVersions);
            //更新APP版本
            [UniversalManager appVersionUpdateWithTips:nil serverGetVersion:version updateUrl:upUrl forcedUpdating:NO];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}

- (void)getAreaCode
{

//    //处理接口请求全局统一参数
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
//    NSString *timestamp = [UniversalManager getSyetemTimeInterval];
//    //在参数中添加时间戳和签名字段
//    [dic setObject:timestamp forKey:@"timestamp"];
//    NSString *sign = [UniversalManager md5EncryptStrWithParam:dic];
//    [dic setObject:sign forKey:@"sign"];
//
//    [[JQHttpClient defaultClient] requestWithPath:API_AREACODE method:JQHttpRequestPostString parameters:dic prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        DLog(@"responseObject = %@",responseObject);
//        UniversalModel *model = [UniversalModel mj_objectWithKeyValues:responseObject];
//        if (model.status == successed) {
//            NSArray *ary = model.data;
//            if ([ary isKindOfClass:NSArray.class]) {
//                [LoginEntity sharedLoginEntity].areaCode = ary;
//            }
//        }
//
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//
//    }];
    
}

- (void)setNavBarAppearence
{
//        [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor purpleColor]}];
//        [UINavigationBar appearance].tintColor = [UIColor yellowColor];
//        [UINavigationBar appearance].barTintColor = [UIColor redColor];
    

    
    //设置是 广泛使用WRNavigationBar，还是局部使用WRNavigationBar，目前默认是广泛使用
    [WRNavigationBar wr_widely];
//    [WRNavigationBar wr_setBlacklist:@[@"SpecialController",
//                                       @"TZPhotoPickerController",
//                                       @"TZGifPhotoPreviewController",
//                                       @"TZAlbumPickerController",
//                                       @"TZPhotoPreviewController",
//                                       @"TZVideoPlayerController",
//                                       @"AipNavigationController",
//                                       @"AipGeneralVC"]];
    
//    NSShadow *shadow = [NSShadow new];
//    [shadow setShadowOffset:CGSizeMake(1, 1)];
//    [shadow setShadowColor:kBlackColor];
//    [[UINavigationBar appearance] setTitleTextAttributes:@{NSShadowAttributeName:shadow}];
    
    // 设置导航栏默认的背景颜色
    [WRNavigationBar wr_setDefaultNavBarBarTintColor:kBlueColor];

    // 设置导航栏所有按钮的默认颜色
    [WRNavigationBar wr_setDefaultNavBarTintColor:kWhiteColor];
    // 设置导航栏标题默认颜色
    [WRNavigationBar wr_setDefaultNavBarTitleColor:kWhiteColor];
    // 统一设置状态栏样式
    [WRNavigationBar wr_setDefaultStatusBarStyle:UIStatusBarStyleLightContent];
    // 如果需要设置导航栏底部分割线隐藏，可以在这里统一设置
    [WRNavigationBar wr_setDefaultNavBarShadowImageHidden:YES];
}

- (void)initSDK
{
    //初始化腾讯bugly crash收集SDK
    [Bugly startWithAppId:BuglyAppid];
    
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = YES;
}

- (void)netWorkError:(NSNotification*)notification
{
    NSString *message = (NSString*)notification.object;
    [UniversalManager showAlertWithMessage:message];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
