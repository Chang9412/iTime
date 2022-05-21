//
//  ITChangeCell.m
//  iTime
//
//  Created by zhengqiang zhang on 2022/5/7.
//

#import "ITChangeCell.h"


@interface ITChangeCell ()

@property (nonatomic, strong) CAShapeLayer *maskLayer;

@end

@implementation ITChangeCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView.layer addSublayer:self.maskLayer];
    }
    return self;;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.maskLayer.hidden = !selected;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!self.maskLayer.path) {
        self.maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.contentView.bounds cornerRadius:5].CGPath;
    }
}

- (CAShapeLayer *)maskLayer {
    if (_maskLayer) {
        return _maskLayer;
    }
    _maskLayer = [CAShapeLayer layer];
    _maskLayer.borderColor = [UIColor theme].CGColor;
    _maskLayer.borderWidth = 1;
    return _maskLayer;
}

@end
