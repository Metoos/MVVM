//
//  MJPhotoProgressView.m
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MJPhotoProgressView.h"

#define KHWCircleLineWidth 3.0f
#define KHWCircleFont [UIFont boldSystemFontOfSize:14.0f]
#define KHWCircleColor [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1]
#define KHWCircleBgColor [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:0.5f]
@interface MJPhotoProgressView()

@property (nonatomic, weak) UILabel *cLabel;
@end

@implementation MJPhotoProgressView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.progressLineWidth = KHWCircleLineWidth;
        self.progressLabelFont = KHWCircleFont;
        self.progressTintColor = KHWCircleBgColor;
        self.trackTintColor    = KHWCircleColor;
        //百分比标签
        UILabel *cLabel = [[UILabel alloc] init];
        cLabel.font = self.progressLabelFont;
        cLabel.textColor = KHWCircleColor;
        cLabel.textAlignment = NSTextAlignmentCenter;
        cLabel.text = [NSString stringWithFormat:@"0%%"];
        [self addSubview:cLabel];
        self.cLabel = cLabel;
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        //百分比标签
        UILabel *cLabel      = [[UILabel alloc] init];
        cLabel.font          = KHWCircleFont;
        cLabel.textColor     = KHWCircleColor;
        self.progressTintColor = KHWCircleBgColor;
        self.trackTintColor    = KHWCircleColor;
        cLabel.textAlignment = NSTextAlignmentCenter;
        cLabel.text = [NSString stringWithFormat:@"0%%"];
        [self addSubview:cLabel];
        cLabel.frame = self.bounds;
        self.cLabel = cLabel;
    }
    
    return self;
}

- (void)layoutSubviews
{
    self.cLabel.frame = self.bounds;
}

- (void)setProgress:(float)progress
{
    _progress = progress;
    
    _cLabel.text = [NSString stringWithFormat:@"%d%%", (int)floor(progress * 100)];
    [self setNeedsDisplay];
}

- (void)setProgressLabelFont:(UIFont *)progressLabelFont
{
    _progressLabelFont = progressLabelFont;
    self.cLabel.font = _progressLabelFont;
}

- (void)drawRect:(CGRect)rect
{
    /** 背景圆圈 */
    //路径
    UIBezierPath *bgPath = [[UIBezierPath alloc] init];
    //线宽
    bgPath.lineWidth = self.progressLineWidth;
    //颜色
    [self.progressTintColor set];
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
    [self.trackTintColor set];
    //拐角
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinRound;
    //半径
    CGFloat radius = (MIN(rect.size.width, rect.size.height) - self.progressLineWidth) * 0.5;
    //画弧（参数：中心、半径、起始角度(3点钟方向为0)、结束角度、是否顺时针）
    [path addArcWithCenter:(CGPoint){rect.size.width * 0.5, rect.size.height * 0.5} radius:radius startAngle:M_PI * 1.5 endAngle:M_PI * 1.5 + M_PI * 2 * _progress clockwise:YES];
    //连线
    [path stroke];
}

@end
