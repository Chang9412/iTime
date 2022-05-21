//
//  ITChangeBackgroundCell.m
//  iTime
//
//  Created by zhengqiang zhang on 2022/5/6.
//

#import "ITChangeBackgroundCell.h"

@interface ITChangeBackgroundCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *imageView2;

@end

@implementation ITChangeBackgroundCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.imageView2];

        self.imageView.frame = self.contentView.bounds;
        self.imageView2.frame = self.contentView.bounds;
    }
    return self;
}

- (void)setImage:(UIImage *)image {
    self.imageView.image = image;
}

- (void)setOriginalimage:(UIImage *)originalimage {
    self.imageView2.image = originalimage;
}

- (UIImageView *)imageView {
    if (_imageView) {
        return _imageView;
    }
    _imageView = [[UIImageView alloc] init];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
    _imageView.layer.cornerRadius = 5;
    return _imageView;
}

- (UIImageView *)imageView2 {
    if (_imageView2) {
        return _imageView2;
    }
    _imageView2 = [[UIImageView alloc] init];
    _imageView2.contentMode = UIViewContentModeCenter;
    return _imageView2;
}

@end
