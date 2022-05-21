//
//  HomeViewController.m
//  iTime
//
//  Created by zhengqiang zhang on 2022/5/2.
//

#import "HomeViewController.h"
#import "ITTimeView.h"
#import "ITTimeSetting.h"
#import <Masonry.h>
#import "ITSwitchCell.h"
#import "ITOperationCell.h"
#import "ITNormalCell.h"
#import "UIScrollView+SafeArea.h"
#import "ITChangeViewController.h"
#import "ITSoundViewController.h"
#import "ITTimeManager.h"
#import "ITPipManager.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <ReactiveCocoa.h>
#import "ITGuideView.h"


@interface HomeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) ITTimeView *timeView;
@property (nonatomic, strong) UIButton *pipButton;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *settings;
@property (nonatomic, strong) CADisplayLink *link;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRGB:0xf3f3f3];
    [self loadSettings];
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.timeView];
    [self.imageView addSubview:self.pipButton];
    [self.view addSubview:self.collectionView];
    float viewHeight = ceilf(CGRectGetWidth(self.view.bounds) * 9 / 16);
    viewHeight += [UIApplication sharedApplication].keyWindow.safeAreaInsets.top;
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@(viewHeight));
    }];
    [self.timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.imageView);
        make.top.equalTo(@([UIApplication sharedApplication].keyWindow.safeAreaInsets.top));
    }];
    [self.pipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-10);
        make.bottom.equalTo(@-10);
        make.width.equalTo(@44);
        make.height.equalTo(@44);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.timeView.mas_bottom);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCountDown:) name:kCountdownNotification object:nil];
    [self showGuideIfNeed];
}

- (void)showGuideIfNeed {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"guide"]) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"guide"];
    ITGuideView *guideView = [[ITGuideView alloc] init];
    [self.view addSubview:guideView];
    [guideView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.imageView);
    }];
}

- (void)onCountDown:(NSNotification *)notification {
    NSInteger second = [notification.userInfo[@"second"] integerValue];
    if (second == 1) {
        for (ITTimeSetting *setting in self.settings) {
            if (setting.tid == 5) {
                setting.value = 0;
                break;
            }
        }
        [[ITPipManager manager] stopPip];
        [ITTimeManager manager].showReverse = NO;
        [self.collectionView reloadData];
    }
}

- (void)loadSettings {
    NSArray * settings = [[NSUserDefaults standardUserDefaults] arrayForKey:@"settings"];
    NSString *version = [[NSUserDefaults standardUserDefaults] objectForKey:@"version"];
    NSString *cversion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    if ([cversion floatValue] > [version floatValue] || !settings) {
        [[NSUserDefaults standardUserDefaults] setObject:cversion forKey:@"version"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        settings = [ITTimeSetting defaultSettings];
    }
    NSMutableArray *marray = [NSMutableArray array];
    for (NSDictionary *dict in settings) {
        ITTimeSetting *setting = [[ITTimeSetting alloc] initWithDict:dict];
        [marray addObject:setting];
        if (setting.tid == 3) {
            [ITTimeManager manager].showMill = setting.value;
        } else if (setting.tid == 4) {
            [ITTimeManager manager].showRed = setting.value;
        } else if (setting.tid == 5) {
            [ITTimeManager manager].showReverse = setting.value;
        }
    }
    self.settings = marray;
}

- (void)saveSettings {
    NSMutableArray *marray = [NSMutableArray array];
    for (ITTimeSetting *setting in self.settings) {
        [marray addObject:[setting toDict]];
    }
    [[NSUserDefaults standardUserDefaults] setObject:marray forKey:@"settings"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.link.paused = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.link.paused = YES;
}

- (void)updateTime {
    self.timeView.time = [[ITTimeManager manager] currentDate];
}

- (void)startPip {
    [[ITPipManager manager] startPip];
}

- (void)gotoChangeViewController {
    ITChangeViewController *vc = [[ITChangeViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)gotoSoundViewController {
    ITSoundViewController *vc = [[ITSoundViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }
    if (section == 1) {
        return self.settings.count - 2;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ITTimeSettingsCell *cell;
    if (indexPath.section == 0) {
        ITOperationCell *scell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ITOperationCell" forIndexPath:indexPath];
        scell.setting = self.settings[indexPath.row];
//        __weak typeof(self) weakSelf = self;
        scell.operatBlcok = ^(ITTimeSetting * _Nonnull setting, NSInteger value) {
            if (setting.tid == 1) { // s
                [ITTimeManager manager].extraSecond = value;
            } else { // ms
                [ITTimeManager manager].extraMillSecond = value;
            }
        };
        cell = scell;
    } else {
        if (indexPath.row < 3) {
            ITSwitchCell *scell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ITSwitchCell" forIndexPath:indexPath];
            __weak typeof(self) weakSelf = self;
            scell.valueDidChange = ^(ITTimeSetting * setting) {
                if (setting.tid == 3) {
                    [ITTimeManager manager].showMill = setting.value;
                    [weakSelf saveSettings];
                } else if (setting.tid == 4) {
                    [ITTimeManager manager].showRed = setting.value;
                    [weakSelf saveSettings];
                } else if (setting.tid == 5) {
                    [ITTimeManager manager].showReverse = setting.value;
                }
            };
            cell = scell;
        } else  {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ITNormalCell" forIndexPath:indexPath];
        }
        cell.setting = self.settings[indexPath.row+2];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(CGRectGetWidth(collectionView.bounds) - 24, 80);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 12, 0, 12);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    ITTimeSettingsHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ITTimeSettingsHeader" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        header.title = @"校准";
    } else {
        header.title = @"设置";
    }
    return header;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(CGRectGetWidth(collectionView.bounds), 75);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ITTimeSettingsCell *cell = (ITTimeSettingsCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.setting.style != 0) {
        return;
    }
    if (cell.setting.tid == 7) {
        [self gotoChangeViewController];
    } else if (cell.setting.tid == 6) {
        [self gotoSoundViewController];
    }
}

#pragma mark -

- (UICollectionView *)collectionView {
    if (_collectionView) {
        return _collectionView;
    }
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 20;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 100, 100) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.sa_shouldAdjustSafeArea = YES;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[ITNormalCell class] forCellWithReuseIdentifier:@"ITNormalCell"];
    [_collectionView registerClass:[ITSwitchCell class] forCellWithReuseIdentifier:@"ITSwitchCell"];
    [_collectionView registerClass:[ITOperationCell class] forCellWithReuseIdentifier:@"ITOperationCell"];
    [_collectionView registerClass:[ITTimeSettingsHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ITTimeSettingsHeader"];
    return _collectionView;
}

- (ITTimeView *)timeView {
    if (_timeView) {
        return _timeView;
    }
    _timeView = [[ITTimeView alloc] init];
    __weak typeof(self) weakSelf = self;
    _timeView.tapBlock = ^{
        [weakSelf startPip];
    };
    RACChannelTo(_timeView, showMill) = RACChannelTo([ITTimeManager manager], showMill);
    return _timeView;
}

- (UIImageView *)imageView {
    if (_imageView) {
        return _imageView;
    }
    _imageView = [[UIImageView alloc] init];
    _imageView.clipsToBounds = YES;
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.image = [UIImage imageNamed:@"top_background"];
//    _imageView.layer.cornerRadius = 20;
    return _imageView;
}

- (CADisplayLink *)link {
    if (_link) {
        return _link;
    }
    _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateTime)];
    _link.preferredFramesPerSecond = 10;
    [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    return _link;
}

- (UIButton *)pipButton {
    if (_pipButton) {
        return _pipButton;
    }
    _pipButton = [[UIButton alloc] init];
    [_pipButton setImage:[UIImage imageNamed:@"pip"] forState:UIControlStateNormal];
    [_pipButton addTarget:self action:@selector(startPip) forControlEvents:UIControlEventTouchUpInside];
    return _pipButton;
}
- (BOOL)prefersNavigationBarHidden {
    return YES;
}

@end
