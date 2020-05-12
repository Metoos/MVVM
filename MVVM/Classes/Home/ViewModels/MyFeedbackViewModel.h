//
//  MyFeedbackViewModel.h
//  KuangJinApp
//
//  Created by life on 2020/1/7.
//  Copyright © 2020 jingdu. All rights reserved.
//

#import "JQBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,MyFeedbackType) {
    MyFeedbackTypeCommon = 0,
    MyFeedbackTypeBlockchainOrder
};

@interface MyFeedbackViewModel : JQBaseViewModel

//联系
@property (strong, nonatomic) NSString *contact;
//反馈内容
@property (strong, nonatomic) NSString *content;

//已选图片总数
@property (assign, nonatomic) NSInteger count;

//已选图片上传完全得到的url
@property (strong, nonatomic) NSArray *imagesUrl;

//申诉类型
@property (nonatomic,assign) MyFeedbackType type;

//业务相关参数
@property (nonatomic,copy) NSDictionary *extraParameter;

@end

NS_ASSUME_NONNULL_END
