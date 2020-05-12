//
//  JQCollectionCellViewModel.h
//  BBA
//
//  Created by life on 2018/3/1.
//  Copyright © 2018年 hdyg. All rights reserved.
//

#import "JQBaseViewModel.h"

typedef CGSize (^JQCollectionCellViewModelSizeCalculateBlock)(void);

@interface JQCollectionCellViewModel : JQBaseViewModel

@property (nonatomic,strong,readonly) id entity; // cellViewModel会绑定一个entity实例对象

@property (nonatomic,assign) CGSize itmeSize; // 每个cellViewModel里面有一个实体，然后还有一个字段计算itme大小，缓存

// cellViewModel的初始化
- (nullable instancetype)initWithEntity:(id)entity;

/**
 cell点击的信号量监听
 */
@property (nonatomic,strong) RACSubject *cellSelectedSignal;


//其他参数
@property (nonatomic,nullable) id object;

- (CGSize)cacheCellSizeWithCalculateBlock:(_Nonnull JQCollectionCellViewModelSizeCalculateBlock)calculateSizeBlock;

@end
