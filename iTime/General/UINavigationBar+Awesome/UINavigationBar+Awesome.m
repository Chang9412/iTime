//
//  UINavigationBar+Awesome.m
//  LTNavigationBar
//
//  Created by ltebean on 15-2-15.
//  Copyright (c) 2015 ltebean. All rights reserved.
//

#import "UINavigationBar+Awesome.h"
#import <objc/runtime.h>
#import "NSObject+Utils.h"

@implementation UINavigationBar (Awesome)
static char overlayKey;

+ (void)load
{
    [UINavigationBar swizzleInstanceMethod:@selector(layoutSubviews) withMethod:@selector(lt_layoutSubviews)];
}

- (void)lt_layoutSubviews
{
    [self lt_layoutSubviews];
    if (!self.overlay) {
        return;
    }
    CGRect frame = CGRectMake(0, -100, [UIScreen mainScreen].bounds.size.width, CGRectGetHeight(self.bounds) + 100);
    self.overlay.frame = [self convertRect:frame toView:self.overlay.superview];
}

- (UIImageView *)overlay
{
    return objc_getAssociatedObject(self, &overlayKey);
}

- (void)setOverlay:(UIImageView *)overlay
{
    objc_setAssociatedObject(self, &overlayKey, overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)lt_setBackgroundColor:(UIColor *)backgroundColor
{
    if (!self.overlay) {
        [self setShadowImage:[UIImage new]];
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.overlay = [[UIImageView alloc] initWithFrame:CGRectMake(0, -100, [UIScreen mainScreen].bounds.size.width, CGRectGetHeight(self.bounds) + 100)];
        self.overlay.userInteractionEnabled = NO;
        self.overlay.autoresizingMask = UIViewAutoresizingNone;
        if ([self.subviews count] > 0) {
            UIView *view = self.subviews[0];
            [view insertSubview:self.overlay atIndex:0];
        } else {
            UIView *back = nil;
            @try {
                back = [self valueForKey:@"backgroundView"];
            } @catch(NSException *exp) {
                
            }
            [back addSubview:self.overlay];
        }
    }
    self.overlay.backgroundColor = backgroundColor;
    self.overlay.image = nil;
}

- (void)lt_setBackgroundImage:(UIImage *)backgroundImage
{
    if (!self.overlay) {
        [self setShadowImage:[UIImage new]];
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.overlay = [[UIImageView alloc] initWithFrame:CGRectMake(0, -100, [UIScreen mainScreen].bounds.size.width, CGRectGetHeight(self.bounds) + 120)];
        self.overlay.userInteractionEnabled = NO;
        self.overlay.autoresizingMask = UIViewAutoresizingNone;
        if ([self.subviews count] > 0) {
            UIView *view = self.subviews[0];
            [view insertSubview:self.overlay atIndex:0];
        } else {
            UIView *back = nil;
            @try {
                back = [self valueForKey:@"backgroundView"];
            } @catch(NSException *exp) {
                
            }
            [back addSubview:self.overlay];
        }
    }
    self.overlay.image = backgroundImage;
    self.overlay.backgroundColor = [UIColor whiteColor];
    self.overlay.contentMode = UIViewContentModeScaleToFill;
}

- (void)lt_setTranslationY:(CGFloat)translationY
{
    self.transform = CGAffineTransformMakeTranslation(0, translationY);
}

- (void)lt_setElementsAlpha:(CGFloat)alpha
{
    [[self valueForKey:@"_leftViews"] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger i, BOOL *stop) {
        view.alpha = alpha;
    }];
    
    [[self valueForKey:@"_rightViews"] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger i, BOOL *stop) {
        view.alpha = alpha;
    }];
    
    UIView *titleView = [self valueForKey:@"_titleView"];
    titleView.alpha = alpha;
//    when viewController first load, the titleView maybe nil
    [[self subviews] enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:NSClassFromString(@"UINavigationItemView")]) {
            obj.alpha = alpha;
            *stop = YES;
        }
    }];
}

- (void)lt_setBackgroundView:(UIView *)view {
    [self lt_setBackgroundColor:[UIColor clearColor]];
    view.frame = self.overlay.bounds;
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.overlay addSubview:view];
}

- (void)lt_reset
{
    [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.overlay removeFromSuperview];
    self.overlay = nil;
}

@end
