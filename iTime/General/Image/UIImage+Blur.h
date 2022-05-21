//
//  UIImage+Blur.h
//  HanjuTV
//
//  Created by patrick on 2020/6/30.
//  Copyright © 2020 上海宝云网络. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Blur)

- (UIImage *)blur_image;
- (UIImage *)blur_imageWithBlur:(CGFloat)blur;

@end

NS_ASSUME_NONNULL_END
