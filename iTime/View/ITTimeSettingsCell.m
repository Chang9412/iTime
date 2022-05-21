//
//  ITTimeSettingsCell.m
//  iTime
//
//  Created by zhengqiang zhang on 2022/5/5.
//

#import "ITTimeSettingsCell.h"

@implementation ITTimeSettingsCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12);
            make.centerY.equalTo(@0);
        }];
        self.contentView.clipsToBounds = YES;
        self.contentView.layer.cornerRadius = 10;
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setSetting:(ITTimeSetting *)setting {
    _setting = setting;
    self.titleLabel.text = setting.title;
}

- (UILabel *)titleLabel {
    if (_titleLabel) {
        return _titleLabel;
    }
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.font = [UIFont boldSystemFontOfSize:17];
    return _titleLabel;
}

@end


@interface ITTimeSettingsHeader ()

@property (nonatomic, strong) UILabel *titleLabel;

@end


@implementation ITTimeSettingsHeader

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12);
            make.centerY.equalTo(@0);
        }];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (UILabel *)titleLabel {
    if (_titleLabel) {
        return _titleLabel;
    }
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.font = [UIFont boldSystemFontOfSize:22];
    return _titleLabel;
}
@end

