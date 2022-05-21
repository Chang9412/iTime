//
//  ITTimeSettingsCell.h
//  iTime
//
//  Created by zhengqiang zhang on 2022/5/5.
//

#import <UIKit/UIKit.h>
#import "ITTimeSetting.h"
#import <Masonry.h>

NS_ASSUME_NONNULL_BEGIN

@interface ITTimeSettingsCell : UICollectionViewCell

@property (nonatomic, strong) ITTimeSetting *setting;

@property (nonatomic, strong) UILabel *titleLabel;

@end

@interface ITTimeSettingsHeader : UICollectionReusableView

@property (nonatomic, strong) NSString *title;

@end

NS_ASSUME_NONNULL_END
