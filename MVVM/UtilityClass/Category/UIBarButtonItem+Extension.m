    //
//  UIBarButtonItem+Extension.m
//  BBA
//
//  Created by life on 2018/4/23.
//  Copyright © 2018年 hdyg. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"
#import "UIButton+WebCache.h"
#import <objc/runtime.h>
#import "UIImage+JQExtension.h"
static char CLICK_BLOCK_BACK;
@implementation UIBarButtonItem (Extension)


- (instancetype)initWithCustomViewWithImageUrlString:(NSString*)imageUrl placeholderImage:(UIImage*)placeholderImage Click:(ClickBlock)click
{
    self = [self init];
    
    UIButton *barButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    //使用图片原图
////    placeholderImage = [placeholderImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    CGFloat originalWidth = placeholderImage.size.width;
//    CGFloat originalHeight = placeholderImage.size.height;
//    CGSize size = CGSizeMake(30.0f, 30.0f*originalHeight/originalWidth);  //固定宽 高按图片宽高比自动缩放
//
//    placeholderImage = [UIImage resizedImage:placeholderImage toSize:size];
//
//    [barButton setImage:[placeholderImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
//    dispatch_async(dispatch_get_global_queue(0,0), ^{
//
//        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
//        UIImage *image = [UIImage imageWithData:imageData];
//
//        if (!image) {
//            image = placeholderImage;
//        }
//        //使用图片原图
//        UIImage *rightImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        CGFloat originalWidth = image.size.width;
//        CGFloat originalHeight = image.size.height;
//        CGSize size = CGSizeMake(30.0f, 30.0f*originalHeight/originalWidth);  //固定宽 高按图片宽高比自动缩放
//
//        rightImage = [UIImage resizedImage:rightImage toSize:size];
//                //切圆角
//        rightImage  = [rightImage circleImage];
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [barButton setImage:rightImage forState:UIControlStateNormal];
////            barButton.layer.cornerRadius = barButton.size.width/2.0f;
////            barButton.layer.masksToBounds = YES;
//        });
//    });
    //使用SDWebImage来加载图片
    [barButton sd_setBackgroundImageWithURL:[NSURL URLWithString:imageUrl] forState:UIControlStateNormal placeholderImage:placeholderImage];
    [barButton addTarget:self action:@selector(barBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    barButton.frame = CGRectMake(0, 0, 30.0f, 30.0f);
    self.customView = barButton;
    self.ClickBlock = click;
    
    return self;
}

- (instancetype)initWithCustomViewWithCircleImageUrlString:(NSString*)imageUrl placeholderImage:(UIImage*)placeholderImage Click:(ClickBlock)click
{
    self = [self init];

    UIButton *barButton = [UIButton buttonWithType:UIButtonTypeCustom];
    barButton.frame = CGRectMake(0, 0, 30, 30);
//
//    //使用图片原图
//    //    placeholderImage = [placeholderImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    CGFloat originalWidth = placeholderImage.size.width;
//    CGFloat originalHeight = placeholderImage.size.height;
//    CGSize size = CGSizeMake(30.0f, 30.0f*originalHeight/originalWidth);  //固定宽 高按图片宽高比自动缩放
//
//    placeholderImage = [UIImage resizedImage:placeholderImage toSize:size];
//
//    [barButton setImage:[placeholderImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
//    dispatch_async(dispatch_get_global_queue(0,0), ^{
//
//        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
//        UIImage *image = [UIImage imageWithData:imageData];
//
//        if (!image) {
//            image = placeholderImage;
//        }
//        //使用图片原图
//        UIImage *rightImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        CGFloat originalWidth = image.size.width;
//        CGFloat originalHeight = image.size.height;
//        CGSize size = CGSizeMake(30.0f, 30.0f*originalHeight/originalWidth);  //固定宽 高按图片宽高比自动缩放
//
//        rightImage = [UIImage resizedImage:rightImage toSize:size];
//        //切圆角
//        rightImage  = [rightImage circleImage];
//
//
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [barButton setImage:rightImage forState:UIControlStateNormal];
//        });
//    });

    //使用SDWebImage来加载图片
    [barButton sd_setBackgroundImageWithURL:[NSURL URLWithString:imageUrl] forState:UIControlStateNormal placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        //使用图片原图
        UIImage *rightImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        CGFloat originalWidth = image.size.width;
//        CGFloat originalHeight = image.size.height;
//        CGSize size = CGSizeMake(30.0f, 30.0f*originalHeight/originalWidth);  //固定宽 高按图片宽高比自动缩放
//        //        //切圆角
//        rightImage = [UIImage resizedImage:rightImage toSize:size];
        rightImage  = [rightImage circleImage];
        [barButton setBackgroundImage:rightImage forState:UIControlStateNormal];
    }];
    [barButton addTarget:self action:@selector(barBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *containVew = [[UIView alloc] initWithFrame:barButton.bounds];
    [containVew addSubview:barButton];
    self.customView = containVew;
    self.ClickBlock = click;
    return self;
}



- (void)barBtnAction:(id)sender
{
    if (self.ClickBlock) {
        self.ClickBlock();
    }
}


- (void)setClickBlock:(ClickBlock)click
{
    objc_setAssociatedObject(self, &CLICK_BLOCK_BACK, click, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(ClickBlock)ClickBlock
{
    return objc_getAssociatedObject(self, &CLICK_BLOCK_BACK);
}

@end
