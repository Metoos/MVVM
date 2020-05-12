//
//  WBQRCodeScanningVC.h
//  SGQRCodeExample
//
//  Created by kingsic on 2018/2/8.
//  Copyright © 2018年 kingsic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBQRCodeScanningVC : UIViewController

@property (nonatomic)void(^ScanResultBlock)(NSString *result);

@end
