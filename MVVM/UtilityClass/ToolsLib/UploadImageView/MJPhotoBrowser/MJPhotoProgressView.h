//
//  MJPhotoProgressView.h
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJPhotoProgressView : UIView

@property (nonatomic, assign) CGFloat progressLineWidth;

@property (nonatomic, strong) UIFont *progressLabelFont;
@property(nonatomic, strong) UIColor *trackTintColor;
@property(nonatomic, strong) UIColor *progressTintColor;
@property (nonatomic) float progress;

@end
