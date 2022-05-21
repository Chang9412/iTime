//
//  ITPipManager.h
//  iTime
//
//  Created by zhengqiang zhang on 2022/5/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ITPipManager : NSObject

+ (instancetype)manager;
- (void)startPip;
- (void)stopPip;


@end

NS_ASSUME_NONNULL_END
