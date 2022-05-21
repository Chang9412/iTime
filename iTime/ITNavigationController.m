//
//  ITNavigationController.m
//  iTime
//
//  Created by zhengqiang zhang on 2022/5/2.
//

#import "ITNavigationController.h"
#import "UINavigationBar+Awesome.h"
#import <objc/runtime.h>

@implementation UIViewController (ITNavigationPopGestureRecognizer)

@dynamic prefersNavigationBarHidden;

- (BOOL)popGestureRecognizerEnabled {
    return YES;
}

- (void)setPrefersNavigationBarHidden:(BOOL)prefersNavigationBarHidden {
    objc_setAssociatedObject(self, @selector(prefersNavigationBarHidden), @(prefersNavigationBarHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)prefersNavigationBarHidden {
    NSNumber *n = objc_getAssociatedObject(self, _cmd);
    if (!n) {
        return NO;
    }
    return [n boolValue];
}

- (BOOL)shouldBeginPopGestureRecognizer:(UIGestureRecognizer *)gr {
    return YES;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForOperation:(UINavigationControllerOperation)operation forToVC:(UIViewController *)toVC{
    return nil;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForOperation:(UINavigationControllerOperation)operation forFromVC:(UIViewController *)FromVC {
    return nil;
}

- (void)resetNavigationBar {
    if (![self.navigationController isKindOfClass:[ITNavigationController class]]) {
        return;
    }
    [(ITNavigationController *)self.navigationController app_resetNavigationBar];
}

@end

@interface ITNavigationController ()<UIGestureRecognizerDelegate, UINavigationControllerDelegate>

@property BOOL pushing;
@property (nonatomic) UIImageView *navigationImageView;
@property (nonatomic) BOOL originBack;

@end

@implementation ITNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.clipsToBounds = YES;
    self.navigationBar.translucent = NO;
    self.navigationBar.tintColor = [self app_barTintColor];
    [self.navigationBar lt_setBackgroundColor:[self app_barBackgroundColor]];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[self app_barTitleColor]}];
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *navigationBarAppearance = [UINavigationBarAppearance new];
        navigationBarAppearance.backgroundColor = [self app_barBackgroundColor];
        navigationBarAppearance.backgroundEffect = nil;
        navigationBarAppearance.shadowColor = [UIColor clearColor];
        navigationBarAppearance.titleTextAttributes = @{NSForegroundColorAttributeName:[self app_barTitleColor]};
        self.navigationBar.scrollEdgeAppearance = navigationBarAppearance;
        self.navigationBar.standardAppearance = navigationBarAppearance;
    }
    __weak typeof(self) weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        UIView *targetView = self.interactivePopGestureRecognizer.view;
        UIPanGestureRecognizer * fullScreenGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(hanleFullScreenGes:)];
        fullScreenGes.delegate = self;
        [targetView addGestureRecognizer:fullScreenGes];
        self.fullScreenPopGestureRecognizer = fullScreenGes;
        // 关闭边缘触发手势 防止和原有边缘手势冲突
        [self.interactivePopGestureRecognizer setEnabled:NO];
        self.delegate = weakSelf;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.pushing = NO;
}

- (NSArray<__kindof UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    UIViewController *vc = viewController;
    if (!vc) {
        return @[];
    }
    if ([self.viewControllers containsObject:vc]) {
        return [super popToViewController:vc animated:animated];
    }
    while (vc.parentViewController) {
        vc = vc.parentViewController;
        if ([self.viewControllers containsObject:vc]) {
            return [super popToViewController:vc animated:animated];
        }
    }
    return @[];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.pushing) {
        return;
    }
    self.pushing = YES;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]){
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    if ([self.viewControllers count] > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        if (!viewController.navigationItem.leftBarButtonItem && !viewController.navigationItem.backBarButtonItem) {
            UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"]  style:UIBarButtonItemStylePlain target:self action:@selector(pop)];
            bar.tintColor = [self app_barTintColor];
            viewController.navigationItem.leftBarButtonItem = bar;
        }
    }
    viewController.edgesForExtendedLayout = UIRectEdgeAll;
    [super pushViewController:viewController animated:animated];
}

- (UIColor *)app_barTintColor {
    return [UIColor whiteColor];
}

- (UIColor *)app_barTitleColor {
    return [UIColor whiteColor];
}

- (UIColor *)app_barBackgroundColor {
    return [UIColor theme];
}

- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated {
    if (self.pushing) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self setViewControllers:viewControllers animated:animated];
        });
        return;
    }
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]){
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    for (UIViewController *viewController in viewControllers) {
        if (viewController != viewControllers.firstObject) {
            viewController.hidesBottomBarWhenPushed = YES;
            if (!viewController.navigationItem.leftBarButtonItem && !viewController.navigationItem.backBarButtonItem) {
                UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"]  style:UIBarButtonItemStylePlain target:self action:@selector(pop)];
                bar.tintColor = [self app_barTintColor];
                viewController.navigationItem.leftBarButtonItem= bar;
            }
            viewController.edgesForExtendedLayout = UIRectEdgeAll;
        }
    }
    [super setViewControllers:viewControllers animated:animated];
}

- (void)navigationController:(UINavigationController*)navigationController willShowViewController:(UIViewController*)viewController animated:(BOOL)animated {
    if(viewController.prefersNavigationBarHidden){
        [self setNavigationBarHidden:YES animated:YES];
    } else {
        [self setNavigationBarHidden:NO animated:YES];
    }
}

- (void)setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated {
    [super setNavigationBarHidden:hidden animated:animated];
}

- (void)pop {
    UIViewController *vc = [self.viewControllers lastObject];
    if ([vc canPerformAction:@selector(app_navigationBackClicked) withSender:nil]) {
        [vc app_navigationBackClicked];
        return;
    }
    [self popViewControllerAnimated:YES];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    if (self.pushing) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self popViewControllerAnimated:animated];
        });
        return nil;
    }
    if ([self.viewControllers count] == 1
        && self.presentingViewController) {
        UIViewController *vc = self.viewControllers.firstObject;
        [self dismissViewControllerAnimated:YES completion:NULL];
        return vc;
    }
    return [super popViewControllerAnimated:animated];
}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    self.pushing = NO;
    if(viewController.prefersNavigationBarHidden){
        [self setNavigationBarHidden:YES animated:animated];
    }else{
        [self setNavigationBarHidden:NO animated:animated];
    }
    [viewController setNeedsStatusBarAppearanceUpdate];
}

- (void)hanleFullScreenGes:(UIPanGestureRecognizer *)gsr {
    id target = self.interactivePopGestureRecognizer.delegate;
    SEL handler = NSSelectorFromString(@"handleNavigationTransition:");
    if ([target respondsToSelector:handler]) {
        IMP imp = [target methodForSelector:handler];
        void (*func)(id, SEL, UIPanGestureRecognizer *) = (void *)imp;
        func(target, handler, gsr);
    }
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    UIPanGestureRecognizer *gsr = (UIPanGestureRecognizer *)gestureRecognizer;
    if ([self.viewControllers count] == 1) {
        return NO;
    }
    if (![[self.viewControllers lastObject] popGestureRecognizerEnabled]) {
        return NO;
    }
    BOOL isTransitioning =  [[self valueForKey:@"_isTransitioning"] boolValue];
    if (isTransitioning) {
        return NO;
    }
    if (![[self.viewControllers lastObject] shouldBeginPopGestureRecognizer:gestureRecognizer]) {
        return NO;
    }
    CGPoint translation = [gsr translationInView:gsr.view];
    if (translation.x <= 0) {
        return NO;
    }
    return YES;
}

- (BOOL)navBarTranslucent {
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.topViewController) {
        return [self.topViewController preferredStatusBarStyle];
    }
    return UIStatusBarStyleLightContent;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if (operation == UINavigationControllerOperationPush) {
        return [toVC animationControllerForOperation:operation forFromVC:fromVC];
    }
    if (operation == UINavigationControllerOperationPop) {
        return [fromVC animationControllerForOperation:operation forToVC:toVC];
    }
    return nil;
}

- (BOOL)prefersStatusBarHidden {
    if (self.topViewController) {
        return self.topViewController.prefersStatusBarHidden;
    }
    return [super prefersStatusBarHidden];
}

- (void)app_resetNavigationBar {
    [self.navigationBar lt_setBackgroundColor:[self app_barBackgroundColor]];
    self.navigationBar.tintColor = [self app_barTintColor];
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *navigationBarAppearance = [UINavigationBarAppearance new];
        navigationBarAppearance.backgroundColor = [self app_barBackgroundColor];
        navigationBarAppearance.backgroundEffect = nil;
        navigationBarAppearance.shadowColor = [UIColor clearColor];
        navigationBarAppearance.titleTextAttributes = @{NSForegroundColorAttributeName:[self app_barTitleColor]};
        self.navigationController.navigationBar.scrollEdgeAppearance = navigationBarAppearance;
        self.navigationController.navigationBar.standardAppearance = navigationBarAppearance;
    }
}

@end

@interface UIPageViewControllerFullScreenPopGestureRecognizerDelegate : NSObject <UIGestureRecognizerDelegate>

@property(nonatomic, weak) UIPageViewController *pageViewController;

@end

@implementation UIPageViewController (FullScreenPopGestureRecognizer)

- (UIPageViewControllerFullScreenPopGestureRecognizerDelegate *)fullScreenPopGestureRecognizerDelegate {
    UIPageViewControllerFullScreenPopGestureRecognizerDelegate *d = objc_getAssociatedObject(self, _cmd);
    if (d) {
        return d;
    }
    d = [[UIPageViewControllerFullScreenPopGestureRecognizerDelegate alloc] init];
    d.pageViewController = self;
    objc_setAssociatedObject(self, _cmd, d, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return d;
}

- (void)addFullPopGestureRecognizer {
    [self addFullPopGestureRecognizerWithNavigationViewController:nil];
}

- (void)addFullPopGestureRecognizerWithNavigationViewController:(UINavigationController *)nav {
    __block UIScrollView *scrollView = nil;
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIScrollView class]]) {
            scrollView = obj;
            *stop = YES;
        }
    }];
    if (!scrollView) {
        return;
    }
    if (!nav) {
        nav = self.navigationController;
    }
    if (!nav) {
        return;
    }
    BOOL isRoot = NO;
    UIViewController *theVC = self;
    while (theVC && ![theVC isKindOfClass:[ITNavigationController class]]) {
        if (nav.viewControllers.firstObject == theVC) {
            isRoot = YES;
            break;
        }
        theVC = theVC.parentViewController;
    }
    if (isRoot) {
        return;
    }
    UIGestureRecognizer *popGr = nil;
    if ([nav isKindOfClass:[ITNavigationController class]]) {
        popGr = [(ITNavigationController *)nav fullScreenPopGestureRecognizer];
    }
    if (!popGr) {
        popGr = nav.interactivePopGestureRecognizer;
    }
    UIPanGestureRecognizer *lockPan = [[UIPanGestureRecognizer alloc] init];
    lockPan.delegate = [self fullScreenPopGestureRecognizerDelegate];
    [scrollView addGestureRecognizer:lockPan];
    [scrollView.panGestureRecognizer requireGestureRecognizerToFail:lockPan];
    [lockPan requireGestureRecognizerToFail:popGr];
}

@end


@implementation UIPageViewControllerFullScreenPopGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    if (!self.pageViewController) {
        return NO;
    }
    if (!self.pageViewController.dataSource) {
        return NO;
    }
    UIViewController *current = [self.pageViewController.viewControllers firstObject];
    if (!current) {
        return [self.pageViewController shouldBeginPopGestureRecognizer:gestureRecognizer];
    }
    if (![self.pageViewController.dataSource respondsToSelector:@selector(pageViewController:viewControllerBeforeViewController:)]) {
        return NO;
    }
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    if (translation.x < 0) {
        return NO;
    }
    UIViewController *vc = [self.pageViewController.dataSource pageViewController:self.pageViewController viewControllerBeforeViewController:current];
    return vc ? NO : YES;
}


@end
