//
//  UIImage+Color.m
//  HanjuTV
//
//  Created by zhengqiang zhang on 2020/3/12.
//  Copyright © 2020 上海宝云网络. All rights reserved.
//

#import "UIImage+Color.h"

@implementation UIImage (Color)

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0);
    [color setFill];
    UIRectFill(rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, false, 0);
    [color setFill];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)imageWithGradientColors:(NSArray *)colors locations:(CGFloat *)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint imageSize:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, false, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGFloat colorComponents[colors.count * 4];
    for (UIColor *color in colors) {
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        NSInteger i = [colors indexOfObject:color];
        for (NSInteger j = 0; j < 4; j++) {
            colorComponents[i * 4 + j] = components[j];
        }
    }
    CGGradientRef gradient = CGGradientCreateWithColorComponents(space, colorComponents, locations, colors.count);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)navBarBackgroundImageWithStarColor:(UIColor *)startColor endColor:(UIColor *)endColor {
    CGSize size = CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), 144);
    CGFloat locations[2] = {0.0, 1.0};
    return [self imageWithGradientColors:@[startColor, endColor] locations:locations startPoint:CGPointMake(0, 0) endPoint:CGPointMake(size.width, 0) imageSize:size];
}

@end
