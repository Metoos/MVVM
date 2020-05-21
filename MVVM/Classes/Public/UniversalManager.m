//
//  UniversalManager.m
//  ZongShengTrainVideo
//
//  Created by zjq on 2017/6/11.
//  Copyright © 2017年 zjq. All rights reserved.
//

#import "UniversalManager.h"
#import <CommonCrypto/CommonDigest.h>
#import <Photos/Photos.h>
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import <WebKit/WebKit.h>
static inline CGFLOAT_TYPE CGFloat_ceil(CGFLOAT_TYPE cgfloat) {
#if CGFLOAT_IS_DOUBLE
    return ceil(cgfloat);
#else
    return ceilf(cgfloat);
#endif
}


@implementation UniversalManager

/**
 * 用户信息处理类 **************************************************
 */

#pragma mark - 获取当前登录用户Token
+ (NSString *)getToken
{
//    LoginEntity *user = [LoginEntity sharedLoginEntity];
//    return user.data.appToken?:@"";
   return @"f8e6014f768e2a38b2fe072cd7a9d7fa2bad53e1";
}

//+ (MJRefreshGifHeader *)gifRefreshHeaderWithRefreshingTarget:(id)target refreshingAction:(SEL)sel
//{
//    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:target refreshingAction:sel];
//    NSMutableArray *images = [NSMutableArray arrayWithCapacity:10];
//    for (int i = 0; i<10; i++) {
//        NSString *imageNamed = [[NSString alloc]initWithFormat:@"loading%d",i+1];
//        UIImage *image = [UIImage imageNamed:imageNamed];
//        [images addObject:image];
//    }
////    [header setImages:images forState:MJRefreshStatePulling];
//    [header setImages:images forState:MJRefreshStateRefreshing];
//
//    images = nil;
////    header.gifView.image = [UIImage animatedGIFNamed:@"loadingview"];
//    return header;
//
//}
//#pragma mark - 获取当前登录用户userid
//+(NSString *)getUserID
//{
//    UserInfoEntity *user = [UserInfoEntity sharedUserInfoEntity];
//    if ([user.userid integerValue]>0) {
//        return user.userid;
//    }
//    return @"0";
//}
/** 刷新用户数据 */

//+ (void)refreshUserInfo:(void(^)(NSInteger status))block
//{
//    NSDictionary *parameters = @{@"method":@"User.index",
//                                 @"token":[self getToken],
//                                 };
//    //处理接口请求全局统一参数
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:(NSDictionary *)parameters copyItems:YES];
//    NSString *timestamp = [UniversalManager getSyetemTimeInterval];
//    //在参数中添加时间戳和签名字段
//    [dic setObject:timestamp forKey:@"timestamp"];
//    NSString *sign = [UniversalManager md5EncryptStrWithParam:dic];
//    [dic setObject:sign forKey:@"sign"];
//    parameters = dic;
//
//    [[JQHttpClient defaultClient] requestWithPath:SERVER_HOST method:JQHttpRequestPostString parameters:parameters prepareExecute:nil success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
//        DLog(@"responseObject = %@",responseObject);
//        UniversalModel *model = [UniversalModel mj_objectWithKeyValues:responseObject];
//
//        if (model.code == successed) {
//
//            [UserInfoEntity mj_objectWithKeyValues:model.data];
//            if (block) {
//               block(successed);
//            }
//
//        }else
//        {
//            if (block) {
//                block(failure);
//            }
//        }
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
//        DLog(@"error = %@",error);
//        if (block) {
//            block(failure);
//        }
//    }];
//}


/** 是否已实名认证 */
//+ (BOOL)isRealnameConfirm:(UIViewController*)target
//{
//    UserInfoModel *user = [UserInfoModel sharedUserInfoModel];
//    if ([user.img_confirm integerValue] == 0) {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还实名未认证，马上去实名认证？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"立即认证", nil];
//        [alert showWithButtonClickBlock:^(NSInteger buttonIndex) {
//            if (buttonIndex == 1) {
//                [target.navigationController pushViewController:[UniversalManager getControllerByStoryboardName:@"Personal" identiffier:@"CertificationInfoTableViewController"] animated:YES];
//            }
//        }];
//        return NO;
//    }else if ([user.img_confirm integerValue] == 2)
//    {
//        [UniversalManager showWithTipsMessage:@"您的实名认证资料还在审核中,请耐心等待审核！"];
//        return NO;
//    }else if ([user.img_confirm integerValue] == 3)
//    {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的实名认证未通过，是否重新实名认证？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"立即认证", nil];
//        [alert showWithButtonClickBlock:^(NSInteger buttonIndex) {
//            if (buttonIndex == 1) {
//                [target.navigationController pushViewController:[UniversalManager getControllerByStoryboardName:@"Personal" identiffier:@"CertificationInfoTableViewController"] animated:YES];
//            }
//        }];
//
//        return NO;
//    }else if ([user.realname_confirm integerValue] == 0) {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还实名未认证，马上去实名认证？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"立即认证", nil];
//        [alert showWithButtonClickBlock:^(NSInteger buttonIndex) {
//            if (buttonIndex == 1) {
//                [target.navigationController pushViewController:[UniversalManager getControllerByStoryboardName:@"Personal" identiffier:@"CertificationInfoTableViewController"] animated:YES];
//            }
//        }];
//        return NO;
//    }else if ([user.realname_confirm integerValue] == 2)
//    {
//            [UniversalManager showWithTipsMessage:@"您的实名认证资料还在审核中,请耐心等待审核！"];
//            return NO;
//    }else if ([user.realname_confirm integerValue] == 3)
//    {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的实名认证未通过，是否重新实名认证？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"立即认证", nil];
//        [alert showWithButtonClickBlock:^(NSInteger buttonIndex) {
//            if (buttonIndex == 1) {
//                [target.navigationController pushViewController:[UniversalManager getControllerByStoryboardName:@"Personal" identiffier:@"CertificationInfoTableViewController"] animated:YES];
//            }
//        }];
//
//        return NO;
//    }
//
//    return YES;
//}
//#pragma mark - 用户是否登录
//+(BOOL)isLogin
//{
//    LoginDataModel *user = [LoginDataModel sharedLoginDataModel];
//    if ([user.userID integerValue] > 0) {
//        return YES;
//    }
//    return NO;
//}


/**
 * 资源加载类 **************************************************
 */



/**
 * 提示框警告框类 **************************************************
 */


#pragma mark - 显示成功提示信息框
+ (void)showWithSucessesMessage:(NSString*)msg
{
    [SVProgressHUD setMinimumDismissTimeInterval:2.0];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
//    [SVProgressHUD setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.65f]];
//    [SVProgressHUD setForegroundColor:[UIColor colorWithWhite:1.0 alpha:1.0f]];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD showSuccessWithStatus:JQGetStringWithKeyFromTable(msg, nil)];
    
}


#pragma mark - 显示带进度条的提示框
+ (void)showWithProgressMessage:(CGFloat)progress status:(NSString*)status
{
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
//    [SVProgressHUD setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.65f]];
//    [SVProgressHUD setForegroundColor:[UIColor colorWithWhite:1.0 alpha:1.0f]];
    [SVProgressHUD showProgress:progress status:JQGetStringWithKeyFromTable(status, nil)];
}




#pragma mark - 显示成功提示信息框

+ (void)showWithErrorMessage:(NSString*)msg
{
    [SVProgressHUD setMinimumDismissTimeInterval:2.0];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
//    [SVProgressHUD setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.65f]];
//    [SVProgressHUD setForegroundColor:[UIColor colorWithWhite:1.0 alpha:1.0f]];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD showErrorWithStatus:JQGetStringWithKeyFromTable(msg, nil)];
}


#pragma mark - 显示等待提示信息框（默认状态）

+ (void)showWithWaitMessage:(NSString*)msg
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
//    [SVProgressHUD setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.65f]];
//    [SVProgressHUD setForegroundColor:[UIColor colorWithWhite:1.0 alpha:1.0f]];
    [self showWithWaitMessage:JQGetStringWithKeyFromTable(msg, nil) maskType:SVProgressHUDMaskTypeBlack];
}


#pragma mark - 显示等待提示信息框 （设置状态）

+ (void)showWithWaitMessage:(NSString*)msg maskType:(SVProgressHUDMaskType)maskType
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
//    [SVProgressHUD setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.65f]];
//    [SVProgressHUD setForegroundColor:[UIColor colorWithWhite:1.0 alpha:1.0f]];
    [SVProgressHUD setDefaultMaskType:maskType];
    [SVProgressHUD showWithStatus:JQGetStringWithKeyFromTable(msg, nil)];
}


#pragma mark - 显示纯文字提示信息框
 
+ (void)showWithTipsMessage:(NSString*)msg
{
    [SVProgressHUD setMinimumDismissTimeInterval:2.0];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
//    [SVProgressHUD setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.65f]];
//    [SVProgressHUD setForegroundColor:[UIColor colorWithWhite:1.0 alpha:1.0f]];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setInfoImage:nil];
    [SVProgressHUD setMinimumSize:CGSizeMake(100, 44)];
    [SVProgressHUD setCornerRadius:5];
//    [SVProgressHUD showImage:nil status:JQGetStringWithKeyFromTable(msg, nil)];
    [SVProgressHUD showInfoWithStatus:JQGetStringWithKeyFromTable(msg, nil)];
    
    
}

#pragma mark -  隐藏提示信息框
 
+ (void)dissmessProgressHUD
{
    [SVProgressHUD dismiss];
}

#pragma mark - 显示警告框
 
+ (void)showAlertWithMessage:(NSString*)msg
{
    
//    UIColor *blueColor = [UIColor colorWithRed:90/255.0f green:154/255.0f blue:239/255.0f alpha:1.0f];
//    UIColor *blueColor = [UIColor colorWithRed:90/255.0f green:154/255.0f blue:239/255.0f alpha:1.0f];

    
    [LEEAlert alert].config
    .LeeAddTitle(^(UILabel *label) {

        label.text = JQGetStringWithKeyFromTable(@"提示", nil);

        label.textColor = COLORRGB(0x030303);
    })
    .LeeAddContent(^(UILabel *label) {
        
        label.text = msg;
        
        label.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.75f];
    })
    .LeeAddAction(^(LEEAction *action) {
        
        action.type = LEEActionTypeCancel;
        
        action.title = JQGetStringWithKeyFromTable(@"取消", nil);
        
        action.titleColor = kWhiteColor;
        
        action.backgroundColor = [UIColor whiteColor];
        
        action.clickBlock = ^{
            
            // 取消点击事件Block
        };
    })
    .LeeHeaderColor([UIColor whiteColor])
    .LeeShow();
}



#pragma mark - 显示警告框
+ (void)showAlertWithTitle:(NSString*)title
                   Message:(NSString*)msg
              cancelButton:(NSString*)cancelButton
               ohterButton:(NSString*)ohterButton
                ClickBlock:(void(^)(NSInteger index))click
{
    
    UIColor *blueColor = [UIColor colorWithRed:90/255.0f green:154/255.0f blue:239/255.0f alpha:1.0f];

    [LEEAlert alert].config
    .LeeAddTitle(^(UILabel *label) {
        label.text = title;
        label.textColor = COLORRGB(0x030303);
    })
    .LeeAddContent(^(UILabel *label) {
        
        label.text = msg;
        label.textColor = COLORRGB(0x030303);
    })
    .LeeAddAction(^(LEEAction *action) {
        
        action.type = LEEActionTypeCancel;
        
        action.title = cancelButton;
        
        action.titleColor = blueColor;
        
        action.backgroundColor = [UIColor whiteColor];
        
        action.clickBlock = ^{
            
            // 取消点击事件Block
            if (click) {
                click(0);
            }
        };
    }).LeeAddAction(^(LEEAction *action) {
        
        action.type = LEEActionTypeDefault;
        
        action.title = ohterButton;
        
        action.titleColor = blueColor;
        
        action.backgroundColor = [UIColor whiteColor];
        
        action.clickBlock = ^{
            
            // 取消点击事件Block
            if (click) {
                click(1);
            }
        };
    })
    .LeeHeaderColor([UIColor whiteColor])
    .LeeShow();
}

+ (void)showAlertWithTitle:(NSString *)title placeholder:(NSString *)placeholder done:(void(^)(NSString *content))done
{
    // 使用一个变量接收自定义的输入框对象 以便于在其他位置调用
    __block UITextField *tf = nil;
    
    [LEEAlert alert].config
    .LeeTitle(title)
    .LeeAddTextField(^(UITextField *textField) {
        // 这里可以进行自定义的设置
        textField.placeholder = placeholder;
        textField.borderStyle = UITextBorderStyleNone;
        textField.textColor = COLORRGB(0x333333);
        textField.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14.0f];
        tf = textField; //赋值
    })
    .LeeAddAction(^(LEEAction *action){
        action.titleColor = COLORRGB(0x333333);
        action.font       = [UIFont fontWithName:@"PingFang-SC-Medium" size:14.0f];
        action.title      = @"确定";
        action.clickBlock = ^{
            [tf resignFirstResponder];
            !done?:done(tf.text);
        };
    })
    .LeeHeaderColor([UIColor whiteColor])
    .LeeShow();
}


#pragma mark - 显示警告框
+ (void)showAlertWithTitle:(NSString*)title
                   Message:(NSString*)msg
              cancelButton:(NSString*)cancelButton
                ClickBlock:(void(^)(NSInteger index))click
{
    
    UIColor *blueColor = [UIColor colorWithRed:90/255.0f green:154/255.0f blue:239/255.0f alpha:1.0f];
    
    
    [LEEAlert alert].config
    .LeeAddTitle(^(UILabel *label) {

        label.text = title;

        label.textColor = COLORRGB(0x030303);
    })
    .LeeAddContent(^(UILabel *label) {
        
        label.text = msg;
        label.textColor = COLORRGB(0x030303);
    })
    .LeeAddAction(^(LEEAction *action) {
        
        action.type = LEEActionTypeCancel;
        
        action.title = cancelButton;
        
        action.titleColor = blueColor;
        
        action.backgroundColor = [UIColor whiteColor];
        
        action.clickBlock = ^{
            
            // 取消点击事件Block
            if (click) {
                click(0);
            }
        };
    })
    .LeeHeaderColor([UIColor whiteColor])
    .LeeShow();
}

#pragma mark - 显示警告框
+ (void)showAlertWithTitle:(NSString*)title
                MessageAtt:(NSString*)msg
              cancelButton:(NSString*)cancelButton
                ClickBlock:(void(^)(NSInteger index))click
{
    
    UIColor *blueColor = [UIColor colorWithRed:90/255.0f green:154/255.0f blue:239/255.0f alpha:1.0f];
    
    [LEEAlert alert].config
    .LeeAddTitle(^(UILabel *label) {

        label.text = title;

        label.textColor = COLORRGB(0x030303);
    })
    .LeeAddContent(^(UILabel *label) {

        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithData:[msg dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        // 设置 文本的 字体大小
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17.0f] range:NSMakeRange(0, attrStr.length)];
        [attrStr addAttribute:NSForegroundColorAttributeName value:COLORRGB(0x030303) range:NSMakeRange(0, attrStr.length)];
        label.attributedText = attrStr;
        label.textColor = COLORRGB(0x030303);
        label.backgroundColor = kWhiteColor;
    })
       .LeeItemInsets(UIEdgeInsetsMake(0, 0, 0, 0))
    .LeeAddAction(^(LEEAction *action) {
        
        action.type = LEEActionTypeCancel;
        
        action.title = cancelButton;
        
        action.titleColor = blueColor;
        
        action.backgroundColor = [UIColor whiteColor];
        
        action.clickBlock = ^{
            
            // 取消点击事件Block
            if (click) {
                click(0);
            }
        };
    })
    .LeeHeaderColor([UIColor whiteColor])
    .LeeShow();
}


+ (void)showActionSheetWithTitle:(NSString *)title
                    cancelButton:(NSString*)cancelButton
                     otherButton:(NSString*)otherButton
                    otherButton1:(NSString*)otherButton1
                      ClickBlock:(void(^)(NSInteger index))click
{
    
    
    [LEEAlert actionsheet].config
    .LeeTitle(title)
    .LeeAction(otherButton, ^{
        !click?:click(1);
        // 点击事件Block
    })
    .LeeDestructiveAction(otherButton1, ^{
        !click?:click(2);
        // 点击事件Block
    })
    .LeeCancelAction(cancelButton, ^{
        !click?:click(0);
        // 点击事件Block
        
    })
    .LeeShow();
}

/**
 *Storyboard加载类***********************************
 */



#pragma mark -从storyboard加载控制器

+ (id)getControllerByStoryboardName:(NSString *)name identiffier:(NSString *)identiffier {
    UIStoryboard *board = [UIStoryboard storyboardWithName:name bundle:nil];
    return [board instantiateViewControllerWithIdentifier:identiffier];
}

#pragma mark -从storyboard加载控制器
+ (id)getControllerByStoryboardWithIdentiffier:(NSString *)identiffier {
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return [board instantiateViewControllerWithIdentifier:identiffier];
}




/**
 *  文档管理类 ***************************************
 */


#pragma mark -归档
+(void)saveMessage:(id)obj andFileName:(NSString *)fileName
{
    NSString * file = [kSandboxPath stringByAppendingPathComponent:fileName];
    
    [NSKeyedArchiver archiveRootObject:obj toFile:file];
}

#pragma mark - 解档
+(id)getMessageWithFile:(NSString *)fileName
{
    NSString * file = [kSandboxPath stringByAppendingPathComponent:fileName];
    //    NSDictionary * dic = [NSKeyedUnarchiver unarchiveObjectWithFile:file];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:file];
}

#pragma mark 计算单个文件大小
+(float)fileSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size/1024.0/1024.0;
    }
    return 0;
}

#pragma mark 计算目录大小
+(float)folderSize{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    float folderSize = 0;
    
    NSArray *childerFiles=[fileManager subpathsAtPath:kSandboxPath];
    if ([fileManager fileExistsAtPath:kSandboxPath]) {
        
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath=[kSandboxPath stringByAppendingPathComponent:fileName];
            folderSize +=[self fileSizeAtPath:absolutePath];
        }
        //SDWebImage框架自身计算缓存的实现
        DLog(@"SDImageCache = %lf",(unsigned long)[[SDImageCache sharedImageCache] totalDiskSize]/1024.0/1024.0);
        folderSize+=[[SDImageCache sharedImageCache] totalDiskSize]/1024.0/1024.0;
        return folderSize;
    }
    return 0;
}

- (CGFloat)getCachSize {
    
    NSUInteger imageCacheSize = [[SDImageCache sharedImageCache] totalDiskSize];
    //获取自定义缓存大小
    //用枚举器遍历 一个文件夹的内容
    //1.获取 文件夹枚举器
    NSString *myCachePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:myCachePath];
    __block NSUInteger count = 0;
    //2.遍历
    for (NSString *fileName in enumerator) {
        NSString *path = [myCachePath stringByAppendingPathComponent:fileName];
        NSDictionary *fileDict = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
        count += fileDict.fileSize;//自定义所有缓存大小
    }
    // 得到是字节  转化为M
    CGFloat totalSize = ((CGFloat)imageCacheSize+count)/1024/1024;
    return totalSize;
}

//字节大小转字符串 系统自带方法
+ (NSString *)byteCountFormatterCount:(long long)count
{
    return [NSByteCountFormatter stringFromByteCount:count countStyle:NSByteCountFormatterCountStyleFile];
}
//字节大小转字符串
+ (NSString *)byteCountTransformedValue:(id)value
{
 
    double convertedValue = [value doubleValue];
    int multiplyFactor = 0;
 
    NSArray *tokens = [NSArray arrayWithObjects:@"bytes",@"KB",@"MB",@"GB",@"TB",@"PB", @"EB", @"ZB", @"YB",nil];
    while (convertedValue >= 1024) {
        convertedValue /= 1024;
        multiplyFactor++;
    }
    return [NSString stringWithFormat:@"%4.2f %@",convertedValue, [tokens objectAtIndex:multiplyFactor]];
}

#pragma mark 清除文件缓存
+(void)clearCache:(NSString *)path{
    
    [self showWithWaitMessage:@"正在清除"];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
    //    [[SDImageCache sharedImageCache] cleanDiskWithCompletionBlock:^{
    //        NSLog(@"成功");
    //        [self showWithSucessesMessage:@"清除完成"];
    //    }];
     [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:NULL];
    
    //    [[SDImageCache sharedImageCache] clearMemory];//可有可无
    
    DLog(@"clear disk");
    
}




/**
 *  字符串操作类*********************************************
 */

#pragma mark -判断字符串是否未空
+(NSString*) isBlankString:(NSString *)string {
    
    if ([string isKindOfClass:[NSNumber class]]) {
        return [[NSString alloc]initWithFormat:@"%@",string];
    }
    if (![string isKindOfClass:[NSString class]]) {
        return @"";
    }
    if (string == nil || string == NULL) {
        return @"";
    }
    if ([string isEqual:[NSNull null]]) {
        return @"";
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return @"";
    }
    
    return string;
}

#pragma mark -清除字符串中的空格
+(NSString*) clearBlankSpaceString:(NSString *)string {
    
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return string;
}

#pragma mark -字符串倒序
+ (NSString*)getStringReverse:(NSString*)string
{
    NSString *reverseString = @"";
    for (int i=0; i<string.length; i++) {
        
        reverseString = [reverseString stringByAppendingString:[string substringWithRange:NSMakeRange(string.length-i-1, 1)]];
    }
    return reverseString;
}

#pragma mark -返回字符串所占用的尺寸.
+ (CGSize)sizeWithString:(NSString*)string Font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrs context:nil].size;
}
#pragma mark -验证字符串是否为数字
+ (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length)
    {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0)
        {
            res = NO;
            break;
        }
        i++;
        
    }
    return res;
    
}


#pragma mark -返回富文本字符串所占用的尺寸.
+ (CGSize)sizeWithAttributedString:(NSAttributedString*)string maxSize:(CGSize)maxSize
{
    CGSize size = [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:NULL].size;
    return size;
}

#pragma mark -URL编码URLEncode
+(NSString*)encodeString:(NSString*)unencodedString{
    
    // CharactersToBeEscaped = @":/?&=;+!@#$()~',*";
    // CharactersToLeaveUnescaped = @"[].";
    
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)unencodedString,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    
    return encodedString;
}
#pragma mark -URL反编码 URLDEcode
+(NSString *)decodeString:(NSString*)encodedString

{
    //NSString *decodedString = [encodedString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
    
    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                                     (__bridge CFStringRef)encodedString,
                                                                                                                     CFSTR(""),
                                                                                                                     CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}

//思路:传入一个请求的URL,进行网络请求,如果返回失败信息则说明此URL不可用
//1.首先进行第一步判断传入的字符串是否符合HTTP路径的语法规则,即”HTTPS://” 或 “HTTP://” ,从封装的一个函数,传入即可判断
+(NSURL *)smartURLForString:(NSString *)str {
    NSURL *     result;
    NSString *  trimmedStr;
    NSRange     schemeMarkerRange;
    NSString *  scheme;
    assert(str != nil);
    result = nil;
    trimmedStr = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ( (trimmedStr != nil) && (trimmedStr.length != 0) ) {
        schemeMarkerRange = [trimmedStr rangeOfString:@"://"];
        if (schemeMarkerRange.location == NSNotFound) {
            result = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", trimmedStr]];
        } else {
            scheme = [trimmedStr substringWithRange:NSMakeRange(0, schemeMarkerRange.location)];
            assert(scheme != nil);
            if ( ([scheme compare:@"http"  options:NSCaseInsensitiveSearch] == NSOrderedSame)
                || ([scheme compare:@"https" options:NSCaseInsensitiveSearch] == NSOrderedSame) ) {
                result = [NSURL URLWithString:trimmedStr];
            } else {
                // 格式不符合
            }
        }
    }
    
    return result;
}

#pragma mark - 判断url连接是否可以打开
+ (void)validateUrl:(NSString *) UrlString result:(void(^)(BOOL isAvailable))result {
    
    NSURL *url = [self smartURLForString:UrlString];
    if (!url) {
        result(NO);
        
        return;
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"HEAD"];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"error %@",error);
            if (!request && error) {
                NSLog(@"不可用");
                result(NO);
            }else{
                NSLog(@"可用%@",request);
                result(YES);
            }
        });
      
    }];
    [task resume];
}

#pragma mark -验证手机号码的正则表达式(只判断，无弹窗)
+ (BOOL)isCheckTel:(NSString *)str
{
    if ([str length] == 0) {
        
        return NO;
    }
    //    NSString *regex = @"^((13[0-9])|(14[5,7])|(15[^4,\\D])|(17[0678,\\D])|(18[01,5-9]))\\d{8}$";
    NSString *regex = @"^1\\d{10}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:str];
    if (!isMatch) {
        
        return NO;
    }
    return YES;
}
#pragma mark -显示手机号头尾中间显示****  （180****6656）
+ (NSString*)getSecurityPhoneNum:(NSString*)phone
{
    
    NSMutableString *muPhone = [NSMutableString stringWithFormat:@"%@",phone];
    if (muPhone.length>=11) {
        [muPhone replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }
    
    return muPhone;
}

#pragma mark -显示银行卡头和中间显示多个*  （xxxxxxxxxxxxxxxx0262）
+ (NSString*)getSecurityBankCardNum:(NSString *)bankCard
              showHeaderBankCardNum:(NSInteger)showHeaderBankCardNum
              showFooterBankCardNum:(NSInteger)showFooterBankCardNum
{
    NSMutableString *bankCardStr = [NSMutableString stringWithFormat:@"%@",bankCard];
    NSInteger needReplaceNum = bankCardStr.length - showHeaderBankCardNum - showFooterBankCardNum;
    NSMutableArray *array = [NSMutableArray array];
    [array removeAllObjects];
    for (int i = 0; i<needReplaceNum; i++) {
        [array addObject:@"*"];
    }
    NSArray *strs = [NSArray arrayWithArray:array];
    NSString *string = [strs componentsJoinedByString:@""];
    if (bankCardStr.length>showHeaderBankCardNum+showFooterBankCardNum) {
        [bankCardStr replaceCharactersInRange:NSMakeRange(showHeaderBankCardNum, needReplaceNum) withString:string];
    }
    return bankCardStr;
}

#pragma mark -邮箱验证
+(BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}




/**
 * 时间操作管理类 ***************************************************
 */

#pragma mark -格式化显示时间字符串
+ (NSString*)getDateFormatterDate:(NSDate*)date

{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}

#pragma mark -根据时间返回星期几
+ (NSString*)getWeekdayForDate:(NSDate*)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    comps = [calendar components:unitFlags fromDate:date];
    
    NSInteger week = [comps weekday];
    NSString *weekString = nil;
    switch (week) {
        case 1:
        {
            weekString = @"星期日";
            break;
        }
        case 2:
        {
            weekString = @"星期一";
            break;
        }
        case 3:
        {
            weekString = @"星期二";
            break;
        }
        case 4:
        {
            weekString = @"星期三";
            break;
        }
        case 5:
        {
            weekString = @"星期四";
            break;
        }
        case 6:
        {
            weekString = @"星期五";
            break;
        }
        case 7:
        {
            weekString = @"星期六";
            break;
        }
        default:
            break;
    }
    
    return weekString;
}


#pragma mark -根据时间戳转换时间显示格式
+ (NSString*)getDateFormatterWithTimeInterval:(NSTimeInterval)interval
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //指定时间显示样式: HH表示强制24小时制 hh跟随系统设置的时间制式）
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    
    
    return strDate;
}
#pragma mark -根据时间戳转换时间显示斜杠格式
+ (NSString*)getSlashDateFormatterWithTimeInterval:(NSTimeInterval)interval
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    
    
    return strDate;
}

#pragma mark -根据时间字符串 转换为时间戳
+ (NSTimeInterval )getTimeIntervalFormatterWithString:(NSString*)dateSting
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //指定时间显示样式: HH表示强制24小时制 hh跟随系统设置的时间制式）
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:dateSting];
    
    return [date timeIntervalSince1970];
}
#pragma mark -格式化的时间字符串转为date
+ (NSDate*)getDateFormatterWithString:(NSString*)dateSting
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:dateSting];
    return date;
}
#pragma mark -获取系统当前时间戳
+ (NSString*)getSyetemTimeInterval
{
    //毫秒级时间戳
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    long time = (long)timeInterval;
    NSString *timeString = [[NSString alloc] initWithFormat:@"%ld",time];
    return timeString;
}
#pragma mark -计算指定时间与当前的时间差
+(NSString *) compareCurrentTime:(NSDate*) compareDate
{
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [[NSString alloc] initWithFormat:@"刚刚"];
    }else if((temp = timeInterval/60) <60){
        result = [[NSString alloc] initWithFormat:@"%ld分前",temp];
    }else if((temp = temp/60) <24){
        result = [[NSString alloc] initWithFormat:@"%ld小前",temp];
    }else if((temp = temp/24) <5){
        result = [[NSString alloc] initWithFormat:@"%ld天前",temp];
    }else{
        //        temp = temp/12;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        result = [dateFormatter stringFromDate:compareDate];
    }
    return  result;
}

#pragma mark - 计算指定时间戳与当前的时间戳差
+(NSTimeInterval) compareCurrentTimeIntervalToInterval:(NSTimeInterval) interval
{
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSTimeInterval  timeInterval = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval result  = interval - timeInterval;
    return result;
    
}
#pragma mark - 计算指定时间戳与当前的时间戳差
+(NSString *) compareCurrentTimeInterval:(NSTimeInterval) interval
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSTimeInterval  timeInterval = [date timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [[NSString alloc] initWithFormat:@"刚刚"];
    }else if((temp = timeInterval/60) <60){
        result = [[NSString alloc] initWithFormat:@"%ld分前",temp];
    }else if((temp = temp/60) <24){
        result = [[NSString alloc] initWithFormat:@"%ld小时前",temp];
    }else if((temp = temp/24) <30){
        result = [[NSString alloc] initWithFormat:@"%ld天前",temp];
    }else{
        //        temp = temp/12;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //        [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        [dateFormatter setDateFormat:@"YYYY-MM-dd"];
        //        NSDate *date = [NSDate dateWithTimeIntervalSinceNow:interval];
        result = [dateFormatter stringFromDate:date];
    }
    return  result;
}
#pragma mark -对比两个时间戳大小
+(BOOL) compareTimeInterval1:(NSTimeInterval)interval1 withTimeInterval2:(NSTimeInterval)interval2
{
    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:interval1];
    NSTimeInterval  timeInterval1 = [date1 timeIntervalSinceNow];
    
    NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:interval2];
    NSTimeInterval  timeInterval2 = [date2 timeIntervalSinceNow];
    
    return  timeInterval1 > timeInterval2;
}




/**
 * 其他 ***********************************************
 */

#pragma mark -获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentViewController
{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    
    if (window.windowLevel != UIWindowLevelNormal){
        
        NSArray *windows = [[UIApplication sharedApplication] windows];
        
        for(UIWindow * tmpWin in windows){
            
            if (tmpWin.windowLevel == UIWindowLevelNormal){
                
                window = tmpWin;
                
                break;
                
            }
            
        }
        
    }
    
    UIViewController *result = window.rootViewController;
    
    while (result.presentedViewController) {
        
        result = result.presentedViewController;
        
    }
    
    if ([result isKindOfClass:[UITabBarController class]]) {
        
        result = [(UITabBarController *)result selectedViewController];
        
    }
    
    if ([result isKindOfClass:[UINavigationController class]]) {
        
        result = [(UINavigationController *)result topViewController];
        
    }
    
    return result;
        

}
#pragma mark -获取当前屏幕中present出来的viewcontroller
+ (UIViewController *)getPresentedViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    if (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    
    return topVC;
}

/**
 *   保存图片到本地相册
 * @param image 图片
 * @param collectionName 相册名
 */
+ (void)saveImage:(UIImage *)image toCollectionWithName:(NSString *)collectionName
{
    // 1. 获取相片库对象
    PHPhotoLibrary *library = [PHPhotoLibrary sharedPhotoLibrary];
    // 2. 调用changeBlock
    [library performChanges:^{
    // 2.1 创建一个相册变动请求
        PHAssetCollectionChangeRequest *collectionRequest;
        // 2.2 取出指定名称的相册
        PHAssetCollection *assetCollection = [self getCurrentPhotoCollectionWithTitle:collectionName];
        // 2.3 判断相册是否存在
        if (assetCollection) {
            // 如果存在就使用当前的相册创建相册请求
            collectionRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
            
        } else {
            // 如果不存在, 就创建一个新的相册请求
            collectionRequest = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:collectionName];
            
        }
        // 2.4 根据传入的相片, 创建相片变动请求
        PHAssetChangeRequest *assetRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        // 2.4 创建一个占位对象
        PHObjectPlaceholder *placeholder = [assetRequest placeholderForCreatedAsset];
        // 2.5 将占位对象添加到相册请求中
        [collectionRequest addAssets:@[placeholder]];
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        // 3. 判断是否出错, 如果报错, 声明保存不成功
        if (error) {
            [self showWithErrorMessage:@"保存失败"];
            
        } else {
            [self showWithSucessesMessage:@"保存成功"];
        }
        
    }];
    
    

}

+ (PHAssetCollection *)getCurrentPhotoCollectionWithTitle:(NSString *)collectionName {
    // 1. 创建搜索集合
    PHFetchResult *result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    // 2. 遍历搜索集合并取出对应的相册
    for (PHAssetCollection *assetCollection in result)
    {
        if ([assetCollection.localizedTitle containsString:collectionName])
        {
            return assetCollection;
            
        }
        
    }
    return nil;
    
}

#pragma -mark 浏览图片
+ (void)photoBrowserWithPicUrlArray:(NSArray*)array withSrcImageViewArray:(NSArray *)imageViewArray currentPhotoIndex:(NSInteger)index
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
            DLog(@"等于");
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
    
 
/**
 * 生成二维码图片
 * @param codeString 用于生成二维码的字符串
 * @param width 生成二维码的宽度
 */
+ (UIImage *)generateQRCodeWithString:(NSString *)codeString width:(CGFloat)width {
    // 1、创建滤镜对象
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 恢复滤镜的默认属性
    [filter setDefaults];
    
    // 2、设置数据
    NSString *info = codeString;
    // 将字符串转换成
    NSData *infoData = [info dataUsingEncoding:NSUTF8StringEncoding];
    
    // 通过KVC设置滤镜inputMessage数据
    [filter setValue:infoData forKeyPath:@"inputMessage"];
    
    // 3、获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    
    return [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:width];
}
/** 根据CIImage生成指定大小的UIImage */
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

/**
 *  生成一张带有logo的二维码
 *
 *  @param data    传入你要生成二维码的数据
 *  @param logoImageName    logo的image名
 *  @param logoScaleToSuperView    logo相对于父视图的缩放比（取值范围：0-1，0，代表不显示，1，代表与父视图大小相同）
 */
+ (UIImage *)generateWithLogoQRCodeString:(NSString *)string logoImageName:(NSString *)logoImageName logoScaleToSuperView:(CGFloat)logoScaleToSuperView {
    // 1、创建滤镜对象
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 恢复滤镜的默认属性
    [filter setDefaults];
    
    // 2、设置数据
    NSString *string_data = string;
    // 将字符串转换成 NSdata (虽然二维码本质上是字符串, 但是这里需要转换, 不转换就崩溃)
    NSData *qrImageData = [string_data dataUsingEncoding:NSUTF8StringEncoding];
    
    // 设置过滤器的输入值, KVC赋值
    [filter setValue:qrImageData forKey:@"inputMessage"];
    
    // 3、获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    
    // 图片小于(27,27),我们需要放大
    outputImage = [outputImage imageByApplyingTransform:CGAffineTransformMakeScale(20, 20)];
    
    // 4、将CIImage类型转成UIImage类型
    UIImage *start_image = [UIImage imageWithCIImage:outputImage];
    
    // - - - - - - - - - - - - - - - - 添加中间小图标 - - - - - - - - - - - - - - - -
    // 5、开启绘图, 获取图形上下文 (上下文的大小, 就是二维码的大小)
    UIGraphicsBeginImageContext(start_image.size);
    
    // 把二维码图片画上去 (这里是以图形上下文, 左上角为(0,0)点
    [start_image drawInRect:CGRectMake(0, 0, start_image.size.width, start_image.size.height)];
    
    // 再把小图片画上去
    NSString *icon_imageName = logoImageName;
    UIImage *icon_image = [UIImage imageNamed:icon_imageName];
    CGFloat icon_imageW = start_image.size.width * logoScaleToSuperView;
    CGFloat icon_imageH = start_image.size.height * logoScaleToSuperView;
    CGFloat icon_imageX = (start_image.size.width - icon_imageW) * 0.5;
    CGFloat icon_imageY = (start_image.size.height - icon_imageH) * 0.5;
    
    [icon_image drawInRect:CGRectMake(icon_imageX, icon_imageY, icon_imageW, icon_imageH)];
    
    // 6、获取当前画得的这张图片
    UIImage *final_image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 7、关闭图形上下文
    UIGraphicsEndImageContext();
    
    return final_image;
}

/**
 *  生成一张彩色的二维码
 *
 *  @param data    传入你要生成二维码的数据
 *  @param backgroundColor    背景色
 *  @param mainColor    主颜色
 */
+ (UIImage *)generateWithColorQRCode:(NSString *)string backgroundColor:(CIColor *)backgroundColor mainColor:(CIColor *)mainColor {
    // 1、创建滤镜对象
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 恢复滤镜的默认属性
    [filter setDefaults];
    
    // 2、设置数据
    NSString *string_data = string;
    // 将字符串转换成 NSdata (虽然二维码本质上是字符串, 但是这里需要转换, 不转换就崩溃)
    NSData *qrImageData = [string_data dataUsingEncoding:NSUTF8StringEncoding];
    
    // 设置过滤器的输入值, KVC赋值
    [filter setValue:qrImageData forKey:@"inputMessage"];
    
    // 3、获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    
    // 图片小于(27,27),我们需要放大
    outputImage = [outputImage imageByApplyingTransform:CGAffineTransformMakeScale(9, 9)];
    
    // 4、创建彩色过滤器(彩色的用的不多)
    CIFilter * color_filter = [CIFilter filterWithName:@"CIFalseColor"];
    
    // 设置默认值
    [color_filter setDefaults];
    
    // 5、KVC 给私有属性赋值
    [color_filter setValue:outputImage forKey:@"inputImage"];
    
    // 6、需要使用 CIColor
    [color_filter setValue:backgroundColor forKey:@"inputColor0"];
    [color_filter setValue:mainColor forKey:@"inputColor1"];
    
    // 7、设置输出
    CIImage *colorImage = [color_filter outputImage];
    
    return [UIImage imageWithCIImage:colorImage];
}


#pragma mark -将16进制字符串转换成uicolor 注：参数值不带＃号
+(UIColor*)hexToUIColorByStr:(NSString*)colorStr{
    
    NSString *cString = [[colorStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    
    if ([cString length] != 6) return [UIColor blackColor];
    
    
    
    // Separate into r, g, b substrings
    
    NSRange range;
    
    range.location = 0;
    
    range.length = 2;
    
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    
    unsigned int r, g, b;
    
    
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    
    
    return [UIColor colorWithRed:((float) r / 255.0f)
            
                           green:((float) g / 255.0f)
            
                            blue:((float) b / 255.0f)
            
                           alpha:1.0f];
    
}

#pragma mark -通过图片Data数据第一个字节 来获取图片扩展名
+ (NSString *)contentTypeForImageData:(NSData *)data
{
    
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c)
    {
        case 0xFF:
            return @"jpeg";
            
        case 0x89:
            return @"png";
            
        case 0x47:
            return @"gif";
            
        case 0x49:
        case 0x4D:
            return @"tiff";
            
        case 0x52:
            if ([data length] < 12) {
                return nil;
            }
            
            NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            if ([testString hasPrefix:@"RIFF"]
                && [testString hasSuffix:@"WEBP"])
            {
                return @"webp";
            }
            
            return nil;
    }
    
    return nil;
}
#pragma mark - 根据bundle中的文件名读取图片
+ (UIImage *)imageWithFileName:(NSString *)name {
    NSString *extension = @"png";
    
    NSArray *components = [name componentsSeparatedByString:@"."];
    if ([components count] >= 2) {
        NSUInteger lastIndex = components.count - 1;
        extension = [components objectAtIndex:lastIndex];
        
        name = [name substringToIndex:(name.length-(extension.length+1))];
    }
    
    // 如果为Retina屏幕且存在对应图片，则返回Retina图片，否则查找普通图片
    if ([UIScreen mainScreen].scale == 2.0) {
        name = [name stringByAppendingString:@"@2x"];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:extension];
        if (path != nil) {
            return [UIImage imageWithContentsOfFile:path];
        }
    }
    
    if ([UIScreen mainScreen].scale == 3.0) {
        name = [name stringByAppendingString:@"@3x"];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:extension];
        if (path != nil) {
            return [UIImage imageWithContentsOfFile:path];
        }
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:extension];
    if (path) {
        return [UIImage imageWithContentsOfFile:path];
    }
    
    return nil;
}

#pragma mark -划线
+ (UIView *)drawLineWithFrame:(CGRect)frame andView:(UIView *)view andColor:(UIColor *)color
{
    UIView *viewLine = [[UIView alloc] initWithFrame:frame];
    viewLine.backgroundColor = color;
    [view addSubview:viewLine];
    
    return viewLine;
}
#pragma mark - 按比例计算图片缩放尺寸
+ (CGSize)calculateImageScaleWithImage:(UIImage*)image AndScaleWidth:(CGFloat)width
{
    CGSize size ;
    CGFloat scale = width/image.size.width;
    CGFloat height = image.size.height*scale;
    
    size.width = width;
    size.height = height;
    return size;
    
}

#pragma mark - 将数组元素倒序排列
+ (NSArray*)reverseArray:(NSArray*)array
{
    NSMutableArray *marray = [[NSMutableArray alloc]init];
    if (array && array.count>0) {
        for (int i = 0; i<array.count ; i++) {
            [marray addObject:array[array.count-1-i]];
        }
        return marray;
    }
    return nil;
    
}

#pragma mark - 获取APP当前版本信息
+ (NSString*)bundleShortVersionString
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

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
                  forcedUpdating:(BOOL)isForcedUpdating
{
    if (!serverVersion || !url) {
        return;
    }
    NSString *appVersion = [self bundleShortVersionString];
    
    if ([appVersion compare:serverVersion options:NSNumericSearch] == NSOrderedAscending) {
        if (isForcedUpdating) {
            [self showAlertWithTitle:JQGetStringWithKeyFromTable(@"更新提示", nil) Message:message?:JQGetStringWithKeyFromTable(@"发现新版本！是否马上更新？", nil) cancelButton:JQGetStringWithKeyFromTable(@"马上更新", nil) ClickBlock:^(NSInteger index) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            }];
        }else
        {
            [self showAlertWithTitle:JQGetStringWithKeyFromTable(@"更新提示", nil) Message:message?:JQGetStringWithKeyFromTable(@"发现新版本！是否马上更新？", nil) cancelButton:JQGetStringWithKeyFromTable(@"关闭", nil) ohterButton:@"更新" ClickBlock:^(NSInteger index) {
                if (index == 1) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                }
            }];
        }
        
    }
   
}

/**
 *  md5加密
 */
+ (NSString *)md5:(NSString*)string
{
    const char *cStr = [string UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [[NSString alloc] initWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
#pragma  mark - 获取随机数
+(NSString *)getRandomString
{
    NSDate * senddate = [NSDate date];
    NSDateFormatter * dateformatter1 = [[NSDateFormatter alloc] init];
    [dateformatter1 setDateFormat:@"yyMMddHHmmss"];
    NSString * locationString1 = [dateformatter1 stringFromDate:senddate];
    int randomNum = 10 + arc4random()%(100 - 10 + 1);
    
    NSString *sendStr =[NSString stringWithFormat:@"%@%d", locationString1, randomNum];
    
    return sendStr;
}

#pragma  mark - md5签名规则
+ (NSString *)md5EncryptStrWithParam:(NSDictionary *)param
{
    NSMutableArray *strArray = [self getArrayFromDic:param];
    NSLog(@"排序前数组:%@", strArray);
    NSArray *orderArray = [self sortArrayByLetter:strArray];
    NSLog(@"排序后数组:%@", orderArray);
    NSString *secretStr = @"";
    for (NSString *str in orderArray) {
        secretStr = [secretStr stringByAppendingString:[NSString stringWithFormat:@"%@&", str]];
    }
    secretStr = [secretStr substringToIndex:secretStr.length-1];
    /** 拼接KEY */
    secretStr = [secretStr stringByAppendingString:[NSString stringWithFormat:@"%@", SERVER_KEY]];
    NSLog(@"md5前:%@", secretStr);
    NSString *md5 = [self md5:secretStr];
    md5 = [md5 uppercaseString];
    NSLog(@"md5 = %@", md5);
    return md5;
}

+(NSMutableArray *)getArrayFromDic:(NSDictionary *)dic
{
    NSArray *keyArray = [dic allKeys];
    NSMutableArray *strArray = [[NSMutableArray alloc] init];
    for (NSString *key in keyArray) {
        if (![[self isBlankString:[dic objectForKey:key]] isEqualToString:@""]) { //去除空值参数
            NSString *str = [NSString stringWithFormat:@"%@=%@", key, [dic objectForKey:key]];
            [strArray addObject:str];
        }
      
    }
    return strArray;
}

+(NSArray *)sortArrayByLetter:(NSArray *)noOrderArray
{
    NSArray *newArray = [noOrderArray sortedArrayUsingSelector:@selector(compare:)];
    return newArray;
    
    return nil;
}

//#pragma  mark - 快速分享
//+ (void)shareViewWithController:(UIViewController*)viewCtrl
//                        AndText:(NSString*)text
//                     AndContent:(NSString*)content
//                       AndImage:(UIImage*)image
//                         AndUrl:(NSString*)url
//                     completion:(CompletionBlock)completion
//
//{
//
//    if (!content) {
//        content = url;
//    }else
//    {
//        content =  [content stringByAppendingString:url];
//    }
//    ShareManager *shareManager = [[ShareManager alloc]init];
//    [shareManager showShareViewWithController:viewCtrl AndText:text AndContent:content AndImage:image AndUrl:url completion:completion];
//
//
//}
//
//#pragma  mark - 快速分享图片
//+ (void)shareViewWithController:(UIViewController*)viewCtrl
//                        AndText:(NSString*)text
//                     AndContent:(NSString*)content
//                       AndImage:(id)image
//                     completion:(CompletionBlock)completion
//
//{
//
//    ShareManager *shareManager = [[ShareManager alloc]init];
//    [shareManager showShareViewWithController:viewCtrl AndText:text AndContent:content AndImage:image completion:completion];
//
//
//}


#pragma mark - 用#ffffff转UIColor
+ (UIColor*)colorWithHexString:(NSString*)stringToConvert{
    if([stringToConvert hasPrefix:@"#"])
    {
        stringToConvert = [stringToConvert substringFromIndex:1];
    }
    NSScanner*scanner = [NSScanner scannerWithString:stringToConvert];
    unsigned hexNum;
    if(![scanner scanHexInt:&hexNum])
    {
        return nil;
    }
    return[self colorWithRGBHex:hexNum];
}

+ (UIColor*)colorWithRGBHex:(UInt32)hex{
    int r = (hex >>16) &0xFF;
    int g = (hex >>8) &0xFF;
    int b = (hex) &0xFF;
    return[UIColor colorWithRed:r /255.0f
                          green:g /255.0f
                           blue:b /255.0f
                          alpha:1.0f];
}



//拨打电话会弹框提示
+ (void)systemMakeCallPhoneNumber:(NSString *) callNumber showView:(UIView *)view {
    if (!callNumber) {
        return;
    }
    WKWebView *_callWebview = [[WKWebView alloc] init];
    NSURL *telURL =[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",callNumber]];
    [_callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    //记得添加到view上
    [view addSubview:_callWebview];
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

/**
 *  返回UILabel自适应后的size
 *
 *  @param aString 字符串
 *  @param width   指定宽度
 *  @param height  指定高度
 *
 *  @return CGSize
 */
+ (CGSize)sizeLabelToFit:(NSAttributedString *)aString width:(CGFloat)width height:(CGFloat)height {
    UILabel *tempLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    tempLabel.attributedText = aString;
    tempLabel.numberOfLines = 0;
    [tempLabel sizeToFit];
    CGSize size = tempLabel.frame.size;
    size = CGSizeMake(CGFloat_ceil(size.width), CGFloat_ceil(size.height));
    return size;
}


+ (NSArray *)loadingImages
{
    NSMutableArray *ary = [NSMutableArray arrayWithCapacity:47];
    for (int i=0; i<44; i++)
    {
        NSString *imageNamed = [[NSString alloc]initWithFormat:@"gif_%d",i];
        UIImage *image = [UIImage imageNamed:imageNamed];
        if (image) {
            [ary addObject:image];
        }
    }
    return ary;
    
}

@end
