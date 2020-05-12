//
//  JQProgressAnimatedView.m
//  SilverLetterFinancial
//
//  Created by mac on 2017/7/7.
//  Copyright © 2017年 zongsheng. All rights reserved.
//

#import "JQProgressAnimatedView.h"

#define KHWCircleLineWidth 3.0f
#define KHWCircleFont [UIFont boldSystemFontOfSize:14.0f]
#define KHWCircleColor [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1]
#define KHWCircleBgColor [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:0.5f]
@interface JQProgressAnimatedView()

@property (nonatomic, strong) UILabel *cLabel;
@end

@implementation JQProgressAnimatedView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self initView];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        [self initView];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    
    return self;
}

- (void)initView{
    self.backgroundColor = [UIColor clearColor];
    self.progressColor = KHWCircleColor;
    self.trackColor = KHWCircleBgColor;
    self.progressLineWidth = KHWCircleLineWidth;
    self.progressLabelFont = KHWCircleFont;
    self.progressViewStyle = JQProgressViewStyleCircular;
    //百分比标签
    UILabel *cLabel = [[UILabel alloc] init];
    cLabel.font = self.progressLabelFont;
    cLabel.textColor = self.progressColor;
    cLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:cLabel];
    __weak __typeof(&*self)weakSelf = self;
    [cLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    self.cLabel = cLabel;
    
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
    _cLabel.text = [NSString stringWithFormat:@"%d%%", (int)floor(progress * 100)];
    [self setNeedsDisplay];
}

- (void)setIsHiddenProgressLabel:(BOOL)isHiddenProgressLabel
{
    _isHiddenProgressLabel = isHiddenProgressLabel;
    
    self.cLabel.hidden = isHiddenProgressLabel;
    
}

- (void)setProgressLabelFont:(UIFont *)progressLabelFont
{
    _progressLabelFont = progressLabelFont;
    self.cLabel.font = _progressLabelFont;
}

- (void)drawRect:(CGRect)rect
{
    
    if (self.progressViewStyle == JQProgressViewStyleCircular) {
        /** 背景圆圈 */
        //路径
        UIBezierPath *bgPath = [[UIBezierPath alloc] init];
        //线宽
        bgPath.lineWidth = self.progressLineWidth;
        //颜色
        [self.trackColor set];
        //拐角
        bgPath.lineCapStyle = kCGLineCapRound;
        bgPath.lineJoinStyle = kCGLineJoinRound;
        //半径
        CGFloat bgRadius = (MIN(rect.size.width, rect.size.height) - self.progressLineWidth) * 0.5;
        //画弧（参数：中心、半径、起始角度(3点钟方向为0)、结束角度、是否顺时针）
        [bgPath addArcWithCenter:(CGPoint){rect.size.width * 0.5, rect.size.height * 0.5} radius:bgRadius startAngle:M_PI * 1.5 endAngle:M_PI * 1.5 + M_PI * 2 clockwise:YES];
        //连线
        [bgPath stroke];
        
        
        /** 进度圆圈 */
        //路径
        UIBezierPath *path = [[UIBezierPath alloc] init];
        //线宽
        path.lineWidth = self.progressLineWidth;
        //颜色
        [self.progressColor set];
        //拐角
        path.lineCapStyle = kCGLineCapRound;
        path.lineJoinStyle = kCGLineJoinRound;
        //半径
        CGFloat radius = (MIN(rect.size.width, rect.size.height) - self.progressLineWidth) * 0.5;
        //画弧（参数：中心、半径、起始角度(3点钟方向为0)、结束角度、是否顺时针）
        [path addArcWithCenter:(CGPoint){rect.size.width * 0.5, rect.size.height * 0.5} radius:radius startAngle:M_PI * 1.5 endAngle:M_PI * 1.5 + M_PI * 2 * _progress clockwise:YES];
        //连线
        [path stroke];
    }else
    {
        
        /** 背景矩形圈 */
        
        //创建UIBezierPath
        UIBezierPath *apath = ({
            //颜色
            [self.trackColor set];
            UIBezierPath *path = [UIBezierPath bezierPath];
            path.lineWidth     = self.progressLineWidth;   //设置线条宽度
            path.lineCapStyle  = kCGLineCapRound;   //设置拐角
            path.lineJoinStyle = kCGLineCapRound;  //终点处理
            //设置起始点
            [path moveToPoint:CGPointMake(0, 0)];
            
            //增加线条
            [path addLineToPoint:CGPointMake(rect.size.width, 0)];
            [path addLineToPoint:CGPointMake(rect.size.width, rect.size.height)];
            [path addLineToPoint:CGPointMake(0, rect.size.height)];
//            [path addLineToPoint:CGPointMake(0, 40)];
            
            //关闭路径
            [path closePath];
            
            path;
        });
        
        //根据坐标连线
        [apath stroke];
        
        
        /** 进度圆圈 */
        //创建UIBezierPath
        UIBezierPath *papath = ({
            //颜色
            [self.progressColor set];
            UIBezierPath *path = [UIBezierPath bezierPath];
            path.lineWidth     = self.progressLineWidth;   //设置线条宽度
            path.lineCapStyle  = kCGLineCapSquare;   //设置拐角
            path.lineJoinStyle = kCGLineCapSquare;  //终点处理
            //设置起始点
            [path moveToPoint:CGPointMake(0, 0)];
            NSInteger inLineNumber = [self currentLinePointForProgress:_progress AndRect:rect];
            //周长
            CGFloat viewPerimeter = (rect.size.width+rect.size.height)*2.0f;
            if (inLineNumber == 1) {
                //增加线条
                [path addLineToPoint:CGPointMake(viewPerimeter*_progress, 0)];
            }else if (inLineNumber == 2)
            {
                //增加线条
                [path addLineToPoint:CGPointMake(rect.size.width, 0)];
                [path addLineToPoint:CGPointMake(rect.size.width, (viewPerimeter*_progress)-rect.size.width)];
            }else if (inLineNumber == 3)
            {
                //增加线条
                [path addLineToPoint:CGPointMake(rect.size.width, 0)];
                [path addLineToPoint:CGPointMake(rect.size.width, rect.size.height)];
                [path addLineToPoint:CGPointMake(rect.size.width-(((viewPerimeter*_progress)-rect.size.width)-rect.size.height), rect.size.height)];
            }else
            {
                //增加线条
                
                [path addLineToPoint:CGPointMake(rect.size.width, 0)];
                [path addLineToPoint:CGPointMake(rect.size.width, rect.size.height)];
                [path addLineToPoint:CGPointMake(0, rect.size.height)];
                [path addLineToPoint:CGPointMake(0, rect.size.height-(((viewPerimeter*_progress)-rect.size.width*2)-rect.size.height))];
            }
            
            
            //            [path addLineToPoint:CGPointMake(0, 40)];
            
//            //关闭路径
//            [path closePath];
            
            path;
        });
        
        //根据坐标连线
        [papath stroke];
        
        
    }
    
    

    
}

- (NSInteger) currentLinePointForProgress:(CGFloat)progress AndRect:(CGRect)rect
{
    NSInteger inLineNumber;
    //周长
    CGFloat viewPerimeter = (rect.size.width+rect.size.height)*2.0f;
    
    //宽与周长的比值
    CGFloat kbz = rect.size.width/viewPerimeter;
    //高与周长的比值
    CGFloat gbz = rect.size.height/viewPerimeter;
    
    if (progress<=kbz) { //进度条在 矩形上边的宽上
        inLineNumber = 1;
    }else if (progress <= (kbz+gbz)) //进度条在 矩形右边的高上
    {
        inLineNumber = 2;
    }else if (progress <= (kbz+gbz+kbz)) //进度条在 矩形下边的宽上
    {
        inLineNumber = 3;
    }else //进度条在 矩形左边的高上
    {
        inLineNumber = 4;
    }
    
    return inLineNumber;
    
}


@end
