//
//  NSObject+Utils.h
//  App
//
//  Created by m on 16/3/23.
//  Copyright © 2016年 上海宝云网络. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Utils)

+ (BOOL)swizzleInstanceMethod:(SEL)origSelector withMethod:(SEL)newSelector;
+ (BOOL)swizzleClassMethod:(SEL)origSelector withMethod:(SEL)newSelector;
+ (BOOL)addInstanceMethod:(SEL)newSelector bySelector:(SEL)selector;

@end
