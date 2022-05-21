//
//  ITGuideView.m
//  iTime
//
//  Created by zhengqiang zhang on 2022/5/10.
//

#import "ITGuideView.h"
#import <Masonry.h>

@interface ITGuideView ()

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ITGuideView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    [self addSubview:self.backgroundView];
    [self addSubview:self.imageView];
    
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-15);
        make.bottom.equalTo(@-60);
        make.width.equalTo(@33);
        make.height.equalTo(@33);
    }];
    
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)]];
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    self.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        [self performSelector:@selector(hide) withObject:nil afterDelay:3];
    }];
    [self addImageViewAnimation];
}


- (void)addImageViewAnimation {
//    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position.y"];
//    animation.fillMode = kCAFillModeForwards;
//    animation.removedOnCompletion = NO;
//    animation.values = @[@0, @20, @0];
//    animation.duration = 0.25;
//    animation.repeatCount = 2;
//    [self.imageView.layer addAnimation:animation forKey:@""];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.imageView.transform = CGAffineTransformMakeTranslation(0, -15);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 animations:^{
            self.imageView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.15 animations:^{
                self.imageView.transform = CGAffineTransformMakeTranslation(0, -15);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.15 animations:^{
                    self.imageView.transform = CGAffineTransformIdentity;
                }];
            }];
        }];
    }];
}

- (void)hide {
    [ITGuideView cancelPreviousPerformRequestsWithTarget:self selector:@selector(hide) object:nil];
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self.imageView.layer removeAllAnimations];
        [self removeFromSuperview];
    }];
}

- (UIView *)backgroundView {
    if (_backgroundView) {
        return _backgroundView;
    }
    _backgroundView = [[UIView alloc] init];
    _backgroundView.backgroundColor = [UIColor colorWithRGB:0x000000 alpha:0.4];
    return _backgroundView;
}

- (UIImageView *)imageView {
    if (_imageView) {
        return _imageView;
    }
    _imageView = [[UIImageView alloc] init];
    _imageView.image = [UIImage imageNamed:@"guide"];
    return _imageView;
}
@end
