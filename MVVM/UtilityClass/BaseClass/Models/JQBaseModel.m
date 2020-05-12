//
//  JQBaseModel.m
//  BBA
//
//  Created by life on 2018/1/24.
//  Copyright © 2018年 hdyg. All rights reserved.
//

#import "JQBaseModel.h"
#import <MJExtension/MJExtension.h>
@implementation JQBaseModel


+ (instancetype)parserEntityWithObject:(id)Object
{
    if (!Object || ![Object isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    return [self mj_objectWithKeyValues:Object];
}

@end
