//
//  ITOperationCell.m
//  iTime
//
//  Created by zhengqiang zhang on 2022/5/5.
//

#import "ITOperationCell.h"
#import <Masonry.h>

@interface ITOperationCell ()

@property (nonatomic, strong) UIButton *plusButton;
@property (nonatomic, strong) UIButton *reduceButton;
@property (nonatomic, strong) UILabel *countLabel;

@property (nonatomic, assign) NSInteger count;

@end

@implementation ITOperationCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [self.contentView addSubview:self.reduceButton];
    [self.contentView addSubview:self.countLabel];
    [self.contentView addSubview:self.plusButton];

    
    [self.reduceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.countLabel.mas_left).offset(0);
        make.centerY.equalTo(@0);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.plusButton.mas_left).offset(0);
        make.centerY.equalTo(@0);
        make.width.equalTo(@80);
        make.height.greaterThanOrEqualTo(@0);
    }];
    [self.plusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-12);
        make.centerY.equalTo(@0);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
}

- (void)setSetting:(ITTimeSetting *)setting {
    [super setSetting:setting];
}

- (void)plusButtonClicked {
    if (self.count >= 1000) {
        return;
    }
    self.count += self.setting.value;
    [self displayeCountLabel];
    
}

- (void)reduceButtonClicked {
    if (self.count <= -1000) {
        return;
    }
    self.count -= self.setting.value;
    [self displayeCountLabel];
}

- (void)displayeCountLabel {
    self.countLabel.text = [NSString stringWithFormat:@"%@", @(self.count)];
    if (self.count == 0) {
        self.countLabel.textColor = [UIColor blackColor];
    } else if (self.count < 0) {
        self.countLabel.textColor = [UIColor greenColor];
    } else {
        self.countLabel.textColor = [UIColor redColor];
    }
    if (self.operatBlcok) {
        self.operatBlcok(self.setting, self.count);
    }
}

- (UIButton *)reduceButton {
    if (_reduceButton) {
        return _reduceButton;
    }
    _reduceButton = [[UIButton alloc] init];
    _reduceButton.titleLabel.font = [UIFont boldSystemFontOfSize:19];
    [_reduceButton setTitle:@"-" forState:UIControlStateNormal];
    [_reduceButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _reduceButton.backgroundColor = [UIColor colorWithRGB:0xd7d7d7];
    _reduceButton.clipsToBounds = YES;
    _reduceButton.layer.cornerRadius = 5;
    [_reduceButton addTarget:self action:@selector(reduceButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    return _reduceButton;
}

- (UIButton *)plusButton {
    if (_plusButton) {
        return _plusButton;
    }
    _plusButton = [[UIButton alloc] init];
    _plusButton.titleLabel.font = [UIFont boldSystemFontOfSize:19];
    [_plusButton setTitle:@"+" forState:UIControlStateNormal];
    [_plusButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _plusButton.backgroundColor = [UIColor colorWithRGB:0xd7d7d7];
    _plusButton.clipsToBounds = YES;
    _plusButton.layer.cornerRadius = 5;
    [_plusButton addTarget:self action:@selector(plusButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    return _plusButton;
}

- (UILabel *)countLabel {
    if (_countLabel) {
        return _countLabel;
    }
    _countLabel = [[UILabel alloc] init];
    _countLabel.font = [UIFont boldSystemFontOfSize:15];
    _countLabel.textAlignment = NSTextAlignmentCenter;
    _countLabel.textColor = [UIColor blackColor];
    _countLabel.text = @"0";
    return _countLabel;
}


@end
