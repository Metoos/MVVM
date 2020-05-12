//
//  HomeViewController.m
//  MVVM
//
//  Created by mac on 2019/8/6.
//  Copyright © 2019 hdyg. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeTableViewCell.h"
#import "CaptchaButton.h"
#import "JQPickerView.h"
#import "MyFeedbackViewController.h"
@interface HomeViewController ()

@property (strong, nonatomic) HomeViewModel *viewModel;

@end

@implementation HomeViewController
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    ///全界面加载视图
    //设置加载界面背景颜色
    self.view.stateView.backgroundColor = kNavBgColor;
    //使用自定义GIF图片作为加载状态显示
    [self.view.stateView setImages:[UniversalManager loadingImages] duration:2.25f];
    //显示加载界面状态
    [self.view showLoadStateWithFrame:CGRectMake(0, -kNavigationBarAndStatusBarHeight, kViewWidth, kViewHeight+kNavigationBarAndStatusBarHeight) maskViewStateType:viewStateWithLoading];
    //加载状态回调
    WEAKIFY
    [self.view loadStateReturnBlock:^(ViewStateReturnType viewStateReturnType) {
        STRONGIFY
        if (viewStateReturnType == ViewStateReturnReloadViewDataType) {//点击了重新加载
            [self.view showLoadStateWithMaskViewStateType:viewStateWithLoading];
            [self jq_setupData];
        }
    }];

    
    // Do any additional setup after loading the view.
}

- (void)jq_layoutNavigation
{
    self.navigationItem.title = @"首页";
    WEAKIFY
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"意见反馈" Click:^{
        STRONGIFY
        MyFeedbackViewModel *viewModel = [[MyFeedbackViewModel alloc]init];
        MyFeedbackViewController *feed = [[MyFeedbackViewController alloc]initStoryboardWithName:@"Home" identiffier:@"MyFeedbackViewController" ViewModel:viewModel];
        [self.navigationController pushViewController:feed animated:YES];
    }];
    
}

- (void)jq_setupData
{
    WEAKIFY
//    [UniversalManager showWithWaitMessage:@"请稍候" maskType:SVProgressHUDMaskTypeNone];
    [self.viewModel jq_sendDataRequest:^(id entity) {
        STRONGIFY
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [UniversalManager dissmessProgressHUD];
            [self.view dismessStateView];//全界面加载视图、移除加载
            [self.tableView reloadData];
            [self endLoadingViewFooter];//结束刷新动作
        });
    } failure:^(NSUInteger errCode, NSString *errorMsg) {
        [UniversalManager showWithErrorMessage:errorMsg?:@"失败"];
        [self endLoadingViewFooter];//结束刷新动作
        //显示加载错误界面
        [self.view showLoadStateWithFrame:CGRectMake(0, -kNavigationBarAndStatusBarHeight, kViewWidth, kViewHeight+kNavigationBarAndStatusBarHeight) maskViewStateType:viewStateWithLoadError];//全界面加载错误视图
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UniversalManager dissmessProgressHUD];
}

- (void)jq_setupViewLayout
{
    [super jq_setupViewLayout];
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"HomeTableViewCell"];
}

- (Class)cellClassForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HomeTableViewCell.class;
}

- (void)tableView:(UITableView *)tableView didSelectButtonInCellAtIndexPath:(NSIndexPath *)indexPath sender:(UIButton *)button
{
    [(CaptchaButton*)button sendSmsWithPhoneNumber:@"18273938273" areaCode:@""];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JQPickerView *picker = [JQPickerView pickerView];
    picker.title = JQGetStringWithKeyFromTable(@"请选择地区", nil);
    picker.isDistrictPickerView = YES;
    picker.districtType = ProvinceAndCityAndAreaType;
//    WEAKIFY;
    [picker showWithAddressCompletion:^(JQPickerView *pickerView, NSString *province, NSString *city, NSString *area) {
        DLog(@"%@-%@-%@",province,city,area);
    }];
}

@end
