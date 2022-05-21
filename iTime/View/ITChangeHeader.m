//
//  ITChangeHeader.m
//  iTime
//
//  Created by zhengqiang zhang on 2022/5/6.
//

#import "ITChangeHeader.h"
#import <Masonry.h>

@interface ITChangeHeader ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation ITChangeHeader

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
    _titleLabel.font = [UIFont boldSystemFontOfSize:22];
    _titleLabel.textColor = [UIColor blackColor];
    return _titleLabel;
}

@end
