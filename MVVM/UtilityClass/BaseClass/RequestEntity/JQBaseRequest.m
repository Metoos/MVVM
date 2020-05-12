//
//  JQBaseRequest.m
//  BBA
//
//  Created by life on 2018/1/24.
//  Copyright © 2018年 hdyg. All rights reserved.
//

#import "JQBaseRequest.h"
#import "JQHttpClient.h"
#import "JQBaseModel.h"
#import <NSDictionary+JQExtension.h>
@interface JQBaseRequest ()

@end

@implementation JQBaseRequest

+ (RACSignal *)requestWithParameters:(NSDictionary *)parameters
                   parserEntityClass:(Class)parseEntityClass
{
    
    return [self requestWithURLString:SERVER_HOST parameters:parameters parserEntityClass:parseEntityClass];
}

+ (RACSignal *)requestWithURLString:(NSString *)urlString
                         parameters:(NSDictionary *)parameters
                  parserEntityClass:(Class)parseEntityClass
{
    
    //处理接口请求全局统一参数
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:(NSDictionary *)parameters copyItems:YES];
    //添加程序当前语言环境
    NSString *language = [[JQLanguageTool sharedInstance] currentLanguage];
    NSString *lang = [self systemLanguageConverAPILanguageString:language];
    //时间戳
    NSString *timestamp = [UniversalManager getSyetemTimeInterval];
    
    dic.addObjectSupplementForKey(@"lang",lang)
    .addObjectSupplementForKey(@"appToken",[UniversalManager getToken])
    .addObjectSupplementForKey(@"timestamp",timestamp);//在参数中添加时间戳和签名字段
    NSString *sign = [UniversalManager md5EncryptStrWithParam:dic];
    dic.addObjectSupplementForKey(@"sign",sign);
    
    
    NSString *pageString = [dic objectForKey:@"page"];
//    if (![urlString isEqualToString:API_LOGIN] || ![urlString isEqualToString:API_REGISTER] || ![urlString isEqualToString:API_SET_NEWPASSWORD]) {
//        dic.addObjectSupplementForKey(@"appToken",[UniversalManager getToken])
//    }
    parameters = dic;
    
    // 根据异步请求创建一个新的RACSinal
    WEAKIFY
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        STRONGIFY;
        
        [[JQHttpClient defaultClient] requestWithPath:urlString method:JQHttpRequestPostString parameters:parameters prepareExecute:nil success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
            NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            DLog(@"responseObject = %@",str);
            JQBaseModel *model = [JQBaseModel mj_objectWithKeyValues:responseObject];
            if (model.code == successed) {
                id entityClass = nil;
                SEL sel = NSSelectorFromString(@"parserEntityWithObject:");
                if (parseEntityClass && [parseEntityClass respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wformat"
                    entityClass = [parseEntityClass performSelector:sel withObject:responseObject];
#pragma clang diagnostic pop
                    if (pageString && ![[NSString content:pageString] isEqualToString:@""]) {
                        ((JQBaseModel *)entityClass).currentPage = pageString.integerValue;
                    }
                }else
                {
                    entityClass = responseObject;
                }
                [subscriber sendNext:entityClass];
                [subscriber sendCompleted];
            }else
            {
                NSError *error = [NSError errorWithDomain:JQCommandErrorDomain code:model.code userInfo:@{JQCommandErrorUserInfoKey:model.message?:TEXT_SERVER_NOT_RESPOND}];
                [subscriber sendError:error];
            
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
            DLog(@"error = %@",error);
            NSError *errors = [NSError errorWithDomain:JQCommandErrorDomain code:JQCommandErrorCode userInfo:@{JQCommandErrorUserInfoKey:TEXT_SERVER_NOT_RESPOND}];
            /// 失败的回调
            [subscriber sendError:errors];
        
        }];
        
        return nil;
    }];
    
}

#pragma mark -  系统语言名称字符串转换成接口的语言表示字符串
+ (NSString *)systemLanguageConverAPILanguageString:(NSString *)systemLanguage
{
    
    if ([systemLanguage hasPrefix:@"zh"]) {
        return @"zh_CN";
    }else if ([systemLanguage hasPrefix:@"en"]) {
        return @"en_US";
    }else if ([systemLanguage hasPrefix:@"ja"]) {
        return @"ja_JP";
    }else if ([systemLanguage hasPrefix:@"ko"]) {
        return @"ko_KP";
    }else if ([systemLanguage hasPrefix:@"ru"]) {
        return @"ru_RU";
    }
    return systemLanguage;
}

@end
