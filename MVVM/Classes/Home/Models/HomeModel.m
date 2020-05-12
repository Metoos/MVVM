//
//  HomeModel.m
//  TongLian
//
//  Created by life on 2018/2/26.
//  Copyright © 2018年 hdyg. All rights reserved.
//

#import "HomeModel.h"

@implementation HomeModel

- (void)setData:(HomeDataEntity *)data
{
    _data = data;
    if ([data isKindOfClass:NSDictionary.class]) {
        _data = [HomeDataEntity mj_objectWithKeyValues:data];
    }
    
}

@end

@implementation HomeDataEntity


@end


