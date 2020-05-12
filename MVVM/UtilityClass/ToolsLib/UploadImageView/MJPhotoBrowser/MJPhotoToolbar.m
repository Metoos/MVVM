//
//  MJPhotoToolbar.m
//  FingerNews
//
//  Created by mj on 13-9-24.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MJPhotoToolbar.h"
#import "MJPhoto.h"
//#import "MBProgressHUD+Add.h"

@interface MJPhotoToolbar()
{
    // 显示页码
    UILabel *_indexLabel;
    //显示标题
    UILabel *_indexTitle;
    UIButton *_saveImageBtn;
}
@end

@implementation MJPhotoToolbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    
    if (_photos.count > 1) {
        _indexLabel = [[UILabel alloc] init];
        _indexLabel.font = [UIFont boldSystemFontOfSize:14];
        _indexLabel.frame =  CGRectMake(0, 30, self.frame.size.width, 26);
        _indexLabel.backgroundColor = [UIColor clearColor];
        _indexLabel.textColor = [UIColor whiteColor];
        _indexLabel.textAlignment = NSTextAlignmentCenter;
        _indexLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:_indexLabel];
        
        
    }
    _indexTitle = [[UILabel alloc] init];
    _indexTitle.font = [UIFont boldSystemFontOfSize:16];
    _indexTitle.frame =  CGRectMake(0, 10, self.frame.size.width, 30);
    _indexTitle.backgroundColor = [UIColor clearColor];
    _indexTitle.textColor = [UIColor whiteColor];
    _indexTitle.textAlignment = NSTextAlignmentCenter;
    _indexTitle.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    _indexTitle.text = @"恒大酒店夜景";
    [self addSubview:_indexTitle];
    
    // 保存图片按钮
    CGFloat btnWidth = self.bounds.size.height;
    _saveImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _saveImageBtn.frame = CGRectMake(self.bounds.size.width - btnWidth - 10, 10, btnWidth, btnWidth);
    _saveImageBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//    [_saveImageBtn setImage:[UIImage imageNamed:@"MJPhotoBrowser.bundle/save_icon.png"] forState:UIControlStateNormal];
//    [_saveImageBtn setImage:[UIImage imageNamed:@"MJPhotoBrowser.bundle/save_icon_highlighted.png"] forState:UIControlStateHighlighted];
    
    [_saveImageBtn setTitle:@"保存" forState:UIControlStateNormal];
    [_saveImageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _saveImageBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
 
    [_saveImageBtn addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_saveImageBtn];
}

- (void)saveImage
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        MJPhoto *photo = _photos[_currentPhotoIndex];
        UIImageWriteToSavedPhotosAlbum(photo.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    });
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
//        [MBProgressHUD showError:@"保存失败" toView:nil];
        [SVProgressHUD showErrorWithStatus:@"保存失败"];
        [self performSelector:@selector(tipss) withObject:nil afterDelay:1];
       
        NSLog(@"error%@",error);
    } else {
        MJPhoto *photo = _photos[_currentPhotoIndex];
        photo.save = YES;
        _saveImageBtn.hidden = YES;
    
        [_saveImageBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        [MBProgressHUD showSuccess:@"成功保存到相册" toView:nil];
        [SVProgressHUD showSuccessWithStatus:@"成功保存到相册"];
    }
}

- (void)tipss
{
//     [MBProgressHUD showError:@"请设置“照片”访问权限" toView:nil];
    [SVProgressHUD showErrorWithStatus:@"请设置“照片”访问权限"];
}

- (void)setCurrentPhotoIndex:(NSUInteger)currentPhotoIndex
{
    _currentPhotoIndex = currentPhotoIndex;
    
    // 更新页码
    _indexLabel.text = [[NSString alloc] initWithFormat:@"%lu / %lu", _currentPhotoIndex + 1, (unsigned long)_photos.count];
    
    MJPhoto *photo = _photos[_currentPhotoIndex];
    //设置图片标题
    _indexTitle.text = photo.imgTitle;
    
    // 按钮
    _saveImageBtn.hidden = !(photo.image != nil && !photo.save);
    if (_saveImageBtn.hidden) {
        [_saveImageBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }else
    {
         [_saveImageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
   
}

@end
