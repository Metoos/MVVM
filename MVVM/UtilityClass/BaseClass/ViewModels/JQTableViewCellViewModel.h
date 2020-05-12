//
//  JQTableViewCellViewModel.h
//  BBA
//
//  Created by life on 2018/1/24.
//  Copyright © 2018年 hdyg. All rights reserved.
//

#import "JQBaseViewModel.h"
#import <ReactiveObjC/ReactiveObjC.h>
typedef NSNumber * _Nonnull (^JQTableCellViewModelHeightCalculateBlock)(void);

@interface JQTableViewCellViewModel : JQBaseViewModel

@property (nonatomic,strong,readonly,nullable) id entity; // cellViewModel会绑定一个entity实例对象

@property (nonatomic,strong,nullable) NSNumber *rowHeight; // 每个cellViewModel里面有一个实体，然后还有一个字段计算高度，缓存

// cellViewModel的初始化
- (nullable instancetype)initWithEntity:(nullable id)entity;

//其他参数
@property (nonatomic,nullable) id object;


- (NSNumber *_Nonnull)cacheCellHeightWithCalculateBlock:(_Nonnull JQTableCellViewModelHeightCalculateBlock)calculateHeightBlock;

@end
