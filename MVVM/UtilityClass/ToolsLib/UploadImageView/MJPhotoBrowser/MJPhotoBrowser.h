//
//  MJPhotoBrowser.h
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.

#import <UIKit/UIKit.h>
#import "MJPhoto.h"
#import "SDWebImageManager+MJ.h"
#import "MJPhotoView.h"
#import "MJPhotoToolbar.h"

@protocol MJPhotoBrowserDelegate;
@interface MJPhotoBrowser : UIViewController <UIScrollViewDelegate,MJPhotoViewDelegate>
// 代理
@property (nonatomic, weak) id<MJPhotoBrowserDelegate> delegate;
// 所有的图片对象
@property (nonatomic, strong) NSArray *photos;

/** 是否隐藏工具栏 */
@property (nonatomic, assign) BOOL toolbarHidden;

// 当前展示的图片索引
@property (nonatomic, assign) NSUInteger currentPhotoIndex;
// 工具条
@property (nonatomic, strong) MJPhotoToolbar *toolbar;
/** 是否禁止图片轻拍动作响应 默认NO */
@property (nonatomic, assign) BOOL isForbidTap;

// 显示
- (void)show;

@end

@protocol MJPhotoBrowserDelegate <NSObject>
@optional
// 切换到某一页图片
- (void)photoBrowser:(MJPhotoBrowser *)photoBrowser didChangedToPageAtIndex:(NSUInteger)index;
@end
