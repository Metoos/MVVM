//
//  UIView+Internationalization.m
//  BBA
//
//  Created by life on 2018/9/11.
//  Copyright © 2018年 hdyg. All rights reserved.
//

#import "UIView+Internationalization.h"
#import "JQLanguageTool.h"
#define JQInternationalizationEnableKey @"JQInternationalizationEnableKey"

#define JQUITextViewEnable 1
#define JQUITextFieldEnable 1
#define JQUIButtonEnable 1
#define JQUILabelEnable 1

@implementation UIView (Internationalization)

/**
 设置国际化是否开启
 @param enable 是否开启
 */
+ (void)internationalizationEnable:(BOOL)enable
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(enable) forKey:JQInternationalizationEnableKey];
    [defaults synchronize];
}

+ (BOOL)getInternationalizationEnable{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *valueNum = [defaults objectForKey:JQInternationalizationEnableKey];
    return valueNum?valueNum.boolValue:NO;
}

@end

@interface UILabel (Internationalization)

@end

@interface UIButton (Internationalization)

@end

@interface UITextField (Internationalization)

@end


@implementation UILabel (Internationalization)

+ (void)load{
    
    if(!JQUILabelEnable) return;
    Method imp = class_getInstanceMethod([self class], @selector(setText:));
    Method myImp = class_getInstanceMethod([self class], @selector(mySetText:));
    method_exchangeImplementations(imp, myImp);

    
    Method cmp = class_getInstanceMethod([self class], @selector(layoutSubviews));
    Method mycImp = class_getInstanceMethod([self class], @selector(myLayoutSubviews));
    method_exchangeImplementations(cmp, mycImp);
//    Method cmp = class_getInstanceMethod([self class], @selector(setAttributedText:));
//    Method mycImp = class_getInstanceMethod([self class], @selector(mySetAttributedText:));
//    method_exchangeImplementations(cmp, mycImp);
    
    
//    Method vimp = class_getInstanceMethod([self class], @selector(initWithCoder:));
//    Method myvImp = class_getInstanceMethod([self class], @selector(myInitWithCoder:));
//    method_exchangeImplementations(vimp, myvImp);
//
//    Method dmp = class_getInstanceMethod([self class], @selector(initWithFrame:));
//    Method mydmp = class_getInstanceMethod([self class], @selector(myInitWithFrame:));
//    method_exchangeImplementations(dmp, mydmp);
//
//    Method emp = class_getInstanceMethod([self class], @selector(init));
//    Method myemp = class_getInstanceMethod([self class], @selector(myInit));
//    method_exchangeImplementations(emp, myemp);
}

//- (void)mySetAttributedText:(NSAttributedString *)attributedText
//{
//    NSString *text = attributedText.string;
//    BOOL enable = [UIView getInternationalizationEnable];
//    if (enable && text && ![text isEqualToString:@""]) {
//        text = JQGetStringWithKeyFromTable(text, nil);
//    }
//    attributedText = [[NSAttributedString alloc]initWithString:text];
//    [self mySetAttributedText:attributedText];
//}

- (void)mySetText:(NSString *)text
{

    BOOL enable = [UIView getInternationalizationEnable];
    if (enable && text && ![text isEqualToString:@""]) {
        text = JQGetStringWithKeyFromTable(text, nil);
    }
    
    [self mySetText:text];
    
}

- (void)myLayoutSubviews
{
    if (![NSStringFromClass(self.class) isEqualToString:@"UILabel"]) return;
    
    NSString *text = self.text;
    self.text = text;
    
    [self myLayoutSubviews];
}


@end

@implementation UIButton (Internationalization)

+ (void)load{
    if(!JQUIButtonEnable) return;
    Method imp = class_getInstanceMethod([self class], @selector(setTitle:forState:));
    Method myImp = class_getInstanceMethod([self class], @selector(mySetTitle:forState:));
    method_exchangeImplementations(imp, myImp);
    
    Method cmp = class_getInstanceMethod([self class], @selector(layoutSubviews));
    Method mycImp = class_getInstanceMethod([self class], @selector(myLayoutSubviews));
    method_exchangeImplementations(cmp, mycImp);
}

- (void)mySetTitle:(NSString *)title forState:(UIControlState)state
{
    BOOL enable = [UIView getInternationalizationEnable];
    if (enable && title && ![title isEqualToString:@""]) {
        title = JQGetStringWithKeyFromTable(title, nil);
    }
    [self mySetTitle:title forState:state];
}

- (void)myLayoutSubviews
{
    [self myLayoutSubviews];
    
    if (![NSStringFromClass(self.class) isEqualToString:@"UIButton"]) return;
    
    NSString *text = self.titleLabel.text;
    [self setTitle:text forState:self.state];
    
}

@end

@implementation UITextField (Internationalization)

+ (void)load{
    if(!JQUITextFieldEnable) return;
    Method imp = class_getInstanceMethod([self class], @selector(setText:));
    Method myImp = class_getInstanceMethod([self class], @selector(mySetText:));
    method_exchangeImplementations(imp, myImp);
    
    
    Method cmp = class_getInstanceMethod([self class], @selector(setPlaceholder:));
    Method mycImp = class_getInstanceMethod([self class], @selector(mySetPlaceholder:));
    method_exchangeImplementations(cmp, mycImp);
    
    
    Method cmp1 = class_getInstanceMethod([self class], @selector(layoutSubviews));
    Method mycImp1 = class_getInstanceMethod([self class], @selector(myLayoutSubviews));
    method_exchangeImplementations(cmp1, mycImp1);
}

- (void)mySetText:(NSString *)text
{
    BOOL enable = [UIView getInternationalizationEnable];
    if (enable && text && ![text isEqualToString:@""]) {
        text = JQGetStringWithKeyFromTable(text, nil);
    }
    [self mySetText:text];

}

- (void)myLayoutSubviews
{
    
    
    BOOL enable = [UIView getInternationalizationEnable];
    if (enable && self.placeholder && ![self.placeholder isEqualToString:@""]) {
        self.placeholder = self.placeholder;
    }
    [self myLayoutSubviews];
    
}

- (void)mySetPlaceholder:(NSString *)placeholder
{
    BOOL enable = [UIView getInternationalizationEnable];
    if (enable && placeholder && ![placeholder isEqualToString:@""]) {
        placeholder = JQGetStringWithKeyFromTable(placeholder, nil);
    }
    [self mySetPlaceholder:placeholder];

}

@end


