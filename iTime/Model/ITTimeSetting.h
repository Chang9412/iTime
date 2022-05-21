//
//  ITTimeSetting.h
//  iTime
//
//  Created by zhengqiang zhang on 2022/5/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ITTimeSettingStyle) {
    ITTimeSettingStyleNormal,
    ITTimeSettingStyleSwitch,
    ITTimeSettingStyleOperation,
};

@interface ITTimeSetting : NSObject

@property (nonatomic, assign) NSInteger tid;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) ITTimeSettingStyle style;
@property (nonatomic, assign) NSInteger value;

- (instancetype)initWithDict:(NSDictionary *)dict;
- (NSDictionary *)toDict;
+ (NSArray *)defaultSettings;
+ (NSArray *)defaultSoundSettings;

@end

NS_ASSUME_NONNULL_END
