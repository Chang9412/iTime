//
//  UIColor+Utils.m
//  iSpeech
//
//  Created by zhengqiang zhang on 2021/12/31.
//

#import "UIColor+Utils.h"

@implementation UIColor (Utils)

+ (UIColor *)colorWithRGB:(NSInteger)rgb {
    return [UIColor colorWithRGB:rgb alpha:1];
}

+ (UIColor *)colorWithRGB:(NSInteger)rgb alpha:(CGFloat)alpha  {
    return [UIColor colorWithRed:((float)((rgb & 0xFF0000) >> 16)) / 255.0
                           green:((float)((rgb & 0xFF00) >> 8)) / 255.0
                            blue:((float)(rgb & 0xFF)) / 255.0
                           alpha:alpha];
}

+ (UIColor *)progressedColorFromColor:(UIColor *)_fromColor toColor:(UIColor *)_toColor progress:(float)progress {
    NSUInteger numFromComponents = CGColorGetNumberOfComponents(_fromColor.CGColor);
    NSUInteger numToComponents = CGColorGetNumberOfComponents(_toColor.CGColor);
    const CGFloat *fromComoents = CGColorGetComponents(_fromColor.CGColor);
    const CGFloat *toComoents = CGColorGetComponents(_toColor.CGColor);
    
    if (numToComponents == 2 && numFromComponents == 2) {
        CGFloat fromColor = fromComoents[0];
        CGFloat fromAlpha = fromComoents[1];
        
        CGFloat toColor = toComoents[0];
        CGFloat toAlpha = toComoents[1];
        
        CGFloat progressAlpha = fromAlpha * (1 - progress) + toAlpha * progress;
        if (fromAlpha == 0) {
            return [_toColor colorWithAlphaComponent:progressAlpha];
        }
        if (toAlpha == 0) {
            return [_fromColor colorWithAlphaComponent:progressAlpha];
        }
        
        CGFloat progressColor = fromColor * (1 - progress) + toColor * progress;
        return [UIColor colorWithWhite:progressColor alpha:progressAlpha];
    }
    

    if (numFromComponents == 2 && numToComponents == 4) {
        CGFloat fromColor = fromComoents[0];
        CGFloat fromAlpha = fromComoents[1];
        CGFloat toRed = toComoents[0];
        CGFloat toGreen = toComoents[1];
        CGFloat toBlue = toComoents[2];
        CGFloat toAlpha = toComoents[3];
     
        CGFloat progressAlpha = fromAlpha * (1 - progress) + toAlpha * progress;
        if (fromAlpha == 0) {
            return [_toColor colorWithAlphaComponent:progressAlpha];
        }
        
        CGFloat progressRed = fromColor * (1 - progress) + toRed * progress;
        CGFloat progressGreen = fromColor * (1 - progress) + toGreen * progress;
        CGFloat progressBlue = fromColor * (1 - progress) + toBlue * progress;
        return [UIColor colorWithRed:progressRed green:progressGreen blue:progressBlue alpha:progressAlpha];
    }
    
    if (numFromComponents == 4 && numToComponents == 2) {
        CGFloat fromRed = fromComoents[0];
        CGFloat fromGreen = fromComoents[1];
        CGFloat fromBlue = fromComoents[2];
        CGFloat fromAlpha = fromComoents[3];
        CGFloat toColor = toComoents[0];
        CGFloat toAlpha = toComoents[1];
     
        CGFloat progressAlpha = fromAlpha * (1 - progress) + toAlpha * progress;
        if (toAlpha == 0) {
            return [_fromColor colorWithAlphaComponent:progressAlpha];
        }
        
        CGFloat progressRed = fromRed * (1 - progress) + toColor * progress;
        CGFloat progressGreen = fromGreen * (1 - progress) + toColor * progress;
        CGFloat progressBlue = fromBlue * (1 - progress) + toColor * progress;
        return [UIColor colorWithRed:progressRed green:progressGreen blue:progressBlue alpha:progressAlpha];
    }
    
    
    
    CGFloat fromRed = fromComoents[0];
    CGFloat fromGreen = fromComoents[1];
    CGFloat fromBlue = fromComoents[2];
    CGFloat fromAlpha = fromComoents[3];
    
    CGFloat toRed = toComoents[0];
    CGFloat toGreen = toComoents[1];
    CGFloat toBlue = toComoents[2];
    CGFloat toAlpha = toComoents[3];
    
    CGFloat progressRed = fromRed * (1 - progress) + toRed * progress;
    CGFloat progressGreen = fromGreen * (1 - progress) + toGreen * progress;
    CGFloat progressBlue = fromBlue * (1 - progress) + toBlue * progress;
    CGFloat progressAlpha = fromAlpha * (1 - progress) + toAlpha * progress;
    return [UIColor colorWithRed:progressRed green:progressGreen blue:progressBlue alpha:progressAlpha];
}


@end
