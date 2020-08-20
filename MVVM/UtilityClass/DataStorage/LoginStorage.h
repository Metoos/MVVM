//
//  LoginStorage.h
//  RTLibrary-ios
//
//  Created by Ryan on 14-8-3.
//  Copyright (c) 2014年 zlycare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseStorage.h"

@interface LoginStorage : BaseStorage

/**
 *  获取登录用户名
 *
 *  @return userName
 */
+ (NSString *)userName;

/**
 *  保存登录用户名
 *
 *  @param userName 登录用户名
 */
+ (void)saveUserName:(NSString *)userName;


/**
 *  获取登录密码
 *
 *  @return password
 */
+ (NSString *)password;

/**
 *  保存登录密码
 *
 *  @param pwd 登录密码
 */
+ (void)savePassword:(NSString *)pwd;

/**
 *  保存登录用户信息
 *
 *  @param userinfoDic 登录用户信息
 */
+ (void)saveUserInfo:(NSDictionary *)userinfoDic;

/**
 *  获取已登录用户信息
 *
 */
+ (NSDictionary*)userInfo;

/**
 *  清除用户登录个人信息的保存记录
 *
 */
+ (void)clearLoginInfo;

/**
 *  清除登录账号和密码的保存记录
 */

+ (void)clearLoginUser;

/**
 *  获取本地存储的应用版本号
 *  @return localVersion
 */
+ (NSString *)localVersion;

/**
 *  保存应用最新版本号
 *
 *  @param currentVersion 当前最新APP版本号
 */
+ (void)saveVersion:(NSString *)currentVersion;

/**
 * 保存支付密码
 * @param payPassword 支付密码
 */
+ (void)savePayPassword:(NSString *)payPassword;
/**
 * 获取本地储存支付密码
 */
+ (NSString *)payPassword;

/**
 * 保存手势密码
 * @param gestureLock 手势密码
 */
+ (void)saveGestureLock:(NSString *)gestureLock;
/**
 * 获取本地储存手势密码
 */
+ (NSString *)gestureLock;

/**
 * 是否开启手势密码
 * @param isOpen 是否开启
 */
+ (void)saveIsOpenGestureLock:(BOOL)isOpen;
/**
 * 获取是否开启手势密码
 */
+ (BOOL)isOpenGestureLock;

/**
 * 是否开启指纹密码
 * @param isOpen 是否开启
 */
+ (void)saveIsOpenFingerprintPassword:(BOOL)isOpen;
/**
 * 获取是否开启指纹密码
 */
+ (BOOL)isOpenFingerprintPassword;



@end
