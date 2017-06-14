//
//  ViewController.m
//  AVFoundation
//
//  Created by Xue Yang on 2017/6/13.
//  Copyright © 2017年 Xue Yang. All rights reserved.
//

#import "ViewController.h"
#import <AudioToolbox/AudioToolbox.h>
@interface ViewController ()
@property(nonatomic,assign)SystemSoundID soundID;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}
- (IBAction)heng {
    [self getFilePath:[[NSBundle mainBundle] pathForResource:@"8785.wav" ofType:nil]];
}
- (IBAction)lock {
    [self getFilePath:@"/System/Library/Audio/UISounds/lock.caf"];
}
- (IBAction)wolf {
    [self getFilePath:[[NSBundle mainBundle] pathForResource:@"8810.wav" ofType:nil]];
}
#pragma mark - 播放音效<AudioToolbox/AudioToolbox.h>
//记录是否正在播放音效
//static bool _isPlaying = NO;
static void ringAudioServicesSystemSoundCompletionProc(SystemSoundID ssID, void *clientData)
{
//    _isPlaying = NO;
    NSLog(@"播放完毕");
}

- (void)getFilePath:(NSString *)filePath
{
//    if (_isPlaying) return;
//    _isPlaying = YES;
    AudioServicesDisposeSystemSoundID(_soundID);
    //@"/System/Library/Audio/UISounds/lock.caf"
    NSURL *url = [NSURL fileURLWithPath:filePath];
    //获得系统声音ID
    SystemSoundID soundID = 0;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)url, &soundID);
    _soundID = soundID;
    //播放完成回调
    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, ringAudioServicesSystemSoundCompletionProc, NULL);
    //播放音乐
    AudioServicesPlaySystemSound(soundID);
//    AudioServicesPlayAlertSound(soundID);//播放音效并震动
}
@end
