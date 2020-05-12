//
//  JQBaseViewModel.m
//  BBA
//
//  Created by life on 2018/1/24.
//  Copyright © 2018年 hdyg. All rights reserved.
//

#import "JQBaseViewModel.h"

@interface JQBaseViewModel ()

@property (nonatomic,assign) BOOL isSucceed;
@property (nonatomic,copy) NSString *message;
@property (nonatomic,copy) NSString *resultCode;
@property (nonatomic,copy) NSString *title;

@end

@implementation JQBaseViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self jq_initialize];
        [self jq_setupBinding];
    }
    return self;
}




#pragma mark - viewModel初始化的时候默认做一些初始化操作

- (void)jq_initialize
{
    // 子类实现
}

#pragma mark - 扩展
- (void)jq_setupBinding
{
    // 子类实现
}

- (void)jq_sendDataRequest:(void (^)(id))succeedBlock failure:(void (^)(NSUInteger, NSString *))failBlock
{
    // 子类实现数据请求
}

- (NSString *)title
{
    return nil;
}

@end
