//
//  MenuGroupView.m
//  MengJiong
//
//  Created by ManLoo on 16/7/25.
//  Copyright © 2016年 manloo. All rights reserved.
//

#import "MenuGroupView.h"

#define isWidthOddNumber (int)self.frame.size.width % (int)self.columns != 0
#define kGridLineHeight 1

@implementation MenuGroupView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _imageHeight = 35;
        _imageWidth  = 35;
        self.columns = 4;
        self.menuItemViewTitleTextColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _imageWidth  = 35;
        _imageHeight = 35;
        self.columns = 4;
        self.menuItemViewTitleTextColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];

    }
    return self;
}

- (NSMutableArray *)buttons {
    if (_buttons == nil) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat buttonW = self.frame.size.width / self.columns;
    if (self.columns > 0 && self.items>0) {
        if (isWidthOddNumber) { //iphone6或iphone6+
            buttonW = (int)round(buttonW);
        }
        CGFloat buttonH = self.frame.size.height / ((self.items.count - 1) / self.columns + 1);
        
    //    CGFloat buttonH = 60.0;
        for (int index = 0; index < self.items.count; index++) {
            
            if (isWidthOddNumber) {
                if ((index + 1) * self.columns == 0) {
                    buttonW = buttonW - 1;
                }
            }
            
            // i这个位置对应的列数
            int col = index % self.columns;
            // i这个位置对应的行数
            int row = index / self.columns;
            
            CGFloat buttonX = col * buttonW;
            CGFloat buttonY = row * buttonH;
            
            [self.buttons[index] setFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
        }
        
    }
}

- (void)setItems:(NSArray *)items {
    
    _items = items;
    
    for (MenuItemView *menuItemView in self.subviews) {
        [menuItemView removeFromSuperview];
    }
    [self.buttons removeAllObjects];
    
    for (int index = 0; index < self.items.count; index++) {
        
        MenuItemView *menuItemView = [[MenuItemView alloc] init];
        menuItemView.tag = index;
        menuItemView.index = index;
        menuItemView.imageWidth = _imageWidth;
        menuItemView.imageHeight = _imageHeight;
        menuItemView.menuItemViewTitleTextColor = self.menuItemViewTitleTextColor;
        menuItemView.menuItem = self.items[index];
        menuItemView.gridLine = self.gridLine;
        menuItemView.isUseCircularImg = _isUseCircularImg;
        [menuItemView addTarget:self action:@selector(itemclick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:menuItemView];
        [self.buttons addObject:menuItemView];
    }
}

- (void)itemclick:(MenuItemView *)menuItemView {
    if ([self.delegate respondsToSelector:@selector(menuGroupView:didClickedItem:)]) {
        [self.delegate menuGroupView:self didClickedItem:menuItemView];
    }
}

@end
