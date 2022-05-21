//
//  ITTimeView.m
//  iTime
//
//  Created by zhengqiang zhang on 2022/5/5.
//

#import "ITTimeView.h"
#import <Masonry.h>

@interface ITTimeView ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation ITTimeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taped)]];
    
    [self addSubview:self.titleLabel];
//    float topOffset = [UIApplication sharedApplication].keyWindow.safeAreaInsets.top;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.equalTo(@310);
        make.height.greaterThanOrEqualTo(@0);
    }];
    
}

- (void)setShowMill:(BOOL)showMill {
    _showMill = showMill;
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(showMill ? @310 : @270);
    }];
}

- (void)setTime:(NSString *)time {
    self.titleLabel.text = time;
}

- (void)taped {
    if (self.tapBlock) {
        self.tapBlock();
    }
}


- (UILabel *)titleLabel {
    if (_titleLabel) {
        return _titleLabel;
    }
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont boldSystemFontOfSize:60];
    _titleLabel.textColor = [UIColor whiteColor];
//    _titleLabel.textAlignment = NSTextAlignmentCenter;
//    _titleLabel.backgroundColor = [UIColor colorWithRGB:0xf3f3f3 alpha:1];
    _titleLabel.clipsToBounds = YES;
    _titleLabel.layer.cornerRadius = 10;
    return _titleLabel;
}



@end


@interface ITPipTimeView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation ITPipTimeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.textColor = [UIColor whiteColor];
    [self addSubview:self.imageView];
    [self addSubview:self.titleLabel];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
//    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self);
//    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];    
    float viewWidth = CGRectGetWidth(self.bounds);
    if (self.showMill) {
        if (viewWidth > MIN(CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds)) / 2) {
            self.titleLabel.frame = CGRectMake(35, 0, CGRectGetWidth(self.bounds) - 35, CGRectGetHeight(self.bounds));
            self.titleLabel.font = [UIFont boldSystemFontOfSize:60];
        } else {
            self.titleLabel.frame = CGRectMake(17.5, 0, CGRectGetWidth(self.bounds) - 20, CGRectGetHeight(self.bounds));
            self.titleLabel.font = [UIFont boldSystemFontOfSize:30];
        }
    } else {
        if (viewWidth > MIN(CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds)) / 2) {
            self.titleLabel.frame = CGRectMake(60, 0, CGRectGetWidth(self.bounds) - 60, CGRectGetHeight(self.bounds));
            self.titleLabel.font = [UIFont boldSystemFontOfSize:60];
        } else {
            self.titleLabel.frame = CGRectMake(30, 0, CGRectGetWidth(self.bounds) - 30, CGRectGetHeight(self.bounds));
            self.titleLabel.font = [UIFont boldSystemFontOfSize:30];
        }
    }
    
}

- (NSAttributedString *)timeString:(NSString *)time {
    NSMutableAttributedString *timeString = [[NSMutableAttributedString alloc] initWithString:time];
    [timeString addAttributes:@{NSFontAttributeName:self.titleLabel.font,NSForegroundColorAttributeName:self.textColor} range:NSMakeRange(0, time.length)];
    [timeString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(time.length-1, 1)];
    return timeString;
}

- (BOOL)showRed {
    return self.showMill && _showRed;
}

- (void)setShowMill:(BOOL)showMill {
    _showMill = showMill;
    [self setNeedsLayout];
}

- (void)setTime:(NSString *)time {
    if (self.showRed) {
        self.titleLabel.attributedText = [self timeString:time];
    } else {
        self.titleLabel.text = time;
    }
}

- (void)setImage:(UIImage *)image {
    self.imageView.image = image;
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    self.titleLabel.textColor = textColor;
}

- (UIImageView *)imageView {
    if (_imageView) {
        return _imageView;
    }
    _imageView = [[UIImageView alloc] init];
    _imageView.clipsToBounds = YES;
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.backgroundColor = [UIColor blackColor];
    return _imageView;
}

- (UILabel *)titleLabel {
    if (_titleLabel) {
        return _titleLabel;
    }
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont boldSystemFontOfSize:60];
//    _titleLabel.adjustsFontSizeToFitWidth = YES;
//    _titleLabel.minimumScaleFactor = 0.2;
    _titleLabel.textColor = self.textColor;
//    _titleLabel.textAlignment = NSTextAlignmentCenter;
    return _titleLabel;
}

@end
