//
//  JQBaseView.h
//  BBA
//
//  Created by life on 2018/1/24.
//  Copyright © 2018年 hdyg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JQBaseViewModel.h"
@interface JQBaseView : UIView

@property (nonatomic,strong,readonly) JQBaseViewModel *viewModel;

- (instancetype)initWithFrame:(CGRect)frame viewModel:(JQBaseViewModel *)viewModel;
- (instancetype)initWithViewModel:(JQBaseViewModel *)viewModel;




/**
 绑定
 */
- (void)jq_setupBinding;
/**
 处理数据回调
 */
- (void)jq_setupData;
/**
 布局UI
 */
- (void)jq_setupViewLayout;

@end
