//
//  MenuItemView.m
//  MengJiong
//
//  Created by ManLoo on 16/7/25.
//  Copyright © 2016年 manloo. All rights reserved.
//

#import "MenuItemView.h"
#import "MenuItem.h"
#import "UIImage+JQExtension.h"
#import "UIImageView+WebCache.h"
#define kMenuItemViewBorder 10
#define kMenuItemViewTitleTextW 80
#define kMenuItemViewTitleTextH 15
#define kMenuItemViewTitleTextFont 14
#define kMenuItemViewSubTitleTextFont 12
#define kMenuItemViewTitleTextColor RGBColor(102, 102, 102)
#define kMenuItemViewTitleTextNumberOfLines 2
#define IsNilOrNull(_ref) (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))
@interface MenuItemView ()

@property (nonatomic, weak) UIView *container;
@property (nonatomic, weak) UIImageView *iconImage;
@property (nonatomic, weak) UILabel *titleName;
@property (nonatomic, weak) UILabel *subTitleName;
@end

@implementation MenuItemView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    
    UIView *container = [[UIView alloc] init];

    container.userInteractionEnabled = NO;
//    container.backgroundColor = [UIColor redColor];
    
    UIImageView *iconImage = [[UIImageView alloc] init];
    iconImage.contentMode = UIViewContentModeCenter;
    [container addSubview:iconImage];
    
    self.iconImage = iconImage;
    
    UILabel *titleName = [[UILabel alloc] init];
    titleName.font = [UIFont systemFontOfSize:kMenuItemViewTitleTextFont];
    titleName.textColor = self.menuItemViewTitleTextColor;
    titleName.textAlignment = NSTextAlignmentCenter;
    titleName.backgroundColor = [UIColor clearColor];
    titleName.numberOfLines = kMenuItemViewTitleTextNumberOfLines;
    [container addSubview:titleName];
    
    self.titleName = titleName;
    
    UILabel *subTitleName = [[UILabel alloc] init];
    subTitleName.font = [UIFont systemFontOfSize:kMenuItemViewSubTitleTextFont];
    subTitleName.textColor = [UIColor grayColor];
    subTitleName.textAlignment = NSTextAlignmentCenter;
    subTitleName.backgroundColor = [UIColor clearColor];
    subTitleName.numberOfLines = kMenuItemViewTitleTextNumberOfLines;
    [container addSubview:subTitleName];
    
    self.subTitleName = subTitleName;
    
    [self addSubview:container];
    
    self.container = container;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
//    CGFloat imageIconW = self.iconImage.image.size.width;
//    CGFloat imageIconH = self.iconImage.image.size.height;
    CGFloat imageIconW = 0.0;
    CGFloat imageIconH = 0.0;
    if ([UIScreen mainScreen].bounds.size.height>=568) {
        imageIconW = _imageWidth*kScreenWidthRatio;
        imageIconH = _imageHeight*kScreenHeightRatio;
    }else
    {
        imageIconW = _imageWidth;
        imageIconH = _imageHeight;
    }
    CGFloat imageIconX = self.frame.size.width * 0.5 - imageIconW * 0.5;
    CGFloat imageIconY = 0;
    if (_isUseCircularImg) {
        imageIconY = -10;
    }
    self.iconImage.frame = CGRectMake(imageIconX, imageIconY, imageIconW, imageIconH);
    self.iconImage.layer.masksToBounds = YES;
    self.iconImage.layer.cornerRadius  = self.iconImage.size.width/7;
    if (_isUseCircularImg) {
        self.iconImage.layer.cornerRadius = self.iconImage.size.width/2;
        
    }
    
    //    CGFloat titleTextW = kMenuItemViewTitleTextW;//zjq
    CGFloat titleTextW = self.frame.size.width;
    CGFloat titleTextH = kMenuItemViewTitleTextH;
    CGFloat titleTextX = self.frame.size.width * 0.5 - titleTextW * 0.5;
    CGFloat titleTextY = imageIconY + imageIconH + kMenuItemViewBorder-5;
    self.titleName.frame = CGRectMake(titleTextX, titleTextY, titleTextW, titleTextH);
    
    CGFloat subTitleTextW = self.frame.size.width;
    CGFloat subTitleTextH = kMenuItemViewTitleTextH;
    CGFloat subTitleTextX = self.frame.size.width * 0.5 - subTitleTextW * 0.5;
    CGFloat subTitleTextY = titleTextY + titleTextH;
    self.subTitleName.frame = CGRectMake(subTitleTextX, subTitleTextY, subTitleTextW, subTitleTextH);
    
    
    CGFloat containerW = self.frame.size.width;
    CGFloat containerH = titleTextY + titleTextH;
    CGFloat containerX = self.frame.size.width * 0.5 - containerW * 0.5;
    CGFloat containerY = self.frame.size.height * 0.5 - containerH * 0.5;;
    self.container.frame = CGRectMake(containerX, containerY, containerW, containerH);
}

- (void)setGridLine:(BOOL)gridLine {
    
    _gridLine = gridLine;
    
    if (self.gridLine) {
        [self setBackgroundImage:[UIImage resizedImageWithName:@"common_background_line"]
                        forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage resizedImageWithName:@"common_background_line_highlighted"]
                        forState:UIControlStateHighlighted];
    }
}
-(void)setMenuItemViewTitleTextColor:(UIColor *)menuItemViewTitleTextColor
{
    _menuItemViewTitleTextColor = menuItemViewTitleTextColor;
    
    self.titleName.textColor = menuItemViewTitleTextColor;
}

- (void)setMenuItem:(MenuItem *)menuItem {
    
    _menuItem = menuItem;
    
    if (!IsNilOrNull(self.menuItem)) {
        
        if (self.menuItem.iconName) {
            self.iconImage.image = [UIImage imageNamed:self.menuItem.iconName];
            self.titleName.text = self.menuItem.titleName;
            if (self.menuItem.subAttTitleName) {
                self.subTitleName.attributedText = self.menuItem.subAttTitleName;
            }else
            {
                self.subTitleName.text = self.menuItem.subTitleName;
            }
            
        
            
        }else
        {
            [self.iconImage sd_setImageWithURL:[NSURL URLWithString:self.menuItem.iconPath] placeholderImage:placeholderImg options:SDWebImageRetryFailed];
            self.titleName.text = self.menuItem.titleName;
            if (self.menuItem.subAttTitleName) {
                self.subTitleName.attributedText = self.menuItem.subAttTitleName;
            }else
            {
                self.subTitleName.text = self.menuItem.subTitleName;
            }
        }
        
       
    }
}


@end
