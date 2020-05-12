//
//  JQBaseTableViewCell.m
//  BBA
//
//  Created by life on 2018/1/24.
//  Copyright © 2018年 hdyg. All rights reserved.
//

#import "JQBaseTableViewCell.h"
@interface JQBaseTableViewCell ()
@property (nonatomic,strong) JQTableViewCellViewModel *viewModel;

/**
 cell中按钮点击的信号量监听
 */
@property (nonatomic,strong) RACSubject *cellButtonsSignal;

@end
@implementation JQBaseTableViewCell


+ (instancetype)cellForTableView:(UITableView *)tableView viewModel:(JQTableViewCellViewModel *)viewModel
{
    NSString *identify = NSStringFromClass([self class]);
    JQBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        [cell jq_setupViewLayout];
      
    }
    cell.viewModel = viewModel;
    
    [cell jq_setupData];
    
    return cell;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self jq_setupBinding];
}

// cell里面实现，通过viewModel去存储数据，高度由这个Block返回给ViewModel保存起来
+ (NSNumber *)calculateRowHeightWithViewModel:(JQTableViewCellViewModel *)viewModel
{
    return nil;
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
/**
 布局UI
 */
- (void)jq_setupViewLayout
{
    
}

- (RACSubject *)cellButtonsSignal
{
    if (!_cellButtonsSignal) {
         _cellButtonsSignal = [RACSubject subject];
    }
    return _cellButtonsSignal;
}

@end
