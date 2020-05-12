//
//  JQBaseModel.h
//  BBA
//
//  Created by life on 2018/1/24.
//  Copyright © 2018年 hdyg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JQBaseModel : NSObject

/** 接口返回的状态信息 **/
@property (nonatomic, copy) NSString *message;
/** 请求结果状态码 **/
@property (nonatomic, assign) NSInteger code;
/**当前请求的页码*/
@property (nonatomic, assign) NSUInteger currentPage;

+ (instancetype)parserEntityWithObject:(id)Object;

@end
