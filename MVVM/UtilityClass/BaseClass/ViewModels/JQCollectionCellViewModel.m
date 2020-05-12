//
//  JQCollectionCellViewModel.m
//  BBA
//
//  Created by life on 2018/3/1.
//  Copyright © 2018年 hdyg. All rights reserved.
//

#import "JQCollectionCellViewModel.h"
@interface JQCollectionCellViewModel ()

@property (nonatomic,strong,nullable) id entity;

@end

@implementation JQCollectionCellViewModel

- (instancetype)initWithEntity:(nullable id)entity
{
    self = [super init];
    if (self) {
        _entity = entity;
        _cellSelectedSignal = [RACSubject subject];
    }
    return self;
}

// cellViewModel来计算高度，通过带返回值的Block，从上层数据拿高度
- (CGSize)cacheCellSizeWithCalculateBlock:(JQCollectionCellViewModelSizeCalculateBlock)calculateSizeBlock
{
    
    if (self.itmeSize.width == 0.0f && self.itmeSize.height == 0.0f) {
        self.itmeSize = calculateSizeBlock();
    }
    return self.itmeSize;
}


@end
