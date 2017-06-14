//
//  AVAudioPlayerVC.m
//  AVFoundation
//
//  Created by Xue Yang on 2017/6/13.
//  Copyright © 2017年 Xue Yang. All rights reserved.
//

#import "AVAudioPlayerVC.h"
#import <AVFoundation/AVFoundation.h>
#import <Masonry.h>
@interface AVAudioPlayerVC ()<AVAudioPlayerDelegate>
@property(nonatomic,strong)UIImageView *foreImgV;
@property(nonatomic,strong)UIProgressView *progressV;
@property(nonatomic,strong)AVAudioPlayer *player;
@property(nonatomic,strong)UIButton *playBtn;
@property(nonatomic,strong)NSTimer *timer;
@end

@implementation AVAudioPlayerVC
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //添加远程控制
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}
- (void)setupUI
{
    UIImageView *backImgV = [[UIImageView alloc] init];
    backImgV.userInteractionEnabled = YES;
    backImgV.image = [UIImage imageNamed:@"lye.jpeg"];
    [self.view addSubview:backImgV];
    [backImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    effectView.alpha = 1;
    [backImgV addSubview:effectView];
    [effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    
    _foreImgV = [[UIImageView alloc] init];
    _foreImgV.image = [UIImage imageNamed:@"lye.jpeg"];
    _foreImgV.layer.masksToBounds = YES;
    [backImgV addSubview:_foreImgV];
    [_foreImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(backImgV).insets(UIEdgeInsetsMake(0, 10, 0, 10));
        make.center.equalTo(backImgV);
        make.height.equalTo(_foreImgV.mas_width);
    }];
    //立即更新UI
    [_foreImgV.superview layoutIfNeeded];
    _foreImgV.layer.masksToBounds = YES;
    _foreImgV.layer.cornerRadius = _foreImgV.bounds.size.width * 0.5;
    
    UIView *bottomBgV = [[UIView alloc] init];
    bottomBgV.alpha = 0.6;
    bottomBgV.backgroundColor = [UIColor blackColor];
    [backImgV addSubview:bottomBgV];
    [bottomBgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(@0);
        make.top.equalTo(_foreImgV.mas_bottom).offset(10);
    }];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.textColor = [UIColor whiteColor];
    titleLab.text = @"Gee";
    [bottomBgV addSubview:titleLab];
    [titleLab setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [titleLab setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@5);
        make.centerX.equalTo(@0);
    }];
    
    UILabel *singerLab = [[UILabel alloc] init];
    singerLab.textColor = [UIColor whiteColor];
    singerLab.text = @"Girls Generation - 少女时代";
    [bottomBgV addSubview:singerLab];
    [singerLab setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [singerLab setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [singerLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab.mas_bottom).offset(5);
        make.centerX.equalTo(@0);
    }];
    
    _progressV = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    [bottomBgV addSubview:_progressV];
    [_progressV setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [_progressV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(singerLab.mas_bottom).offset(5);
    }];
    
    
    UIView *toolBgV = [[UIView alloc] init];
    toolBgV.backgroundColor = [UIColor clearColor];
    [bottomBgV addSubview:toolBgV];
    [toolBgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(@0);
        make.top.equalTo(_progressV.mas_bottom);
    }];
    
    UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _playBtn = playBtn;
    [playBtn setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    [playBtn setBackgroundImage:[UIImage imageNamed:@"pause"] forState:UIControlStateSelected];
    [playBtn addTarget:self action:@selector(playBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [toolBgV addSubview:playBtn];
    [playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.bottom.equalTo(@(-10));
        make.center.equalTo(toolBgV);
        make.width.equalTo(playBtn.mas_height);
    }];
    
    UIButton *previousBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [previousBtn setBackgroundImage:[UIImage imageNamed:@"previous"] forState:UIControlStateNormal];
    [toolBgV addSubview:previousBtn];
    [previousBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@20);
        make.bottom.equalTo(@(-20));
        make.right.equalTo(playBtn.mas_left).offset(-10);
        make.width.equalTo(previousBtn.mas_height);
    }];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
    [toolBgV addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@20);
        make.bottom.equalTo(@(-20));
        make.left.equalTo(playBtn.mas_right).offset(10);
        make.width.equalTo(nextBtn.mas_height);
    }];
}
#pragma mark - 播放按钮点击
- (void)playBtnClicked:(UIButton *)btn
{
    btn.selected = !btn.isSelected;
    
    if (btn.isSelected) {
        
        //播放音乐
        if (_player) {
            [_player stop];
            _player = nil;
        }
        [self play];
        //更新进度条
        __weak typeof (self) weakSelf = self;
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.5f repeats:YES block:^(NSTimer * _Nonnull timer) {
            CGFloat currentTime = weakSelf.player.currentTime;
            CGFloat totalTime = weakSelf.player.duration;
            CGFloat progress = currentTime * 1.0 / totalTime;
            [weakSelf.progressV setProgress:progress];
        }];
    } else {
        [self stop];
    }
}
#pragma mark - 图片动画
- (void)beginAnimation
{
    CABasicAnimation *basicA = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    basicA.fromValue = @0;
    basicA.toValue = @( M_PI * 2);
    basicA.duration = 12;
    basicA.removedOnCompletion = NO;
    basicA.repeatCount = MAXFLOAT;
    [_foreImgV.layer addAnimation:basicA forKey:@"basicA"];
}
- (void)stopAnimation
{
    [_foreImgV.layer removeAllAnimations];
    
    
}
#pragma mark - 停止
- (void)stop
{
    [self stopAnimation];
    _playBtn.selected = NO;
    [_player stop];
    _player = nil;
    
    [_timer invalidate];
    _timer = nil;
    
    _progressV.progress = 0;
}
#pragma mark - 播放
- (void)play
{
    NSError *error = nil;
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Gee.mp3" ofType:nil]] error:&error];
    _player.numberOfLoops = 0;
    _player.volume = 1.0;
    _player.delegate = self;
    [_player prepareToPlay];
    if(error){
        NSLog(@"初始化播放器过程发生错误,错误信息:%@",error.localizedDescription);
        return;
    }
    
    if (_player.isPlaying) {
        NSLog(@"正在播放");
        return;
    } else {
        [_player play];
    }
    
    [self beginAnimation];
    
    //支持后台播放
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    
    //监听耳机拔出的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(routeChanged:) name:AVAudioSessionRouteChangeNotification object:nil];
    
}
- (void)routeChanged:(NSNotification *)notify
{
    NSDictionary *dic = notify.userInfo;
    /*
     //拔出耳机输出的内容
     {
     AVAudioSessionRouteChangePreviousRouteKey = "<AVAudioSessionRouteDescription: 0x1702019b0, \ninputs = (\n    \"<AVAudioSessionPortDescription: 0x17001e9e0, type = MicrophoneBuiltIn; name = iPhone Microphone; UID = Built-In Microphone; selectedDataSource = Front>\"\n); \noutputs = (\n    \"<AVAudioSessionPortDescription: 0x170201e30, type = Headphones; name = Headphones; UID = Wired Headphones; selectedDataSource = (null)>\"\n)>";
     AVAudioSessionRouteChangeReasonKey = 2;
     }
     */
    int changereson = [dic[AVAudioSessionRouteChangeReasonKey] intValue];
    if (changereson == AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {//旧设备不可用
        //当旧设备为耳机时，暂停播放
        AVAudioSessionRouteDescription *des = dic[AVAudioSessionRouteChangePreviousRouteKey];
        AVAudioSessionPortDescription *port = des.outputs.firstObject;
        if ([port.portType isEqualToString:@"Headphones"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self stop];
            });
            
        }
        
    }
}
#pragma mark - delegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self stop];
}
- (void)dealloc
{
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
}
@end
