//
//  JQGesturesLockViewController.m
//  DigitalTreasure
//
//  Created by mac on 2019/8/29.
//  Copyright © 2019 hdyg. All rights reserved.
//

#import "JQGesturesLockViewController.h"
#import "ZZGestureLockView.h"
#import "LoginStorage.h"
#import "PayPasswordKeyboard.h"
#define MAX_VERIFICATIONS_NUMBER 3     //最大验证次数

@interface JQGesturesLockViewController ()<ZZGestureLockViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;

@property (weak, nonatomic) IBOutlet ZZGestureLockView *lockView;

@property (weak, nonatomic) IBOutlet UIButton *gestureButton;

/** 临时密码 */
@property (strong, nonatomic) NSString *tempPassword;
/** 验证次数 */
@property (assign, nonatomic) NSUInteger number;


@property (assign, nonatomic) GesturesLockStatus originalStatus;

@property (copy, nonatomic) validationDone done;

@end

@implementation JQGesturesLockViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.originalStatus = self.lockStatus;
}

- (void)validationDone:(validationDone)done
{
    self.done = done;
    
}


- (void)jq_setupViewLayout
{
    self.lockView.normalLineColor = kWhiteColor;
    self.lockView.warningLineColor = kRedColor;
    self.lockView.itemWidth = 50;
    self.lockView.lineWidth = 10;
    self.lockView.miniPasswordLength = 4;
    self.lockView.delegate = self;
    
    [self initPage];
}


- (void)jq_setupBinding
{
    @weakify(self);
    [[self.gestureButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
        @strongify(self);
        PayPasswordKeyboard *pay = [[PayPasswordKeyboard alloc]init];
        @weakify(self);
        [pay showWithDone:^(NSString *password) {
            @strongify(self);
            if ([[LoginStorage payPassword] isEqualToString:password]) {
                self.lockStatus = GesturesLockStatusSetup;
            }else
            {
                [UniversalManager showWithErrorMessage:@"支付密码错误"];
            }
            
        }];
    }];
    
    [[self.backButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
        @strongify(self);
        
        !self.done?:self.done(NO,nil);
        
        [self goBack];
    
    }];
    
    
}

#pragma ZZGestureLockViewDelegate
- (void)zzGestureLockViewDidStartWithLockView:(ZZGestureLockView *)lockView {
    NSLog(@"begin-----");
}

- (void)zzGestureLockViewDidEndWithLockView:(ZZGestureLockView *)lockView itemState:(ZZGestureLockItemState)itemState gestureResult:(NSString *)gestureResult {
    
    NSLog(@"end----");
    
    if (itemState == ZZGestureLockItemStateNormal) {
        
        if (self.lockStatus == GesturesLockStatusSetup) {
            [self setupGesture:gestureResult];
        }else
        {
            [self validationGestures:gestureResult];
        }
        
    } else {
        self.tipsLabel.text = @"请至少连接四个点";
        self.tipsLabel.textColor = kRedColor;
    }
}

- (void)setLockStatus:(GesturesLockStatus)lockStatus
{
    _lockStatus = lockStatus;
    
    
    [self initPage];
}

- (void)initPage{
    
    self.tempPassword = nil;
    self.number = MAX_VERIFICATIONS_NUMBER;
    
    if (_lockStatus == GesturesLockStatusValidation) {
        self.gestureButton.hidden = NO;
        self.tipsLabel.text = @"请绘制手势";
        self.tipsLabel.textColor = kWhiteColor;
    }else
    {
        self.gestureButton.hidden = YES;
        self.tipsLabel.text = @"请绘制您的新手势";
        self.tipsLabel.textColor = kWhiteColor;
    }
}

- (void)validationGestures:(NSString *)gestureResult
{
    NSString *gestureLock = [LoginStorage gestureLock];
    if ([gestureResult isEqualToString:gestureLock])
    {
        !self.done?:self.done(YES,[LoginStorage payPassword]);
        [self goBack];
        
    }else if(self.number>1)
    {
        self.number--;
        self.tipsLabel.text = [NSString stringWithFormat:@"绘制的手势错误,您还可以尝试%ld次",self.number];
        self.tipsLabel.textColor = kRedColor;
        [self.lockView makeWarning];
    }else
    {
        WEAKIFY
        [UniversalManager showAlertWithTitle:@"提示" Message:@"是否使用支付密码进行验证" cancelButton:@"取消" ohterButton:@"验证密码" ClickBlock:^(NSInteger index) {
            STRONGIFY
            if (index == 0) {
                !self.done?:self.done(NO,nil);
                [self goBack];
            }else
            {
                [self validationPayPassword];
            }
        }];
        
        
//        self.tempPassword = nil;
//        self.tipsLabel.text = [NSString stringWithFormat:@"请重新绘制新手势"];
//        self.tipsLabel.textColor = kWhiteColor;
    }
}

- (void)validationPayPassword
{
    PayPasswordKeyboard *pass = [[PayPasswordKeyboard alloc]init];
    WEAKIFY
    [pass showWithDone:^(NSString *password) {
        STRONGIFY
        if ([[LoginStorage payPassword] isEqualToString:password]) {
            !self.done?:self.done(YES,password);
            [self goBack];
        }else
        {
            [UniversalManager showWithErrorMessage:@"支付密码错误"];
            [self validationPayPassword];
        }
    }];
}

- (void)goBack
{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

- (void)setupGesture:(NSString *)gestureResult
{
    if (self.tempPassword && ![self.tempPassword isEqualToString:@""]) {
        
        if ([self.tempPassword isEqualToString:gestureResult]) {
            WEAKIFY
            [UniversalManager showAlertWithTitle:@"提示" Message:@"设置手势密码成功" cancelButton:@"确定" ClickBlock:^(NSInteger index) {
                STRONGIFY
                if (self.originalStatus == GesturesLockStatusValidation) {
                    //如果首次进入界面的状态为验证手势时
                    self.lockStatus = GesturesLockStatusValidation;
                    
                }else
                {
                    !self.done?:self.done(YES,[LoginStorage payPassword]);
                    
                    [self goBack];
                }
                
            }];
            [LoginStorage saveGestureLock:gestureResult];
            
        }else if(self.number>1)
        {
            self.number--;
            self.tipsLabel.text = [NSString stringWithFormat:@"两次绘制手势不一致,您还可以尝试%ld次",self.number];
            self.tipsLabel.textColor = kRedColor;
            [self.lockView makeWarning];
            
            [LoginStorage saveGestureLock:@""];
            
        }else
        {
            self.tempPassword = nil;
            self.tipsLabel.text = [NSString stringWithFormat:@"手势设置失败，请重新绘制新手势"];
            self.tipsLabel.textColor = kWhiteColor;
            self.number = MAX_VERIFICATIONS_NUMBER;
            [LoginStorage saveGestureLock:@""];
        }
        
    }else{
        
        self.tempPassword = gestureResult;
        self.tipsLabel.text = [NSString stringWithFormat:@"请再次绘制新手势"];
        self.tipsLabel.textColor = kWhiteColor;
    }
}

@end
