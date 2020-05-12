//
//  JQTableViewCellViewModel.m
//  BBA
//
//  Created by life on 2018/1/24.
//  Copyright © 2018年 hdyg. All rights reserved.
//

#import "JQTableViewCellViewModel.h"

@interface JQTableViewCellViewModel ()

@property (nonatomic,strong,nullable) id entity;

@end


@implementation JQTableViewCellViewModel

- (instancetype)initWithEntity:(nullable id)entity
{
    self = [super init];
    if (self) {
        _entity = entity;
    }
    return self;
}

// cellViewModel来计算高度，通过带返回值的Block，从上层数据拿高度
- (NSNumber *)cacheCellHeightWithCalculateBlock:(JQTableCellViewModelHeightCalculateBlock)calculateHeightBlock
{
    if (!self.rowHeight) {
        self.rowHeight = calculateHeightBlock();
    }
    return self.rowHeight;
}



@end
