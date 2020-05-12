//
//  MyFeedbackViewModel.m
//  KuangJinApp
//
//  Created by life on 2020/1/7.
//  Copyright © 2020 jingdu. All rights reserved.
//

#import "MyFeedbackViewModel.h"
#import "HomeRequest.h"
@interface MyFeedbackViewModel()

@property (strong, nonatomic) NSString *urls;

@end

@implementation MyFeedbackViewModel

- (void)jq_sendDataRequest:(void (^)(id entity))succeedBlock
                   failure:(void (^)(NSUInteger errorCode, NSString *errorMsg))failBlock
{
    if ([[UniversalManager isBlankString:self.contact] isEqualToString:@""]) {
        failBlock(0,JQGetStringWithKeyFromTable(@"请输入联系方式",nil));
        return;
    }
    
    if ([[UniversalManager isBlankString:self.content] isEqualToString:@""]) {
        failBlock(0,JQGetStringWithKeyFromTable(@"请输入您的反馈理由",nil));
        return;
    }
    
    if (self.imagesUrl && (self.count != self.imagesUrl.count)) {
        failBlock(0,JQGetStringWithKeyFromTable(@"您选择的图片中还有没有上传成功，请重新上传或者删除该图片",nil));
        return;
    }

    RACSignal *signal = [JQBaseRequest requestWithParameters:kDic
                         .addObjectSupplementForKey(@"method",@"user.feedback")
                         .addObjectSupplementForKey(@"contact",self.contact)
                         .addObjectSupplementForKey(@"note",self.content)
                         .addObjectForKey(@"img",self.urls)
                                       parserEntityClass:JQBaseModel.class];
    
    RACMulticastConnection *connection = [signal multicast:[RACReplaySubject subject]];
    [connection connect];
    [connection.signal subscribeNext:^(id data) {
        JQBaseModel *entity = data;
        !succeedBlock?:succeedBlock(entity.message);
    }];
    //获取数据失败结果信号量订阅
    [connection.signal subscribeError:^(NSError * _Nullable error) {
        if ([error.domain isEqualToString:JQCommandErrorDomain]) {
            !failBlock?:failBlock(error.code,error.userInfo[JQCommandErrorUserInfoKey]);
        }
    }];
}

- (void)setImagesUrl:(NSArray *)imagesUrl
{
    _imagesUrl = imagesUrl;
    
    if (_imagesUrl) {
        [_imagesUrl enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            self.urls = [obj stringByAppendingFormat:@",%@",obj];
        }];
    }
}


@end
