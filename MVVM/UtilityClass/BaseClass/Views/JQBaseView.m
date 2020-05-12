//
//  JQBaseView.m
//  BBA
//
//  Created by life on 2018/1/24.
//  Copyright © 2018年 hdyg. All rights reserved.
//

#import "JQBaseView.h"
@interface JQBaseView ()

@property (nonatomic,strong) JQBaseViewModel *viewModel;

@end
@implementation JQBaseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self jq_setupViewLayout];
        [self jq_setupBinding];
        [self jq_setupData];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame viewModel:(JQBaseViewModel *)viewModel
{
    self = [super initWithFrame:frame];
    if (self) {
        _viewModel = viewModel;
        [self jq_setupViewLayout];
//        [self jq_setupBinding];
        [self jq_setupData];
    }
    return self;
}
- (instancetype)initWithViewModel:(JQBaseViewModel *)viewModel
{
    self = [super init];
    if (self) {
        _viewModel = viewModel;
        [self jq_setupViewLayout];
//        [self jq_setupBinding];
        [self jq_setupData];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self jq_setupViewLayout];
//        [self jq_setupBinding];
        [self jq_setupData];
    }
    return self;
}

/**
 布局UI
 */
- (void)jq_setupViewLayout
{
    
}
/**
 绑定
 */
- (void)jq_setupBinding
{
    
}
/**
 处理数据回调
 */
- (void)jq_setupData
{
    
}


@end
