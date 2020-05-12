//
//  JQUploadImageView.h
//  SilverLetterFinancial
//
//  Created by mac on 2017/7/7.
//  Copyright © 2017年 zongsheng. All rights reserved.
//
typedef NS_ENUM(NSUInteger, UploadState) {
    UploadingState = 1,  //上传中...
    UploadErrorState,//上传出错
    UploadFinishState,   //上传完成
};

typedef void(^ReuploadBlock)(UIView *sender,UIImage *image);
typedef void(^uploadStateBlock)(UIView *sender,NSString *url,UploadState uploadState);
typedef void(^uploadCompletionBlock)(BOOL finished);
typedef void(^uploadDeleteBlock)(NSInteger index);
#import <UIKit/UIKit.h>
#import "JQUpload.h"
@interface JQUploadImageView : UIView

@property (strong, nonatomic, readonly) UIImageView *imageView;
/** 占位图 */
@property (strong, nonatomic) UIImage *placeHolderImage;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *imageUrl;
/** 设置图片内容展示模式 */
@property (assign, nonatomic) UIViewContentMode imageContentMode;
/** 上传完成后获取到的url */
@property (strong, nonatomic, readonly) NSString *url;
/** 上传过程状态 */
@property (assign, nonatomic, readonly) UploadState uploadState;

@property (assign, nonatomic) CGFloat progress;

@property (nonatomic, assign) CGFloat progressLineWidth;

@property (nonatomic, strong) UIFont *progressLabelFont;

/** 图片上传操作类 */
@property (strong, nonatomic) JQUpload *uploadEngine;
//@property (weak, nonatomic) id<JQUploadDelegate>deleagate;

//是否为添加图片
@property (assign, nonatomic) BOOL isAddImgType;
//是否选中
@property (assign, nonatomic) BOOL isSelected;
//是否添加删除按钮
@property (assign, nonatomic) BOOL isCanDelete;
//是否添加删除按钮图片
@property (strong, nonatomic) UIImage *deleteImage;

@property (copy, nonatomic) uploadDeleteBlock uploadDeleteBlock;

//上传file 后台对应的接受字段 默认为 "file"
@property (nonatomic, strong) NSString * fieldName;
/**初始化自动上传操作引擎*/
- (void)initUploadEnginePostUrl:(NSString *)url parameters:(id)param;
/** 处理上传图片数据格式并上传到服务器 */
- (void)uploadProcessImage:(UIImage *)image completion:(uploadCompletionBlock)completion;

/** 初始化上传操作引擎 */
- (void)initUploadEngineTarget:(UIViewController<JQUploadDelegate> *)target postUrl:(NSString *)url parameters:(NSDictionary *)param;
/**- 初始化上传操作引擎 */
- (void)initUploadEngineTarget:(id)target delegate:(id<JQUploadDelegate>)delegate postUrl:(NSString *)url parameters:(NSDictionary *)param;


/** 上传错误时点击重新上传操作后的回调 */
- (void)reuploadBlock:(ReuploadBlock)reuploadBlock;
/** 上传状态改变时回调 */
- (void)uploadStateChangeBlock:(uploadStateBlock)uploadStateBlock;
/** 改变上传状态 */
- (void)setUploadState:(UploadState)uploadState;

/** 上传完成状态 */
- (void)setUploadFinishStateWithUrl:(NSString*)url;

@end
