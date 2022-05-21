//
//  ITTimeView.h
//  iTime
//
//  Created by zhengqiang zhang on 2022/5/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ITTimeView : UIView

@property (nonatomic, strong) NSString *time;
@property (nonatomic, copy) void(^tapBlock)(void);

@property (nonatomic, assign) BOOL showMill;


@end

@interface ITPipTimeView : UIView

@property (nonatomic, assign) BOOL showRed;
@property (nonatomic, assign) BOOL showMill;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) NSString *time;


@end

NS_ASSUME_NONNULL_END
