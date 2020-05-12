//
//  HomeModel.h
//  TongLian
//
//  Created by life on 2018/2/27.
//  Copyright © 2018年 hdyg. All rights reserved.
//

#import "JQBaseRequest.h"
@interface HomeRequest : JQBaseRequest


/** 刷新首页数据
 * @param parameters 参数列表
 */
+ (RACSignal *)requestRefreshWithParameters:(NSDictionary *)parameters;


@end
