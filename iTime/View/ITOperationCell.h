//
//  ITOperationCell.h
//  iTime
//
//  Created by zhengqiang zhang on 2022/5/5.
//

#import "ITTimeSettingsCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ITOperationCell : ITTimeSettingsCell

@property (nonatomic, copy) void(^operatBlcok)(ITTimeSetting *setting, NSInteger value);

@end

NS_ASSUME_NONNULL_END
