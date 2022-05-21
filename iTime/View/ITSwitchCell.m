//
//  ITSwitchCell.m
//  iTime
//
//  Created by zhengqiang zhang on 2022/5/5.
//

#import "ITSwitchCell.h"
#import <Masonry.h>
#import "ITTimeManager.h"

@interface ITSwitchCell ()

@property (nonatomic, strong) UISwitch *switchView;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation ITSwitchCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.switchView];
        [self.contentView addSubview:self.timeLabel];

        [self.switchView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-12);
            make.centerY.equalTo(@0);
            make.width.equalTo(@50);
            make.height.equalTo(@30);
        }];
        
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel);
            make.top.equalTo(self.titleLabel.mas_bottom);
        }];
    }
    return self;
}

- (void)setSetting:(ITTimeSetting *)setting {
    [super setSetting:setting];
    self.switchView.on = setting.value;
    [self showOrHideTimeLabel];
}

- (void)switchViewValueChanged {
    self.setting.value = self.switchView.on;
    if (self.valueDidChange) {
        self.valueDidChange(self.setting);
    }
    
    [self showOrHideTimeLabel];
}

- (void)showOrHideTimeLabel {
    if (self.setting.tid == 5) { // 倒计时
        self.timeLabel.hidden = !self.setting.value;
    } else {
        self.timeLabel.hidden = YES;
    }
    if (!self.timeLabel.hidden) {
        self.timeLabel.text = [ITTimeManager manager].lastCountdownDateString;
    }
}

- (UISwitch *)switchView {
    if (_switchView) {
        return _switchView;
    }
    _switchView = [[UISwitch alloc] init];
    _switchView.onTintColor = [UIColor theme];
    [_switchView addTarget:self action:@selector(switchViewValueChanged) forControlEvents:UIControlEventValueChanged];
    return _switchView;
}

- (UILabel *)timeLabel {
    if (_timeLabel) {
        return _timeLabel;
    }
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.font = [UIFont systemFontOfSize:14];
    _timeLabel.textColor = [UIColor colorWithRGB:0x666666];
    return _timeLabel;
}

@end
