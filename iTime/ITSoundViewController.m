//
//  ITSoundViewController.m
//  iTime
//
//  Created by zhengqiang zhang on 2022/5/8.
//

#import "ITSoundViewController.h"
#import "ITSoundCell.h"
#import <Masonry.h>
#import "ITTimeManager.h"
#import "ITSwitchCell.h"


@interface ITSoundViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *sounds;
@property (nonatomic, strong) NSArray *settings;
@end

@implementation ITSoundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"倒计时音效";
    self.view.backgroundColor = [UIColor colorWithRGB:0xf3f3f3];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.sounds = @[@"无", @"音效-1", @"音效-2", @"音效-3"];
    [self loadSettings];
}

- (void)loadSettings {
    NSArray * settings = [[NSUserDefaults standardUserDefaults] arrayForKey:@"soundSettings"];
    NSString *version = [[NSUserDefaults standardUserDefaults] objectForKey:@"version"];
    NSString *cversion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    if ([cversion floatValue] > [version floatValue] || !settings) {
        [[NSUserDefaults standardUserDefaults] synchronize];
        settings = [ITTimeSetting defaultSoundSettings];
    }
    NSMutableArray *marray = [NSMutableArray array];
    for (NSDictionary *dict in settings) {
        ITTimeSetting *setting = [[ITTimeSetting alloc] initWithDict:dict];
        [marray addObject:setting];
        if (setting.tid == 1) {
            [ITTimeManager manager].lastThreeSecondTips = setting.value;
        } else if (setting.tid == 2) {
            [ITTimeManager manager].tips = setting.value;
        }
    }
    self.settings = marray;
}

- (void)saveSettings {
    NSMutableArray *marray = [NSMutableArray array];
    for (ITTimeSetting *setting in self.settings) {
        [marray addObject:[setting toDict]];
    }
    [[NSUserDefaults standardUserDefaults] setObject:marray forKey:@"soundSettings"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return self.settings.count;
    }
    return self.sounds.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ITSwitchCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ITSwitchCell" forIndexPath:indexPath];
        cell.setting = self.settings[indexPath.item];
        __weak typeof(self) weakSelf = self;
        cell.valueDidChange = ^(ITTimeSetting * setting) {
            if (setting.tid == 1) {
                [ITTimeManager manager].lastThreeSecondTips = setting.value;
            } else if (setting.tid == 2) {
                [ITTimeManager manager].tips = setting.value;
            }
            [weakSelf saveSettings];
        };
        return cell;
    }
    ITSoundCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ITSoundCell" forIndexPath:indexPath];
    cell.text = self.sounds[indexPath.item];
    if ([ITTimeManager manager].sound == indexPath.item) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [collectionView selectItemAtIndexPath:indexPath animated:false scrollPosition:UICollectionViewScrollPositionNone];
        });
    } else {
        cell.selected = NO;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [ITTimeManager manager].sound = indexPath.item;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CGSizeMake(CGRectGetWidth(collectionView.bounds) - 24, 80);
    }
    return CGSizeMake(320, 50);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return UIEdgeInsetsMake(40, 12, 0, 12);
    }
    float left = (CGRectGetWidth(collectionView.bounds) - 320) / 2;
    return UIEdgeInsetsMake(40, left, 0, left);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return nil;
    }
    ITSoundHeader *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"ITSoundHeader" forIndexPath:indexPath];
    footer.buttonClickBlock = ^{
        [[ITTimeManager manager] playTipsSound];
    };
    return footer;;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeZero;
    }
    return CGSizeMake(CGRectGetWidth(collectionView.bounds), 100);
}

- (UICollectionView *)collectionView {
    if (_collectionView) {
        return _collectionView;
    }
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 16;
    layout.minimumInteritemSpacing = 0;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 100, 100) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.allowsMultipleSelection = NO;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[ITSoundCell class] forCellWithReuseIdentifier:@"ITSoundCell"];
    [_collectionView registerClass:[ITSwitchCell class] forCellWithReuseIdentifier:@"ITSwitchCell"];
    [_collectionView registerClass:[ITSoundHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"ITSoundHeader"];
    return _collectionView;
}

@end

