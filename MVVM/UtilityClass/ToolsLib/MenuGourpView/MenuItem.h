//
//  MenuItem.h
//  MengJiong
//
//  Created by ManLoo on 16/7/25.
//  Copyright © 2016年 manloo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuItem : NSObject

@property (nonatomic, assign) NSInteger key;
@property (nonatomic, copy) NSString *iconName;
@property (nonatomic, copy) NSString *iconPath;
@property (nonatomic, copy) NSString *titleName;

@property (strong, nonatomic) NSString *subTitleName;
@property (strong, nonatomic) NSAttributedString *subAttTitleName;

//@property (nonatomic, copy) NSString *cateID;

- (instancetype)initWithIconName:(NSString *)iconName titleName:(NSString *)titleName;
+ (instancetype)initWithIconName:(NSString *)iconName titleName:(NSString *)titleName;
+ (instancetype)menuWithIconName:(NSString *)iconName titleName:(NSString *)titleName;
+ (instancetype)menuWithIconPath:(NSString *)iconPath titleName:(NSString *)titleName;
+ (instancetype)menuWithIconPath:(NSString *)iconPath titleName:(NSString *)titleName subTitleName:(NSString *)subTitleName;
+ (instancetype)menuWithIconPath:(NSString *)iconPath titleName:(NSString *)titleName subAttTitleName:(NSAttributedString *)subAttTitleName;
@end
