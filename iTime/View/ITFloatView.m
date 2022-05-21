//
//  ITFloatView.m
//  iTime
//
//  Created by zhengqiang zhang on 2022/5/5.
//

#import "ITFloatView.h"
#import <Masonry.h>

@interface ITFloatView ()

@property (nonatomic, strong) UIButton *button;

@end

@implementation ITFloatView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [self addSubview:self.button];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (UIButton *)button {
    if (_button) {
        return _button;
    }
    _button = [[UIButton alloc] init];
    [_button setTitle:@"开启画中画" forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _button.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    return _button;
}

@end
