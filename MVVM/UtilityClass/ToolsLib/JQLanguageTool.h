//
//  JQLanguageTool.h
//  BBA
//
//  Created by life on 2018/5/4.
//  Copyright © 2018年 hdyg. All rights reserved.
//

#import <Foundation/Foundation.h>
#define JQGetStringWithKeyFromTable(key, tbl)[[JQLanguageTool sharedInstance] getStringForKey:key withTable:tbl]

@interface JQLanguageTool : NSObject

+(id)sharedInstance;
/** * 返回table中指定的key的值
 *
 * @param key key
 * @param table table
 *
 * @return 返回table中指定的key的值
 */
-(NSString *)getStringForKey:(NSString *)key withTable:(NSString *)table;
/** * 改变语言 */
-(void)changeNowLanguage;
/** * 改变为英文语言 */
-(void)changeEnLanguage;
/** * 改变为中文语言 */
-(void)changeZhLanguage;
/** * 改变为日文语言 */
-(void)changeJaLanguage;
/** * 改变为韩文语言 */
-(void)changeKoLanguage;
/** * 改变为俄文语言 */
-(void)changeRuLanguage;

- (NSString *)currentLanguage;
/** * 设置新的语言
 *
 * @param language 新语言
 */
-(void)setNewLanguage:(NSString*)language;

//重新设置
-(void)resetRootViewController;


@end
