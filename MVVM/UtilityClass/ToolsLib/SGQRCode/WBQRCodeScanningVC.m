//
//  WBQRCodeScanningVC.m
//  SGQRCodeExample
//
//  Created by kingsic on 2018/2/8.
//  Copyright © 2018年 kingsic. All rights reserved.
//

#import "WBQRCodeScanningVC.h"
#import "SGQRCode.h"
#import "ScanSuccessJumpVC.h"
#import "SGQRCodeHelperTool.h"
@interface WBQRCodeScanningVC () <SGQRCodeScanManagerDelegate, SGQRCodeAlbumManagerDelegate>
@property (nonatomic, strong) SGQRCodeScanManager *manager;
@property (nonatomic, strong) SGQRCodeScanningView *scanningView;
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, strong) UIButton *lightingButton;

@end

@implementation WBQRCodeScanningVC

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.scanningView addTimer];
    [_manager startRunning];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.scanningView removeTimer];
}

- (void)dealloc {
    NSLog(@"WBQRCodeScanningVC - dealloc");
    [self removeScanningView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor clearColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.scanningView];
    [self setupNavigationBar];
    [self setupQRCodeScanning];
    [self.view addSubview:self.promptLabel];
    [self.view addSubview:self.lightingButton];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"backWhite"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(goBackAction)];
    
    self.navigationItem.leftBarButtonItem = backBtn;
    
    // Do any additional setup after loading the view.
}

- (void)goBackAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupNavigationBar {
    self.navigationItem.title = JQGetStringWithKeyFromTable(@"扫一扫", nil);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:JQGetStringWithKeyFromTable(@"相册", nil) style:(UIBarButtonItemStyleDone) target:self action:@selector(rightBarButtonItenAction)];
}

- (SGQRCodeScanningView *)scanningView {
    if (!_scanningView) {
        _scanningView = [[SGQRCodeScanningView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _scanningView.scanningImageName = @"SGQRCode.bundle/QRCodeScanningLine";
        _scanningView.scanningAnimationStyle = ScanningAnimationStyleDefault;
        _scanningView.cornerColor = [UIColor orangeColor];
    }
    return _scanningView;
}
- (void)removeScanningView {
    [self.scanningView removeTimer];
    [self.scanningView removeFromSuperview];
    self.scanningView = nil;
}

- (void)rightBarButtonItenAction {
    SGQRCodeAlbumManager *manager = [SGQRCodeAlbumManager sharedManager];
    [manager readQRCodeFromAlbumWithCurrentController:self];
    manager.delegate = self;
    
    if (manager.isPHAuthorization == YES) {
        [self.scanningView removeTimer];
    }
}

- (void)setupQRCodeScanning {
    self.manager = [SGQRCodeScanManager sharedManager];
    NSArray *arr = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    // AVCaptureSessionPreset1920x1080 推荐使用，对于小型的二维码读取率较高
    [_manager setupSessionPreset:AVCaptureSessionPreset1920x1080 metadataObjectTypes:arr currentController:self];
    [_manager cancelSampleBufferDelegate];
    _manager.delegate = self;
}

#pragma mark - - - SGQRCodeAlbumManagerDelegate
- (void)QRCodeAlbumManagerDidCancelWithImagePickerController:(SGQRCodeAlbumManager *)albumManager {
    [self.view addSubview:self.scanningView];
}
- (void)QRCodeAlbumManager:(SGQRCodeAlbumManager *)albumManager didFinishPickingMediaWithResult:(NSString *)result {
//    if ([result hasPrefix:@"http"]) {
//        ScanSuccessJumpVC *jumpVC = [[ScanSuccessJumpVC alloc] init];
//        jumpVC.comeFromVC = ScanSuccessJumpComeFromWB;
//        jumpVC.jump_URL = result;
//        [self.navigationController pushViewController:jumpVC animated:YES];
//
//    } else {
//        ScanSuccessJumpVC *jumpVC = [[ScanSuccessJumpVC alloc] init];
//        jumpVC.comeFromVC = ScanSuccessJumpComeFromWB;
//        jumpVC.jump_bar_code = result;
//        [self.navigationController pushViewController:jumpVC animated:YES];
//    }
    if (self.ScanResultBlock) {
        self.ScanResultBlock(result);
    }
    [self.navigationController popViewControllerAnimated:NO];
    
}
- (void)QRCodeAlbumManagerDidReadQRCodeFailure:(SGQRCodeAlbumManager *)albumManager {
    NSLog(@"暂未识别出二维码");
    [UniversalManager showWithTipsMessage:JQGetStringWithKeyFromTable(@"暂未识别出二维码", nil)];
}

#pragma mark - - - SGQRCodeScanManagerDelegate
- (void)QRCodeScanManager:(SGQRCodeScanManager *)scanManager didOutputMetadataObjects:(NSArray *)metadataObjects {
    NSLog(@"metadataObjects - - %@", metadataObjects);
    if (metadataObjects != nil && metadataObjects.count > 0) {
        [scanManager playSoundName:@"SGQRCode.bundle/sound.caf"];
        [scanManager stopRunning];
        
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
//        ScanSuccessJumpVC *jumpVC = [[ScanSuccessJumpVC alloc] init];
//        jumpVC.comeFromVC = ScanSuccessJumpComeFromWB;
//        jumpVC.jump_URL = [obj stringValue];
//        [self.navigationController pushViewController:jumpVC animated:YES];
        if (self.ScanResultBlock) {
            self.ScanResultBlock([obj stringValue]);
        }
        [self.navigationController popViewControllerAnimated:NO];
        
    } else {
        NSLog(@"暂未识别出扫描的二维码");
        [UniversalManager showWithTipsMessage:JQGetStringWithKeyFromTable(@"暂未识别出二维码", nil)];
    }
}

- (UILabel *)promptLabel {
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.backgroundColor = [UIColor clearColor];
        CGFloat promptLabelX = 0;
        CGFloat promptLabelY = 0.73 * self.view.frame.size.height;
        CGFloat promptLabelW = self.view.frame.size.width;
        CGFloat promptLabelH = 35;
        _promptLabel.frame = CGRectMake(promptLabelX, promptLabelY, promptLabelW, promptLabelH);
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        _promptLabel.font = [UIFont boldSystemFontOfSize:13.0];
        _promptLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
        _promptLabel.text = JQGetStringWithKeyFromTable(@"将二维码放入框内, 即可自动扫描", nil);
        _promptLabel.numberOfLines = 0;
    }
    return _promptLabel;
}

- (UIButton *)lightingButton
{
    if (!_lightingButton) {
        _lightingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *lighting = [UIImage imageNamed:@"SGQRCode.bundle/QRCodeLighting"];
        CGFloat promptLabelY = 0.73 * self.view.frame.size.height+ 50;
        _lightingButton.frame = CGRectMake(self.view.center.x - lighting.size.width/2.0f, promptLabelY, lighting.size.width, lighting.size.height);
        [_lightingButton setImage:[UIImage imageNamed:@"SGQRCode.bundle/QRCodeLighting"] forState:UIControlStateNormal];
        [_lightingButton addTarget:self action:@selector(operationLighting:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lightingButton;
}

- (void)operationLighting:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [SGQRCodeHelperTool SG_openFlashlight];
    }else
    {
        [SGQRCodeHelperTool SG_CloseFlashlight];
    }
}

@end

