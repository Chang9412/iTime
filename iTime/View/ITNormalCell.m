//
//  ITNormalCell.m
//  iTime
//
//  Created by zhengqiang zhang on 2022/5/5.
//

#import "ITNormalCell.h"

@interface ITNormalCell ()

@property (nonatomic, strong) UIImageView *arrowImageView;

@end

@implementation ITNormalCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.arrowImageView];
        [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-12);
            make.centerY.equalTo(@0);
            make.width.equalTo(@24);
            make.height.equalTo(@24);
        }];
    }
    return self;
}

- (UIImageView *)arrowImageView {
    if (_arrowImageView) {
        return _arrowImageView;
    }
    _arrowImageView = [[UIImageView alloc] init];
    _arrowImageView.image = [UIImage imageNamed:@"arrow"];
    return _arrowImageView;
}

@end
