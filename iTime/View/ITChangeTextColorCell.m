//
//  ITChangeFontCell.m
//  iTime
//
//  Created by zhengqiang zhang on 2022/5/6.
//

#import "ITChangeTextColorCell.h"

@interface ITChangeTextColorCell ()

@property (nonatomic, strong) UIView *back;

@end

@implementation ITChangeTextColorCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.back];
        self.back.frame = self.contentView.bounds;
    }
    return self;
}


- (void)setColor:(UIColor *)color {
    self.back.backgroundColor = color;
}

- (UIView *)back {
    if (_back) {
        return _back;
    }
    _back = [[UIView alloc] init];
    _back.layer.cornerRadius = 5;
    return _back;
}
@end
