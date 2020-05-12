//
//  JQBaseViewModel.h
//  BBA
//
//  Created by life on 2018/1/24.
//  Copyright © 2018年 hdyg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JQBaseViewModelProtocol.h"
typedef void(^AFMRequestSucceed)(id entity);
typedef void(^AFMRequestFailure)(NSUInteger errCode,NSString *errorMsg);


@interface JQBaseViewModel : NSObject<JQBaseViewModelProtocol>


/**
 请求回调的公共属性
 */
@property (nonatomic,assign,readonly) BOOL isSucceed;
@property (nonatomic,copy,readonly) NSString *message;
@property (nonatomic,copy,readonly) NSString *resultCode;


/**
 扩展字段
 */
@property (nonatomic,copy,readonly) NSString *title;


@end
