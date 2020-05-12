//
//  JQPickerTableView.m
//  JQ
//
//  Created by life on 2016/2/27.
//  Copyright © 2016年 life. All rights reserved.
//

#import "JQPickerTableView.h"
//屏幕宽高
#define     k_ViewWidth       [UIScreen mainScreen].bounds.size.width
#define     k_ViewHeight      [UIScreen mainScreen].bounds.size.height
//屏幕比例

#define     k_ScreenWidthRatio    (kViewWidth/320.0)
#define     k_ScreenHeightRatio   (kViewHeight/568.0>1?kViewHeight/568.0:1)

#define     JQColorRGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define     kShowViewHeight (300*k_ScreenHeightRatio) //选择器显示高度

#define k_Device_Is_iPhoneX (([[UIApplication sharedApplication] statusBarFrame].size.height)>=44)
#define k_Distancebottom                   (k_Device_Is_iPhoneX?34.0f:0.0f)

@interface JQPickerTableView()<UITableViewDelegate,UITableViewDataSource>
{
    JQPickerTableViewItem *selectedItem;
}
/** view */
@property (nonatomic,strong) UIView *topView;
/** button */
@property (nonatomic,strong) UIButton *doneBtn;
/** button */
@property (nonatomic,strong) UIButton *closeBtn;
/** title Label */
@property (nonatomic,strong) UILabel *titleLabel;
/** pickerView */
@property (nonatomic,strong) UITableView *tableView;
/** srting */
@property (nonatomic,strong) NSString *result;


@property (nonatomic,assign) CGFloat showViewHeight;
@property (nonatomic ,copy) pickerTableCompletion pickerCompletion;

@end


@implementation JQPickerTableView

-(instancetype)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:CGRectMake(0, 0, k_ViewWidth, k_ViewHeight+kShowViewHeight)];
    
    if (self)
    {
        self.backgroundColor = JQColorRGBA(0, 0, 0, 0.4);
        
        self.currentSelectIndex = 0;
        self.rowHeight = 60.0f;
        self.showViewHeight = kShowViewHeight;
        
    }
    return self;
}

- (void)setShowViewHeight:(CGFloat)showViewHeight
{
    _showViewHeight = showViewHeight;
    [self setNeedsDisplay];
    
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
//    self.showViewHeight = self.rowHeight*self.dataSourceArray.count+50*k_ScreenHeightRatio;
    self.height = k_ViewHeight+self.showViewHeight;
    [self.topView setFrame:CGRectMake(0, k_ViewHeight, k_ViewWidth, self.showViewHeight)];
    self.topView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.topView];
    
    //为view上面的两个角做成圆角。不喜欢的可以注掉
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.topView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.topView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.topView.layer.mask = maskLayer;
    
    
    [self.doneBtn setFrame:CGRectMake(k_ViewWidth-60, 5, 50*k_ScreenWidthRatio, 40)];
    [self.topView addSubview:self.doneBtn];
    
    if (self.selectStyle == JQPickerSelectStyleNone) {
        [self.closeBtn setFrame:CGRectMake(k_ViewWidth-60, 10, 30, 30)];
    }else
    {
        [self.closeBtn setFrame:CGRectMake(10, 10, 30, 30)];
    }
    
    
    [self.topView addSubview:self.closeBtn];
    

//    CGPoint point = self.center;
//    point.y = 50*k_ScreenHeightRatio/2.0;

    [self.topView addSubview:self.titleLabel];
    
    [self.tableView setFrame:CGRectMake(0, 50, self.topView.frame.size.width, self.rowHeight*self.dataSourceArray.count)];
    DLog(@"self.tableView = %@",NSStringFromCGRect(self.tableView.frame));
     DLog(@"topView = %@",NSStringFromCGRect(self.topView.frame));
    [self.topView addSubview:self.tableView];
    
    
    
}

- (void)setDataSourceArray:(NSArray<JQPickerTableViewItem *> *)dataSourceArray
{
    _dataSourceArray = dataSourceArray;
    self.showViewHeight = self.rowHeight*self.dataSourceArray.count+50+k_Distancebottom;
    [self setNeedsDisplay];
    if(self.selectStyle == JQPickerSelectStyleRadio)
    {
        if (_dataSourceArray.count-1 >= self.currentSelectIndex) {
            selectedItem = _dataSourceArray[self.currentSelectIndex];
            selectedItem.selected = YES;
        }
    }else if(self.selectStyle == JQPickerSelectStyleMultiple)
    {
        for (NSNumber *indexNum in self.currentSelectIndexs) {
            NSInteger index = [indexNum integerValue];
            if (_dataSourceArray.count-1 >= index) {
               JQPickerTableViewItem *selectedPItme = _dataSourceArray[index];
               selectedPItme.selected = YES;
            }
        }
    }
     [self.tableView reloadData];
}

- (void)setRowHeight:(CGFloat)rowHeight
{
    _rowHeight = rowHeight;
    self.showViewHeight = _rowHeight*self.dataSourceArray.count+50+k_Distancebottom;
    [self setNeedsDisplay];
}

//弹出
- (void)show
{
    [self showWithCompletion:NULL];
}

- (void)showWithCompletion:(pickerTableCompletion)completion
{
    self.pickerCompletion = completion;
    [self showInView:[UIApplication sharedApplication].keyWindow];
}

//添加弹出移除的动画效果
- (void)showInView:(UIView *)view
{
    
    // 浮现
    [UIView animateWithDuration:0.3 animations:^{
        CGPoint point = self.center;
        point.y -= self.showViewHeight;
        self.center = point;
    } completion:^(BOOL finished) {
        
    }];
    DLog(@"self = %@",NSStringFromCGRect(self.frame));
    [view addSubview:self];
}

-(void)finish
{
    [self dismess];
    
    !_pickerCompletion?:_pickerCompletion(self,@[@(self.currentSelectIndex)]);
    if (_delegate && [_delegate respondsToSelector:@selector(pickerTableView:didSelectRowAtIndex:)]) {
        
        [_delegate pickerTableView:self didSelectRowAtIndex:self.currentSelectIndex];
    }
    
}

- (void)dismess
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
        CGPoint point = self.center;
        point.y += self.showViewHeight;
        self.center = point;
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return self.rowHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"JQPickerTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    JQPickerTableViewItem *itme = self.dataSourceArray[indexPath.row];
    if (self.selectStyle == JQPickerSelectStyleNone) {
        
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else
    {
        if (itme.selected) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    
    cell.imageView.contentMode = UIViewContentModeCenter;
    if (itme.imageNamed) {
        cell.imageView.image = [UIImage resizedImage:[UIImage imageNamed:itme.imageNamed] toSize:CGSizeMake(35.0f, 35.0f)];
    }else if (itme.imageUrlString) {
        
         [cell.imageView jq_setImageWithURL:itme.imageUrlString placeholderImage:placeholderImg width:35.0f];
//        [cell.imageView jq_setImageWithURL:itme.imageUrlString];
    }else
    {
        cell.imageView.image = nil;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = itme.title;
    cell.textLabel.textColor = JQColorRGBA(51, 51, 51, 1);
    cell.textLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size: 16];
    return cell;
}
    


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.selectStyle == JQPickerSelectStyleNone)
    {
        [tableView reloadData];
        self.currentSelectIndex = indexPath.row;
        [self finish];
        
    }else if(self.selectStyle == JQPickerSelectStyleRadio)
    {
        selectedItem.selected = NO;
        JQPickerTableViewItem *itme = self.dataSourceArray[indexPath.row];
        selectedItem = itme;
        selectedItem.selected = YES;
        [tableView reloadData];
        self.currentSelectIndex = indexPath.row;
    }else if(self.selectStyle == JQPickerSelectStyleMultiple)
    {
        JQPickerTableViewItem *itme = self.dataSourceArray[indexPath.row];
        itme.selected = !itme.selected;
        [tableView reloadData];
        NSNumber *index = [NSNumber numberWithInteger:indexPath.row];
        if(itme.selected)
        {
            [self.currentSelectIndexs addObject:index];
        }else
        {
            WS(weakSelf);
            [self.currentSelectIndexs enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if([obj isEqual:index])
                {
                    [weakSelf.currentSelectIndexs removeObjectAtIndex:idx];
                    *stop = YES;
                }
            }];
        }
        [self dismess];
        !_pickerCompletion?:_pickerCompletion(self,self.currentSelectIndexs);
        if (_delegate && [_delegate respondsToSelector:@selector(pickerTableView:didSelectRowsAtIndexs:)]) {
            [_delegate pickerTableView:self didSelectRowsAtIndexs:(NSArray*)self.currentSelectIndexs];
        }
    }
   
    
}

#pragma mark - 懒加载
- (UIView *)topView
{
    if (_topView == nil) {
        _topView = [[UIView alloc]initWithFrame:CGRectZero];
    }
    return _topView;
}

- (UIButton *)doneBtn
{
    if (self.selectStyle != JQPickerSelectStyleNone) {
        if (_doneBtn == nil) {
            _doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_doneBtn setTitle:@"完成" forState:UIControlStateNormal];
            [_doneBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [_doneBtn addTarget:self action:@selector(finish) forControlEvents:UIControlEventTouchUpInside];
        }
        return _doneBtn;
    }
    
    return nil;
   
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

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView setBackgroundColor:JQColorRGBA(255, 255, 255, 1)];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.bounces = NO;
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
    }
    return _tableView;
}

- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 175*k_ScreenWidthRatio, 50)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = self.selectStyle == JQPickerSelectStyleNone?NSTextAlignmentLeft:NSTextAlignmentCenter;
        _titleLabel.text = self.title;
        _titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size: 17];
    }
    return _titleLabel;
}

- (NSMutableArray<NSNumber *> *)currentSelectIndexs
{
    if(!_currentSelectIndexs)
    {
        _currentSelectIndexs = [[NSMutableArray alloc]init];
    }
    return _currentSelectIndexs;
}
    
@end


@implementation JQPickerTableViewItem

- (instancetype)initWithImageNamed:(NSString *)imageNamed title:(NSString*)title
{
    self = [super init];
    if (self) {
        
        _imageNamed = imageNamed;
        _title = title;
    }
    
    return self;
}
- (instancetype)initWithImageUrl:(NSString *)urlString title:(NSString*)title
{
    self = [super init];
    if (self) {
        _imageUrlString = urlString;
        _title = title;
    }
    
    return self;
}




@end
