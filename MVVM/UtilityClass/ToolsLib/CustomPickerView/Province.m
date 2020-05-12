//
//  Province.m
//  JQ
//
//  Created by life on 2016/2/27.
//  Copyright © 2016年 life. All rights reserved.
//

#import "Province.h"


@implementation Province

// 成员方法创建
- (instancetype)initWithName:(NSString *)name
                      cities:(NSArray *)cities
{
    if (self = [super init]) {
        _name = name;
        _cities = cities;
    }
    
    return self;
}

// 类方法创建
+ (instancetype)provinceWithName:(NSString *)name
                          cities:(NSArray *)cities{
    Province *p = [[Province alloc] initWithName:name
                                          cities:cities];
    return p;
}



@end
