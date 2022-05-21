//
//  UIImage+Blur.m
//  HanjuTV
//
//  Created by patrick on 2020/6/30.
//  Copyright © 2020 上海宝云网络. All rights reserved.
//

#import "UIImage+Blur.h"

@implementation UIImage (Blur)

- (UIImage *)blur_image {
    return [self blur_imageWithBlur:15];
}

- (UIImage *)blur_imageWithBlur:(CGFloat)blur {
    if (self) {
        CIContext *context = [CIContext contextWithOptions:nil];
        CIImage *inputImage = [CIImage imageWithCGImage:self.CGImage];
        // create gaussian blur filter
        CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
        [filter setValue:inputImage forKey:kCIInputImageKey];
        [filter setValue:[NSNumber numberWithFloat:blur] forKey:@"inputRadius"];
        // blur image
        CIImage *result = [filter valueForKey:kCIOutputImageKey];
        CIImage *tmpImage = [CIImage imageWithCGImage:self.CGImage];
        CGImageRef outImage = [context createCGImage:result fromRect:[tmpImage extent]];
        UIImage *blurImage = [UIImage imageWithCGImage:outImage];
        CGImageRelease(outImage);
        return blurImage;
    } else {
        return self;
    }
}

@end
