//
//  JQBaseRequest.h
//  BBA
//
//  Created by life on 2018/1/24.
//  Copyright © 2018年 hdyg. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <ReactiveObjC/ReactiveObjC.h>
@interface JQBaseRequest : NSObject

/** 请求数据 并解析返回实体类 使用默认URL*/
+ (RACSignal *)requestWithParameters:(NSDictionary *)parameters
                  parserEntityClass:(Class)parseEntityClass;

/** 请求数据 并解析返回实体类 */
+ (RACSignal *)requestWithURLString:(NSString *)urlString
                         parameters:(NSDictionary *)parameters
                  parserEntityClass:(Class)parseEntityClass;


@end
