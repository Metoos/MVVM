//
//  JQButton.h
//  BBA
//
//  Created by life on 2018/9/7.
//  Copyright © 2018年 hdyg. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  按钮中图片的位置
 */
typedef NS_ENUM(NSUInteger, JQImageAlignment) {
    /**
     *  图片在左，默认
     */
    JQImageAlignmentLeft = 0,
    /**
     *  图片在上
     */
    JQImageAlignmentTop,
    /**
     *  图片在下
     */
    JQImageAlignmentBottom,
    /**
     *  图片在右
     */
    JQImageAlignmentRight,
};


@interface JQButton : UIButton
/**
 *  按钮中图片的位置
 */
@property(nonatomic,assign) IBInspectable NSUInteger imageAlignment;
/**
 *  按钮中图片与文字的间距
 */
@property(nonatomic,assign) IBInspectable CGFloat space;


@end
