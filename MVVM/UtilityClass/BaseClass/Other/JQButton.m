//
//  JQButton.m
//  BBA
//
//  Created by life on 2018/9/7.
//  Copyright © 2018年 hdyg. All rights reserved.
//

#import "JQButton.h"

@interface JQButton ()
@end

@implementation JQButton



- (instancetype)init
{
    self = [super init];
    if (self) {
        self.space = 5;
 
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.space = 5;

    }
    return self;
}

-(void)setImageAlignment:(NSUInteger)imageAlignment
{
    _imageAlignment = imageAlignment;
    [self layoutSubviews];
}
- (void)setSpace:(CGFloat)space
{
    _space = space;
    [self layoutSubviews];
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    
    [super setTitle:title forState:state];
    [self layoutSubviews];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat space = self.space;

//    self.titleLabel.numberOfLines = 0;
    CGFloat titleW = CGRectGetWidth(self.titleLabel.bounds);//titleLabel的宽度
    CGFloat titleH = CGRectGetHeight(self.titleLabel.bounds);//titleLabel的高度
    
    NSDictionary *attrs = @{NSFontAttributeName : self.titleLabel.font};
    CGSize titleSize = [self.titleLabel.text boundingRectWithSize:CGSizeMake(self.size.width, self.titleLabel.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrs context:nil].size;
    self.titleLabel.width = titleSize.width;
    titleW = titleSize.width;
    
    CGFloat imageW = CGRectGetWidth(self.imageView.bounds);//imageView的宽度
    CGFloat imageH = CGRectGetHeight(self.imageView.bounds);//imageView的高度

    CGFloat btnCenterX = CGRectGetWidth(self.bounds)/2;//按钮中心点X的坐标（以按钮左上角为原点的坐标系）
    CGFloat imageCenterX = btnCenterX - titleW/2;//imageView中心点X的坐标（以按钮左上角为原点的坐标系）
    CGFloat titleCenterX = btnCenterX + imageW/2;//titleLabel中心点X的坐标（以按钮左上角为原点的坐标系）


    switch (self.imageAlignment)
    {
        case JQImageAlignmentTop:
        {
            [self adjustButtonImageViewUPTitleDownWithButton:self];
//            self.titleEdgeInsets = UIEdgeInsetsMake(imageH/2+ space/2, -(titleCenterX-btnCenterX), -(imageH/2 + space/2), titleCenterX-btnCenterX);
//            self.imageEdgeInsets = UIEdgeInsetsMake(-(titleH/2 + space/2), btnCenterX-imageCenterX, titleH/2+ space/2, -(btnCenterX-imageCenterX));
        }
            break;
        case JQImageAlignmentLeft:
        {
            self.titleEdgeInsets = UIEdgeInsetsMake(0, space/2, 0,  -space/2);
            self.imageEdgeInsets = UIEdgeInsetsMake(0, -space/2, 0, space);
        }
            break;
        case JQImageAlignmentBottom:
        {
            self.titleEdgeInsets = UIEdgeInsetsMake(-(imageH/2+ space/2), -(titleCenterX-btnCenterX), imageH/2 + space/2, titleCenterX-btnCenterX);
            self.imageEdgeInsets = UIEdgeInsetsMake(titleH/2 + space/2, btnCenterX-imageCenterX,-(titleH/2+ space/2), -(btnCenterX-imageCenterX));
        }
            break;
        case JQImageAlignmentRight:
        {
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageW + space/2), 0, imageW + space/2);
            self.imageEdgeInsets = UIEdgeInsetsMake(0, titleW+space/2, 0, -(titleW+space/2));
        }
            break;
        default:
            break;
    }
}



- (void)adjustButtonImageViewUPTitleDownWithButton:(UIButton *)button {
    [button.superview layoutIfNeeded];
    //使图片和文字居左上角
    button.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    CGFloat buttonHeight = CGRectGetHeight(button.frame);
    CGFloat buttonWidth = CGRectGetWidth(button.frame);
    
    CGFloat ivHeight = CGRectGetHeight(button.imageView.frame);
    CGFloat ivWidth = CGRectGetWidth(button.imageView.frame);
    
    CGFloat titleHeight = CGRectGetHeight(button.titleLabel.frame);
    CGFloat titleWidth = CGRectGetWidth(button.titleLabel.frame);
    //调整图片
    float iVOffsetY = buttonHeight / 2.0 - (ivHeight + titleHeight) / 2.0;
    float iVOffsetX = buttonWidth / 2.0 - ivWidth / 2.0;
    [button setImageEdgeInsets:UIEdgeInsetsMake(iVOffsetY-self.space/2, iVOffsetX, 0, 0)];
    
    //调整文字
    float titleOffsetY = iVOffsetY + CGRectGetHeight(button.imageView.frame);
    float titleOffsetX = 0;
    if (CGRectGetWidth(button.imageView.frame) >= (CGRectGetWidth(button.frame) / 2.0)) {
        //如果图片的宽度超过或等于button宽度的一半
        titleOffsetX = -(ivWidth + titleWidth - buttonWidth / 2.0 - titleWidth / 2.0);
    }else {
        titleOffsetX = buttonWidth / 2.0 - ivWidth - titleWidth / 2.0;
    }
    [button setTitleEdgeInsets:UIEdgeInsetsMake(titleOffsetY+self.space/2 , titleOffsetX, 0, 0)];
}


@end
