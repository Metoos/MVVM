//
//  AppConfig.h
//  ManLiao
//
//  Created by Manloo on 15/12/4.
//  Copyright © 2015年 manloo. All rights reserved.
//

#ifndef AppConfig_h
#define AppConfig_h
//bolck使用 避免循环引用
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;


#define WEAKSELF typeof(self) __weak weakSelf = self;

#define NSStringFormat(...) [[NSString alloc] initWithFormat:__VA_ARGS__]

#define WEAKIFY @weakify(self)
#define STRONGIFY @strongify(self)

//请求数据分页大小
#define PAGESIZE 30


#define     kDic [NSMutableDictionary new]

//屏幕宽高
#define     kViewWidth       [UIScreen mainScreen].bounds.size.width
#define     kViewHeight      [UIScreen mainScreen].bounds.size.height

//屏幕比例

#define     kScreenWidthRatio    (kViewWidth/375)
#define     kScreenHeightRatio   (kViewHeight/667.0>1?kViewHeight/667.0:1)

#define kDevice_Is_iPhoneX (([[UIApplication sharedApplication] statusBarFrame].size.height)>=44)
#define kStatusBarBottom [[UIApplication sharedApplication] statusBarFrame].size.height

#define kNavigationBarAndStatusBarHeight  (kDevice_Is_iPhoneX?88.0f:64.0f)
#define kTabbarHeight                     (kDevice_Is_iPhoneX?83.0f:49.0f)
#define kDistancebottom                   (kDevice_Is_iPhoneX?34.0f:0.0f)


#define kFrame( x, y, w, h)         CGRectMake(x, y, w, h)
#define kBounds(x, y, w, h)         CGRectMake(x, y, w, h)
#define kGetMaxY(view)              CGRectGetMaxY(view.frame)
#define kGetMaxX(view)              CGRectGetMaxX(view.frame)
#define kSize( w, h)                CGSizeMake(w, h);
#define kPoint(x,y)                 CGPointMake(x,y);
#define kGetMinX(view)              CGRectGetMinX(view.frame)
#define kGetMinY(view)              CGRectGetMinY(view.frame)
#define kGetMidX(view)              CGRectGetMidX(view.frame)
#define kGetMidY(view)              CGRectGetMidY(view.frame)
#define kGetWidth(view)             CGRectGetWidth(view.frame)
#define kGetHeight(view)            CGRectGetHeight(view.frame)


//获取程序当前版本信息
#define kCurrentVersions  [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"]
//获取沙盒路径
#define kSandboxPath      NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]

#define kCornerRadius    5.0f

//十六进制设置颜色 透明度
#define COLORRGBA(c,a) [UIColor colorWithRed:((c>>16)&0xFF)/255.0	\
green:((c>>8)&0xFF)/255.0	\
blue:(c&0xFF)/255.0         \
alpha:a]

//十六进制设置颜色
#define COLORRGB(c)    [UIColor colorWithRed:((c>>16)&0xFF)/255.0	\
green:((c>>8)&0xFF)/255.0	\
blue:(c&0xFF)/255.0         \
alpha:1.0]


/**
 *  全局字体大小与颜色
 */
#define     kColorRGB(R,G,B,A) [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:(A)]

//主标题颜色
#define     kTitleColor       kColorRGB(58,58,58,1)
//主标题字号
#define     kTitleFont        [UIFont systemFontOfSize:15]
//副标题颜色
#define     kSubTitleColor    kColorRGB(204,204,204,1)
//副标题字号
#define     kSubTitleFont     [UIFont systemFontOfSize:14]
//主题色
#define     kThemeColor       COLORRGB(0x278FFF)
//导航栏主题色
#define     kNavBgColor       COLORRGB(0xB2E0FD)
//导航栏主题色
#define     kNavBgOtherColor  COLORRGB(0xfea803)

//tableview背景颜色
#define     kTableViewBgColor kColorRGB(239,239,244,1)
//#define     kTableViewBgColor kColorRGB(255,255,255,1)
//线条颜色
#define     kLineColor        kColorRGB(230,230,230,1)


#define     kFont(x)        [UIFont systemFontOfSize:x]
#define     kFontBold(x)    [UIFont boldSystemFontOfSize:x]
#define     kUserNameFont   [UIFont fontWithName:@"Helvetica-Bold" size:16]
#define     kUserNameColor  kColorRGB(16, 106, 1, 1)

//各颜色
#define     kWhiteColor     [UIColor whiteColor]
#define     kBlackColor     [UIColor blackColor]
#define     kRedColor       [UIColor redColor]
#define     kYellowColor    [UIColor yellowColor]
#define     kClearColor     [UIColor clearColor]
#define     kBrownColor     [UIColor brownColor]
#define     kBlueColor      [UIColor blueColor]
#define     kGreenColor     [UIColor greenColor]
#define     kOrangeColor    [UIColor orangeColor]
#define     kLightGrayColor [UIColor lightGrayColor]
#define     kGrayColor      [UIColor grayColor]

//判断是否是iphone4或4s
#define     iPhone4         ([UIScreen mainScreen].bounds.size.height == 480)
//判断是否为iPhone5或iPhone5s
#define     iPhone5         ([UIScreen mainScreen].bounds.size.height == 568)

//判断是否为iPhone6
#define     iPhone6         ([UIScreen mainScreen].bounds.size.height == 667)

//判断是否为iPhone6plus
#define     iPhone6plus     ([UIScreen mainScreen].bounds.size.height >= 736)

//判断是否为iPhoneX
#define     iPhoneX         ([[UIApplication sharedApplication] statusBarFrame].size.height >= 44)

//判断系统版本
#define     systemversion   [[UIDevice currentDevice].systemVersion floatValue]

/// 项目中关于一些简单的业务逻辑验证放在ViewModel的命令中统一处理 NSError
/// eg：假设验证出来不是正确的手机号：
/// [RACSignal error:[NSError errorWithDomain:JQCommandErrorDomain code:JQCommandErrorCode userInfo:@{JQCommandErrorUserInfoKey:@"请输入正确的手机号码"}]];
#define JQCommandErrorDomain @"JQCommandErrorDomain"
#define JQCommandErrorUserInfoKey @"JQCommandErrorUserInfoKey"
#define JQCommandErrorCode 12333

//信息提示
#define TEXT_NETWORK_ERROR       JQGetStringWithKeyFromTable(@"网络异常请求失败", nil)

#define TEXT_SERVER_NOT_RESPOND  JQGetStringWithKeyFromTable(@"服务器异常请求失败", nil)

#define APPNAME @""
#define CopyRightName @"duomi Inc"
#define COPYRIGHTEMAIL @"1300000000@qq.com"

//appstore创建的App得到的APPID
#define AppStoreAppID @""

//#define placeholderImg [UIImage imageNamed:@"placeHoldImg"]
#define placeholderImg [UIImage jq_imageWithColor:kColorRGB(242, 242, 242, 1)]

#define dispatch_async_on_main(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}

#define dispatch_async_on_global(block)\
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),block)

//日志输出宏定义，若为调试状态，则可以输出，若是发布状态，则自动不会参与编译输出
#ifdef DEBUG
//调试状态
#define DLog( s, ... ) NSLog( @"<%p %@:%d (%@)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__,  NSStringFromSelector(_cmd), [NSString stringWithFormat:(s), ##__VA_ARGS__] )

#define DLogFrame(view)  DLog(@"%@",NSStringFromCGRect(view.frame))
#else
//发布状态
#define DLog(...)

#define NSLog(...)

#endif






#endif





