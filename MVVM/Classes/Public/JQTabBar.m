//
//  JQTabBar.m
//  ZongShengTrainVideo
//
//  Created by zjq on 2017/6/11.
//  Copyright © 2017年 zjq. All rights reserved.
//

#import "JQTabBar.h"

@implementation JQTabBar

//设置自己定义的button为懒加载并且设置上背景图片
- (JQButton *)centerButton{
    
    if (_centerButton == nil) {
        _centerButton = [JQButton buttonWithType:UIButtonTypeCustom];
        [_centerButton sizeToFit];
        [self addSubview:_centerButton];

    }
    return _centerButton;
    
}



//设置tabbar子控件的布局
- (void)layoutSubviews{
    [super layoutSubviews];
    
    
    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;
    
    self.centerButton.bounds = CGRectMake(0, 0, 78, 78);
    
    CGFloat btnx = 0;
    CGFloat btny = 0;
    //5.0是tabbar中的控件的数量
    CGFloat width = self.bounds.size.width/(self.items.count + 1);
    CGFloat height = 49;
    
    //设置自定义button的位置
    self.centerButton.center = CGPointMake(w*0.5, h*0.5-(kDevice_Is_iPhoneX?(kDistancebottom-3):15));
    int index = 0;
    for (UIView *btn in self.subviews) {
        //判断是否是系统自带的UITabBarButton类型的控件
        if ([btn isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            btnx = index*width;
            index++;
            if (index == 2) {
                index =3;
            }
            btn.frame = CGRectMake(btnx, btny, width, height);
        }
    }
}

@end
