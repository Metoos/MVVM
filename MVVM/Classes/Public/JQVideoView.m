//
//  JQVideoView.m
//  MVVM
//
//  Created by mac on 2019/10/10.
//  Copyright © 2019 hdyg. All rights reserved.
//

#import "JQVideoView.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
@interface JQVideoView()

@property (strong, nonatomic) AVPlayer *avPlayer;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;
@property (assign, nonatomic) BOOL isPaused;
@end

@implementation JQVideoView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setPlayer];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setPlayer];
    }
    return self;
}

- (void)setPlayer
{
//    //网络视频播放
//    NSString *playString = @"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4";
//    NSURL *url = [NSURL URLWithString:playString];

//    本地视频播放
    NSString *audioPath = [[NSBundle mainBundle] pathForResource:@"loginbg" ofType:@"mp4"];
    NSURL *url = [NSURL fileURLWithPath:audioPath?:@""];
    
    //设置播放的项目0
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:url];
    //初始化player对象
    self.avPlayer = [[AVPlayer alloc] initWithPlayerItem:item];
    self.avPlayer.volume = 0.0f; //设置为静音
    
    self.playerLayer = nil;
    //设置播放页面
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.avPlayer];
    //设置播放页面的大小
    self.playerLayer.frame = self.bounds;
    self.playerLayer.backgroundColor = [UIColor cyanColor].CGColor;
    //设置播放窗口和当前视图之间的比例显示内容
    //1.保持纵横比；适合层范围内
    //2.保持纵横比；填充层边界
    //3.拉伸填充层边界
    /*
     第1种AVLayerVideoGravityResizeAspect是按原视频比例显示，是竖屏的就显示出竖屏的，两边留黑；
     第2种AVLayerVideoGravityResizeAspectFill是以原比例拉伸视频，直到两边屏幕都占满，但视频内容有部分就被切割了；
     第3种AVLayerVideoGravityResize是拉伸视频内容达到边框占满，但不按原比例拉伸，这里明显可以看出宽度被拉伸了。
     */
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    //添加播放视图到self.view
    [self.layer addSublayer:self.playerLayer];
    //视频播放
    [self.avPlayer play];
    
    //视频暂停
    //[self.avPlayer pause];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.avPlayer.currentItem];
}

- (void)layoutSubviews
{
    
    self.playerLayer.frame = self.bounds;
    
    [super layoutSubviews];
    
}

- (void)pause
{
    [self.avPlayer pause];
    self.isPaused = YES;
}
- (void)play
{
    [self.avPlayer play];
    self.isPaused = NO;
}

- (BOOL)isPause
{
    return self.isPaused;
}



// 视频循环播放

- (void)moviePlayDidEnd:(NSNotification*)notification{

    AVPlayerItem*item = [notification object];
    [item seekToTime:kCMTimeZero];
    [self.avPlayer play];

}

- (void)removeFromSuperview
{
    
    [self.avPlayer pause];
    self.avPlayer = nil;
    self.playerLayer = nil;
    NSLog(@"video removeFromSuperview");
    [super removeFromSuperview];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.avPlayer pause];
    self.avPlayer = nil;
    self.playerLayer = nil;
    NSLog(@"video dealloc");
}

@end
