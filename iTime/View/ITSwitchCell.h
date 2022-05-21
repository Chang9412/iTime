//
//  ITSwitchCell.h
//  iTime
//
//  Created by zhengqiang zhang on 2022/5/5.
//

#import "ITTimeSettingsCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ITSwitchCell : ITTimeSettingsCell

@property (nonatomic, copy) void(^valueDidChange)(ITTimeSetting *setting);

@property (nonatomic, strong) NSString *time;

@end

NS_ASSUME_NONNULL_END
