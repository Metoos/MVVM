//
//  JQUpload.h
//  SilverLetterFinancial
//
//  Created by mac on 2017/7/10.
//  Copyright © 2017年 zjq. All rights reserved.
//
@protocol JQUploadDelegate <NSObject>

@optional
/** 选择回调的image */
- (void)selectWithUploadView:(UIView *)uploadView Image:(UIImage *)image;
/** 开始上传 */
- (void)uploadBeginWithUploadView:(UIView *)uploadView;
/** 图片上传进度 */
- (void)uploadWithUploadView:(UIView *)uploadView Progress:(double)uploadProgress;
/** 上传成功回调 */
- (void)uploadSuceessWithUploadView:(UIView *)uploadView task:(NSURLSessionDataTask *)task responseObject:(id)responseObject;
/** 上传失败回调 */
- (void)uploadFailureWithUploadView:(UIView *)uploadView task:(NSURLSessionDataTask *)task error:(NSError *)error responseObject:(id)responseObject;
@end


typedef NS_ENUM(NSUInteger, LoadfileType)
{
    LoadfileTypeHoldIdCard      = 1010, //手持身份证
    LoadfileTypeIdCardFront     = 1011, //身份证正面
    LoadfileTypeIdCardReverse   = 1012, //身份证反面
    LoadfileTypeBankCardFront   = 1020, //银行卡正面
    LoadfileTypeBankCardReverse = 1021, //银行卡反面

    LoadfileTypeDoorHead        = 1031, //店铺门头
    LoadfileTypeCashier         = 1032, //店铺收银
    LoadfileTypeBusinessLicense = 1033, //营业执照
    LoadfileTypeStoreInterior   = 1034, //店铺内景

};



#import <Foundation/Foundation.h>

@interface JQUpload : NSObject

- (instancetype)initWithTarget:(id)target sender:(UIView *)view postUrl:(NSString *)url parameters:(NSDictionary *)param;

//上传file 后台对应的接受字段 默认为 "file"
@property (nonatomic, strong) NSString * fieldName;

@property (weak, nonatomic) id<JQUploadDelegate>delegate;

/** 上传图标比例缩放宽度 */
@property (assign, nonatomic) CGFloat compressAndProportionWidth;

/** 上传方式 file格式上传图片 */
@property (assign, nonatomic) BOOL isFileUploadMethod;


/** 单张图片是否可编辑 Default YES **/
@property (assign, nonatomic) BOOL allowsEditing;

- (void)cancelRequest;

/** 开始选择上传的图片 */
- (void)selectImage;
/** 开始选择上传的图片
 *@prama reshapeScale 裁剪比例
 */
- (void)selectImageReshapeScale:(CGFloat)reshapeScale; //== 1为正方形

/** 开始拍照上传的图片
 *@prama reshapeScale 裁剪比例
 */
- (void)selectImageForCameralReshapeScale:(CGFloat)reshapeScale; //== 1为正方形

/** 处理上传图片数据格式并上传到服务器 */
- (void)uploadProcessImage:(UIImage *)image;
@end
