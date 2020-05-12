//
//  JQTouchIDAndFaceIDViewController.m
//  DigitalTreasure
//
//  Created by mac on 2019/9/10.
//  Copyright © 2019 hdyg. All rights reserved.
//

#import "JQTouchIDAndFaceIDViewController.h"
#import "JQTouchIDAndFaceIDManager.h"
#import "LoginStorage.h"
@interface JQTouchIDAndFaceIDViewController ()
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *touchButton;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (copy, nonatomic) validationTouchIDDone done;
@end

@implementation JQTouchIDAndFaceIDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    我的_指纹大
    // Do any additional setup after loading the view from its nib.
}

- (void)validationDone:(validationTouchIDDone)done
{
    self.done = done;
    
}

- (void)jq_setupViewLayout
{
    if (kDevice_Is_iPhoneX) {
        [self.touchButton setImage:[UIImage imageNamed:@"我的_面容"] forState:UIControlStateNormal];
    }else
    {
        [self.touchButton setImage:[UIImage imageNamed:@"我的_指纹大"] forState:UIControlStateNormal];
    }
    
    [self startVal];
}

- (void)jq_setupBinding
{
    @weakify(self);
    [[self.touchButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
        @strongify(self);
        [self startVal];
    }];
    
    
    [[self.closeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
        @strongify(self);
        
        !self.done?:self.done(NO,NO,nil);
        [self goBackAnimated:YES];
        
    }];
    
}

- (void)startVal{
    
    NSString *title  = self.isOpening?nil:@"使用密码验证";
    NSString *reason = @"请验证您的指纹";
    if (kDevice_Is_iPhoneX) {
        reason = @"请验证您的面容";
    }
    
    [JQTouchIDAndFaceIDManager jq_touchIDOrFaceIDLocalAuthenticationFallBackTitle:title localizedReason:reason callBack:^(BOOL isSuccess, NSError * _Nullable error, NSString *referenceMsg) {
        if (error.code == LAErrorUserFallback) {
            //使用支付密码验证
            !self.done?:self.done(NO,YES,nil);
            [self goBackAnimated:NO];
        }else{
            self.tipsLabel.text = referenceMsg;
            
            if (isSuccess) {
                !self.done?:self.done(isSuccess,NO,[LoginStorage payPassword]);
                [self goBackAnimated:YES];
            }
            
        }
        
    }];
}

- (void)goBackAnimated:(BOOL)isAnimated
{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:isAnimated];
    }else
    {
        [self dismissViewControllerAnimated:isAnimated completion:NULL];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
