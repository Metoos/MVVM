//
//  PayPasswordKeyboard.m
//  MVVM
//
//  Created by mac on 2019/8/7.
//  Copyright © 2019 hdyg. All rights reserved.
//

#import "PayPasswordKeyboard.h"

@interface PayPasswordKeyboard()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *passwordView;

@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (nonatomic) CGRect frameNew;

@end

@implementation PayPasswordKeyboard

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"PayPasswordKeyboard" owner:nil options:nil] lastObject];
        self.frameNew = frame;
        [self setupBinding];
        
    }
    
    return self;
    
}

- (void)layoutSubviews

{
    [super layoutSubviews];
    self.frame = self.frameNew;
    
}

- (void)setupBinding
{
    WEAKIFY;
    
    [[self.closeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
        STRONGIFY;
        [self dismess];
    }];
    
    [[self.submitButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
        STRONGIFY;
        [self dismess];
        !self.inputPasswordDone?:self.inputPasswordDone(self.passwordTextField.text);
    }];
    
}

- (void)showWithDone:(InputPasswordDone)inputPasswordDone
{
    self.inputPasswordDone = inputPasswordDone;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.frameNew = window.bounds;
    [self layoutIfNeeded];
    DLog(@"self.frame = %@",NSStringFromCGRect(self.frame));
    [window addSubview:self];
    self.alpha = 0.0f;
    WEAKIFY;
    [UIView animateWithDuration:0.3 animations:^{
        STRONGIFY;
        self.alpha = 1.0f;
    }completion:^(BOOL finished) {
        STRONGIFY;
        [self.passwordTextField becomeFirstResponder];
    }];
    
}


- (void)dismess
{
    WEAKIFY;
    [UIView animateWithDuration:0.3 animations:^{
        STRONGIFY;
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        STRONGIFY;
        self.inputPasswordDone = nil;
        [self removeFromSuperview];
    }];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.15 animations:^{
        self.passwordView.transform = CGAffineTransformMakeTranslation(0, -100);
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.15 animations:^{
        self.passwordView.transform = CGAffineTransformMakeTranslation(0, 0);
    }];
}

@end
