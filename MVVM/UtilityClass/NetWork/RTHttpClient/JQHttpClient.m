//
//  JQHttpClient.m
//  net
//
//  Created by zjq on 2017/6/11.
//  Copyright © 2017年 zjq. All rights reserved.
//

#import "JQHttpClient.h"
#import "Reachability.h"//pod 'Reachability', '~> 3.1.1'
//#import "RTJSONResponseSerializerWithData.h"

@interface JQHttpClient()
@property(nonatomic,strong) AFHTTPSessionManager *manager;

@property(nonatomic,strong) UIAlertView *alertView;
@end

@implementation JQHttpClient

- (id)init{
    if (self = [super init]){
        self.manager = [AFHTTPSessionManager manager];
        //请求参数序列化类型
        self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
//        RTJSONResponseSerializerWithData *JSONResponseSerializerWithData = [RTJSONResponseSerializerWithData serializer];
        AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
        //添加对 text/html的支持
        responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
        //响应结果序列化类型
        self.manager.responseSerializer = responseSerializer;
    }
    return self;
}

+ (JQHttpClient *)defaultClient
{
    static JQHttpClient *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

//取消所有请求线程队列
- (void)cancelAllOperations
{
    [self.manager.operationQueue cancelAllOperations];
}

- (void)requestWithPath:(NSString *)url
                 method:(JQHttpRequestType)method
             parameters:(id)parameters
         prepareExecute:(PrepareExecuteBlock)prepareExecute
                success:(void (^)(NSURLSessionDataTask * _Nullable, id _Nullable))success
                failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nullable))failure
{
    
    //请求的URL
    DLog(@"Request URL:%@",url);
//    DLog(@"Request Body：%@", parameters);
   
    NSData *datax = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *parametersString = [[NSString alloc] initWithData:datax encoding:NSUTF8StringEncoding];
    DLog(@"Request Body：%@", parametersString);
    
    //判断网络状况（有链接：执行请求；无链接：弹出提示）
    if ([self isConnectionAvailable]) {
        //预处理（显示加载信息啥的）
        if (prepareExecute) {
            prepareExecute();
        }
        switch (method) {
            case JQHttpRequestGet:
            {
//                self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//                self.manager.securityPolicy.allowInvalidCertificates = YES;//生产环境不建议使用
//                self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];

                [self.manager GET:url parameters:parameters headers:nil progress:nil success:success failure:failure];
                
            }
                break;
            case JQHttpRequestPost:
            {
                //请求参数序列化类型
                self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
//                [self.manager POST:url parameters:parameters progress:nil success:success failure:failure];
                [self.manager POST:url parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    [self otherExecuteWithURL:url AndTask:task AndResponseObject:responseObject Success:success];
                } failure:failure];
            }
                break;
            case JQHttpRequestPostString:
            {
                //请求参数序列化类型
                
                AFHTTPRequestSerializer *requesetSerializer  = [AFHTTPRequestSerializer serializer];
                [requesetSerializer requestWithMethod:@"POST" URLString:url parameters:parameters error:nil];
                self.manager.requestSerializer = requesetSerializer;
//                [self.manager POST:url parameters:parameters progress:nil success:success failure:failure];
                [self.manager POST:url parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    [self otherExecuteWithURL:url AndTask:task AndResponseObject:responseObject Success:success];
                } failure:failure];
            }
                break;
            case JQHttpRequestDelete:
            {
                //请求参数序列化类型
//                self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
                [self.manager DELETE:url parameters:parameters  headers:nil success:success failure:failure];
            }
                break;
            case JQHttpRequestPut:
            {
                [self.manager PUT:url parameters:parameters headers:nil success:success failure:failure];
            }
                break;
            default:
                break;
        }
    }else{
        //网络错误咯
//        [self showExceptionDialogToView:view];
        //发出网络异常通知广播
        failure(nil,nil);
        [[NSNotificationCenter defaultCenter] postNotificationName:k_NOTI_NETWORK_ERROR object:TEXT_NETWORK_ERROR];
    }

}

//统一处理所以请求的token过期问题
- (void)otherExecuteWithURL:(NSString*)url AndTask:(NSURLSessionDataTask * _Nullable)task AndResponseObject:(id)responseObject
              Success:(void (^)(NSURLSessionDataTask * _Nullable, id _Nullable))success
{
    if([responseObject[@"code"] integerValue] == OtherDevice ||
       [responseObject[@"code"] integerValue] == UnLogin) //token过期自动提示重新登录
    {
        success(task,@{@"code":responseObject[@"code"],@"data":@"",@"message":JQGetStringWithKeyFromTable(@"提出提示", nil)});
        if (self.alertView.isVisible) {
            return;
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:k_SHOW_LOGINVIEW object:@(0)];

    }else
    {
        success(task,responseObject);
    }
}


- (void)requestSimpleWithPath:(NSString *)url
                 method:(JQHttpRequestType)method
             parameters:(id)parameters
         prepareExecute:(PrepareExecuteBlock)prepareExecute
                success:(void (^)(NSURLSessionDataTask * _Nullable, id _Nullable))success
                failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nullable))failure
{
    
    
    //请求的URL
    DLog(@"Request path:%@",url);
    DLog(@"请求参数：%@", parameters);
    
    
    //判断网络状况（有链接：执行请求；无链接：弹出提示）
    if ([self isConnectionAvailable]) {
        //预处理（显示加载信息啥的）
        if (prepareExecute) {
            prepareExecute();
        }
        switch (method) {
            case JQHttpRequestGet:
            {
                //                [self.manager GET:url parameters:parameters success:success failure:failure];
                //                self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
                //                self.manager.securityPolicy.allowInvalidCertificates = YES;//生产环境不建议使用
                //                self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
                
                [self.manager GET:url parameters:parameters headers:nil progress:nil success:success failure:failure];
                
            }
                break;
            case JQHttpRequestPost:
            {
                //请求参数序列化类型
                self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
                [self.manager POST:url parameters:parameters headers:nil progress:nil success:success failure:failure];
            }
                break;
            case JQHttpRequestPostString:
            {
                //请求参数序列化类型
                
                AFHTTPRequestSerializer *requesetSerializer  = [AFHTTPRequestSerializer serializer];
                [requesetSerializer requestWithMethod:@"POST" URLString:url parameters:parameters error:nil];
                self.manager.requestSerializer = requesetSerializer;
                [self.manager POST:url parameters:parameters headers:nil progress:nil success:success failure:failure];
            }
                break;
            case JQHttpRequestDelete:
            {
                //请求参数序列化类型
                //                self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
                [self.manager DELETE:url parameters:parameters headers:nil success:success failure:failure];
            }
                break;
            case JQHttpRequestPut:
            {
                [self.manager PUT:url parameters:parameters headers:nil success:success failure:failure];
            }
                break;
            default:
                break;
        }
    }else{
        //网络错误咯
        //        [self showExceptionDialogToView:view];
        //发出网络异常通知广播
        
        failure(nil,nil);
        [[NSNotificationCenter defaultCenter] postNotificationName:k_NOTI_NETWORK_ERROR object:TEXT_NETWORK_ERROR];
    }
    
}





- (void)postRequestWithPath:(NSString *)url
                 parameters:(id)parameters
             prepareExecute:(PrepareExecuteBlock) prepareExecute
                    success:(void (^)(NSURLResponse *response, id responseObject))success
                    failure:(void (^)(NSURLResponse *response, NSError *error))failure
{
    
    //请求的URL
    DLog(@"Request path:%@",url);
    
    //判断网络状况（有链接：执行请求；无链接：弹出提示）
    if ([self isConnectionAvailable]) {
        //预处理（显示加载信息啥的）
        if (prepareExecute) {
            prepareExecute();
        }
       
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
        
        [request setHTTPMethod:@"POST"];

        NSString *urlBody = [[NSString alloc] initWithFormat:@"%@",parameters];
        NSData *data = [urlBody dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:data];
        NSURLSession *session = [[NSURLSession alloc]init];
        [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (!error) {
                NSError *error = nil;
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                //                  NSLog(@"dic:%@",dic);
                success(response,dic);
            }else
            {
                
                failure(response,error);
            }
            
            
            
        }];
        
        
    }else{
        //网络错误咯
        //        [self showExceptionDialogToView:view];
        //发出网络异常通知广播
        [[NSNotificationCenter defaultCenter] postNotificationName:k_NOTI_NETWORK_ERROR object:TEXT_NETWORK_ERROR];
    }
    
    
    
}

- (void)GetRequestWithPath:(NSString *)url
                 parameters:(id)parameters
             prepareExecute:(PrepareExecuteBlock) prepareExecute
                    success:(void (^)(NSURLResponse *response, id responseObject))success
                    failure:(void (^)(NSURLResponse *response, NSError *error))failure
{
    
    //请求的URL
    DLog(@"Request path:%@",url);
    
    //判断网络状况（有链接：执行请求；无链接：弹出提示）
    if ([self isConnectionAvailable]) {
        //预处理（显示加载信息啥的）
        if (prepareExecute) {
            prepareExecute();
        }
    
        [[NSURLSession sharedSession]dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (!error) {
                NSError *error = nil;
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                //                  NSLog(@"dic:%@",dic);
                success(response,dic);
            }else
            {
                
                failure(response,error);
            }
            
        }];
        
        
    }else{
        //网络错误咯
        //        [self showExceptionDialogToView:view];
        //发出网络异常通知广播
        [[NSNotificationCenter defaultCenter] postNotificationName:k_NOTI_NETWORK_ERROR object:TEXT_NETWORK_ERROR];
    }
    
    
    
}

- (void)requestWithPathInHEAD:(NSString *)url
                   parameters:(NSDictionary *)parameters
                       inView:(UIView *)view
                      success:(void (^)(NSURLSessionDataTask *task))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    if ([self isConnectionAvailable]) {
        [self.manager HEAD:url parameters:parameters headers:nil success:success failure:failure];
    }else{
        [self showExceptionDialogToView:view];
    }
}

- (void)connectionAvailablewithSuccessBlock:(successBlock)success
{
    [[AFNetworkReachabilityManager sharedManager]startMonitoring];
    
    [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (status == 0) {
            if (success) {
                success(TEXT_NETWORK_ERROR);
            }
            
            //发出网络异常通知广播
            [[NSNotificationCenter defaultCenter] postNotificationName:k_NOTI_NETWORK_ERROR object:TEXT_NETWORK_ERROR];
        }else if (status == 1){
            if (success) {
                success(@"3G/4G网络");
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:k_CONN_NETWORK_SUCCES object:nil userInfo:@{@"status":@(status)}];
        }else if (status == 2){
            if (success) {
                success(@"wifi状态下");
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:k_CONN_NETWORK_SUCCES object:nil userInfo:@{@"status":@(status)}];
        }
    }];
}

////看看网络是不是给力
- (BOOL)isConnectionAvailable{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        DLog(@"Error. Could not recover network reachability flags");
        return NO;
    }
    BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
    return (isReachable && !needsConnection) ? YES : NO;
}




//弹出网络错误提示框
- (void)showExceptionDialogToView:(UIView*)view
{
//    [[[UIAlertView alloc] initWithTitle:@"提示"
//                                message:@"网络异常，请检查网络连接"
//                               delegate:self
//                      cancelButtonTitle:@"好的"
//                      otherButtonTitles:nil, nil] show];
    
    [UIAlertController alertControllerWithTitle:@"提示" message:@"网络异常，请检查网络连接" preferredStyle:UIAlertControllerStyleAlert];
}

@end
