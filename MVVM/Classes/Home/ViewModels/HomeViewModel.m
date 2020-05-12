//
//  HomeViewModel.m
//  TongLian
//
//  Created by life on 2018/2/27.
//  Copyright © 2018年 hdyg. All rights reserved.
//

#import "HomeViewModel.h"
#import "HomeModel.h"
#import "HomeRequest.h"
#import "HomeCellViewModel.h"
@interface HomeViewModel ()

@end

@implementation HomeViewModel

- (void)jq_sendDataRequest:(void (^)(id entity))succeedBlock
                   failure:(void (^)(NSUInteger errorCode, NSString *errorMsg))failBlock
{
    //    if ([[UniversalManager isBlankString:self.password] isEqualToString:@""]) {
    //        failBlock(0,JQGetStringWithKeyFromTable(@"请输入",nil));
    //        return;
    //    }
    
    
    //模拟处理接口返回数据
    NSMutableArray *ary = [[NSMutableArray alloc]init];
    for (int i = 0; i<50; i++) {
        HomeModel *model = [[HomeModel alloc]init];
        model.title = [[NSString alloc]initWithFormat:@"abcdd---%d",i];
        model.isSms = i==1?@"1":@"0";
        [ary addObject:model];
    }
    //将model数组转换为cellViewModel数组
    //单页数据处理
    //    [self handleMutableArrayEntites:ary cellViewModelClass:HomeCellViewModel.class];
    //分页数据处理
    [self handlePagingEntities:ary dataPage:[self.currentPage integerValue] totalCount:@(MAXFLOAT) cellViewModelClass:HomeCellViewModel.class];
    
    //测试数据
    !succeedBlock?:succeedBlock(nil);
    
    return; //模拟数据逻辑
    
    
    
    //请求数据
    RACSignal *signal = [HomeRequest requestRefreshWithParameters:kDic
                         .addObjectSupplementForKey(@"page",@"1")
                         .addObjectSupplementForKey(@"userid",@"1001")];
    RACMulticastConnection *connection = [signal multicast:[RACReplaySubject subject]];
    [connection connect];
    [connection.signal subscribeNext:^(id data) {
        JQBaseModel *entity = data;
        
        //将model数组转换为cellViewModel数组
        //单页数据处理
        //    [self handleMutableArrayEntites:entity.ary cellViewModelClass:HomeCellViewModel.class];
        //分页数据处理
        //            [self handlePagingEntities:ary dataPage:[self.currentPage integerValue] totalCount:@(MAXFLOAT) cellViewModelClass:HomeCellViewModel.class];
        
        
        !succeedBlock?:succeedBlock(entity.message);
    }];
    //获取数据失败结果信号量订阅
    [connection.signal subscribeError:^(NSError * _Nullable error) {
        if ([error.domain isEqualToString:JQCommandErrorDomain]) {
            !failBlock?:failBlock(error.code,error.userInfo[JQCommandErrorUserInfoKey]);
        }
    }];
}

- (NSInteger)numberOfRowInSection:(NSInteger)section
{
    return self.cellViewModels.count;
}

- (JQTableViewCellViewModel *)cellViewModelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.cellViewModels[indexPath.row];
}



@end
