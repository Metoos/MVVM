//
//  JQUpload.m
//  SilverLetterFinancial
//
//  Created by mac on 2017/7/10.
//  Copyright © 2017年 zjq. All rights reserved.
//

#import "JQUpload.h"
#import "AliImageReshapeController.h"
#import <TZImagePickerController.h>
#import "JQPickerTableView.h"
@interface JQUpload()
<
UIActionSheetDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
ALiImageReshapeDelegate,
TZImagePickerControllerDelegate>

@property (weak, nonatomic) UIViewController *target;

@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSDictionary *parameters;

@property (strong, nonatomic) UIView *sender;

@property (assign, nonatomic) CGFloat reshapeScale;

@property (assign, nonatomic) BOOL isOnlyCameral;

@property (strong, nonatomic) AFHTTPSessionManager *manager;

@end

@implementation JQUpload

-(instancetype)initWithTarget:(UIViewController *)target sender:(UIView *)view postUrl:(NSString *)url parameters:(NSDictionary *)param
{
    self = [super init];
    if (self) {
        self.target     = target;
        self.url        = url;
        self.parameters = param;
        self.sender     = view;
        self.compressAndProportionWidth = 320;
        self.isFileUploadMethod = YES;
        self.allowsEditing = YES;
//        self.delegate = target;
    }
    return self;
    
}

- (void)selectImage
{
    //默认裁剪正方形
    [self selectImageReshapeScale:1.0];
}

- (void)selectImageReshapeScale:(CGFloat)reshapeScale
{
    self.reshapeScale = reshapeScale;
    self.isOnlyCameral = NO;
//    UIActionSheet *actionSheetImg = [[UIActionSheet alloc] initWithTitle:JQGetStringWithKeyFromTable(@"请选择上传的图片", nil)  delegate:self cancelButtonTitle:JQGetStringWithKeyFromTable(@"取消", nil)  destructiveButtonTitle:nil otherButtonTitles:JQGetStringWithKeyFromTable(@"从相册中选择", nil) ,JQGetStringWithKeyFromTable(@"手机拍照", nil) , nil];
    
    JQPickerTableView *picker = [[JQPickerTableView alloc]init];
    picker.title = @"请选择图片";
    picker.dataSourceArray = @[[[JQPickerTableViewItem alloc]initWithImageNamed:nil title:@"从相册中选择"],
        [[JQPickerTableViewItem alloc]initWithImageNamed:nil title:@"手机拍照"]];
    WEAKIFY
    [picker showWithCompletion:^(JQPickerTableView *pickerTableView, NSArray<NSNumber *> *rows) {
        STRONGIFY
        DLog(@"rows = %@",rows);
         [self actionClickedButtonAtIndex:[[rows firstObject] integerValue]];
    }];
    

//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    [actionSheetImg showInView:window];

}

/** 开始拍照上传的图片
 *@prama reshapeScale 裁剪比例
 */
- (void)selectImageForCameralReshapeScale:(CGFloat)reshapeScale
{
    self.reshapeScale = reshapeScale;
    self.isOnlyCameral = YES;
//    UIActionSheet *actionSheetImg = [[UIActionSheet alloc] initWithTitle:JQGetStringWithKeyFromTable(@"请选择上传的图片", nil)  delegate:self cancelButtonTitle:JQGetStringWithKeyFromTable(@"取消", nil)  destructiveButtonTitle:nil otherButtonTitles:JQGetStringWithKeyFromTable(@"手机拍照", nil) , nil];
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    [actionSheetImg showInView:window];
    
    JQPickerTableView *picker = [[JQPickerTableView alloc]init];
    picker.title = @"请选择图片";
    picker.dataSourceArray = @[
        [[JQPickerTableViewItem alloc]initWithImageNamed:nil title:@"手机拍照"]];
    WEAKIFY
    [picker showWithCompletion:^(JQPickerTableView *pickerTableView, NSArray<NSNumber *> *rows) {
        STRONGIFY
        DLog(@"rows = %@",rows);
         [self actionClickedButtonAtIndex:[[rows firstObject] integerValue]];
    }];
    
}

#pragma make UIActionSheetDelegate
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
- (void)actionClickedButtonAtIndex:(NSInteger)buttonIndex
{
    

    switch (buttonIndex) {
        case 0:
            if (self.isOnlyCameral) {
               [self takePhotoFromCameral];
                break;
            }
           
            [self takePhotoFromAlbum];
            
            
            break;
        case 1:
            if (!self.isOnlyCameral) {
                [self takePhotoFromCameral];
                break;
            }
            break;
            
        default:
            break;
    }
    
}


#pragma mark - 使用系统 从相册中选择图片
- (void)takePhotoFromAlbum{
    
    
    UIImagePickerController *picker1 = [[UIImagePickerController alloc] init];
    //资源类型为图片库
    picker1.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker1.delegate = self;
    //设置选择后的图片可被编辑
//    picker1.allowsEditing = YES;
    picker1.navigationBar.barTintColor = kNavBgColor;
    [self.target presentViewController:picker1 animated:YES completion:nil];
    
}

#pragma mark - 从相机拍摄图片
- (void)takePhotoFromCameral
{
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
       
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        //    <UINavigationControllerDelegate,UIImagePickerControllerDelegate>
        picker.delegate = self;
//        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.navigationBar.barTintColor = kNavBgColor;
        [self.target presentViewController:picker animated:YES completion:nil];
    }
}

#pragma mark - ALiImageReshapeDelegate

- (void)imageReshaperController:(AliImageReshapeController *)reshaper didFinishPickingMediaWithInfo:(UIImage *)image
{
    //图片显示在界面上
    
    if (_delegate && [_delegate respondsToSelector:@selector(selectWithUploadView:Image:)]) {
        [_delegate selectWithUploadView:self.sender Image:image];
    }
    
    
    [self uploadProcessImage:image];
    
    [reshaper dismissViewControllerAnimated:YES completion:nil];
}

- (void)imageReshaperControllerDidCancel:(AliImageReshapeController *)reshaper
{
    [reshaper dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    if (picker.allowsEditing) {
        UIImage* image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        //图片显示在界面上
        
        if (_delegate && [_delegate respondsToSelector:@selector(selectWithUploadView:Image:)]) {
            [_delegate selectWithUploadView:self.sender Image:image];
        }
        
        [self uploadProcessImage:image];

        [picker dismissViewControllerAnimated:YES completion:nil];
        
    } else {
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        AliImageReshapeController *vc = [[AliImageReshapeController alloc] init];
        vc.sourceImage = image;
        vc.reshapeScale = self.reshapeScale;
        vc.delegate = self;
        [picker dismissViewControllerAnimated:NO completion:^{
            [self.target presentViewController:vc animated:YES completion:nil];
        }];
        
//        [picker pushViewController:vc animated:YES];
    }
    
}

//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
//{
//    //    获得选择的图片
//    //当图片不为空时显示图片并保存图片
//    if (image != nil) {
//        
//        //图片显示在界面上
//        
//        if (_delegate && [_delegate respondsToSelector:@selector(selectWithUploadView:Image:)]) {
//            [_delegate selectWithUploadView:self.sender Image:image];
//        }
//        
//        
//        [self uploadProcessImage:image];
//
//        
//    }
//    //关闭相册界面
//    [self.target dismissViewControllerAnimated:YES completion:nil];
//}

#pragma mark - 处理上传图片数据格式并上传到服务器
- (void)uploadProcessImage:(UIImage *)image
{
    UIImage * im2 =  [self compressAndProportionWithImageName:image AndWidth:self.compressAndProportionWidth];
    
    //以下是保存文件到沙盒路径下
    //把图片转成NSData类型的数据来保存文件
    NSData *data;
    //判断图片是不是png格式的文件
    NSString *imageType = nil;
    NSUInteger length = 0;
    if (UIImagePNGRepresentation(im2)) {
        //返回为png图像。
        data = UIImagePNGRepresentation(im2);
        //获取图片占用空间大小
        length = [data length];
        NSLog(@"length = %lu",length);
        imageType = @"png";
    }else {
        //返回为JPEG图像。
        data = UIImageJPEGRepresentation(im2, 0.8f);
        //获取图片占用空间大小
        length = [data length];
        NSLog(@"length = %lu",length);
        imageType = @"jpeg";
    }
    
    if (self.isFileUploadMethod) {
        [self uploadImgWithFileImgData:data AndImageType:imageType];
    }else
    {
        [self uploadImgWithSexadecimalImgData:data AndImageType:imageType imageLenght:length];
    }

    
}

/**
 *  按比例来压缩,固定宽度，高度自动缩放
 */
- (UIImage*)compressAndProportionWithImageName:(UIImage *)sourceImage AndWidth:(CGFloat)defineWidth{
    //    CGFloat defineWidth = 800;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(size);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)cancelRequest
{
    if ([self.manager.tasks count] > 0) {
        NSLog(@"返回时取消网络请求");
        [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
        //NSLog(@"tasks = %@",manager.tasks);
    }
}

/** file格式上传图片 */
- (void)uploadImgWithFileImgData:(NSData*)data AndImageType:(NSString*)imageType
{
    
    __weak __typeof(&*self)weakSelf = self;
    self.manager = [AFHTTPSessionManager manager];
    self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //添加对 text/html的支持
    self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.parameters];
//    NSString *randomString = [UniversalManager getSyetemTimeInterval];
//    [dic setObject:randomString forKey:@"timestamp"];
//    NSString *sign = [UniversalManager md5EncryptStrWithParam:dic];
//    [dic setObject:sign forKey:@"sign"];
//    dic.addObjectSupplementForKey(@"logincode",AppLoginUser.logincode)
//    .addObjectSupplementForKey(@"signcode",AppLoginUser.signcode);
    NSString *sign = [UniversalManager md5EncryptStrWithParam:dic];
    dic.addObjectSupplementForKey(@"sign",sign);
    DLog(@"file格式上传图片dic=%@",dic);
    // 显示进度
    [self.manager POST:self.url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //把图片转成NSData类型的
        //数据来保存文件
        // 上传的参数名
        NSString * Name = self.fieldName?:@"file";
        // 上传filename
        NSString * fileName = [[NSString alloc] initWithFormat:@"%@.%@", Name,[imageType isEqualToString:@"jpeg"]?@"jpg":imageType];
        
        [formData appendPartWithFileData:data name:Name fileName:fileName mimeType:[[NSString alloc] initWithFormat:@"image/%@",imageType]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(uploadBeginWithUploadView:)]) {
                [weakSelf.delegate uploadBeginWithUploadView:weakSelf.sender];
            }
        });
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(uploadWithUploadView:Progress:)]) {
                [weakSelf.delegate uploadWithUploadView:weakSelf.sender Progress:uploadProgress.fractionCompleted];
            }
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(uploadSuceessWithUploadView:task:responseObject:)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.delegate uploadSuceessWithUploadView:weakSelf.sender task:task responseObject:responseObject];
            });
        }
       
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"错误 %@", error);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(uploadFailureWithUploadView:task:error:responseObject:)]) {
                [weakSelf.delegate uploadFailureWithUploadView:weakSelf.sender task:task error:error responseObject:nil];
            }
        });
    }];
    
}

/** 十六进制形式上传图片 */
- (void)uploadImgWithSexadecimalImgData:(NSData*)data AndImageType:(NSString*)imageType imageLenght:(NSUInteger)lenght
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //添加对 text/html的支持
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    //响应结果序列化类型

    //获取图片数据内容（十六进制）
    NSString *content = [self convertDataToHexStr:data];
//    NSString *checkValue = [self encryptXor:data];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.parameters];
//    [dic setObject:checkValue forKey:@"checkValue"];
    [dic setObject:imageType forKey:@"suffix"];
//    [dic setObject:@"1b8c60b7af33670012931e9999ae279f" forKey:@"token"];
    NSString *randomString = [UniversalManager getSyetemTimeInterval];
    //在参数中添加时间戳和签名字段
    [dic setObject:randomString forKey:@"timestamp"];
//    [dic setObject:SERVER_NO forKey:@"no"];
    if ([dic[@"method"] isEqualToString:@"img_head"]) {
        [dic setObject:content forKey:@"head"];
    }else
    {
        [dic setObject:content forKey:@"content"];
    }
    NSString *sign = [UniversalManager md5EncryptStrWithParam:dic];
    
//    [dic setObject:@(lenght) forKey:@"totalLength"];
    [dic setObject:sign forKey:@"sign"];
    NSLog(@"sign = %@",sign);
    
    NSLog(@"request url: %@",self.url);
    NSLog(@"parameters: %@",dic);
    
    __weak __typeof(&*self)weakSelf = self;
    if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(uploadBeginWithUploadView:)]) {
        [weakSelf.delegate uploadBeginWithUploadView:weakSelf.sender];
    }

    [manager POST:self.url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
        dispatch_async(dispatch_get_main_queue(), ^
        {
            NSLog(@"当前上传进度 = %lf",uploadProgress.fractionCompleted);
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(uploadWithUploadView:Progress:)]) {
                [weakSelf.delegate uploadWithUploadView:weakSelf.sender Progress:uploadProgress.fractionCompleted];
            }
                           
        });
       
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
        NSLog(@"responseObject = %@",responseObject);
        
        JQBaseModel *model = [JQBaseModel mj_objectWithKeyValues:responseObject];
        
        if (model.code == successed) {
            /** 上传成功回调img_url */
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(uploadSuceessWithUploadView:task:responseObject:)]) {
                [weakSelf.delegate uploadSuceessWithUploadView:weakSelf.sender task:task responseObject:responseObject];
            }
        }else
        {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(uploadFailureWithUploadView:task:error:responseObject:)]) {
                [weakSelf.delegate uploadFailureWithUploadView:weakSelf.sender task:task error:nil responseObject:responseObject];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(uploadFailureWithUploadView:task:error:responseObject:)]) {
            [weakSelf.delegate uploadFailureWithUploadView:weakSelf.sender task:task error:error responseObject:nil];
        }
    }];
}

/** 图片data转十六进制格式 */
- (NSString *)convertDataToHexStr:(NSData *)data {
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] < 2) {
                [string appendFormat:@"0%@",hexStr];
            } else {
                [string appendString:hexStr];
            }
        }
    }];

//    NSLog(@"十六进制结果:%@",string);
    return string;
}

/** 对二进制异或 返回十六进制字符串*/
- (NSString *)aencryptXor:(NSData *)data {
    
    NSLog(@"二进制: %@",data);
    char *dataP = (char *)[data bytes];
    for (int i = 0; i < data.length; i++) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunsequenced"
        *dataP = *(++dataP) ^ 1;
#pragma clang diagnostic pop
    }
    NSLog(@"二进制异或结果: %@",data);
    NSString *result = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"二进制异或结果字符串: %@",result);
    return [self convertDataToHexStr:data];
}

/**
 *  异或加密算法
 *
 *  @param sourceData 需要加密的字节流
 *
 *  @return 加密后的字节流
 */
- (NSString *)encryptXor:(NSData *)sourceData {
   
    Byte keyByte = 0x00;
    Byte *sourceDataPoint = (Byte *)[sourceData bytes];  //取需要加密的数据的Byte数组
//    NSLog(@"二进制: %s",sourceDataPoint);
    
    for (long i = 0; i < [sourceData length]; i++) {
        keyByte = sourceDataPoint[i] ^ keyByte; //前一位和后一位进行异或运算
    }
    
//    NSLog(@"二进制异或结果: %hhu",keyByte);
    NSData *dataResult = [NSData dataWithBytes:&keyByte length:1];

    return [self convertDataToHexStr:dataResult];
}

//十六进制转data
- (NSData *)convertHexStrToData:(NSString *)str {
    if (!str || [str length] == 0) {
        return nil;
    }
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
//    NSLog(@"hexdata: %@", hexData);
    return hexData;
}

- (void)dealloc
{
    self.manager = nil;
    self.delegate = nil;
}

@end
