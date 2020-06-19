//
//  JQBaseCollectionViewCell.m
//  BBA
//
//  Created by life on 2018/3/1.
//  Copyright © 2018年 hdyg. All rights reserved.
//

#import "JQBaseCollectionViewCell.h"
@interface JQBaseCollectionViewCell ()
@property (nonatomic,strong) JQCollectionCellViewModel *viewModel;
/**
 cell中按钮点击的信号量监听
 */
@property (nonatomic,strong) RACSubject *cellButtonsSignal;


@property (nonatomic,strong) NSIndexPath *indexPath;

@end
@implementation JQBaseCollectionViewCell
+ (instancetype)itemForCollectionView:(UICollectionView *)collectionView
                         forIndexPath:(NSIndexPath *)indexPath
                            viewModel:(JQCollectionCellViewModel *)viewModel
{
    NSString *identify = NSStringFromClass([self class]);
    JQBaseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    cell.viewModel = viewModel;

  
    [cell jq_setupData];
    return cell;
}

//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//
//        [self jq_setupViewLayout];
//        [self jq_setupBinding];
//    }
//    return self;
//}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self jq_setupViewLayout];
    [self jq_setupBinding];
}

// cell里面实现，通过viewModel去存储数据，高度由这个Block返回给ViewModel保存起来
+ (CGSize)calculateItemSizeWithViewModel:(JQCollectionCellViewModel *)viewModel
{
    return CGSizeZero;
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
