//
//  UserDefaultStorage.h
//  ZongShengTrainVideo
//
//  Created by zjq on 2017/6/23.
//  Copyright © 2017年 zjq. All rights reserved.
//

#import "BaseStorage.h"

@interface UserDefaultStorage : BaseStorage

/**
 *   保存非WIFI网络下播放视频提示设置
 *
 *  @param isTips ture
 */
+ (void)savePlayVideoTipsForWWAN:(BOOL)isTips;
/**
 *   获取非WIFI网络下播放视频提示设置
 *
 */
+ (BOOL)playVideoTipsForWWAN;
/**
 *设置提交App Store审核中状态
 **/
+(void)saveSubmitInreviewState:(BOOL)isTips;
/**
 *   提交App Store审核中
 *
 *  @return bool   YES 审核中    NO 正常状态
 */
+ (BOOL)submitInreviewState;

/**
 *保存APP中使用到的HTML URL
 **/
+(void)saveHtmlUrls:(NSDictionary*)dic;
/**
 *   获取APP中使用到的HTML URL
 *
 *  @return bool   NSDictionary
 */
+ (NSDictionary *)getHtmlUrls;
/**
 *  获取本地储存的APP版本号
 *  @return NSString  版本号字符串
 */
+ (NSString *)localVersion;
/**
 * 设置本地储存的APP版本号
 * @param currentVersion 当前版本号
 */
+ (void)saveVersion:(NSString *)currentVersion;

/**
 * 设置本地储存cookies
 * @param cookiestr cookie值
 */
+ (void)saveWebCookies:(NSString *)cookiestr;
/**
 * 获取本地储存cookies
 */
+ (NSString *)webCookies;

@end
