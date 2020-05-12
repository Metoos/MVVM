//
//  JQProgressAnimatedView.h
//  SilverLetterFinancial
//
//  Created by mac on 2017/7/7.
//  Copyright © 2017年 zongsheng. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, JQProgressViewStyle) {
    JQProgressViewStyleCircular = 0, //圆环形进度条
    JQProgressViewStyleSquare = 1    //矩形环进度条
    
};
@interface JQProgressAnimatedView : UIView

@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, assign) CGFloat progressLineWidth;

@property (nonatomic, strong) UIFont *progressLabelFont;
/** 进度条风格 */
@property (nonatomic, assign) JQProgressViewStyle progressViewStyle;
/** 是否隐藏进度标签 默认 NO */
@property (nonatomic, assign) BOOL isHiddenProgressLabel;
/** 进度条当前进度颜色 */
@property (nonatomic, strong) UIColor *progressColor;
/** 进度条背景颜色 */
@property (nonatomic, strong) UIColor *trackColor;

@end
