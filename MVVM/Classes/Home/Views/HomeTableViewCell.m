//
//  HomeTableViewCell.m
//  MVVM
//
//  Created by mac on 2019/12/16.
//  Copyright © 2019 hdyg. All rights reserved.
//

#import "HomeTableViewCell.h"
#import "CaptchaButton.h"
#import "HomeCellViewModel.h"
@interface HomeTableViewCell()


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet CaptchaButton *captchaButton;

@property (strong, nonatomic) HomeCellViewModel *viewModel;


@end

@implementation HomeTableViewCell
@dynamic viewModel;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)jq_setupData
{
    self.titleLabel.text = self.viewModel.titleString;
    self.captchaButton.hidden = !self.viewModel.isCanGetCaptcha;
}

- (void)jq_setupBinding
{
    @weakify(self);
    [[self.captchaButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(CaptchaButton *sender) {
        @strongify(self);
        [self.cellButtonsSignal sendNext:sender];
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
