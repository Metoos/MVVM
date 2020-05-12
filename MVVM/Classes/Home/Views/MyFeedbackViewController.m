//
//  MyFeedbackViewController.m
//  KuangJinApp
//
//  Created by life on 2020/1/7.
//  Copyright © 2020 jingdu. All rights reserved.
//

#import "MyFeedbackViewController.h"
#import "JQUploadMoreImagesView.h"
@interface MyFeedbackViewController ()

@property (weak, nonatomic) IBOutlet UIButton *titleButton;

@property (weak, nonatomic) IBOutlet UITableViewCell *submitCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *alertCell;

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;

@property (weak, nonatomic) IBOutlet UILabel *contentTextTitleLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet JQUploadMoreImagesView *uplaodView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;

@property (nonatomic,strong) UIButton *bottomActionButton;

@property (strong, nonatomic) MyFeedbackViewModel *viewModel;

@end

@implementation MyFeedbackViewController
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if (self.submitCell == cell && self.submitCell.hidden) {
        return 0.0f;
    }
    if (self.alertCell == cell && self.alertCell.hidden) {
        return 0.0f;
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (void)jq_layoutNavigation
{
    self.navigationItem.title = @"意见反馈";
    
}

- (void)jq_setupViewLayout
{
    UIView *backView = [[UIView alloc] initWithFrame:self.tableView.bounds];
    backView.backgroundColor = [UIColor whiteColor];
    UIView *backHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, 400)];
    backHeadView.backgroundColor = COLORRGB(0x386DEC);
    [backView addSubview:backHeadView];
    self.tableView.backgroundView = backView;
    
//    self.uplaodView.addImage = [UIImage imageNamed:@"添加"];
    self.uplaodView.columns = 4;
    self.uplaodView.imagesMaxCount = 4;
    self.uplaodView.imageContentMode = UIViewContentModeScaleAspectFill;
    [self.uplaodView setUploadEnginePostUrl:SERVER_HOST parameters:kDic.addObjectForKey(@"method",@"site.tpsc") field:@"User[tradeprice]"];
    
    self.uplaodView.itemUrls = @[@"http://test.eny-pay.com/hash/ab/1578965229_6837.png",@"http://a3.att.hudong.com/44/95/01300542667193141387952986188.jpg",@"http://c.hiphotos.baidu.com/zhidao/pic/item/d009b3de9c82d1587e249850820a19d8bd3e42a9.jpg"];

}

- (void)jq_setupBinding
{
    WEAKIFY
    RAC(self.viewModel, contact) = [RACSignal merge:@[RACObserve(self.titleTextField, text),self.titleTextField.rac_textSignal]];
    
    
    RAC(self.viewModel, content) = [[RACSignal merge:@[RACObserve(self.contentTextView, text),self.contentTextView.rac_textSignal]] map:^id _Nullable(NSString *value) {
        STRONGIFY
        self.countLabel.text = [[NSString alloc]initWithFormat:@"%ld/200",value.length];
        if (value && value!=self.contentTextView.text) {
            if (value.length>200) {
                self.contentTextView.text = [value substringToIndex:199];
            }
        }
        return value;
    }];
    [RACObserve(self.uplaodView, count) subscribeNext:^(id x) {
        STRONGIFY
        if ([x integerValue] > 0) {
            self.tipsLabel.hidden = YES;
        }else
        {
            self.tipsLabel.hidden = NO;
        }
        self.viewModel.count = [x integerValue];
        DLog(@"图片总数=%ld",[x integerValue]);
    }];

    [[self.submitButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
        STRONGIFY
        self.viewModel.imagesUrl = [self.uplaodView getUploadResultUrlArray];
        [self requestAction:sender];
    }];
    
    
}

- (void)requestAction:(UIButton *)sender
{
    [[[UIApplication sharedApplication] delegate].window endEditing:YES];
    [sender setLoadingWithTitle:JQGetStringWithKeyFromTable(@"请稍候", nil)];
    @weakify(self);
    [self.viewModel jq_sendDataRequest:^(id entity) {
        @strongify(self);
        [sender setNormalWithTitle:JQGetStringWithKeyFromTable(@"提交", nil)];
        [UniversalManager showWithTipsMessage:entity?:@"提交成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(NSUInteger errCode, NSString *errorMsg) {
        [sender setNormalWithTitle:JQGetStringWithKeyFromTable(@"提交", nil)];
        [UniversalManager showWithTipsMessage:errorMsg?:@"失败"];
    }];
}


@end
