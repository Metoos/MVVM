//
//  JQPickerView.h
//  JQ
//
//  Created by life on 2016/2/27.
//  Copyright © 2016年 life. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger,PickerViewDataType) {
    PickerViewDataTypeNone = 0, //通用数据选择器
    PickerViewDataTypeDistrict, //地区选择器
    PickerViewDataTypeDate,     //时间选择器
};

typedef NS_ENUM(NSUInteger,DistrictType) {
    ProvinceAndCityAndAreaType = 0, //省市区选择器
    ProvinceAndCityType,            //省市选择器
    ProvinceType                    //省 选择器
};


@class JQPickerView;
@protocol JQPickerViewDidSelectedDelegate <NSObject>
@optional
// 选中第component第row的时候调用
- (void)pickerView:(JQPickerView *)pickerView didSelectRow:(NSInteger)row;

/**
 *  地区选择器点击事件
 *
 *  @param province 当前选中的省份
 *  @param city     当前选中的市
 *  @param area     当前选中的区
 */
- (void)pickerView:(JQPickerView *)pickerView Province:(NSString *)province City:(NSString *)city Area:(NSString *)area;
@end

typedef void(^pickerCompletion)(JQPickerView *pickerView, NSInteger row);

typedef void(^addressCompletion)(JQPickerView *pickerView, NSString *province, NSString *city, NSString *area);

@interface JQPickerView : UIView

@property (weak, nonatomic) id<JQPickerViewDidSelectedDelegate>delegate;
/** array */
@property (nonatomic,strong) NSArray *array;
/** title */
@property (nonatomic,strong) NSString *title;

/** 是否为地区选择器 default NO  YES时传入array无效*/
@property (nonatomic,assign) BOOL isDistrictPickerView;
@property (nonatomic,assign) DistrictType districtType;


//快速创建
+(instancetype)pickerView;


//弹出
-(void)show;
//弹出选择完成时回调
-(void)showWithCompletion:(pickerCompletion)completion;
//弹出选择地区完成时回调
-(void)showWithAddressCompletion:(addressCompletion)completion;
//移除
- (void)dismess;

@end
