//
//  ITNavigationController.h
//  iTime
//
//  Created by zhengqiang zhang on 2022/5/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN



@protocol ITNavigationControllerBackClicked <NSObject>

@optional
- (void)app_navigationBackClicked;

@end

@interface UIViewController (ITNavigationPopGestureRecognizer) <ITNavigationControllerBackClicked>

@property(nonatomic) BOOL prefersNavigationBarHidden;

- (void)resetNavigationBar;
- (BOOL)popGestureRecognizerEnabled;
- (BOOL)prefersNavigationBarHidden;
- (BOOL)shouldBeginPopGestureRecognizer:(UIGestureRecognizer *)gr;
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForOperation:(UINavigationControllerOperation)operation forToVC:(UIViewController *)toVC;
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForOperation:(UINavigationControllerOperation)operation forFromVC:(UIViewController *)FromVC;

@end

@interface ITNavigationController : UINavigationController

@property(nonatomic) UIPanGestureRecognizer *fullScreenPopGestureRecognizer;
- (UIColor *)app_barTintColor;
- (UIColor *)app_barTitleColor;
- (UIColor *)app_barBackgroundColor;
- (void)app_resetNavigationBar;

@end

NS_ASSUME_NONNULL_END
