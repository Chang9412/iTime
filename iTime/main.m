//
//  main.m
//  iTime
//
//  Created by zhengqiang zhang on 2022/5/2.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ITApplication.h"

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, NSStringFromClass([ITApplication class]), appDelegateClassName);
}
