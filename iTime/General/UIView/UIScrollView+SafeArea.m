//
//  UIScrollView+SafeArea.m
//  HanjuTV
//
//  Created by zhengqiang zhang on 2020/9/7.
//  Copyright © 2020 上海宝云网络. All rights reserved.
//

#import "UIScrollView+SafeArea.h"
#import "NSObject+Utils.h"
#import <objc/runtime.h>

@implementation UIScrollView (SafeArea)

+ (void)load {
    if (@available(iOS 11.0, *)) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [UIScrollView swizzleInstanceMethod:@selector(safeAreaInsetsDidChange) withMethod:@selector(sa_safeAreaInsetsDidChange)];
        });
    }
}

- (void)sa_safeAreaInsetsDidChange API_AVAILABLE(ios(11.0)) {
    [self sa_safeAreaInsetsDidChange];
    if (!self.sa_shouldAdjustSafeArea) {
        return;
    }
//    if (![self.nextResponder.nextResponder isKindOfClass:[UIViewController class]]) {
//        return;
//    }
    UIEdgeInsets insets = self.contentInset;
    insets.bottom -= self.sa_lastBottom;
    self.sa_lastBottom = self.safeAreaInsets.bottom;
    insets.bottom += self.sa_lastBottom;
    self.contentInset = insets;
}

- (void)setSa_lastBottom:(float)sa_lastBottom {
    objc_setAssociatedObject(self, @selector(sa_lastBottom), @(sa_lastBottom), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (float)sa_lastBottom {
    NSNumber *bottom = objc_getAssociatedObject(self, _cmd);
    if (!bottom) {
        return 0;
    }
    return [bottom floatValue];
}

- (void)setSa_shouldAdjustSafeArea:(BOOL)sa_shouldAdjustSafeArea {
    objc_setAssociatedObject(self, @selector(sa_shouldAdjustSafeArea), @(sa_shouldAdjustSafeArea), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)sa_shouldAdjustSafeArea{
    NSNumber *should = objc_getAssociatedObject(self, _cmd);
//    if (!should) {
//        return YES;
//    }
    return [should boolValue];
}

@end
