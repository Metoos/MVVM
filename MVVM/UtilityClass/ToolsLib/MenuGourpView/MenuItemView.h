//
//  MenuItemView.h
//  MengJiong
//
//  Created by ManLoo on 16/7/25.
//  Copyright © 2016年 manloo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuItem;

@interface MenuItemView : UIButton

@property (nonatomic, assign) long index;
@property (nonatomic, assign, getter=isGridLine) BOOL gridLine;
@property (nonatomic, assign) BOOL isUseCircularImg;//图片是否使用圆角
@property (nonatomic, assign) CGFloat imageWidth;
@property (nonatomic, assign) CGFloat imageHeight;
@property (nonatomic, strong) UIColor *menuItemViewTitleTextColor;
@property (nonatomic, strong) MenuItem *menuItem;

@end
