//
//  City.m
//  JQ
//
//  Created by life on 2016/2/27.
//  Copyright © 2016年 life. All rights reserved.
//

#import "City.h"

@implementation City

- (instancetype)initWithName:(NSString *)name
                       areas:(NSArray *)areas{
    if (self = [super init]) {
        _cityName = name;
        _areas = areas;
    }
    return self;
}

+ (instancetype)cityWithName:(NSString *)cityName
                       areas:(NSArray *)areas{
    City * city = [[City alloc]initWithName:cityName
                                      areas:areas];
    return city;
}

@end
