//专门用来保存单例代码
//最后一行不要加\

//生成单例的类
//使用方法：
//1.在项目中导入该文件，并clean下
//2.在单例文件中#import该文件，即#import“singleton.h”
//3.在头文件中写：singleton_interface(单例文件名)，记住这里结尾不需要加分号
//4.在.m文件中写:singleton_implementation(单例文件名),不需要分号
//经过上面四步，该文件就是单例文件了

//使用时，声明单例用share。。方法声明


//@interface
#define singleton_interface(className) \
+ (className *)shared##className;


//@implementation
#define singleton_implementation(className) \
static className *_instance; \
+ (id)allocWithZone: (NSZone *)zone \
{ \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        _instance = [super allocWithZone:zone]; \
    }); \
return _instance; \
} \
+ (className *)shared##className \
{ \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        _instance = [[self alloc] init]; \
    }); \
    return _instance; \
}
