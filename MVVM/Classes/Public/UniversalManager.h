//
//  UniversalManager.h
//  ZongShengTrainVideo
//
//  Created by zjq on 2017/6/11.
//  Copyright © 2017年 zjq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "ShareManager.h"
@interface UniversalManager : NSObject

/**
 * 用户信息处理类 **************************************************
 */

/**
 * 获取当前登录用户Token
 */
+ (NSString *)getToken;

/**
 *获取当前登录用户userid
 */
+ (NSString *)getUserID;


/** 刷新用户数据 */
+ (void)refreshUserInfo:(void(^)(NSInteger status))block;

///** 是否已实名认证 */
//+ (BOOL)isRealnameConfirm:(UIViewController*)target;

///**
// * 用户是否登录
// */
//+ (BOOL)isLogin;

/** gif 刷新头 */
+ (MJRefreshGifHeader *)gifRefreshHeaderWithRefreshingTarget:(id)target refreshingAction:(SEL)sel;

/**
 * 资源加载类 **************************************************
 */



/**
 * 提示框警告框类 **************************************************
 */

/**
*  显示成功提示信息框
*/
+ (void)showWithSucessesMessage:(NSString*)msg;

/**
 *  显示带进度条的提示框
 */
+ (void)showWithProgressMessage:(CGFloat)progress status:(NSString*)status;

/**
 *  显示成功提示信息框
 */
+ (void)showWithErrorMessage:(NSString*)msg;

/**
 *  显示等待提示信息框
 */
+ (void)showWithWaitMessage:(NSString*)msg;
/**
 *  显示等待提示信息框
 */
+ (void)showWithWaitMessage:(NSString*)msg maskType:(SVProgressHUDMaskType)maskType;
/**
 *  显示纯文字提示信息框
 */
+ (void)showWithTipsMessage:(NSString*)msg;
/**
 *  隐藏提示信息框
 */
+ (void)dissmessProgressHUD;

/**
 *  显示警告框
 */
+ (void)showAlertWithMessage:(NSString*)msg;

/** 显示带输入框的警告框  */
+ (void)showAlertWithTitle:(NSString *)title
               placeholder:(NSString *)placeholder
                      done:(void(^)(NSString *content))done;

/** 显示警告框  */
+ (void)showAlertWithTitle:(NSString*)title
                   Message:(NSString*)msg
              cancelButton:(NSString*)cancelButton
               ohterButton:(NSString*)ohterButton
                ClickBlock:(void(^)(NSInteger index))click;


/** 显示警告框 */
+ (void)showAlertWithTitle:(NSString*)title
                   Message:(NSString*)msg
              cancelButton:(NSString*)cancelButton
                ClickBlock:(void(^)(NSInteger index))click;


#pragma mark - 显示警告框
+ (void)showAlertWithTitle:(NSString*)title
                   MessageAtt:(NSString*)msg
              cancelButton:(NSString*)cancelButton
                ClickBlock:(void(^)(NSInteger index))click;

/** 显示警告框ActionSheet */
+ (void)showActionSheetWithTitle:(NSString *)title  cancelButton:(NSString*)cancelButton otherButton:(NSString*)otherButton otherButton1:(NSString*)otherButton1 ClickBlock:(void(^)(NSInteger index))click;
/**
 *Storyboard加载类***********************************
 */



/**
 *  从storyboard加载控制器
 *
 *  @param name        storyboard名称
 *  @param identiffier controller标志
 *
 *  @return 控制器
 */
+ (id)getControllerByStoryboardName:(NSString *)name identiffier:(NSString *)identiffier;


/**
 *  从storyboard加载控制器
 *
 *  @param identiffier controller标志
 *
 *  @return 控制器
 */
+ (id)getControllerByStoryboardWithIdentiffier:(NSString *)identiffier;






/**
 *  文档管理类 ***************************************
 */


/**
 *  归档
 *
 *  @param obj      保存的文件
 *  @param fileName 文件名
 */
+(void)saveMessage:(id)obj andFileName:(NSString *)fileName;

/**
 *  解档
 *
 *  @param fileName 文件名
 *
 *  @return 返回文件
 */
+(id)getMessageWithFile:(NSString *)fileName;

/**
 *  计算目录大小
 *
 *  @return 返回目录大小
 */
+(float)folderSize;

/**
 *  清除文件缓存
 *
 *  @param path 清除文件缓存
 */
+(void)clearCache:(NSString *)path;


/**
 *  字符串操作类*********************************************
 */


/**
 *  判断字符串是否未空
 *
 *  @param string 字符串
 *
 *  @return 处理结果字符串
 */
+ (NSString*) isBlankString:(NSString *)string;



/**
 *  清除字符串中的空格
 *
 *  @param string 字符串
 *
 *  @return 处理结果字符串
 */
+(NSString*) clearBlankSpaceString:(NSString *)string;
/**
 *  字符串倒序
 *
 *  @param string 字符串
 *
 *  @return 处理结果字符串
 */
+ (NSString*)getStringReverse:(NSString*)string;
/**
 *  返回字符串所占用的尺寸.
 *
 *  @param string 字符串
 *  @param font 字体
 *  @param maxSize 容器大小
 *  @return 处理结果字符串
 */
+ (CGSize)sizeWithString:(NSString*)string Font:(UIFont *)font maxSize:(CGSize)maxSize;

/** 验证字符串是否为数字 */
+ (BOOL)validateNumber:(NSString*)number;


/**
 *  返回富文本字符串所占用的尺寸.
 *
 *  @param string 富文本字符串
 *  @param maxSize 容器大小
 *  @return 处理结果字符串
 */
+ (CGSize)sizeWithAttributedString:(NSAttributedString*)string maxSize:(CGSize)maxSize;
/**
 *  URL编码
 *
 *  @param unencodedString URL待编码字符串
 *  @return 处理结果字符串
 */
+(NSString*)encodeString:(NSString*)unencodedString;

/**
 *  URL反编码
 *
 *  @param encodedString URL待反编码字符串
 *  @return 处理结果字符串
 */
+(NSString *)decodeString:(NSString*)encodedString;


/**
 * 判断url连接是否可以打开
 **/
+ (void)validateUrl:(NSString *)UrlString result:(void(^)(BOOL isAvailable))result;
/**
 *  验证手机号码的正则表达式
 *
 *  @param str 手机号
 *
 *  @return 正确返回YES
 */
+ (BOOL)isCheckTel:(NSString *)str;

/**
 *  显示手机号头尾中间显示****  （153****4335）
 *
 *  @param phone 手机号
 *
 *  @return 正确返回（153****4335）
 */
+ (NSString*)getSecurityPhoneNum:(NSString*)phone;


/**
 显示银行卡的显示方式（eg: 6227************0523）

 @param bankCard 银行卡号
 @param showHeaderBankCardNum 头部显示位数
 @param showFooterBankCardNum 尾部显示位数
 @return 正确返回
 */
+ (NSString*)getSecurityBankCardNum:(NSString *)bankCard
              showHeaderBankCardNum:(NSInteger)showHeaderBankCardNum
              showFooterBankCardNum:(NSInteger)showFooterBankCardNum;

/**
 *  邮箱验证
 *
 *  @param email 邮箱
 *
 *  @return 正确返回yes
 */
+(BOOL)isValidateEmail:(NSString *)email;




/**
 * 时间操作管理类 ***************************************************
 */

/**
 *  格式化显示时间
 *
 *  @param date 时间
 *
 *  @return 正确返回@"yyyy-MM-dd"
 */
+ (NSString*)getDateFormatterDate:(NSDate*)date;

/**
 *  根据时间返回星期几
 *
 *  @param date 时间
 *
 *  @return 星期几
 */
+ (NSString*)getWeekdayForDate:(NSDate*)date;

/**
 *  根据时间戳转换时间显示格式
 *
 *  @param interval 时间戳
 *
 *  @return 字符串
 */
+ (NSString*)getDateFormatterWithTimeInterval:(NSTimeInterval)interval;

/**
 *  -根据时间戳转换时间显示斜杠格式
 *
 *  @param interval 时间戳
 *
 *  @return 字符串
 */
+ (NSString*)getSlashDateFormatterWithTimeInterval:(NSTimeInterval)interval;

/**
 *  根据时间字符串 转换为时间戳
 *  @param dateSting 时间字符串
 *  @return 时间戳
 */
+ (NSTimeInterval )getTimeIntervalFormatterWithString:(NSString*)dateSting;

/**
 *  格式化的时间字符串转为date
 *  @param dateSting 时间字符串
 *  @return 时间date
 */
+ (NSDate*)getDateFormatterWithString:(NSString*)dateSting;

/**
 *  获取系统当前时间戳
 *  @return 当前系统时间字符串
 */
+ (NSString*)getSyetemTimeInterval;

/**
 * 计算指定时间与当前的时间差
 * @param compareDate   某一指定时间
 * @return 多少(秒or分or天or月or年)+前 (比如，3天前、10分钟前)
 */
+(NSString *) compareCurrentTime:(NSDate*) compareDate;
#pragma mark - 计算指定时间戳与当前的时间戳差
+(NSTimeInterval) compareCurrentTimeIntervalToInterval:(NSTimeInterval) interval;
/**
 * 计算指定时间戳与当前的时间戳差
 * @param interval   某一指定时间戳
 * @return 多少(秒or分or天or月or年)+前 (比如，3天前、10分钟前)
 */
+(NSString *) compareCurrentTimeInterval:(NSTimeInterval) interval;

/**
 * 对比两个时间戳大小
 * @param interval1   某一指定时间戳1
 * @param interval2   某一指定时间戳2
 * @return YES or NO
 */
+(BOOL) compareTimeInterval1:(NSTimeInterval)interval1 withTimeInterval2:(NSTimeInterval)interval2;





/**
 * 其他 ***********************************************
 */

/**
 *  浏览图片
 */
+ (void)photoBrowserWithPicUrlArray:(NSArray*)array withSrcImageViewArray:(NSArray *)imageViewArray currentPhotoIndex:(NSInteger)index;
/**
 *  获取当前屏幕显示的viewcontroller
 */
+ (UIViewController *)getCurrentViewController;


/**
 *  获取当前屏幕中present出来的viewcontroller
 */
+ (UIViewController *)getPresentedViewController;

/**
 *   保存图片到本地相册
 * @param image 图片
 * @param collectionName 相册名
 */
+ (void)saveImage:(UIImage *)image toCollectionWithName:(NSString *)collectionName;
/**
 * 生成二维码图片
 * @param codeString 用于生成二维码的字符串
 * @param width 生成二维码的宽度
 */
+ (UIImage *)generateQRCodeWithString:(NSString *)codeString width:(CGFloat)width;
/**
 *  生成一张带有logo的二维码
 *
 *  @param string    传入你要生成二维码的数据
 *  @param logoImageName    logo的image名
 *  @param logoScaleToSuperView    logo相对于父视图的缩放比（取值范围：0-1，0，代表不显示，1，代表与父视图大小相同）
 */
+ (UIImage *)generateWithLogoQRCodeString:(NSString *)string logoImageName:(NSString *)logoImageName logoScaleToSuperView:(CGFloat)logoScaleToSuperView;
/**
 *  生成一张彩色的二维码
 *
 *  @param string    传入你要生成二维码的数据
 *  @param backgroundColor    背景色
 *  @param mainColor    主颜色
 */
+ (UIImage *)generateWithColorQRCode:(NSString *)string backgroundColor:(CIColor *)backgroundColor mainColor:(CIColor *)mainColor;

/**将16进制字符串转换成uicolor 
 * @param colorStr 注：参数值不带＃号
 **/
+(UIColor*)hexToUIColorByStr:(NSString*)colorStr;

/**
 *通过图片Data数据第一个字节 来获取图片扩展名
 * @param data 图片data
 */
+ (NSString *)contentTypeForImageData:(NSData *)data;
/**
 * 根据bundle中的文件名读取图片
 * @param name 图片data
 */
+ (UIImage *)imageWithFileName:(NSString *)name;

/**
 *  划线
 */
+ (UIView *)drawLineWithFrame:(CGRect)frame andView:(UIView *)view andColor:(UIColor *)color;

/**
 *  计算图片按width缩放后的尺寸
 *
 *  @param image 图片
 *  @param width 缩放后的宽
 *  @return 处理结果 计算缩放后的尺寸
 */
+ (CGSize)calculateImageScaleWithImage:(UIImage*)image AndScaleWidth:(CGFloat)width;

/**
 *将数组元素倒序排列
 **/
+ (NSArray*)reverseArray:(NSArray*)array;
/**
 *获取APP当前版本信息
 **/
+ (NSString*)bundleShortVersionString;


/**
 *APP更新版本操作
 *@param message                    更新提示信息
 *@param serverVersion       服务器获取到的版本号
 *@param url                              更新地址
 *@param isForcedUpdating 是否强制更新
 **/
+ (void)appVersionUpdateWithTips:(NSString *)message
                serverGetVersion:(NSString *)serverVersion
                       updateUrl:(NSString *)url
                  forcedUpdating:(BOOL)isForcedUpdating;





/** 
 *获取随机数
 */
+(NSString *)getRandomString;

/** 
 *MD5
 *@Param string 字符串
 */
+ (NSString *)md5:(NSString*)string;
/**
 *签名规则
 */
+ (NSString *)md5EncryptStrWithParam:(NSDictionary *)dic;

/**
 * 快速分享
 **/
//+ (void)shareViewWithController:(UIViewController*)viewCtrl
//                        AndText:(NSString*)text
//                     AndContent:(NSString*)content
//                       AndImage:(UIImage*)image
//                         AndUrl:(NSString*)url
//                     completion:(CompletionBlock)completion;
//
//#pragma  mark - 快速分享图片
//+ (void)shareViewWithController:(UIViewController*)viewCtrl
//                        AndText:(NSString*)text
//                     AndContent:(NSString*)content
//                       AndImage:(id)image
//                     completion:(CompletionBlock)completion;


#pragma mark - 用#ffffff转UIColor
+ (UIColor*)colorWithHexString:(NSString*)stringToConvert;


+ (void)systemMakeCallPhoneNumber:(NSString *) callNumber showView:(UIView *)view;


//JSON字符串转化为字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

/**
 *  返回UILabel自适应后的size
 *
 *  @param aString 字符串
 *  @param width   指定宽度
 *  @param height  指定高度
 *
 *  @return CGSize
 */
+ (CGSize)sizeLabelToFit:(NSAttributedString *)aString width:(CGFloat)width height:(CGFloat)height;

/** 加载中动态图片组 */
+ (NSArray *)loadingImages;
@end
