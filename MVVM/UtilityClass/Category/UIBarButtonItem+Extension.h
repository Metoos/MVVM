//
//  UIBarButtonItem+Extension.h
//  BBA
//
//  Created by life on 2018/4/23.
//  Copyright © 2018年 hdyg. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ClickBlock)(void);
@interface UIBarButtonItem (Extension)


@property (nonatomic)void(^ClickBlock)(void);
/**
 *使用一张网络图片来创建一个UIBarButtonItem
 *@param imageUrl   图片网络地址
 *@param image      placeholder Image
 *@param click      点击回调block
 */
- (instancetype)initWithCustomViewWithImageUrlString:(NSString*)imageUrl placeholderImage:(UIImage*)image Click:(ClickBlock)click;

/**
 *使用一张网络图片来创建一个圆角UIBarButtonItem
 *@param imageUrl   图片网络地址
 *@param placeholderImage      placeholder Image
 *@param click      点击回调block
 */
- (instancetype)initWithCustomViewWithCircleImageUrlString:(NSString*)imageUrl placeholderImage:(UIImage*)placeholderImage Click:(ClickBlock)click;


@end
