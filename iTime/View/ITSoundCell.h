//
//  ITSoundCell.h
//  iTime
//
//  Created by zhengqiang zhang on 2022/5/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ITSoundCell : UICollectionViewCell

@property (nonatomic, strong) NSString *text;

@end


@interface ITSoundHeader : UICollectionReusableView

@property (nonatomic, copy) void(^buttonClickBlock)(void);

//@property (nonatomic, strong) <##>;
@end

NS_ASSUME_NONNULL_END
