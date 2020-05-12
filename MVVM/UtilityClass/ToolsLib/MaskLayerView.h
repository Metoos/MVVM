//
//  MaskLayerView.h
//  ZongShengTrainVideo
//
//  Created by zjq on 2017/6/12.
//  Copyright © 2017年 zjq. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickBlock)(void);

@interface MaskLayerView : UIView
/**
 * 初始化遮罩层
 * @param backgroundColor 背景颜色
 * @param alpha           遮罩层透明度
 * @param clickBlock      遮罩层点击事件回调
 */


-(instancetype)initWithBackgroundColor:(UIColor *)backgroundColor Alpha:(CGFloat)alpha  ClickBlock:(ClickBlock)clickBlock;
@property (nonatomic) BOOL canToushBg;
- (void)ClickBlock:(ClickBlock)clickBlock;

- (void)showWithTarget:(id)target;
- (void)showWithView:(UIView *)view;
- (void)showWithView:(UIView *)view WithInRect:(CGRect)rect;
- (void)showWithView:(UIView *)view WithInPoint:(CGPoint)point;
- (void)dismissMaskLayerView;

@end
