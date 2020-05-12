//
//  UserDefaultStorage.m
//  ZongShengTrainVideo
//
//  Created by zjq on 2017/6/23.
//  Copyright © 2017年 zjq. All rights reserved.
//

#import "UserDefaultStorage.h"
/** 非WIFI网络下播放视频提示 */
static NSString * const PALY_VIDEO_TIPS_FOR_WWAN_KEY = @"PALY_VIDEO_TIPS_FOR_WWAN_KEY";

/** App Store审核中 */
static NSString * const APP_INREVIEW_KEY = @"APP_INREVIEW_KEY";
/** Html url */
static NSString * const APP_HTML_URL_KEY = @"APP_HTML_URL_KEY";

/** Htmlcookie */
static NSString * const APP_HTML_WEBCOOKIE_KEY = @"APP_HTML_WEBCOOKIE_KEY";

static NSString * const CFBundleShortVersionString = @"CFBundleShortVersionString";

@implementation UserDefaultStorage

#pragma mark - 保存非WIFI网络下播放视频提示设置
+ (void)savePlayVideoTipsForWWAN:(BOOL)isTips
{
    [self saveValue:[NSNumber numberWithBool:isTips] forKey:PALY_VIDEO_TIPS_FOR_WWAN_KEY];
}
#pragma mark - 获取非WIFI网络下播放视频提示设置
+ (BOOL)playVideoTipsForWWAN
{
    return [[self valueWithKey:PALY_VIDEO_TIPS_FOR_WWAN_KEY] boolValue];
}
#pragma mark - 设置提交App Store审核中状态
+(void)saveSubmitInreviewState:(BOOL)isTips
{
    [self saveValue:[NSNumber numberWithBool:isTips] forKey:APP_INREVIEW_KEY];

}
#pragma mark - 获取提交App Store审核中
+(BOOL)submitInreviewState
{
    return [[self valueWithKey:APP_INREVIEW_KEY] boolValue];
}

#pragma mark -  保存APP中使用到的HTML URL
+(void)saveHtmlUrls:(NSDictionary*)dic
{
    if (dic) {
       [self saveValue:dic forKey:APP_HTML_URL_KEY]; 
    }
    
}

#pragma mark - 获取APP中使用到的HTML URL
+ (NSDictionary *)getHtmlUrls
{
    return [self valueWithKey:APP_HTML_URL_KEY];
}

#pragma mark - 获取本地储存的APP版本号
+ (NSString *)localVersion
{
    return [self valueWithKey:CFBundleShortVersionString];
}
#pragma mark - 设置本地储存的APP版本号
+ (void)saveVersion:(NSString *)currentVersion
{
    [self saveValue:currentVersion forKey:CFBundleShortVersionString];
}

/**
 * 设置本地储存cookies
 * @param cookiestr cookie值
 */
+ (void)saveWebCookies:(NSString *)cookiestr
{
    [self saveValue:cookiestr forKey:APP_HTML_WEBCOOKIE_KEY];
    
}
/**
 * 获取本地储存cookies
 */
+ (NSString *)webCookies
{
    return [self valueWithKey:APP_HTML_WEBCOOKIE_KEY];
}


@end
