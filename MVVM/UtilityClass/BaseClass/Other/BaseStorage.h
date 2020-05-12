//
//  BaseStorage.h
//  ManLiao
//
//  Created by Manloo on 15/12/4.
//  Copyright © 2015年 manloo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseStorage : NSObject

+(void)saveValue:(id) value forKey:(NSString *)key;

+(id)valueWithKey:(NSString *)key;
+(void)removeFromUserDefault : (NSString *)key;

+(BOOL)boolValueWithKey:(NSString *)key;

+(void)saveBoolValue:(BOOL)value withKey:(NSString *)key;

+(void)print;


+(void)saveValue:(id) value forPath:(NSString *)path;

+(NSDictionary*)dictionaryWithPath:(NSString *)path;

+(NSArray*)arrayWithPath:(NSString *)path;
@end
