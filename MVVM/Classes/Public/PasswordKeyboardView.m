//
//  PasswordKeyboardView.m
//  LKC
//
//  Created by life on 2018/9/12.
//  Copyright © 2018年 hdyg. All rights reserved.
//

#import "PasswordKeyboardView.h"


@interface PasswordKeyboardView()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *passwordView;

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (weak, nonatomic) IBOutlet UIButton *number1Button;

@property (weak, nonatomic) IBOutlet UIButton *number2Button;

@property (weak, nonatomic) IBOutlet UIButton *number3Button;

@property (weak, nonatomic) IBOutlet UIButton *number4Button;

@property (weak, nonatomic) IBOutlet UIButton *number5Button;

@property (weak, nonatomic) IBOutlet UIButton *number6Button;

@property (nonatomic) CGRect frameNew;

@end

@implementation PasswordKeyboardView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"PasswordKeyboardView" owner:nil options:nil] lastObject];
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

- (IBAction)edit:(UIButton *)sender
{
    if (!self.textField.isFirstResponder) {
        [self.textField becomeFirstResponder];
    }
    
}


- (void)setupBinding
{
    [self.textField becomeFirstResponder];
    WEAKIFY;
    [[self.submitButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        STRONGIFY;
        !self.inputPasswordDone?:self.inputPasswordDone(self.textField.text);
        [self dismess];
        
    }];
}


- (void)setButtonSelected:(NSInteger)count
{
    for (int i = 0; i<6; i++) {
        UIButton *button = [self viewWithTag:i+1];
        if ([button isKindOfClass:UIButton.class]) {
            button.selected = NO;
        }
    }
    
    for (int i = 0; i<count; i++) {
        UIButton *button = [self viewWithTag:i+1];
        if ([button isKindOfClass:UIButton.class]) {
            button.selected = YES;
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (![UniversalManager validateNumber:string]) {
        [UniversalManager showWithTipsMessage:@"请输入数字"];
        return NO;
    }
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (toBeString.length > 6 && range.length!=1){
        
        textField.text = [toBeString substringToIndex:6];
        
        return NO;
        
    }
    
    [self setButtonSelected:toBeString.length];
    if (toBeString.length == 6) {
        !_inputPasswordDone?:_inputPasswordDone(toBeString);
        [self dismess];
       
    }
    
    return YES;
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
