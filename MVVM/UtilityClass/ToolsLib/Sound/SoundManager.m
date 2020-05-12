//
//  SoundManager.m
//  BBA
//
//  Created by life on 2018/10/10.
//  Copyright © 2018年 hdyg. All rights reserved.
//

#import "SoundManager.h"

@implementation SoundManager

-(id)initForPlayingVibrate
{
    self = [super init];
    if (self) {
        soundID = kSystemSoundID_Vibrate;
    }
    return self;
}
-(id)initForPlayingSystemSoundEffectWith:(NSString *)resourceName ofType:(NSString *)type
{
    self = [super init];
    if (self) {
        NSString *path = [[NSBundle bundleWithIdentifier:@"com.apple.UIKit"] pathForResource:resourceName ofType:type];
        if (path) {
            SystemSoundID theSoundID;
            OSStatus error =  AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &theSoundID);
            if (error == kAudioServicesNoError) {
                soundID = theSoundID;
                
            }else {
                NSLog(@"Failed to create sound ");
                
            }
            
        }
        
    }
    return self;
    
}

- (id)initForPlayingSoundEffectWith:(NSString *)filename{
    self = [super init];
    if (self) {
        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
        if (fileURL)
        {
            SystemSoundID theSoundID;
            OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)fileURL, &theSoundID);
            if (error == kAudioServicesNoError){
                soundID = theSoundID;
                
            }else {
                NSLog(@"Failed to create sound ");
                
            }
            
        }
        
    }
    return self;
    
}

-(void)play
{
    AudioServicesPlaySystemSound(soundID);
}

-(void)dealloc
{
    AudioServicesDisposeSystemSoundID(soundID);
}
@end
