//
//  HomeRequest.m
//  TongLian
//
//  Created by life on 2018/2/27.
//  Copyright © 2018年 hdyg. All rights reserved.
//

#import "HomeRequest.h"
#import "JQBaseModel.h"
#import "HomeModel.h"
@implementation HomeRequest


/** 刷新首页数据
 * @param parameters 参数列表
 */
+ (RACSignal *)requestRefreshWithParameters:(NSDictionary *)parameters
{
    
    return [self requestWithURLString:API_REFRESH parameters:parameters parserEntityClass:HomeModel.class];
}




@end
