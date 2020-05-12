//
//  JQTouchIDAndFaceIDViewController.h
//  DigitalTreasure
//
//  Created by mac on 2019/9/10.
//  Copyright © 2019 hdyg. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^validationTouchIDDone)(BOOL pass,BOOL isNeedInput,NSString *payPwd);

@interface JQTouchIDAndFaceIDViewController : JQBaseViewController

@property (assign, nonatomic) BOOL isOpening;

- (void)validationDone:(validationTouchIDDone)done;


@end


