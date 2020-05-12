//
//  JQPickerView.m
//  JQ
//
//  Created by life on 2016/2/27.
//  Copyright © 2016年 life. All rights reserved.
//

//屏幕宽高
#define     k_ViewWidth       [UIScreen mainScreen].bounds.size.width
#define     k_ViewHeight      [UIScreen mainScreen].bounds.size.height
//屏幕比例

#define     k_ScreenWidthRatio    (kViewWidth/320.0)
#define     k_ScreenHeightRatio   (kViewHeight/568.0>1?kViewHeight/568.0:1)

#define     JQColorRGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define     kShowViewHeight 250 //选择器显示高度


#import "JQPickerView.h"
#import "Province.h"
@interface JQPickerView()<UIPickerViewDelegate,UIPickerViewDataSource>
/** view */
@property (nonatomic,strong) UIView *topView;
/** button */
@property (nonatomic,strong) UIButton *doneBtn;
/** button */
@property (nonatomic,strong) UIButton *closeBtn;
/** pickerView */
@property (nonatomic,strong) UIPickerView *pickerView;
/** srting */
@property (nonatomic,strong) NSString *result;
/** selected index */
@property (nonatomic, assign) NSInteger index;



@property (nonatomic ,strong) NSMutableArray * pArr;/**< 地址选择器数据源,装省份模型,每个省份模型内包含城市模型*/

@property (nonatomic ,strong) NSDictionary   * dataDict;/**< 省市区数据源字典*/
@property (nonatomic ,strong) NSMutableArray * provincesArr;/**< 省份名称数组*/
@property (nonatomic ,strong) NSDictionary   * citysDict;/**< 所有城市的字典*/
@property (nonatomic ,strong) NSDictionary   * areasDict;/**< 所有地区的字典*/

@property (nonatomic ,copy) pickerCompletion pickerCompletion;

@property (nonatomic ,copy) addressCompletion addressCompletion;

@end

@implementation JQPickerView


-(instancetype)initWithFrame:(CGRect)frame
{
    //    967
    self = [super initWithFrame:CGRectMake(0, 0, k_ViewWidth, k_ViewHeight+kShowViewHeight)];
    
    if (self)
    {
        self.backgroundColor = JQColorRGBA(0, 0, 0, 0.4);
        self.index = 0;
        [self setup];
        
    }
    return self;
}

- (void)setIsDistrictPickerView:(BOOL)isDistrictPickerView
{
    _isDistrictPickerView = isDistrictPickerView;
    if (isDistrictPickerView) {
        [self loadAddressData];
        [self.pickerView reloadAllComponents];
    }
}

-(void)setup
{
    [self.topView setFrame:CGRectMake(0, k_ViewHeight, k_ViewWidth, kShowViewHeight)];
    self.topView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.topView];
    
    //为view上面的两个角做成圆角。不喜欢的可以注掉
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.topView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(2, 2)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.topView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.topView.layer.mask = maskLayer;
    
    
    [self.doneBtn setFrame:CGRectMake(k_ViewWidth-60, 0, 50*k_ScreenWidthRatio, 40*k_ScreenHeightRatio)];
    [self.topView addSubview:self.doneBtn];
    
    [self.closeBtn setFrame:CGRectMake(10, 0, 30, 40*k_ScreenHeightRatio)];
    [self.topView addSubview:self.closeBtn];
    
    
    UILabel *titlelb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 175*k_ScreenWidthRatio, 40*k_ScreenHeightRatio)];
    titlelb.backgroundColor = [UIColor clearColor];
    titlelb.textAlignment = NSTextAlignmentCenter;
    titlelb.text = self.title;
    titlelb.font = [UIFont systemFontOfSize:14];
    
    titlelb.adjustsFontSizeToFitWidth = YES;
    CGPoint point = self.center;
    point.y = 50*k_ScreenHeightRatio/2.0;
    titlelb.center = point;
    [self.topView addSubview:titlelb];
    
    
    [self.pickerView setFrame:CGRectMake(0, 40*k_ScreenHeightRatio, self.topView.frame.size.width, kShowViewHeight-(40*k_ScreenHeightRatio))];
    [_pickerView selectRow:self.index inComponent:0 animated:YES];
    [self.topView addSubview:self.pickerView];
    
    
}

//快速创建
+(instancetype)pickerView;
{
    return [[self alloc]init];
}

-(void)setArray:(NSArray *)array
{
    _array = array;
    [self.pickerView reloadAllComponents];
}

//弹出
- (void)show
{
    [self showWithCompletion:NULL];
}

- (void)showWithCompletion:(pickerCompletion)completion
{
    self.pickerCompletion = completion;
    [self showInView:[UIApplication sharedApplication].keyWindow];
}

//弹出选择地区完成时回调
- (void)showWithAddressCompletion:(addressCompletion)completion
{
    self.addressCompletion = completion;
    [self showInView:[UIApplication sharedApplication].keyWindow];
}

//添加弹出移除的动画效果
- (void)showInView:(UIView *)view
{
    
    // 浮现
    [UIView animateWithDuration:0.3 animations:^{
        CGPoint point = self.center;
        point.y -= kShowViewHeight;
        self.center = point;
    } completion:^(BOOL finished) {
        
    }];
    DLog(@"self = %@",NSStringFromCGRect(self.frame));
    [view addSubview:self];
}

-(void)quit
{
    [self dismess];
    
    if (_isDistrictPickerView) {
        
        if (self.districtType == ProvinceAndCityAndAreaType) {
            NSInteger selectProvince = [self.pickerView selectedRowInComponent:0];
            NSInteger selectCity     = [self.pickerView selectedRowInComponent:1];
            NSInteger selectArea     = [self.pickerView selectedRowInComponent:2];
            Province * p = _pArr[selectProvince];
            //解决省市同时滑动未结束时点击完成按钮的数组越界问题
            if (selectCity > p.cityModels.count - 1) {
                selectCity = p.cityModels.count - 1;
            }
            
            City * c = p.cityModels[selectCity];
            //解决省市区同时滑动未结束时点击完成按钮的数组越界问题
            if (selectArea > c.areas.count - 1) {
                selectArea = c.areas.count - 1;
            }
            
            ![self isRespondsToSelector]?:[_delegate pickerView:self Province:p.name City:c.cityName Area:c.areas[selectArea]];
            
            !self.addressCompletion?:self.addressCompletion(self,p.name,c.cityName,c.areas[selectArea]);
            
        }else if (self.districtType == ProvinceAndCityType)
        {
            NSInteger selectProvince = [self.pickerView selectedRowInComponent:0];
            NSInteger selectCity     = [self.pickerView selectedRowInComponent:1];
            Province * p = _pArr[selectProvince];
            //解决省市同时滑动未结束时点击完成按钮的数组越界问题
            if (selectCity > p.cityModels.count - 1) {
                selectCity = p.cityModels.count - 1;
            }
            
            City * c = p.cityModels[selectCity];
            
            ![self isRespondsToSelector]?:[_delegate pickerView:self Province:p.name City:c.cityName Area:nil];
            
            !self.addressCompletion?:self.addressCompletion(self,p.name,c.cityName,nil);
            
        }else if (self.districtType == ProvinceType)
        {
            NSInteger selectProvince = [self.pickerView selectedRowInComponent:0];
            Province * p = _pArr[selectProvince];
            
            ![self isRespondsToSelector]?:[_delegate pickerView:self Province:p.name City:nil Area:nil];
            !self.addressCompletion?:self.addressCompletion(self,p.name,nil,nil);
        }
        
    }else
    {
        if (!self.result) {
            self.result = self.array[self.index];
        }
        NSLog(@"%@",self.result);
        !self.pickerCompletion?:self.pickerCompletion(self,self.index);
        if (_delegate && [_delegate respondsToSelector:@selector(pickerView:didSelectRow:)]) {
            
            [_delegate pickerView:self didSelectRow:self.index];
        }
    }
}

- (BOOL)isRespondsToSelector
{
    if (_delegate && [_delegate respondsToSelector:@selector(pickerView:Province:City:Area:)]) {
        return YES;
    }
    return NO;
}

- (void)dismess
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
        CGPoint point = self.center;
        point.y += kShowViewHeight;
        self.center = point;
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (_isDistrictPickerView) {
        
        if (self.districtType == ProvinceAndCityAndAreaType) {
            return 3;
        }else if (self.districtType == ProvinceAndCityType)
        {
            return 2;
        }
        
    }
    return 1;
}

// returns the # of rows in each component.
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (_isDistrictPickerView) {
        if (0 == component) {
            return _pArr.count;
        }
        else if (1 == component){
            NSInteger selectProvince = [pickerView selectedRowInComponent:0];
            Province  * p            = _pArr[selectProvince];
            return p.cities.count;
        }
        else if (2 == component){
            NSInteger selectProvince = [pickerView selectedRowInComponent:0];
            NSInteger selectCity     = [pickerView selectedRowInComponent:1];
            Province  * p            = _pArr[selectProvince];
            if (selectCity > p.cityModels.count - 1) {
                return 0;
            }
            City * c = p.cityModels[selectCity];
            return c.areas.count;
        }
        
    }
    
    return [self.array count];
}

#pragma mark - 代理
// 返回第component列第row行的标题
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (_isDistrictPickerView) {
        if (0 == component) {
            Province * p = _pArr[row];
            return p.name;
        }
        else if (1 == component) {
            Province * selectP = _pArr[[pickerView selectedRowInComponent:0]];
            if (row > selectP.cities.count - 1) {
                return nil;
            }
            return selectP.cities[row];
        }
        else if (2 == component) {
            NSInteger selectProvince = [pickerView selectedRowInComponent:0];
            NSInteger selectCity     = [pickerView selectedRowInComponent:1];
            Province  * p            = _pArr[selectProvince];
            if (selectCity > p.cityModels.count - 1) {
                return nil;
            }
            City * c = p.cityModels[selectCity];
            if (row > c.areas.count -1 ) {
                return nil;
            }
            return c.areas[row];
        }
        
    }
    
    
    return self.array[row];
}

// 选中第component第row的时候调用
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (_isDistrictPickerView) {
        
        if (self.districtType == ProvinceAndCityAndAreaType) {
            if (0 == component) {
                NSInteger selectCity = [pickerView selectedRowInComponent:1];
                NSInteger selectArea = [pickerView selectedRowInComponent:2];
                [pickerView reloadComponent:1];
                [pickerView selectRow:selectCity inComponent:1 animated:YES];
                [pickerView reloadComponent:2];
                [pickerView selectRow:selectArea inComponent:2 animated:YES];
                
            }
            else if (1 == component){
                NSInteger selectArea = [pickerView selectedRowInComponent:2];
                [pickerView reloadComponent:2];
                [pickerView selectRow:selectArea inComponent:2 animated:YES];
            }
        }else if (self.districtType == ProvinceAndCityType)
        {
            if (0 == component) {
                NSInteger selectCity = [pickerView selectedRowInComponent:1];
                [pickerView reloadComponent:1];
                [pickerView selectRow:selectCity inComponent:1 animated:YES];
                
            }
        }
        
        
        
    }else
    {
        self.index = row;
        self.result = self.array[row];
        //        if (_delegate && [_delegate respondsToSelector:@selector(pickerView:didSelectRow:)]) {
        //
        //            [_delegate pickerView:self didSelectRow:row];
        //        }
    }
    
    
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row forComponent:(NSInteger)component
           reusingView:(UIView *)view{
    
    UILabel* pickerLabel = (UILabel*)view;
    
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.textColor = [UIColor colorWithRed:51.0/255
                                                green:51.0/255
                                                 blue:51.0/255
                                                alpha:1.0];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:18]];
    }
    
    pickerLabel.text = [self pickerView:pickerView
                            titleForRow:row
                           forComponent:component];
    return pickerLabel;
}

#pragma mark - 懒加载
-(UIView *)topView
{
    if (_topView == nil) {
        _topView = [[UIView alloc]initWithFrame:CGRectZero];
    }
    return _topView;
}

- (UIButton *)doneBtn
{
    if (_doneBtn == nil) {
        _doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_doneBtn addTarget:self action:@selector(quit) forControlEvents:UIControlEventTouchUpInside];
        [_doneBtn setImage:[UIImage imageNamed:@"jq_done"] forState:UIControlStateNormal];
    }
    return _doneBtn;
}

- (UIButton *)closeBtn
{
    if (_closeBtn == nil) {
        
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn addTarget:self action:@selector(dismess) forControlEvents:UIControlEventTouchUpInside];
        [_closeBtn setImage:[UIImage imageNamed:@"jq_close"] forState:UIControlStateNormal];
    }
    
    return  _closeBtn;
}


- (UIPickerView *)pickerView
{
    if (_pickerView == nil) {
        _pickerView = [[UIPickerView alloc]init];
        [_pickerView setBackgroundColor:JQColorRGBA(239, 239, 244, 1)];
        
        [_pickerView setDelegate:self];
        [_pickerView setDataSource:self];
        
    }
    return _pickerView;
}

#pragma mark - 加载地址数据
- (void)loadAddressData{
    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"address"
                                                          ofType:@"txt"];
    
    NSError  * error;
    NSString * str22 = [NSString stringWithContentsOfFile:filePath
                                                 encoding:NSUTF8StringEncoding
                                                    error:&error];
    
    if (error) {
        return;
    }
    
    _dataDict = [self dictionaryWithJsonString:str22];
    
    if (!_dataDict) {
        return;
    }
    
    _provincesArr = [_dataDict objectForKey:@"p"];
    _citysDict    = [_dataDict objectForKey:@"c"];
    _areasDict    = [_dataDict objectForKey:@"a"];
    
    _pArr         = [[NSMutableArray alloc]init];
    
    //省份模型数组加载各个省份模型
    for (int i = 0 ;i < _provincesArr.count; i++) {
        NSArray  * citys = [_citysDict objectForKey:_provincesArr[i]];
        Province * p     = [Province provinceWithName:_provincesArr[i]
                                               cities:citys];
        [_pArr addObject:p];
    }
    
    //各个省份模型加载各自的所有城市模型
    for (Province * p in _pArr) {
        NSMutableArray * areasArr = [[NSMutableArray alloc]init];
        for (NSString * cityName in p.cities) {
            NSString * cityKey = [NSString stringWithFormat:@"%@-%@",p.name,cityName];
            NSArray  * cityArr = [_areasDict objectForKey:cityKey];
            City     * city    = [City cityWithName:cityName areas:cityArr];
            [areasArr addObject:city];
        }
        p.cityModels = areasArr;
    }
}

#pragma mark - 解析json

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData  * jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError * err;
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

-(void)dealloc
{
    DLog(@"界面释放");
}

@end
