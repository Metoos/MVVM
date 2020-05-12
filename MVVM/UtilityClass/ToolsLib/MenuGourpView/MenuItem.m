//
//  MenuItem.m
//  MengJiong
//
//  Created by ManLoo on 16/7/25.
//  Copyright © 2016年 manloo. All rights reserved.
//

#import "MenuItem.h"

@implementation MenuItem

- (instancetype)initWithIconName:(NSString *)iconName titleName:(NSString *)titleName{
    if (self = [super init]) {
        self.iconName  = iconName;
        self.iconPath  = nil;
        self.titleName = titleName;
//        self.cateID    = cateID;
    }
    return self;
}

- (instancetype)initWithIconPath:(NSString *)iconPath titleName:(NSString *)titleName{
    if (self = [super init]) {
        self.iconName  = nil;
        self.iconPath  = iconPath;
        self.titleName = titleName;
//        self.cateID    = cateID;
    }
    return self;
}
- (instancetype)initWithIconPath:(NSString *)iconPath titleName:(NSString *)titleName subTitleName:(NSString *)subTitleName{
    if (self = [super init]) {
        self.iconName  = nil;
        self.iconPath  = iconPath;
        self.titleName = titleName;
        self.subTitleName = subTitleName;
        //        self.cateID    = cateID;
    }
    return self;
}
- (instancetype)initWithIconPath:(NSString *)iconPath titleName:(NSString *)titleName subAttTitleName:(NSAttributedString *)subAttTitleName{
    if (self = [super init]) {
        self.iconName  = nil;
        self.iconPath  = iconPath;
        self.titleName = titleName;
        self.subAttTitleName = subAttTitleName;
        //        self.cateID    = cateID;
    }
    return self;
}

+ (instancetype)initWithIconName:(NSString *)iconName titleName:(NSString *)titleName
{
    return [[self alloc] initWithIconName:iconName titleName:titleName];
}


+ (instancetype)menuWithIconName:(NSString *)iconName titleName:(NSString *)titleName
{
    return [[self alloc] initWithIconName:iconName titleName:titleName];
}
+ (instancetype)menuWithIconPath:(NSString *)iconPath titleName:(NSString *)titleName
{
    return [[self alloc]initWithIconPath:iconPath titleName:titleName];
}

+ (instancetype)menuWithIconPath:(NSString *)iconPath titleName:(NSString *)titleName subTitleName:(NSString *)subTitleName
{
     return [[self alloc]initWithIconPath:iconPath titleName:titleName subTitleName:subTitleName];
}

+ (instancetype)menuWithIconPath:(NSString *)iconPath titleName:(NSString *)titleName subAttTitleName:(NSAttributedString *)subAttTitleName
{
    return [[self alloc]initWithIconPath:iconPath titleName:titleName subAttTitleName:subAttTitleName];
}

@end
