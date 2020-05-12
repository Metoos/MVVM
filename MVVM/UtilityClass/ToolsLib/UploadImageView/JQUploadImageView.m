//
//  JQUploadImageView.m
//  SilverLetterFinancial
//
//  Created by mac on 2017/7/7.
//  Copyright © 2017年 zongsheng. All rights reserved.
//





#import "JQUploadImageView.h"
#import "JQProgressAnimatedView.h"
#import "Masonry.h"
//#import "UploadImageModel.h"
//bolck使用 避免循环引用
#define WeakSelf(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#define KWCircleLineWidth 3.0f
#define KWCircleFont [UIFont boldSystemFontOfSize:14.0f]

@interface JQUploadImageView()<UIGestureRecognizerDelegate,JQUploadDelegate>


@property (strong, nonatomic, readwrite) UIImageView *imageView;
@property (strong, nonatomic) UIImageView *maskLayerImageView;

//@property (strong, nonatomic) UILabel *errorLabel;

@property (strong, nonatomic) UIImageView *refershImage;

@property (strong, nonatomic) JQProgressAnimatedView *progressAnimatedView;

@property (strong, nonatomic) void(^ReuploadBlock)(UIView *sender,UIImage *image);

@property (strong, nonatomic) void(^uploadStateBlock)(UIView *sender,NSString *url,UploadState uploadState);

@property (strong, nonatomic) void(^uploadCompletionBlock)(BOOL finished);

/** 上传完成后获取到的url */
@property (strong, nonatomic) NSString *url;


/** 删除按钮 */
@property (strong, nonatomic) UIButton *deleteButton;

@end

@implementation JQUploadImageView



- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
         [self setViewConfig];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
         [self setViewConfig];
    }
    
    return self;
}

- (void)setViewConfig
{
    self.progressLineWidth = KWCircleLineWidth;
    self.progressLabelFont = KWCircleFont;
    
    self.deleteImage = [UIImage imageNamed:@"JQUploadImageView.bundle/删除.png"];
    
    /** 添加图片 */
    [self insertSubview:self.imageView atIndex:0];
    WeakSelf(ws);
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapOperationAction:)];
    self.refershImage.userInteractionEnabled = YES;
    tap.delegate = self;
    [self.refershImage addGestureRecognizer:tap];
}

#pragma mark-手势代理，解决和tableview点击发生的冲突
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UIButton"]) {//判断如果点击的是tableView的cell，就把手势给关闭了
        return NO;//关闭手势
    }//否则手势存在
    return YES;
}


- (void)setImage:(UIImage *)image
{
    _image = image;
    self.imageView.image = image?:_placeHolderImage;
    
    if (image && self.isCanDelete) {
        self.deleteButton.frame = CGRectMake(self.width-10, -10, 20, 20);
        [self addSubview:self.deleteButton];
    }
}

- (void)setIsCanDelete:(BOOL)isCanDelete
{
    _isCanDelete = isCanDelete;
    if (isCanDelete == NO) {
        self.deleteButton.hidden = YES;
    }else
    {
        self.deleteButton.hidden = NO;
    }
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.deleteButton.frame = CGRectMake(self.width-10, -10, 20, 20);
}

- (void)setDeleteImage:(UIImage *)deleteImage
{
    _deleteImage = deleteImage;
    [_deleteButton setImage:_deleteImage forState:UIControlStateNormal];
}
//删除按钮超出了父视图的悬空部分触摸处理
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView * view = [super hitTest:point withEvent:event];
    if (view == nil) {
        // 转换坐标系
        CGPoint newPoint = [self.deleteButton convertPoint:point fromView:self];
        // 判断触摸点是否在button上
        if (CGRectContainsPoint(self.deleteButton.bounds, newPoint)) {
            view = self.deleteButton;
        }
    }
    return view;
}

- (UIButton *)deleteButton
{
    if (_deleteButton == nil) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setImage:self.deleteImage forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

- (void)deleteAction:(id)sender
{
    self.image = nil;
    self.url = nil;
    !_uploadDeleteBlock?:_uploadDeleteBlock(self.tag);
}

- (void)setImageUrl:(NSString *)imageUrl
{
    _imageUrl = imageUrl;
    
    [self.imageView jq_setImageWithURL:imageUrl placeholderImage:self.placeHolderImage completed:^(UIImage *image) {
        self.image = image;
    }];
    if (_imageUrl) {
         _url = _imageUrl;
    }
   
}
- (void)setFieldName:(NSString *)fieldName
{
    _fieldName = fieldName;
    
    self.uploadEngine.fieldName = fieldName;
}

-(void)setPlaceHolderImage:(UIImage *)placeHolderImage
{
    _placeHolderImage = placeHolderImage;
    self.imageView.image = placeHolderImage;
}

- (void)setImageContentMode:(UIViewContentMode)imageContentMode
{
    _imageContentMode = imageContentMode;
    self.imageView.contentMode = imageContentMode;
}

- (void)didTapOperationAction:(UITapGestureRecognizer*)tap
{
    //重新上传一次
    [self.uploadEngine uploadProcessImage:self.image];
    
    if (self.ReuploadBlock) {
        self.ReuploadBlock(self, self.image);
    }
}

#pragma mark - 重新上传操作回调
- (void)reuploadBlock:(ReuploadBlock)reuploadBlock
{
    self.ReuploadBlock = reuploadBlock;
}
#pragma mark - 上传状态改变时回调
- (void)uploadStateChangeBlock:(uploadStateBlock)uploadStateBlock
{
    self.uploadStateBlock = uploadStateBlock;
    
}

#pragma mark - set上传完成状态
- (void)setUploadFinishStateWithUrl:(NSString*)url
{
    self.url = url;
    [self setUploadState:UploadFinishState];
    
//    [self.imageView jq_setImageWithURL:url placeholderImage:self.image];
    
}

#pragma mark - set上传状态
- (void)setUploadState:(UploadState)uploadState
{
    _uploadState = uploadState;
    
    switch (uploadState) {
        case UploadingState:
        {
            [self showUploadingView];
            if (self.uploadStateBlock) {
               self.uploadStateBlock(self, nil, UploadingState);
            }
            
            break;
        }
        case UploadErrorState:
        {
            [self showErrorView];
            if (self.uploadStateBlock) {
                self.uploadStateBlock(self, nil, UploadErrorState);
            }
            break;
        }
        case UploadFinishState:
        {
            [self dismessErrorView];
            [self dismessUploadingView];
            if (self.uploadStateBlock) {
                self.uploadStateBlock(self, _url, UploadFinishState);
            }
            break;
        }
        default:
            break;
    }
}
/** 显示加载中页面 */
- (void)showUploadingView
{
    //显示前移除其他同级试图
    [self dismessErrorView];

    WeakSelf(ws);
    [self insertSubview:self.maskLayerImageView aboveSubview:self.imageView];
    [self.maskLayerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.edges.equalTo(ws).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    
    [self insertSubview:self.progressAnimatedView aboveSubview:self.maskLayerImageView];
    [self.progressAnimatedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(ws);
        make.size.mas_offset(CGSizeMake(50, 50));
    }];
}
/** 移除加载中页面 */
- (void)dismessUploadingView
{
    [self.maskLayerImageView removeFromSuperview];
    [self.progressAnimatedView removeFromSuperview];
}

/** 显示上传失败或错误页面 */
- (void)showErrorView
{
    //显示前移除其他同级试图
    [self dismessUploadingView];
    WeakSelf(ws);
    [self insertSubview:self.maskLayerImageView aboveSubview:self.imageView];
    [self.maskLayerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.edges.equalTo(ws).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self insertSubview:self.refershImage aboveSubview:self.maskLayerImageView];
    [self.refershImage mas_makeConstraints:^(MASConstraintMaker *make) {
         make.edges.equalTo(ws).with.insets(UIEdgeInsetsMake(20, 20, 20, 20));
    }];
}
- (void)dismessErrorView
{
    [self.maskLayerImageView removeFromSuperview];
    [self.refershImage removeFromSuperview];
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
    self.progressAnimatedView.progress = _progress;

}
- (void)setProgressLabelFont:(UIFont *)progressLabelFont
{
    _progressLabelFont = progressLabelFont;
    self.progressAnimatedView.progressLabelFont = _progressLabelFont;
}
- (void)setProgressLineWidth:(CGFloat)progressLineWidth
{
    _progressLineWidth = progressLineWidth;
    self.progressAnimatedView.progressLineWidth = _progressLineWidth;
}

#pragma  mark - 初始化上传操作引擎
- (void)initUploadEngineTarget:(UIViewController<JQUploadDelegate> *)target postUrl:(NSString *)url parameters:(NSDictionary *)param
{
    self.uploadEngine.delegate = nil;
    self.uploadEngine = nil;
    self.uploadEngine = [[JQUpload alloc]initWithTarget:target sender:self postUrl:url parameters:param];
    self.uploadEngine.delegate = target;
}

#pragma  mark - 初始化上传操作引擎
- (void)initUploadEngineTarget:(id)target delegate:(id<JQUploadDelegate>)delegate postUrl:(NSString *)url parameters:(NSDictionary *)param
{
    self.uploadEngine.delegate = nil;
    self.uploadEngine = nil;
    self.uploadEngine = [[JQUpload alloc]initWithTarget:target sender:self postUrl:url parameters:param];
    self.uploadEngine.delegate = delegate;
}

#pragma  mark - 初始化自动上传操作引擎
- (void)initUploadEnginePostUrl:(NSString *)url parameters:(id)param
{
     self.uploadEngine = [[JQUpload alloc]initWithTarget:nil sender:self postUrl:url parameters:param];
    self.uploadEngine.delegate = self;
    
}
- (void)uploadProcessImage:(UIImage *)image completion:(uploadCompletionBlock)completion
{
    self.uploadCompletionBlock = completion;
    [self.uploadEngine uploadProcessImage:image];
}
#pragma  mark - 开始上传
- (void)uploadBeginWithUploadView:(JQUploadImageView *)uploadView
{
    // 同步到主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        [uploadView setUploadState:UploadingState];
    });
}
#pragma  mark -  图片上传进度
- (void)uploadWithUploadView:(JQUploadImageView *)uploadView Progress:(double)uploadProgress
{
    // 同步到主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        double progress = MAX(uploadProgress-0.01f, 0);
        [uploadView setProgress:progress];
    });
}
#pragma  mark - 上传成功回调
- (void)uploadSuceessWithUploadView:(JQUploadImageView *)uploadView task:(NSURLSessionDataTask *)task responseObject:(id)responseObject
{
//    UploadImageModel *model = [UploadImageModel mj_objectWithKeyValues:responseObject];
    DLog(@"图片上传结果 = %@",responseObject);
    // 同步到主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([responseObject[@"code"] integerValue] == successed) {
            NSString *url = [[responseObject toDict:@"data"] toString:@"src"];
            [uploadView setUploadFinishStateWithUrl:url];
            if (self.uploadCompletionBlock) {
                self.uploadCompletionBlock(YES);
            }
        }else
        {
            [uploadView setUploadState:UploadErrorState];
            if (self.uploadCompletionBlock) {
                self.uploadCompletionBlock(NO);
            }
        }
    });
    
}
#pragma  mark - 上传失败回调
- (void)uploadFailureWithUploadView:(JQUploadImageView *)uploadView task:(NSURLSessionDataTask *)task error:(NSError *)error responseObject:(id)responseObject
{
    DLog(@"图片上传结果error = %@ responseObject = %@",error,responseObject);
    // 同步到主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        [uploadView setUploadState:UploadErrorState];
    });
    
    if (self.uploadCompletionBlock) {
        self.uploadCompletionBlock(NO);
    }
}

#pragma mark -懒加载

- (UIImageView *)imageView
{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc]init];
        _imageView.clipsToBounds = YES;
//        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}
/** 黑色透明遮罩层 */
-(UIImageView *)maskLayerImageView
{
    if (_maskLayerImageView == nil) {
        
        _maskLayerImageView = [[UIImageView alloc]init];
        _maskLayerImageView.alpha = 0.5f;
        _maskLayerImageView.backgroundColor = [UIColor blackColor];
    }
    
    return _maskLayerImageView;
}
/** 加载动画view */
- (JQProgressAnimatedView *)progressAnimatedView
{
    if (_progressAnimatedView == nil) {
        _progressAnimatedView = [[JQProgressAnimatedView alloc]init];
        _progressAnimatedView.progressLabelFont = self.progressLabelFont;
        _progressAnimatedView.progressLineWidth = self.progressLineWidth;
    }
    return _progressAnimatedView;
}

-(UIImageView *)refershImage
{
    if (_refershImage == nil) {
        _refershImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"JQUploadImageView.bundle/刷新"]];
        _refershImage.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _refershImage;
}

@end
