//
//  ITSoundCell.m
//  iTime
//
//  Created by zhengqiang zhang on 2022/5/8.
//

#import "ITSoundCell.h"
#import <Masonry.h>

@interface ITSoundCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation ITSoundCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.titleLabel.textColor = [UIColor theme];
        self.titleLabel.layer.borderColor = [UIColor theme].CGColor;
    } else {
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.layer.borderColor = [UIColor colorWithRGB:0x999999].CGColor;
    }
}

- (void)setText:(NSString *)text {
    self.titleLabel.text = text;
}

- (UILabel *)titleLabel {
    if (_titleLabel) {
        return _titleLabel;
    }
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:17];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.clipsToBounds = YES;
    _titleLabel.layer.borderColor = [UIColor colorWithRGB:0x999999].CGColor;
    _titleLabel.layer.borderWidth = 1;
    _titleLabel.layer.cornerRadius = 25;

    return _titleLabel;
}
@end


@interface ITSoundHeader ()

@property (nonatomic, strong) UIButton *button;

@end

@implementation ITSoundHeader

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.button];
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.height.equalTo(@50);
            make.width.equalTo(@320);
        }];
    }
    return self;
}

- (void)buttonClicked {
    if (self.buttonClickBlock) {
        self.buttonClickBlock();
    }
}

- (UIButton *)button {
    if (_button) {
        return _button;
    }
    _button = [[UIButton alloc] init];
    [_button setTitle:@"试听" forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _button.titleLabel.font = [UIFont systemFontOfSize:17];
    _button.backgroundColor = [UIColor theme];
    _button.clipsToBounds = YES;
    _button.layer.cornerRadius = 25;
    [_button addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
    return _button;
}

@end

