//
//  NSObject+Utils.m
//  App
//
//  Created by m on 16/3/23.
//  Copyright © 2016年 上海宝云网络. All rights reserved.
//

#import "NSObject+Utils.h"
#import <objc/runtime.h>

@implementation NSObject (Utils)

+ (BOOL)swizzleInstanceMethod:(SEL)origSelector withMethod:(SEL)newSelector {
    Method origMethod = class_getInstanceMethod(self, origSelector);
    Method newMethod = class_getInstanceMethod(self, newSelector);
    
    if (origMethod && newMethod) {
        if (class_addMethod(self, origSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
            class_replaceMethod(self, newSelector, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
        } else {
            method_exchangeImplementations(origMethod, newMethod);
        }
        return YES;
    }
    return NO;
}

+ (BOOL)swizzleClassMethod:(SEL)origSelector withMethod:(SEL)newSelector {
    Class metaClass = object_getClass(self);
    return [metaClass swizzleInstanceMethod:origSelector withMethod:newSelector];
}

+ (BOOL)addInstanceMethod:(SEL)newSelector bySelector:(SEL)selector {
    Method newMethod = class_getInstanceMethod(self, newSelector);
    if (newMethod) {
        return NO;
    }
    Method method = class_getInstanceMethod(self, selector);
    return class_addMethod(self, newSelector, method_getImplementation(method), method_getTypeEncoding(method));
}

@end
