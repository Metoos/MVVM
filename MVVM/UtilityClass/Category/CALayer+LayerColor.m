//
//  CALayer+LayerColor.m
//  BBA
//
//  Created by life on 2018/3/20.
//  Copyright © 2018年 hdyg. All rights reserved.
//

#import "CALayer+LayerColor.h"

@implementation CALayer (LayerColor)


- (void)setBorderColorFromUIColor:(UIColor *)color
{
    self.borderColor = color.CGColor;
}

@end
