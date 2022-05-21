//
//  UIImage+Color.h
//  HanjuTV
//
//  Created by zhengqiang zhang on 2020/3/12.
//  Copyright © 2020 上海宝云网络. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Color)

+ (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

+ (UIImage *)imageWithGradientColors:(NSArray *)colors
                           locations:(CGFloat *)locations
                          startPoint:(CGPoint)startPoint
                            endPoint:(CGPoint)endPoint
                                imageSize:(CGSize)size;
    
+ (UIImage *)navBarBackgroundImageWithStarColor:(UIColor *)startColor endColor:(UIColor *)endColor;

@end

NS_ASSUME_NONNULL_END
