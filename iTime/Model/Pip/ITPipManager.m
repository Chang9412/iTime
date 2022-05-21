//
//  ITPipManager.m
//  iTime
//
//  Created by zhengqiang zhang on 2022/5/5.
//

#import "ITPipManager.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <Masonry.h>
#import <ReactiveCocoa.h>
#import "ITTimeView.h"
#import "ITTimeManager.h"

@interface ITPipManager ()<AVPictureInPictureControllerDelegate>

@property (nonatomic, strong) AVPictureInPictureController *pictureInPictureController;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) RACDisposable *pipPossibleDisposable;
@property (nonatomic, strong) RACDisposable *windowDisposable;

@property (nonatomic, assign) BOOL isActiviting;
@property (nonatomic, assign) BOOL stoping;
@property (nonatomic, assign) BOOL isInPicture;

@property (nonatomic, strong) ITPipTimeView *timeView;
@property (nonatomic, strong) CADisplayLink *link;

@end


@implementation ITPipManager

+ (instancetype)manager {
    static ITPipManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ITPipManager alloc] init];
    });
    return manager;
}

- (void)startPip {
    if (![ITPipManager isPictureInPictureSupported]) {
        
        return;
    }
    if (self.isInPicture) {
        
//        [self stopPip];
//        [self performSelector:@selector(startPip) withObject:nil afterDelay:0.1];
        return;
    }
    
//    [ITPipManager cancelPreviousPerformRequestsWithTarget:self selector:@selector(startPip) object:nil];
    
    [self _startPip];
}

- (void)_startPip {
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"mp4"];
    AVPlayerItem *playItem = [[AVPlayerItem alloc] initWithURL:url];
    self.player = [[AVPlayer alloc] initWithPlayerItem:playItem];
    self.player.muted = YES;
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    [[UIApplication sharedApplication].keyWindow addSubview:self.contentView];
    [self.contentView.layer addSublayer:self.playerLayer];
    self.playerLayer.hidden = YES;
    [self.player playImmediatelyAtRate:1];
    self.pictureInPictureController = [[AVPictureInPictureController alloc] initWithPlayerLayer:self.playerLayer];
    self.pictureInPictureController.delegate = self;
    @weakify(self)
    self.pipPossibleDisposable = [RACObserve(self.pictureInPictureController, pictureInPicturePossible) subscribeNext:^(id x) {
        @strongify(self)
        if ([x boolValue]) {
            NSLog(@"pip_pictureInPicturePossible");
            [self performSelector:@selector(startPictureInPicture) withObject:nil afterDelay:0.1];
        }
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished) name:AVPlayerItemDidPlayToEndTimeNotification object:playItem];

}

- (void)stopPip {
    [self stopPictureInPicture];
//    [self reset];
}

- (void)reset {
    [self.contentView removeFromSuperview];
    [self.timeView removeFromSuperview];
    self.link.paused = YES;
    self.player = nil;
    self.playerLayer = nil;
    self.pictureInPictureController.delegate = nil;
    self.pictureInPictureController = nil;
    [self.pipPossibleDisposable dispose];
    [self.windowDisposable dispose];
}

- (BOOL)shouldShowTime {
    return YES;
}

- (void)showTimeViewIfNeed {
    NSLog(@"showTimeViewIfNeed");
    if (![self shouldShowTime]) {
        return;
    }
    UIWindow *targetWindow;
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        if ([window isKindOfClass:NSClassFromString(@"PGHostedWindow")]) {
            targetWindow = window;
            break;
        }
    }
    if (!targetWindow) {
        NSLog(@"did not find targetWindow");
        return;
    }
    [targetWindow addSubview:self.timeView];
    [self.timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(targetWindow);
    }];
    UIView *shadowView = [self findShadowView:targetWindow];
    if (shadowView) {
        shadowView.hidden = YES;
    }
    self.link.paused = NO;
    NSLog(@"didshowTimeView");
//    self.windowDisposable = [RACObserve(targetWindow, gestureRecognizers) subscribeNext:^(id x) {
//        NSLog(@"aa-%@", x);
//    }];
}

- (void)hideShadowViewIfNeed {
    if (!self.timeView.superview) {
        return;
    }
    UIView *shadowView = [self findShadowView:self.timeView.superview];
    if (shadowView) {
//        shadowView.frame = CGRectMake(-1, -1, 1, 1);
    }
}

- (UIView *)findShadowView:(UIView *)view {
//    if ([view isKindOfClass:NSClassFromString(@"_UIRoundedRectShadowView")]) {
//        return view;
//    }
    
    if ([view isKindOfClass:NSClassFromString(@"UIButton")]) {
        return view;
    }
    for (UIView *subview in view.subviews) {
        UIView *shadowView = [self findShadowView:subview];
        if (shadowView) {
            return shadowView;
        }
    }
    return nil;
}


#pragma mark -

- (void)playbackFinished {
    [self.player seekToTime:CMTimeMakeWithSeconds(0, 600)];
    [self.player playImmediatelyAtRate:1];
}

- (void)updateTime {
    if ([ITTimeManager manager].showReverse) {
        self.timeView.time = [[ITTimeManager manager] countdownString];
    } else {
        self.timeView.time = [[ITTimeManager manager] currentDate];
    }
}

#pragma mark -

- (void)startPictureInPicture {
//    if (!self.isAppActived) {
//        self.shouldStartPictureInPicture = YES;
//        return;
//    }
    if (self.pictureInPictureController.pictureInPictureActive) {
        [self stopPictureInPicture];
    }
    [self.pictureInPictureController startPictureInPicture];
    [ITPipManager cancelPreviousPerformRequestsWithTarget:self selector:@selector(startPictureInPicture) object:nil];
    NSLog(@"startPictureInPicture");
}

- (void)stopPictureInPicture {
    [self.pictureInPictureController stopPictureInPicture];
}

- (BOOL)isPictureInPictureActive {
    if (!self.pictureInPictureController) {
        return NO;
    }
    return self.pictureInPictureController.isPictureInPictureActive;
}

- (BOOL)isPictureInPictureActivating {
    return self.isActiviting;
}

+ (BOOL)isPictureInPictureSupported {
    return [AVPictureInPictureController isPictureInPictureSupported];
}

#pragma mark - AVPictureInPictureControllerDelegate

- (void)pictureInPictureControllerWillStartPictureInPicture:(AVPictureInPictureController *)pictureInPictureController {
    NSLog(@"pictureInPictureControllerWillStartPictureInPicture");
    [self showTimeViewIfNeed];

}

- (void)pictureInPictureControllerDidStartPictureInPicture:(AVPictureInPictureController *)pictureInPictureController {
    self.isActiviting = NO;
    self.isInPicture = YES;
//    [self hideShadowViewIfNeed];
    
}

- (void)pictureInPictureController:(AVPictureInPictureController *)pictureInPictureController failedToStartPictureInPictureWithError:(NSError *)error {
//    [self onComplete:error];
    self.isInPicture = NO;

}

- (void)pictureInPictureControllerWillStopPictureInPicture:(AVPictureInPictureController *)pictureInPictureController {
//    self.stoping = YES;
}

- (void)pictureInPictureControllerDidStopPictureInPicture:(AVPictureInPictureController *)pictureInPictureController {
    NSLog(@"pictureInPictureControllerDidStopPictureInPicture");
//    self.stoping = NO;
    self.isInPicture = NO;
    [self reset];
}

- (void)pictureInPictureController:(AVPictureInPictureController *)pictureInPictureController restoreUserInterfaceForPictureInPictureStopWithCompletionHandler:(void (^)(BOOL))completionHandler {
    if (self.isInPicture) {
        [self stopPip];
        self.isInPicture = NO;
    }
    completionHandler(YES);
}

#pragma mark -

- (UIView *)contentView {
    if (_contentView) {
        return _contentView;
    }
    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = [UIColor blackColor];
    return _contentView;
}

- (ITPipTimeView *)timeView {
    if (_timeView) {
        return _timeView;
    }
    _timeView = [[ITPipTimeView alloc] init];
//    _timeView.showRed = [ITTimeManager manager].showMill && [ITTimeManager manager].showRed;
    RACChannelTo(_timeView, showRed) = RACChannelTo([ITTimeManager manager], showRed);
    RACChannelTo(_timeView, showMill) = RACChannelTo([ITTimeManager manager], showMill);
    RACChannelTo(_timeView, textColor) = RACChannelTo([ITTimeManager manager], currentTextColor);
    RACChannelTo(_timeView, image) = RACChannelTo([ITTimeManager manager], currentBackground);
    return _timeView;
}

- (CADisplayLink *)link {
    if (_link) {
        return _link;
    }
    _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateTime)];
    _link.preferredFramesPerSecond = 10;
    [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    _link.paused = YES;
    return _link;
}


@end
