//
//  KeyboardToolsView.m
//  BBA
//
//  Created by life on 2018/3/16.
//  Copyright © 2018年 hdyg. All rights reserved.
//

#import "KeyboardToolsView.h"

@interface KeyboardToolsView()


@property (strong, nonatomic) UIButton *closeButton;
//键盘回收回调
@property (strong, nonatomic) void(^closeBlock)(void);
@end

@implementation KeyboardToolsView

+ (instancetype)instancekeyboardToolsView
{
    
    return [[KeyboardToolsView alloc]initWithFrame:CGRectMake(0, 0, kViewWidth, 44.0f)];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        self.backgroundColor = [UIColor colorWithRed:240.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:1];
    }
    return self;
}

- (void)setupView {
    
    [self addSubview:self.closeButton];

}

- (void)updateConstraints
{
    WS(weakSelf);
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.mas_right).offset(-10);
        make.top.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf);
        make.width.mas_equalTo(@44);
    }];
    
    [super updateConstraints];
}

//安装键盘工具栏
- (void)install
{
    WEAKIFY;
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(NSNotification *aNotification){
        STRONGIFY;
        NSLog(@"键盘弹出");
        //键盘弹出时显示工具栏
        //获取键盘的高度
        NSDictionary *userInfo = [aNotification userInfo];
        NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardRect = [aValue CGRectValue];
        float keyBoardHeight = keyboardRect.size.height;
        NSNumber *durationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        float duration = [durationValue floatValue];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        self.frame = CGRectMake(0, window.size.height, window.size.width, 44.0f);
        [window addSubview:self];
        //    NSLog(@"%ld",(long)keyBoardHeight);
        [UIView animateWithDuration:duration animations:^{
            
            self.frame = CGRectMake(0, window.size.height-keyBoardHeight-44.0f, window.size.width, 44);
        }];
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillHideNotification object:nil] subscribeNext:^(id x ){
        STRONGIFY;
        NSLog(@"键盘关闭");
        [self removeFromSuperview];
    }];
    
    
}
//卸载键盘工具栏
- (void)uninstall
{
    [self removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)returnKeyBoardBlock:(void (^)(void))block
{
    _closeBlock = block;
}
- (void)clickCloseAction:(UIButton *)sender
{
    [[[UIApplication sharedApplication] delegate].window endEditing:YES];
    !_closeBlock?:_closeBlock();
}

- (UIButton *)closeButton
{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setTitle:@"完成" forState:UIControlStateNormal];
        [_closeButton setTitleColor:[UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(clickCloseAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}


@end
