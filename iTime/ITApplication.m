//
//  ITApplication.m
//  iTime
//
//  Created by zhengqiang zhang on 2022/5/10.
//

#import "ITApplication.h"

@implementation ITApplication

- (BOOL)sendAction:(SEL)action to:(id)target from:(id)sender forEvent:(UIEvent *)event {
    return [super sendAction:action to:target from:sender forEvent:event];
}

- (void)sendEvent:(UIEvent *)event {
    [super sendEvent:event];
}

@end
