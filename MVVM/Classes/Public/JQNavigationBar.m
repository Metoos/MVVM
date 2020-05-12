//
//  JQNavigationBar.m
//  ZongShengTrainVideo
//
//  Created by zjq on 2017/6/11.
//  Copyright © 2017年 zjq. All rights reserved.
//

#import "JQNavigationBar.h"

@implementation JQNavigationBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:NSClassFromString(@"_UIBarBackground")] || [view isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")]) {
                self.bgView = view;
            }
        }
    }
    return self;
}

-(void)navigationBarHidden:(BOOL)hidden
{
    [UIView animateWithDuration:0.3 animations:^{
        if (!hidden) {
            self.bgView.alpha = 1;
        }else
        {
            self.bgView.alpha = 0;
            
        }
        
    }completion:^(BOOL finished) {
        self.bgView.hidden = hidden;
    }];
}

@end
