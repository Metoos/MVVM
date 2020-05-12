//
//  UIView+Utils.m
//  FirstRankRice
//
//  Created by zjq on 2018/9/8.
//  Copyright © 2018年 hdyg. All rights reserved.
//

#import "UIView+Utils.h"

@implementation UIView (Utils)

-(void)setSetCornerRadius:(CGFloat)setCornerRadius
{
    self.layer.cornerRadius = setCornerRadius;
}

- (CGFloat)setCornerRadius
{
    return self.layer.cornerRadius;
}
- (void)setSetMasksToBounds:(BOOL)setMasksToBounds
{
    self.layer.masksToBounds = setMasksToBounds;
}
- (BOOL)setMasksToBounds
{
    return self.layer.masksToBounds;
}

-(void)setSetBorderWidth:(CGFloat)setBorderWidth
{
    self.layer.borderWidth = setBorderWidth;
}
-(CGFloat)setBorderWidth
{
    return self.layer.borderWidth;
}

- (void)setSetBorderColor:(UIColor *)setBorderColor
{
    self.layer.borderColor = setBorderColor.CGColor;
}
- (UIColor *)setBorderColor
{
    return [UIColor colorWithCGColor:self.layer.borderColor];
}


- (UIView*)subViewOfClassName:(NSString*)className {
    
    for (UIView* subView in self.subviews) {
        if ([NSStringFromClass(subView.class) isEqualToString:className]) {
            return subView;
        }
        UIView* resultFound = [subView subViewOfClassName:className];
        if (resultFound) {
            return resultFound;
        }
    }
    return nil;
}



/*
 周边加阴影，并且同时圆角
 */
- (void)shadowWithOpacity:(float)shadowOpacity
           shadowRadius:(CGFloat)shadowRadius
             shadowOffset:(CGSize)shadowOffset
            shadowColor:(UIColor*)shadowColor
        andCornerRadius:(CGFloat)cornerRadius
{
    //////// shadow /////////
    CALayer *shadowLayer = [CALayer layer];
    shadowLayer.frame = self.layer.frame;
    
    shadowLayer.shadowColor = shadowColor.CGColor;//shadowColor阴影颜色
    shadowLayer.shadowOffset = shadowOffset;//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    shadowLayer.shadowOpacity = shadowOpacity;//0.8;//阴影透明度，默认0
    shadowLayer.shadowRadius = shadowRadius;//8;//阴影半径，默认3
    //路径阴影
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    float width = shadowLayer.bounds.size.width;
    float height = shadowLayer.bounds.size.height;
    float x = shadowLayer.bounds.origin.x;
    float y = shadowLayer.bounds.origin.y;
    
    CGPoint topLeft      = shadowLayer.bounds.origin;
    CGPoint topRight     = CGPointMake(x + width, y);
    CGPoint bottomRight  = CGPointMake(x + width, y + height);
    CGPoint bottomLeft   = CGPointMake(x, y + height);
    
    CGFloat offset = -1.f;
    [path moveToPoint:CGPointMake(topLeft.x - offset, topLeft.y + cornerRadius)];
    [path addArcWithCenter:CGPointMake(topLeft.x + cornerRadius, topLeft.y + cornerRadius) radius:(cornerRadius + offset) startAngle:M_PI endAngle:M_PI_2 * 3 clockwise:YES];
    [path addLineToPoint:CGPointMake(topRight.x - cornerRadius, topRight.y - offset)];
    [path addArcWithCenter:CGPointMake(topRight.x - cornerRadius, topRight.y + cornerRadius) radius:(cornerRadius + offset) startAngle:M_PI_2 * 3 endAngle:M_PI * 2 clockwise:YES];
    [path addLineToPoint:CGPointMake(bottomRight.x + offset, bottomRight.y - cornerRadius)];
    [path addArcWithCenter:CGPointMake(bottomRight.x - cornerRadius, bottomRight.y - cornerRadius) radius:(cornerRadius + offset) startAngle:0 endAngle:M_PI_2 clockwise:YES];
    [path addLineToPoint:CGPointMake(bottomLeft.x + cornerRadius, bottomLeft.y + offset)];
    [path addArcWithCenter:CGPointMake(bottomLeft.x + cornerRadius, bottomLeft.y - cornerRadius) radius:(cornerRadius + offset) startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    [path addLineToPoint:CGPointMake(topLeft.x - offset, topLeft.y + cornerRadius)];
    //设置阴影路径
    shadowLayer.shadowPath = path.CGPath;
    //////// cornerRadius /////////
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    [self.superview.layer insertSublayer:shadowLayer below:self.layer];
}

@end
