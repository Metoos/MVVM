//
//  BaseStorage.m
//  ManLiao
//
//  Created by Manloo on 15/12/4.
//  Copyright © 2015年 manloo. All rights reserved.
//

#import "BaseStorage.h"

@implementation BaseStorage

+(void)saveValue:(id) value forKey:(NSString *)key{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:value forKey:key];
    [userDefaults synchronize];
}

+(id)valueWithKey:(NSString *)key{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:key];
}
+(void)removeFromUserDefault : (NSString *)key{
    //创建user default, 持久化
    NSUserDefaults *standardUserDefault = [NSUserDefaults standardUserDefaults];
    [standardUserDefault removeObjectForKey:key];
}
+(BOOL)boolValueWithKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:key];
}

+(void)saveBoolValue:(BOOL)value withKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:value forKey:key];
    [userDefaults synchronize];
}

+(void)print{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [userDefaults dictionaryRepresentation];
    DLog(@"%@",dic);
}


+(void)saveValue:(id) value forPath:(NSString *)path
{
    NSString *newPath = [self getDocumentsPathWithPath:path];
    DLog(@"path = %@",newPath);
    [value writeToFile:newPath atomically:YES];
    
    
}

+(NSDictionary*)dictionaryWithPath:(NSString *)path
{
    NSString *newPath = [self getDocumentsPathWithPath:path];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:newPath];
    
    return dic;
}

+(NSArray*)arrayWithPath:(NSString *)path
{
    NSString *newPath = [self getDocumentsPathWithPath:path];
    NSArray *ary = [NSArray arrayWithContentsOfFile:newPath];
    
    return ary;
}

+ (NSString*)getDocumentsPathWithPath:(NSString *)path
{
    NSString *basePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *newPath = [[NSString alloc] initWithFormat:@"%@/%@",basePath,path];
    
    return newPath;
}
@end
