//
//  ITTimeManager.h
//  iTime
//
//  Created by zhengqiang zhang on 2022/5/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * const kCountdownNotification = @"kCountdownNotification";

@interface ITTimeManager : NSObject

+ (instancetype)manager;

@property (nonatomic, assign) BOOL showMill;
@property (nonatomic, assign) BOOL showRed;
@property (nonatomic, assign) BOOL showReverse;

@property (nonatomic, strong, readonly) NSMutableArray *textColors;
@property (nonatomic, strong, readonly) NSMutableArray *backgrounds;
@property (nonatomic, strong) UIColor *currentTextColor;
@property (nonatomic, strong) UIImage *currentBackground;

@property (nonatomic, assign) NSInteger extraSecond;
@property (nonatomic, assign) NSInteger extraMillSecond;

@property (nonatomic, assign) NSInteger sound;
@property (nonatomic, assign) BOOL lastThreeSecondTips;
@property (nonatomic, assign) BOOL tips;

- (void)updateTextColor:(NSInteger)index;
- (void)updateBackground:(NSInteger)index;

- (NSString *)currentDate;
- (NSString *)currentDateForSecond;
- (NSString *)currentDateForMillSecond;

- (NSString *)countdownString;
- (NSDate *)lastCountdownDate;
- (NSString *)lastCountdownDateString;

- (NSString *)imageSavedDirectory;
- (void)addBackground:(UIImage *)image;
- (void)clearCustomBackgrounds;

- (void)playTipsSound;

@end

NS_ASSUME_NONNULL_END
