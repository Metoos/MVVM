//
//  WebViewController.h
//  LKC
//
//  Created by life on 2018/4/16.
//  Copyright © 2018年 hdyg. All rights reserved.
//

#import "JQBaseViewController.h"

@interface WebViewController : JQBaseViewController

- (instancetype) initWithURLString:(NSString *)urlString;

- (instancetype) initWithHTMLString:(NSString *)htmlString;

@property (strong, nonatomic) NSString *urlString;

@property (assign, nonatomic) BOOL isHiddenBackItem;


- (void)loadRequest:(NSString *)urlString;


@end
