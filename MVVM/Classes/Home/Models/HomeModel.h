//
//  HomeModel.h
//  TongLian
//
//  Created by life on 2018/2/26.
//  Copyright © 2018年 hdyg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JQBaseModel.h"
#import "Singleton.h"
@class HomeDataEntity,
HomeBannerEntity,
HomeZodiacListData;


@interface HomeModel : JQBaseModel


@property (copy, nonatomic) HomeDataEntity *data;

@property (copy, nonatomic) NSString *title;

@property (copy, nonatomic) NSString *isSms;

@end


@interface HomeDataEntity : NSObject


@end

