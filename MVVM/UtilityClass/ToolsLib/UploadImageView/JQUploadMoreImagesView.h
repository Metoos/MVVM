//
//  JQUploadMoreImagesView.h
//  KuangJinApp
//
//  Created by life on 2020/1/7.
//  Copyright © 2020 jingdu. All rights reserved.
//
/**
 多图片上传封装
 可任意设置图片数量上限
 自带调取选择图片器、也支持从外部传入图片数组
 自带上传引擎封装
 支持XIB、SB和纯代码集成
 集成图片上传失败提示及可点击重新上传
 集成上传进度条
 */
#import <UIKit/UIKit.h>
#import "JQUploadImageView.h"

typedef void(^JQUploadDidClickItemBlock)(JQUploadImageView *obj, NSInteger index);

typedef void(^JQSelectedItemsBlock)(NSArray<UIImage *> *items);

@interface JQUploadMoreImagesView : UIView



/** 所有图片总数
 */
@property (nonatomic, assign, readonly) NSUInteger count;

/** 图片数组
 * 可从外部传入UIImage 默认自动上传图片
 *  不传入数组也可从自带的图片选择器选取图片上传
 */
@property (nonatomic, strong) NSArray<UIImage *> *items;

/** 外部传入图片url数组展示
 * 可从外部传入图片url   默认自动加载显示图片
 */
@property (nonatomic, strong) NSArray<NSString *> *itemUrls;
/** 图片占位图
* 从外部传入图片url   网络图片未加载完成时先显示占位图
*/
@property (nonatomic, strong) UIImage *placeholderImage;



/** 每行显示图片数量 超过自动换行显示图片 默认 4 */
@property (nonatomic, assign) NSInteger columns;

//是否取消删除图片功能 默认NO
@property (nonatomic, assign) BOOL isCancelDeleteImage;

/** 允许上传的最大图片数量 默认4张 */
@property (nonatomic, assign) NSInteger imagesMaxCount;

/** 是否显示添加图片的按钮 */
@property (nonatomic, assign) BOOL isShowAddItem;

/** 添加图片占位图 */
@property (nonatomic, strong) UIImage *addImage;

/** 是否在右上角添加删除按钮  默认 YES*/
@property (assign, nonatomic) BOOL isCanDelete;

/** 列间距 */
@property (assign, nonatomic) CGFloat columnsSpace;

/** 行间距 */
@property (assign, nonatomic) CGFloat rowSpace;

/** 设置图片内容展示模式
 * 默认 UIViewContentModeScaleToFill
 */
@property (assign, nonatomic) UIViewContentMode imageContentMode;

/** 主动返回图片数组Block
 *数据与上面items属性一致，也可使用kvo监听items属性来即时获取选取或传入的图片
 */
@property (nonatomic, copy) JQSelectedItemsBlock itemsBlock;

/** 裁剪图片的宽高比 默认1/1 */
@property (nonatomic, assign) CGFloat reshapeScale;

/** 选择及上传完图片后用户是否可预览图片 默认 YES */
@property (nonatomic, assign) BOOL allowPreview;

/** 直接返回所有子视图
 */
- (NSArray<JQUploadImageView *> *)ItmeViews;

//获取上传结果url数组（自动上传图片并返回图片的网络访问地址url）
- (NSArray *)getUploadResultUrlArray;

/**设置上传图片接口url 及参数  必须在输入items 之前调用
 * @param url 接口请求地址
 * @param param 接口请求参数
 * @param name 后台对应接收file数据流的字段 不传默认为 “file”
 */
- (void)setUploadEnginePostUrl:(NSString *)url parameters:(id)param field:(NSString *)name;

/** 点击每个图片得 */
- (void)setUploadDidClickItemBlock:(JQUploadDidClickItemBlock)uploadDidClickItemBlock;

//- (void)setUploadDidResultBlock:(JQUploadDidResultBlock)uploadDidResultBlock;
@end

