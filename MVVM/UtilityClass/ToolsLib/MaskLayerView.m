//
//  MaskLayerView.m
//  ZongShengTrainVideo
//
//  Created by zjq on 2017/6/12.
//  Copyright © 2017年 zjq. All rights reserved.
//

#import "MaskLayerView.h"
@interface MaskLayerView()


@property (weak, nonatomic) id target;
@property (strong, nonatomic) ClickBlock clickBlock;
@end

@implementation MaskLayerView

-(instancetype)initWithBackgroundColor:(UIColor *)backgroundColor Alpha:(CGFloat)alpha ClickBlock:(ClickBlock)clickBlock{
    self = [super init];
    if (self) {
        
        self.backgroundColor = backgroundColor;
        self.alpha = alpha;
        self.canToushBg = YES;
        self.clickBlock = clickBlock;
        [self setView];
    }
    return  self;
}

- (void)setView{
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
    
    
}
- (void)ClickBlock:(ClickBlock)clickBlock
{
    self.clickBlock = clickBlock;
}


- (void)setCanToushBg:(BOOL)canToushBg
{
    _canToushBg = canToushBg;
    
}
- (void)tapView{
    
    if (self.canToushBg) {
        
        if (self.clickBlock) {
            self.clickBlock();
        }
        [self dismissMaskLayerView];
    }
    
}

- (void)dismissMaskLayerView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        [self removeFromSuperview];
        self.alpha = 1.0f;
    }];
}

- (void)showWithTarget:(id)target{
    if ([self.target isKindOfClass:[UIViewController class]]) {
        UIViewController *ctrl = (UIViewController*)self.target;
        self.frame = ctrl.view.bounds;
        [ctrl.view addSubview:self];
    }else if ([self.target isKindOfClass:[UIView class]]) {
        UIView *view = (UIView*)self.target;
        self.frame = view.bounds;
        [view addSubview:self];
    }

}
- (void)showWithView:(UIView *)view{
    
    [self showWithView:view WithInRect:view.bounds];
    
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    self.frame = window.bounds;
//    [window addSubview:self];
//    [self addSubview:view];
//    WEAKIFY;
//    [view mas_makeConstraints:^(MASConstraintMaker *make) {
//        STRONGIFY;
//        make.bottom.and.left.right.equalTo(self);
//        make.height.mas_equalTo(@215);
//    }];
}

- (void)showWithView:(UIView *)view WithInRect:(CGRect)rect{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.frame = window.bounds;
    [window addSubview:self];
    view.frame = rect;
    [self addSubview:view];
}

- (void)showWithView:(UIView *)view WithInPoint:(CGPoint)point{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.frame = window.bounds;
    [window addSubview:self];
    view.x = point.x;
    view.y = point.y;
    [self addSubview:view];
}



@end
