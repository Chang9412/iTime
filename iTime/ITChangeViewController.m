//
//  ITChangeViewController.m
//  iTime
//
//  Created by zhengqiang zhang on 2022/5/5.
//

#import "ITChangeViewController.h"
#import <Masonry.h>
#import "ITChangeBackgroundCell.h"
#import "ITChangeTextColorCell.h"
#import "ITChangeHeader.h"
#import "ITTimeManager.h"
#import <SVProgressHUD.h>
#import "UIScrollView+SafeArea.h"
#import <TZImagePickerController.h>
#import <Photos/Photos.h>


@interface ITChangeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, TZImagePickerControllerDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, strong) NSArray *backgrounds;

@end

@implementation ITChangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"画中画样式";
    self.view.backgroundColor = [UIColor colorWithRGB:0xf3f3f3];

    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.colors = [ITTimeManager manager].textColors;
    self.backgrounds = [ITTimeManager manager].backgrounds;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清除图片" style:UIBarButtonItemStylePlain target:self action:@selector(clearImage)];
}

- (void)clearImage {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"清除所有自定义背景" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [[ITTimeManager manager] clearCustomBackgrounds];
        [self.collectionView reloadData];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)gotoImagePicker {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusDenied) {
            [self showMessage:@"请打开您的相册权限"];
            return;
        }
    }];
    
    TZImagePickerController *picker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    picker.allowPickingVideo = NO;
    picker.allowPickingImage = YES;
    
    picker.allowEditVideo= NO;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)saveImage:(UIImage *)image {
    
    
}

#pragma mark -

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    UIImage *image = photos.lastObject;
    [[ITTimeManager manager] addBackground:image];
    self.backgrounds = [[ITTimeManager manager] backgrounds];
    [self.collectionView reloadData];
}

- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return self.colors.count;
    }
    return self.backgrounds.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ITChangeTextColorCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ITChangeTextColorCell" forIndexPath:indexPath];
        cell.color = self.colors[indexPath.item];
        cell.selected = [ITTimeManager manager].currentTextColor;
        return cell;
    }
    ITChangeBackgroundCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ITChangeBackgroundCell" forIndexPath:indexPath];
    if (indexPath.item == self.backgrounds.count) {
        cell.originalimage = [UIImage imageNamed:@"plus"];
        cell.image = nil;
    } else {
        cell.image = self.backgrounds[indexPath.item];
        cell.originalimage = nil;
    }
    cell.selected = [ITTimeManager manager].currentBackground;

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    float width = CGRectGetWidth(collectionView.bounds);
    if (indexPath.section == 0) {
        float itemWidth = floorf((width - 12 - 12 - 12 * 2) / 3);
        return CGSizeMake(itemWidth, 30);
    }
    float itemWidth = floorf((width - 12 - 12 - 20) / 2);
    float itemHeight = ceilf(itemWidth * 9 / 16);
    return CGSizeMake(itemWidth, itemHeight);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return 12;
    }
    return 20;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return 12;
    }
    return 20;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 12, 0, 12);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    ITChangeHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ITChangeHeader" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        header.title = @"字体颜色";
    } else {
        header.title = @"背景颜色";
    }
    return header;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(CGRectGetWidth(collectionView.bounds), 75);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        [[ITTimeManager manager] updateTextColor:indexPath.item];
        [self showMessage:@"字体颜色切换成功"];
    } else {
        if (indexPath.item == self.backgrounds.count) {
            [self gotoImagePicker];
            return;
        }
        [[ITTimeManager manager] updateBackground:indexPath.item];
        [self showMessage:@"背景切换成功"];
    }
    
}

- (void)showMessage:(NSString *)message {
    [SVProgressHUD showSuccessWithStatus:message];
    [SVProgressHUD dismissWithDelay:1.5];
}

- (UICollectionView *)collectionView {
    if (_collectionView) {
        return _collectionView;
    }
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 100, 100) collectionViewLayout:layout];
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.sa_shouldAdjustSafeArea = YES;
    [_collectionView registerClass:[ITChangeBackgroundCell class] forCellWithReuseIdentifier:@"ITChangeBackgroundCell"];
    [_collectionView registerClass:[ITChangeTextColorCell class] forCellWithReuseIdentifier:@"ITChangeTextColorCell"];
    [_collectionView registerClass:[ITChangeHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ITChangeHeader"];
    return _collectionView;
}


@end
