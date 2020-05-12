//
//  HomeCellViewModel.m
//  MVVM
//
//  Created by mac on 2019/12/16.
//  Copyright © 2019 hdyg. All rights reserved.
//

#import "HomeCellViewModel.h"
#import "HomeModel.h"
@interface HomeCellViewModel()

@property (strong, nonatomic) HomeModel *entity;

@end

@implementation HomeCellViewModel
@dynamic entity;


- (NSString *)titleString
{
    return self.entity.title;
}

- (BOOL)isCanGetCaptcha
{
    return [self.entity.isSms isEqualToString:@"1"];
}

@end
