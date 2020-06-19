//
//  JQUploadMoreImagesView.m
//  KuangJinApp
//
//  Created by life on 2020/1/7.
//  Copyright © 2020 jingdu. All rights reserved.
//

#import "JQUploadMoreImagesView.h"
#import "TZImagePickerController.h"
#import "MJPhotoBrowser.h"
#define isWidthOddNumber (int)self.frame.size.width % (int)self.columns != 0
#define kDeleteButtonExceedHeight 10
#define kGridColumnsSpace 10
#define kGridRowSpace 10
#define kTag 3293986
#define kImagesMaxCount 4
@interface JQUploadMoreImagesView()<TZImagePickerControllerDelegate>
{
    
    NSArray *_items;
    NSArray *_itemUrls;
}
@property (nonatomic, strong) NSMutableArray *mutableItmeViews;

@property (nonatomic, strong) NSArray *oldItmeViews;

@property (nonatomic, copy) JQUploadDidClickItemBlock block;

//@property (nonatomic, copy) JQUploadDidResultBlock resultBlock;

@property (strong, nonatomic) JQUploadImageView *addImageView;

@property (nonatomic, strong) NSString *requestUrl;

@property (nonatomic, strong) NSDictionary *parameters;

@property (nonatomic, strong) NSString * fieldName;

@property (nonatomic, strong) NSMutableArray *addItmeImages;
//直接返回所有子视图
//@property (nonatomic, strong) NSArray<JQUploadImageView *> *itmeViews;
/** 所有图片总数
 */
@property (nonatomic, assign) NSUInteger count;

@end

@implementation JQUploadMoreImagesView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        [self setup];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
        
    }
    return self;
}
- (NSArray<JQUploadImageView *> *)ItmeViews
{
    
    NSMutableArray *itmeViews = [[NSMutableArray alloc]initWithArray:self.mutableItmeViews];
    
    if ([itmeViews containsObject:self.addImageView]) {
        [itmeViews removeObject:self.addImageView];
    }
    return itmeViews;
}

- (void)setup
{
    self.columns = 4;
    self.imagesMaxCount = kImagesMaxCount;
    self.isCanDelete = YES;
    self.allowPreview = YES;
    self.reshapeScale = 1;
    self.columnsSpace = kGridColumnsSpace;
    self.rowSpace = kGridRowSpace;
    self.addImageView.frame = CGRectMake(0, 0, self.height, self.height);
    [self addSubview:self.addImageView];
    [self.mutableItmeViews addObject:self.addImageView];
    
}

- (NSMutableArray *)mutableItmeViews {
    if (_mutableItmeViews == nil) {
        _mutableItmeViews = [NSMutableArray array];
    }
    return _mutableItmeViews;
}


- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat imagesW = (self.frame.size.width - (self.columns-1)*self.columnsSpace) / self.columns;
    if (self.columns > 0 && self.mutableItmeViews>0) {
        if (isWidthOddNumber) { //iphone6或iphone6+
            imagesW = (int)round(imagesW);
        }
        
        CGFloat exceedHeight = self.isCancelDeleteImage?0:kDeleteButtonExceedHeight;
        NSInteger rows = ((self.imagesMaxCount - 1) / self.columns + 1);
        CGFloat imagesH = (self.frame.size.height - (rows-1)*self.rowSpace - exceedHeight) / rows;
    //    CGFloat buttonH = 60.0;
        for (int index = 0; index < self.mutableItmeViews.count; index++) {
            
            if (isWidthOddNumber) {
                if ((index + 1) * self.columns == 0) {
                    imagesW = imagesW - 1;
                }
            }
            // i这个位置对应的列数
            int col = index % self.columns;
            // i这个位置对应的行数
            int row = index / self.columns;
            
            CGFloat imagesX = (imagesW + self.columnsSpace) * col;
            CGFloat imagesY = (imagesH + self.rowSpace + exceedHeight) * row + exceedHeight;
            DLog(@"%@",NSStringFromCGRect(CGRectMake(imagesX, imagesY, imagesW, imagesH)));
            __weak __typeof(&*self)weakSelf = self;
            [UIView animateWithDuration:0.3 animations:^{
                [weakSelf.mutableItmeViews[index] setFrame:CGRectMake(imagesX, imagesY, imagesW, imagesH)];
            }];
            
            
        }
    }
}

- (void)setItems:(NSArray<UIImage*> *)items {
    
    //kvo通知值改变
//    [self willChangeValueForKey:@"items"];
    _items = items;
//    [self didChangeValueForKey:@"items"];
    
    !_itemsBlock?:_itemsBlock(_items);
    
    [self reloadData:items];
}

- (NSArray<UIImage *> *)items
{
    NSMutableArray *ary = [[NSMutableArray alloc]initWithCapacity:self.imagesMaxCount];
    [[self ItmeViews] enumerateObjectsUsingBlock:^(JQUploadImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.image) {
            [ary addObject:obj.image];
        }
    }];
    //kvo通知值改变
//    [self willChangeValueForKey:@"items"];
    _items = ary;
//    [self didChangeValueForKey:@"items"];
    return _items;
}


- (void)setItemUrls:(NSArray<NSString *> *)itemUrls
{
    //kvo通知值改变
//    [self willChangeValueForKey:@"itemUrls"];
    _itemUrls = itemUrls;
//    [self didChangeValueForKey:@"itemUrls"];
    
    [self reloadData:itemUrls];
}

- (NSArray<NSString *> *)itemUrls
{
    NSMutableArray *ary = [[NSMutableArray alloc]initWithCapacity:self.imagesMaxCount];
    [[self ItmeViews] enumerateObjectsUsingBlock:^(JQUploadImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.url) {
            [ary addObject:obj.url];
        }
    }];
    //kvo通知值改变
//    [self willChangeValueForKey:@"itemUrls"];
    _itemUrls = ary;
//    [self didChangeValueForKey:@"itemUrls"];
    
    return _itemUrls;
}



//增量添加数据
- (void)addData
{
    [self.addImageView removeFromSuperview];//先移除在视图最后面的添加按钮
    [self.mutableItmeViews removeLastObject];//并移除数组中最后面的添加按钮
    
    NSInteger count = self.items.count;
    
    CGFloat imagesW = (self.frame.size.width - (self.columns-1)*self.columnsSpace) / self.columns;
    for (int index = 0; index < self.addItmeImages.count; index++) {
        
        //        __block JQUploadImageView *uploadImageView = [self processUploadedImages:self.items[index]];
        //        uploadImageView.tag = index;
        //        if (!uploadImageView) {
        
        
        JQUploadImageView *uploadImageView = [[JQUploadImageView alloc] initWithFrame:CGRectMake(0, 0, imagesW, imagesW)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(itemclick:)];
        uploadImageView.isCanDelete = self.isCanDelete;
        uploadImageView.imageContentMode = self.imageContentMode;
        uploadImageView.placeHolderImage = self.placeholderImage?:placeholderImg;
        uploadImageView.tag = kTag + count + index;
//        uploadImageView.deleteImage = [UIImage imageNamed:@"删除"];
        WEAKIFY
        uploadImageView.uploadDeleteBlock = ^(NSInteger indexs) {
            STRONGIFY
            [self uploadDelete:indexs-kTag];
        };
        [uploadImageView addGestureRecognizer:tap];
        uploadImageView.image = self.addItmeImages[index];
        [uploadImageView initUploadEnginePostUrl:self.requestUrl parameters:self.parameters];
        uploadImageView.fieldName = self.fieldName;
        //        }
        
        if (uploadImageView.url == nil) {
            [uploadImageView.uploadEngine uploadProcessImage:uploadImageView.image];
        }
        [self addSubview:uploadImageView];
        [self.mutableItmeViews addObject:uploadImageView];
    }
    self.count = self.mutableItmeViews.count;
//    self.oldItmeViews = self.mutableItmeViews;
    
    [self additionAddImageView];
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    NSMutableArray *item = [[NSMutableArray alloc]initWithArray:self.items];
    [item addObjectsFromArray:self.addItmeImages];
//    //kvo通知值改变
//    [self willChangeValueForKey:@"items"];
    _items = item;
//    [self didChangeValueForKey:@"items"];
}

//刷新数据
- (void)reloadData:(NSArray *)itemsData
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.mutableItmeViews removeAllObjects];
    CGFloat imagesW = (self.frame.size.width - (self.columns-1)*self.columnsSpace) / self.columns;
    
    
    for (int index = 0; index < itemsData.count; index++) {
        
        //        __block JQUploadImageView *uploadImageView = [self processUploadedImages:self.items[index]];
        //        uploadImageView.tag = index;
        //        if (!uploadImageView) {
        JQUploadImageView *uploadImageView = [[JQUploadImageView alloc] initWithFrame:CGRectMake(0, 0, imagesW, imagesW)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(itemclick:)];
        uploadImageView.isCanDelete = self.isCanDelete;
        uploadImageView.imageContentMode = self.imageContentMode;
        uploadImageView.placeHolderImage = self.placeholderImage?:placeholderImg;
        uploadImageView.tag = kTag+index;
//        uploadImageView.deleteImage =  [UIImage imageNamed:@"删除"];
        WEAKIFY
        uploadImageView.uploadDeleteBlock = ^(NSInteger indexs) {
            STRONGIFY
            [self uploadDelete:indexs-kTag];
        };
        [uploadImageView addGestureRecognizer:tap];
        id data = itemsData[index];
        if ([data isKindOfClass:UIImage.class]) {
            uploadImageView.image = (UIImage *)data;
        }else if([data isKindOfClass:NSString.class])
        {
        
            uploadImageView.imageUrl = (NSString *)data;
        }
        
        [uploadImageView initUploadEnginePostUrl:self.requestUrl parameters:self.parameters];
        uploadImageView.fieldName = self.fieldName;
        //        }
        
        if (uploadImageView.url == nil) {
            [uploadImageView.uploadEngine uploadProcessImage:uploadImageView.image];
        }
        [self addSubview:uploadImageView];
        [self.mutableItmeViews addObject:uploadImageView];
    }
    
    self.count = self.mutableItmeViews.count;
    [self additionAddImageView];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

//添加添加图片按钮
- (void)additionAddImageView
{
    //添加图片按钮
    if (self.mutableItmeViews.count<self.imagesMaxCount) {
        [self addSubview:self.addImageView];
        [self.mutableItmeViews addObject:self.addImageView];
    }
//    self.oldItmeViews = self.mutableItmeViews;
}

- (void)uploadDelete:(NSInteger)tag
{
    JQUploadImageView *uploadImageView = [self.mutableItmeViews objectAtIndex:tag];
    [uploadImageView removeFromSuperview];
    [self.mutableItmeViews removeObjectAtIndex:tag];
//    self.oldItmeViews = self.mutableItmeViews;
    self.count = [self ItmeViews].count;
    if (self.count == self.imagesMaxCount-1) {
        CGFloat imagesW = (self.frame.size.width - (self.columns-1)*self.columnsSpace) / self.columns;
        self.addImageView.x = (imagesW * (self.columns-1))+((self.columns-1)*self.columnsSpace);
        if (self.imagesMaxCount == 1) {
            self.addImageView.x = 0;
        }
        
        [self additionAddImageView];
    }
    [self updateTag];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

//更新subviews的tag值 用于下标
- (void)updateTag
{
    [self.mutableItmeViews enumerateObjectsUsingBlock:^(JQUploadImageView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!obj.isAddImgType) { //添加按钮不需要添加tag也不需要更新
            obj.tag = kTag+idx;
        }
    }];
}



- (void)addClik:(UITapGestureRecognizer *)tap
{
    [self openTZImagePickerController:self.imagesMaxCount-self.items.count isCropping:YES];
}

- (void)setUploadEnginePostUrl:(NSString *)url parameters:(id)param field:(NSString *)name
{
    self.requestUrl = url;
    self.parameters = param;
    self.fieldName  = name;
}

//- (void)setUploadDidResultBlock:(JQUploadDidResultBlock)uploadDidResultBlock
//{
//    self.resultBlock = uploadDidResultBlock;
//}


- (void)openTZImagePickerController:(NSInteger)maxCount isCropping:(BOOL)cropping
{
    [self.addItmeImages removeAllObjects];
    __block TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:maxCount>1?maxCount:1 delegate:self];
    imagePickerVc.maxImagesCount = maxCount;
    imagePickerVc.isSelectOriginalPhoto = YES;
    imagePickerVc.allowCrop = cropping;
    CGFloat cropViewW = MIN(kViewWidth, kViewHeight);
    CGFloat cropViewH = cropViewW/self.reshapeScale;
    imagePickerVc.cropRect = CGRectMake(0, (kViewHeight - cropViewH) / 2, cropViewW, cropViewH);
    // You can get the photos by block, the same as by delegate.
    
    // 你可以通过block或者代理，来得到用户选择的照片.

    
//    NSMutableArray *imgPaths = [[NSMutableArray alloc]init];
    WEAKIFY
    [imagePickerVc setDidFinishPickingPhotosWithInfosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto, NSArray<NSDictionary *> *infos) {
        STRONGIFY
        
        [self.addItmeImages addObjectsFromArray:photos];
        //添加图片数据
         [self addData];
//        WEAKIFY
//        [assets enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL * _Nonnull stop) {
//            STRONGIFY
//            //转化NSData
//            PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
//            PHImageRequestOptions *option = [PHImageRequestOptions new];
//            option.resizeMode = PHImageRequestOptionsResizeModeFast;
//            option.synchronous = YES;
//            WEAKIFY
//            [imageManager requestImageDataForAsset:asset
//                                           options:option
//                                     resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
//                STRONGIFY
//                NSData *data = imageData;
//                UIImage *image = [[UIImage alloc]initWithData:data];
//
//                [self.addItmeImages addObject:image];
//            }];
//        }];
//        //添加图片数据
//        [self addData];
        
    }];
    [[UniversalManager getCurrentViewController] presentViewController:imagePickerVc animated:YES completion:nil];
}

- (NSArray *)getUploadResultUrlArray
{
    
    NSMutableArray *ary = [[NSMutableArray alloc]init];
    for (JQUploadImageView *obj in self.mutableItmeViews) {
        if (obj.url) {
            [ary addObject:obj.url];
        }
    }
    return ary;
    
}

- (void)setAddImage:(UIImage *)addImage
{
    _addImage = addImage;
    self.addImageView.placeHolderImage = _addImage;
}

//处理已经上传过的图片 如果已经上传过则直接用已有的
//- (JQUploadImageView *)processUploadedImages:(UIImage *)image
//{
//    for (JQUploadImageView *obj in self.oldItmeViews) {
//
//        if ([[self imageConvertData:obj.image] isEqualToData:[self imageConvertData:image]]) {
//            return obj;
//        }
//    }
//    return nil;
//}

- (NSData *)imageConvertData:(UIImage *)image
{
    NSData *data = UIImagePNGRepresentation(image);
    if (data == nil) {
        data = UIImageJPEGRepresentation(image, 1);
    }
    
    return data;
}

- (JQUploadImageView *)addImageView
{
    if (!_addImageView) {
        _addImageView = [[JQUploadImageView alloc] init];
        _addImageView.placeHolderImage = self.addImage?:[UIImage imageNamed:@"JQUploadImageView.bundle/添加"];
        _addImageView.isAddImgType = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addClik:)];
        [_addImageView addGestureRecognizer:tap];
    }
    return _addImageView;
}

- (void)setUploadDidClickItemBlock:(JQUploadDidClickItemBlock)uploadDidClickItemBlock
{
    self.block = uploadDidClickItemBlock;
}

- (NSMutableArray *)addItmeImages
{
    if (!_addItmeImages) {
        _addItmeImages = [[NSMutableArray alloc]init];
    }
    return _addItmeImages;
}

- (void)itemclick:(UITapGestureRecognizer *)tap {
    
    JQUploadImageView *uploadImageView = (JQUploadImageView*)tap.view;
    !_block?:_block(uploadImageView,uploadImageView.tag-kTag);
    
    if (self.allowPreview) {
        NSMutableArray *itemsArray = [NSMutableArray arrayWithArray:[self ItmeViews]];
        NSMutableArray *itemsImageViewArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:itemsArray.count];
        if (self.itemUrls && itemsArray.count != self.items.count) {
            [itemsArray enumerateObjectsUsingBlock:^(JQUploadImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.image) {
                    [array addObject:obj.image];
                    
                    UIImageView *image = [[UIImageView alloc]initWithImage:obj.image];
                    image.frame = obj.frame;
                    [itemsImageViewArray addObject:image];
                }else if (obj.url) {
                    [array addObject:obj.url];
                    UIImageView *image = [[UIImageView alloc]init];
                    image.frame = obj.frame;
                    [itemsImageViewArray addObject:image];
                }
            }];
            [self photoBrowserWithPicForUrlOrImageArray:array withSrcImageViewArray:itemsImageViewArray currentPhotoIndex:uploadImageView.tag-kTag];
        }else{
            [self photoBrowserWithPicForUrlOrImageArray:self.items withSrcImageViewArray:itemsArray currentPhotoIndex:uploadImageView.tag-kTag];
        }
    }

    
    
}


#pragma -mark 浏览图片
- (void)photoBrowserWithPicForUrlOrImageArray:(NSArray*)array withSrcImageViewArray:(NSArray *)imageViewArray currentPhotoIndex:(NSInteger)index
{
    // 1.创建图片浏览器
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    
    // 2.设置图片浏览器显示的所有图片
    NSMutableArray *photos = [NSMutableArray array];
    NSUInteger count = array.count;
    for (int i = 0; i <count; i++){
        //        MLooPhoto *pic = [[MLooPhoto alloc] init];
        //        pic.original_pic = self.picUrls[i];
        //
        MJPhoto *photo = [[MJPhoto alloc] init];
        if ([array[i] isKindOfClass:[NSString class]]) {
            photo.url = [NSURL URLWithString:array[i]];
        }else
        {
            photo.image = array[i];
        }
        
        
        if (imageViewArray.count > i) {
            //设置来源于哪一个UIImageView
            photo.srcImageView = imageViewArray[i];
        }
        
        
        [photos addObject:photo];
    }
    browser.photos = photos;
    
    // 3.设置默认显示的图片索引
    browser.currentPhotoIndex = index;
    
    // 4.显示浏览器
    [browser show];
}

@end
