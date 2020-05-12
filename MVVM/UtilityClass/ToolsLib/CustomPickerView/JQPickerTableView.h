//
//  JQPickerTableView.h
//  JQ
//
//  Created by life on 2016/2/27.
//  Copyright © 2016年 life. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,JQPickerSelectStyle) {
    JQPickerSelectStyleNone,     //none
    JQPickerSelectStyleRadio,    //单选
    JQPickerSelectStyleMultiple, //多选
};

@class JQPickerTableView;
@protocol JQPickerTableViewDidSelectedDelegate <NSObject>

@optional

// 选中row的时候调用 (JQPickerSelectStyleNone,JQPickerSelectStyleRadio 时调用)
- (void)pickerTableView:(JQPickerTableView *)pickerView didSelectRowAtIndex:(NSInteger)index;

// 多选选中row的时候调用 (JQPickerSelectStyleMultiple 时调用)
- (void)pickerTableView:(JQPickerTableView *)pickerView didSelectRowsAtIndexs:(NSArray<NSNumber*> *)indexs;

@end


@class JQPickerTableViewItem;

typedef void(^pickerTableCompletion)(JQPickerTableView *pickerTableView, NSArray<NSNumber *> *rows);

@interface JQPickerTableView : UIView

@property (weak, nonatomic) id<JQPickerTableViewDidSelectedDelegate>delegate;
/** 数据源 */
@property (nonatomic,strong) NSArray<JQPickerTableViewItem*> *dataSourceArray;
/** 标题 */
@property (nonatomic,strong) NSString *title;
/** 行高 */
@property (nonatomic,assign) CGFloat rowHeight;
/** 当前选中的索引 */
@property (nonatomic, assign) NSInteger currentSelectIndex;
/** 当前选中的索引数组 （JQPickerSelectStyleMultiple 多选时存在） */
@property (nonatomic, strong) NSMutableArray<NSNumber *> *currentSelectIndexs;
    
/** 显示选择的风格 默认 none */
@property (nonatomic, assign) JQPickerSelectStyle selectStyle;

//弹出
- (void)show;
//移除
- (void)dismess;

- (void)showWithCompletion:(pickerTableCompletion)completion;

@end


@interface JQPickerTableViewItem : NSObject

@property (strong, nonatomic) NSString *imageNamed;

@property (strong, nonatomic) NSString *imageUrlString;

@property (strong, nonatomic) NSString *title;
/** 当前是否选中 */
@property (nonatomic, assign) BOOL selected;

/** 加载本地图片 */
- (instancetype)initWithImageNamed:(NSString *)imageNamed title:(NSString*)title;
/** 加载远程网络图片 */
- (instancetype)initWithImageUrl:(NSString *)imageUrlString title:(NSString*)title;


@end
