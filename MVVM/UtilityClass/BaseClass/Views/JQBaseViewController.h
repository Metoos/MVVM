//
//  JQBaseViewController.h
//  BBA
//
//  Created by life on 2018/1/24.
//  Copyright © 2018年 hdyg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JQBaseViewModel.h"
#import "JQBaseViewControllerProtocol.h"
@interface JQBaseViewController : UIViewController<JQBaseViewControllerProtocol>


/** BaseViewController 的基础ViewModel */
@property (nonatomic,strong,readonly) JQBaseViewModel *viewModel;

@end
