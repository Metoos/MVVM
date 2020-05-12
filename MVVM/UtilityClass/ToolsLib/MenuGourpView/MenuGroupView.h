//
//  MenuGroupView.h
//  MengJiong
//
//  Created by ManLoo on 16/7/25.
//  Copyright © 2016年 manloo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuItemView.h"
#import "MenuItem.h"

@class MenuGroupView;

@protocol MenuGroupViewDelegate <NSObject>

@optional
- (void)menuGroupView:(MenuGroupView *)MenuGroupView didClickedItem:(MenuItemView *)item;

@end

@interface MenuGroupView : UIView

@property (nonatomic, strong) id package;
@property (nonatomic, assign) NSInteger columns;
@property (nonatomic, assign) CGFloat imageWidth;
@property (nonatomic, assign) CGFloat imageHeight;
@property (nonatomic, assign, getter=isGridLine) BOOL gridLine;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) UIColor *menuItemViewTitleTextColor;
@property (nonatomic, assign) BOOL isUseCircularImg;//图片是否使用圆角
@property (nonatomic, weak) IBOutlet id<MenuGroupViewDelegate> delegate;

@end
