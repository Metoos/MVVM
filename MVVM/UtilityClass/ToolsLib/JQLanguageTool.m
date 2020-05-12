//
//  JQLanguageTool.m
//  BBA
//
//  Created by life on 2018/5/4.
//  Copyright © 2018年 hdyg. All rights reserved.
//
#define CNS @"zh-Hans"
#define EN @"en"
#define JA @"ja"
#define KO @"ko"
#define RU @"ru"

#define LANGUAGE_SET @"langeuageset"

#import "AppDelegate.h"

#import "JQLanguageTool.h"
//#import "LoginViewController.h"
static JQLanguageTool *sharedModel;

@interface JQLanguageTool()

@property(nonatomic,strong)NSBundle *bundle;
@property(nonatomic,copy)NSString *language;



@end
@implementation JQLanguageTool

+(id)sharedInstance
{
    if (!sharedModel)
    {
        sharedModel = [[JQLanguageTool alloc]init];
    }
    
    return sharedModel;
}

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        [self initLanguage];
    }
    
    return self;
}
-(void)initLanguage
{
    NSString *tmp = [[NSUserDefaults standardUserDefaults]objectForKey:LANGUAGE_SET];
    NSString *path;
    
    
    //默认是英文
    if (!tmp)
    {
//        NSString *systemLanguage = [self getPreferredLanguage];
//        if ([systemLanguage isEqualToString:@"zh-Hans-CN"] || [systemLanguage isEqualToString:@"en-CN"]
//            || [systemLanguage isEqualToString:CNS] || [systemLanguage isEqualToString:EN] ||[systemLanguage isEqualToString:JA]||[systemLanguage isEqualToString:KO]||[systemLanguage isEqualToString:RU]) {
//            tmp = systemLanguage;
//        }else
//        {
//            tmp = EN;
//        }
        
        tmp = CNS;
        
    }
    self.language = tmp;
    path = [[NSBundle mainBundle]pathForResource:self.language ofType:@"lproj"];
    self.bundle = [NSBundle bundleWithPath:path];
}

-(NSString *)getStringForKey:(NSString *)key withTable:(NSString *)table
{
    if (self.bundle)
    {
        return NSLocalizedStringFromTableInBundle(key, table, self.bundle, @"");
        
    }
    return NSLocalizedStringFromTable(key, table, @"");
    
}

/**  *得到本机现在用的语言  * en:英文  zh-Hans:简体中文   zh-Hant:繁体中文    ja:日本  ......  */
- (NSString*)getPreferredLanguage {
    
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString* preferredLang = [languages objectAtIndex:0];
    NSLog(@"Preferred Language:%@", preferredLang);
    return preferredLang;
}

-(void)changeNowLanguage
{
    if ([self.language isEqualToString:EN])
    {
        [self setNewLanguage:CNS];
    }
    else
    {
        [self setNewLanguage:EN];
    }
}

/** * 改变为英文语言 */
-(void)changeEnLanguage
{
    [self setNewLanguage:EN];
}
/** * 改变为中文语言 */
-(void)changeZhLanguage
{
    [self setNewLanguage:CNS];
}

/** * 改变为日文语言 */
-(void)changeJaLanguage
{
    [self setNewLanguage:JA];
}
/** * 改变为韩文语言 */
-(void)changeKoLanguage
{
    [self setNewLanguage:KO];
}
/** * 改变为俄文语言 */
-(void)changeRuLanguage
{
    [self setNewLanguage:RU];
}

- (NSString *)currentLanguage
{
    return self.language;
}

-(void)setNewLanguage:(NSString *)language
{
    if ([language isEqualToString:self.language])
    {
        return;
    }
    if ([language isEqualToString:EN] || [language isEqualToString:CNS] ||[language isEqualToString:JA]||[language isEqualToString:KO]||[language isEqualToString:RU])
    {
        NSString *path = [[NSBundle mainBundle]pathForResource:language ofType:@"lproj"];
        self.bundle = [NSBundle bundleWithPath:path];
        
    }
    self.language = language;
    [[NSUserDefaults standardUserDefaults]setObject:language forKey:LANGUAGE_SET];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self resetRootViewController];
    
}

//重新设置
-(void)resetRootViewController
{
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    LoginViewModel *viewModel = [[LoginViewModel alloc]init];
////    viewModel.isResetLanguage = YES;
//    LoginViewController *login =  [[LoginViewController alloc]initStoryboardWithName:@"My" identiffier:@"LoginViewController" ViewModel:viewModel];
//    JQNavigationController *nav = [[JQNavigationController alloc]initWithRootViewController:login];
//    appDelegate.window.rootViewController = nav;
    
    
}


@end
