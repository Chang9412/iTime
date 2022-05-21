//
//  UIScrollView+SafeArea.h
//  HanjuTV
//
//  Created by zhengqiang zhang on 2020/9/7.
//  Copyright © 2020 上海宝云网络. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (SafeArea)

@property (nonatomic, assign) float sa_lastBottom;
@property (nonatomic, assign) BOOL sa_shouldAdjustSafeArea;

@end

NS_ASSUME_NONNULL_END
