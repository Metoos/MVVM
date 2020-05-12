//
//  UIView+Utils.h
//  FirstRankRice
//
//  Created by zjq on 2018/9/8.
//  Copyright © 2018年 hdyg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Utils)

@property (nonatomic) IBInspectable CGFloat setCornerRadius;
@property (nonatomic) IBInspectable BOOL    setMasksToBounds;
@property (nonatomic) IBInspectable CGFloat setBorderWidth;
@property (nonatomic) IBInspectable UIColor *setBorderColor;

- (UIView*)subViewOfClassName:(NSString*)className;

/*
 给View周边加阴影，并且同时圆角
 */
- (void)shadowWithOpacity:(float)shadowOpacity
             shadowRadius:(CGFloat)shadowRadius
             shadowOffset:(CGSize)shadowOffset
              shadowColor:(UIColor*)shadowColor
          andCornerRadius:(CGFloat)cornerRadius;

@end
