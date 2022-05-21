//
//  AppDelegate.m
//  iTime
//
//  Created by zhengqiang zhang on 2022/5/2.
//

#import "AppDelegate.h"
#import "ITNavigationController.h"
#import "HomeViewController.h"
#import <SVProgressHUD.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    UIViewController *vc = [[ITNavigationController alloc] initWithRootViewController:[[HomeViewController alloc] init]];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
    
    [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    [UIView appearance].exclusiveTouch = YES;
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    return YES;
}




@end
