//
//  ITTimeManager.m
//  iTime
//
//  Created by zhengqiang zhang on 2022/5/5.
//

#import "ITTimeManager.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "ITTimeSetting.h"

@interface ITTimeManager ()

@property (nonatomic, strong) NSDateFormatter *secondFormatter;
@property (nonatomic, strong) NSDateFormatter *millSecondFormatter;

@property (nonatomic, strong) NSMutableArray *textColors;
@property (nonatomic, strong) NSMutableArray *backgrounds;
@property (nonatomic, strong) NSMutableArray *custombBackgrounds;

@property (nonatomic, assign) NSInteger colorIndex;
@property (nonatomic, assign) NSInteger backgroundIndex;

@property (nonatomic, strong) NSDate *lastCountdownDate;

@property (nonatomic, strong) CADisplayLink *link;

@end

@implementation ITTimeManager

+ (instancetype)manager {
    static ITTimeManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ITTimeManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        _secondFormatter = [[NSDateFormatter alloc] init];
        _secondFormatter.dateFormat = @"HH:mm:ss";
        _millSecondFormatter = [[NSDateFormatter alloc] init];
        _millSecondFormatter.dateFormat = @"HH:mm:ss.S";
        _backgroundIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"background"];
        _backgrounds = [NSMutableArray array];
        [_backgrounds addObjectsFromArray:[self defaultBackground]];
        _custombBackgrounds = [NSMutableArray arrayWithArray:[self acustomBackgrounds]];
        [_backgrounds addObjectsFromArray:self.custombBackgrounds];
        _textColors = [NSMutableArray array];
        _colorIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"textColor"];
        [_textColors addObjectsFromArray:[self defaultTextColor]];
        _sound = [[NSUserDefaults standardUserDefaults] integerForKey:@"sound"];
        [self loadExtraSettings];
    }
    return self;
}

- (CADisplayLink *)link {
    if (_link) {
        return _link;
    }
    _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(playTipsSoundIfNeed)];
    _link.preferredFramesPerSecond = 1;
    [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    _link.paused = YES;
    return _link;
}

- (void)setTips:(BOOL)tips {
    _tips = tips;
    self.link.paused = !tips;
}

- (void)loadExtraSettings {
    NSArray * settings = [[NSUserDefaults standardUserDefaults] arrayForKey:@"soundSettings"];
    NSString *version = [[NSUserDefaults standardUserDefaults] objectForKey:@"version"];
    NSString *cversion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    if ([cversion floatValue] > [version floatValue] || !settings) {
        [[NSUserDefaults standardUserDefaults] synchronize];
        settings = [ITTimeSetting defaultSoundSettings];
    }
    NSMutableArray *marray = [NSMutableArray array];
    for (NSDictionary *dict in settings) {
        ITTimeSetting *setting = [[ITTimeSetting alloc] initWithDict:dict];
        [marray addObject:setting];
        if (setting.tid == 1) {
            self.lastThreeSecondTips = setting.value;
        } else if (setting.tid == 2) {
            self.tips = setting.value;
        }
    }
}


- (NSString *)currentDate {
    if (self.showMill) {
        return [self currentDateForMillSecond];
    } else {
        return [self currentDateForSecond];
    }
}

- (NSString *)currentDateForSecond {
    NSDate *date = [self date];
    NSString *string = [self.secondFormatter stringFromDate:date];
    if (self.lastCountdownDate && [self.lastCountdownDate timeIntervalSinceDate:date] <= 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kCountdownNotification object:nil userInfo:@{@"second":@(1)}];
    }
    return string;
}

- (NSString *)currentDateForMillSecond {
    NSDate *date = [self date];
    NSString *string = [self.millSecondFormatter stringFromDate:date];
    if (self.lastCountdownDate && [self.lastCountdownDate timeIntervalSinceDate:date] <= 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kCountdownNotification object:nil userInfo:@{@"second":@(1)}];
    }
    return string;
}

- (NSDate *)date {
    NSDate *date = [NSDate dateWithTimeInterval:self.extraSecond+self.extraMillSecond / 1000.0 sinceDate:[NSDate date]];
    return date;
}

- (NSArray *)defaultTextColor {
    return @[[UIColor flatWhiteColor],
             [UIColor flatBlackColor],
             [UIColor flatBlueColor],
             [UIColor flatSkyBlueColor],
             [UIColor flatLimeColor],
             [UIColor flatPinkColor],
             [UIColor flatSandColor],
             [UIColor flatTealColor],
             [UIColor flatPurpleColor],
             [UIColor flatOrangeColor],
             [UIColor flatWatermelonColor],
             [UIColor flatYellowColor]];
}

- (NSArray *)defaultBackground {
    return @[[UIImage imageWithColor:[UIColor flatBlackColor]],
             [UIImage imageWithColor:[UIColor flatWhiteColor]],
             [UIImage imageWithColor:[UIColor flatGrayColor]],
             [UIImage imageWithColor:[UIColor flatGreenColorDark]],
             [UIImage imageWithColor:[UIColor flatBrownColorDark]],
             [UIImage imageWithColor:[UIColor flatMintColorDark]],
             [UIImage imageWithColor:[UIColor flatMagentaColorDark]],
             [UIImage imageWithColor:[UIColor flatNavyBlueColorDark]]];
}

- (UIColor *)currentTextColor {
    if (_currentTextColor) {
        return _currentTextColor;
    }
    _currentTextColor = self.textColors[self.colorIndex];
    return _currentTextColor;
}

- (UIImage *)currentBackground {
    if (_currentBackground) {
        return _currentBackground;
    }
    _currentBackground = self.backgrounds[self.backgroundIndex];
    return _currentBackground;
}

- (void)updateTextColor:(NSInteger)index {
    self.colorIndex = index;
    self.currentTextColor = self.textColors[self.colorIndex];
    [[NSUserDefaults standardUserDefaults] setInteger:index forKey:@"textColor"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)updateBackground:(NSInteger)index {
    self.backgroundIndex = index;
    self.currentBackground = self.backgrounds[self.backgroundIndex];
    [[NSUserDefaults standardUserDefaults] setInteger:index forKey:@"background"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setShowReverse:(BOOL)showReverse {
    _showReverse = showReverse;
    if (showReverse) {
        self.lastCountdownDate = [self alastCountdownDate];
    } else {
        self.lastCountdownDate = nil;
    }
}

- (NSDate *)alastCountdownDate {
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date];
    NSDateComponents *nextComponents = [[NSDateComponents alloc] init];
    if (components.hour == 23) {
        nextComponents.hour = 0;
    } else {
        nextComponents.hour = components.hour + 1;
    }
    // TEST
    nextComponents.hour = components.hour;
    nextComponents.minute = components.minute;
    nextComponents.second = components.second + 10;
    if (nextComponents.second >= 60) {
        nextComponents.second = 59;
    }
    NSDate *nextDate = [calendar nextDateAfterDate:date matchingComponents:nextComponents options:NSCalendarMatchNextTimePreservingSmallerUnits];
    return nextDate;
}

- (NSString *)lastCountdownDateString {
    return [self.secondFormatter stringFromDate:self.lastCountdownDate];
}

- (NSString *)countdownString {
    NSDate *date = self.lastCountdownDate;
    NSInteger offset = [date timeIntervalSinceDate:[self date]] * 1000;
    if (offset < 0) {
        return nil;
    }
    NSInteger minutes = offset / 60000;
    NSInteger seconds = (offset / 1000) % 60;
    NSInteger mills = offset % 1000 / 100;
    
    if (minutes == 0 && seconds <= 3 && mills <1) { //倒计时3s
        NSLog(@"%ld ", seconds);
        if ([NSThread currentThread] == [NSThread mainThread]) {
            [self playLastThreeSecondsTipsSound:seconds];
            [[NSNotificationCenter defaultCenter] postNotificationName:kCountdownNotification object:nil userInfo:@{@"second":@(seconds)}];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self playLastThreeSecondsTipsSound:seconds];
                [[NSNotificationCenter defaultCenter] postNotificationName:kCountdownNotification object:nil userInfo:@{@"second":@(seconds)}];
            });
        }
    }
    if (self.showMill) {
        return [NSString stringWithFormat:@"00:%02ld:%02ld.%ld", (long)minutes, (long)seconds, mills];
    }
    return [NSString stringWithFormat:@"00:%02ld:%02ld", (long)minutes, (long)seconds];
}

- (void)setSound:(NSInteger)sound {
    _sound = sound;
    [[NSUserDefaults standardUserDefaults] setInteger:sound forKey:@"sound"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)playLastThreeSecondsTipsSound:(NSInteger)second {
    if (!self.lastThreeSecondTips) {
        return;
    }
    NSString *fileName = [NSString stringWithFormat:@"%@.m4a", @(second)];
    [self playSound:fileName];
}

- (void)playTipsSoundIfNeed {
    if (!self.tips) {
        return;
    }
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date];
    if (components.minute == 0 && components.second == 0) {
        [self playTipsSound];
    }
}

- (void)playTipsSound {
    if (self.sound == 0) {
        return;
    }
    [self playSound:[NSString stringWithFormat:@"yinxiao%@.m4a", @(self.sound)]];
}

- (void)playSound:(NSString *)fileName {
    if (!fileName || fileName.length == 0) {
        return;
    }
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
    
    NSString *audioFile=[[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    if (!audioFile || audioFile.length == 0) {
        return;
    }
    NSURL *fileUrl=[NSURL fileURLWithPath:audioFile];
    //1.获得系统声音ID
    SystemSoundID soundID = 0;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundCompleteCallback, NULL);
    //2.播放音频
    AudioServicesPlaySystemSound(soundID);//播放音效
    //    AudioServicesPlayAlertSound(soundID);//播放音效并震动
}

void soundCompleteCallback(SystemSoundID soundID,void * clientData){
    NSLog(@"播放完成...");
    AudioServicesDisposeSystemSoundID(soundID);

}

- (NSString *)imageSavedDirectory {
    return [NSHomeDirectory() stringByAppendingFormat:@"/Library/Caches/Images"];
}

- (void)addBackground:(UIImage *)image {
    [self.custombBackgrounds addObject:image];
    [self.backgrounds addObject:image];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = UIImageJPEGRepresentation(image, 1);
        NSString *dir = [self imageSavedDirectory];
        if (![[NSFileManager defaultManager] fileExistsAtPath:dir]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
        }
        NSString *path =  [[ITTimeManager manager].imageSavedDirectory stringByAppendingFormat:@"/%@.jpg", @(self.backgrounds.count)];
        [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil];
    });
}

- (NSArray *)acustomBackgrounds {
    NSString *directory = [self imageSavedDirectory];
    NSArray *files = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:directory error:nil];
    NSMutableArray *marray = [NSMutableArray array];
    for (NSString *path in files) {
        UIImage *image = [UIImage imageNamed:[directory stringByAppendingPathComponent:path]];
        [marray addObject:image];
    }
    return marray;
}

- (void)clearCustomBackgrounds {
    [self.backgrounds removeObjectsInArray:self.custombBackgrounds];
    NSString *directory = [self imageSavedDirectory];
    NSArray *files = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:directory error:nil];
    for (NSString *path in files) {
        [[NSFileManager defaultManager] removeItemAtPath:[directory stringByAppendingPathComponent:path] error:nil];
    }
    [self.custombBackgrounds removeAllObjects];
    [self updateBackground:0];
}

@end
