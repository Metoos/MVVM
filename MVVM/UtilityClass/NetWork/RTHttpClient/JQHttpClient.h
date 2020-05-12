//
//  JQHttpClient.h
//  net
//
//  Created by zjq on 2017/6/11.
//  Copyright © 2017年 zjq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "APIConfig.h"

//HTTP REQUEST METHOD TYPE
typedef NS_ENUM(NSInteger, JQHttpRequestType) {
    JQHttpRequestGet,
    JQHttpRequestPost,
    JQHttpRequestPostString,
    JQHttpRequestDelete,
    JQHttpRequestPut,
};

//成功回调
typedef void  (^ _Nullable successBlock)(NSString * _Nullable status);

/**
 *  请求开始前预处理Block
 */
typedef void(^ _Nullable PrepareExecuteBlock)(void);

/****************   JQHttpClient   ****************/
@interface JQHttpClient : NSObject

+ (JQHttpClient * _Nonnull)defaultClient;


//取消所有请求线程队列
- (void)cancelAllOperations;
/**
 *  经过处理的HTTP请求（GET、POST、DELETE、PUT）
 *
 *  @param url        请求地址
 *  @param method     请求类型
 *  @param parameters 请求参数
 *  @param prepareExecute    请求前预处理块
 *  @param success    请求成功处理块
 *  @param failure    请求失败处理块
 */
- (void)requestWithPath:(NSString * _Nullable)url
                method:(JQHttpRequestType)method
            parameters:(id _Nullable)parameters
        prepareExecute:(PrepareExecuteBlock) prepareExecute
               success:(void (^ _Nullable)(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject))success
               failure:(void (^ _Nullable)(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error))failure;


/**
 *  简单HTTP请求（GET、POST、DELETE、PUT）
 *
 *  @param url        请求地址
 *  @param method     RESTFul请求类型
 *  @param parameters 请求参数
 *  @param prepareExecute    请求前预处理块
 *  @param success    请求成功处理块
 *  @param failure    请求失败处理块
 */
- (void)requestSimpleWithPath:(NSString *_Nullable)url
                       method:(JQHttpRequestType)method
                   parameters:(id _Nullable )parameters
               prepareExecute:(PrepareExecuteBlock)prepareExecute
                      success:(void (^_Nullable)(NSURLSessionDataTask * _Nullable, id _Nullable))success
                      failure:(void (^_Nullable)(NSURLSessionDataTask * _Nullable, NSError * _Nullable))failure;
/**
 *  系统原生POST请求
 *
 *  @param url        请求地址
 *  @param parameters 请求参数
 *  @param prepareExecute    请求前预处理块
 *  @param success    请求成功处理块
 *  @param failure    请求失败处理块
 **/
- (void)postRequestWithPath:(NSString * _Nullable)url
                 parameters:(id _Nullable)parameters
             prepareExecute:(PrepareExecuteBlock) prepareExecute
                    success:(void (^ _Nullable)(NSURLResponse * _Nullable response , id _Nullable responseObject))success
                    failure:(void (^ _Nullable)(NSURLResponse * _Nullable response, NSError *_Nullable error))failure;

/**
 *  系统原生GET请求
 *
 *  @param url               请求地址
 *  @param parameters        请求参数
 *  @param prepareExecute    请求前预处理块
 *  @param success           请求成功处理块
 *  @param failure           请求失败处理块
 **/
- (void)GetRequestWithPath:(NSString * _Nullable)url
                parameters:(id _Nullable)parameters
            prepareExecute:(PrepareExecuteBlock) prepareExecute
                   success:(void (^_Nullable)(NSURLResponse * _Nullable response, id _Nullable responseObject))success
                   failure:(void (^_Nullable)(NSURLResponse * _Nullable response, NSError * _Nullable error))failure;
/**
 *  HTTP请求（HEAD）
 *
 */
- (void)requestWithPathInHEAD:(NSString *_Nullable)url
                  parameters:(NSDictionary *_Nullable)parameters
                      inView:(UIView *_Nullable)view
                     success:(void (^_Nullable)(NSURLSessionDataTask *_Nullable task))success
                     failure:(void (^_Nullable)(NSURLSessionDataTask *_Nullable task, NSError * _Nullable error))failure;

//判断当前网络状态
//- (BOOL)isConnectionAvailable;

- (void)connectionAvailablewithSuccessBlock:(successBlock)success;



@end
