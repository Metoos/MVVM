//
//  JQBaseViewModelProtocol.h
//  BBA
//
//  Created by life on 2018/1/24.
//  Copyright © 2018年 hdyg. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JQBaseViewModelProtocol <NSObject>

@optional

/* viewModel初始化的时候默认做一些初始化操作 */
- (void)jq_initialize;

/* 扩展 */
- (void)jq_setupBinding;

/*  请求数据*/
- (void)jq_sendDataRequest:(void(^)(id entity))succeedBlock
                   failure:(void(^)(NSUInteger errCode,NSString *errorMsg))failBlock;

@end
