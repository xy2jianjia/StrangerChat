//
//  NPhotoController.m
//  StrangerChat
//
//  Created by zxs on 15/11/26.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "NPhotoController.h"
#import "NPhotoCell.h"
#import "ZLPhoto.h"
#import "UIImageView+WebCache.h"
#import "DHUserAlbumModel.h"
@interface NPhotoController ()<UICollectionViewDataSource,UICollectionViewDelegate,ZLPhotoPickerBrowserViewControllerDataSource,ZLPhotoPickerBrowserViewControllerDelegate,UIActionSheetDelegate>

@property (nonatomic , strong) NSMutableArray *assets;
@property (weak,nonatomic) UICollectionView *collectionView;
@property (strong,nonatomic) ZLCameraViewController *cameraVc;

@end
static NSString *kcellIdentifier = @"collectionCellID";
@implementation NPhotoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    [self setupDataSource];
    [self setupUI];
}
/**
 *  处理数据
 */
- (void)setupDataSource{
    
//    for (DHUserAlbumModel *item in _albumArr) {
//        
//    }
    
}
- (void)setupUI{
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupCollectionView];
}

#pragma mark setup UI
- (void)setupCollectionView{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(([[UIScreen mainScreen] bounds].size.width-30)/4, 70);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 10;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 80) collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.pagingEnabled = true;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerClass:[NPhotoCell class] forCellWithReuseIdentifier:kcellIdentifier];
    [self.view addSubview:collectionView];
    
    self.collectionView = collectionView;
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    return [self.assets count];
    return self.albumArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kcellIdentifier forIndexPath:indexPath];
    DHUserAlbumModel *item = self.albumArr[indexPath.item];
    [cell.simage sd_setImageWithURL:[NSURL URLWithString:item.b59] placeholderImage:[UIImage imageNamed:@"list_item_icon.png"]];
    return cell;
    
}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    // 图片游览器
    ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
    pickerBrowser.delegate = self;
    pickerBrowser.dataSource = self;
    // 是否可以删除照片
    pickerBrowser.editing = false;
    // 当前分页的值
    // pickerBrowser.currentPage = indexPath.row;
    // 传入组
    pickerBrowser.currentIndexPath = indexPath;
    // 展示控制器
    [pickerBrowser showPickerVc:self];
}

#pragma mark - <ZLPhotoPickerBrowserViewControllerDataSource>
- (NSInteger)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section{
    return self.albumArr.count;
}

- (ZLPhotoPickerBrowserPhoto *)photoBrowser:(ZLPhotoPickerBrowserViewController *)pickerBrowser photoAtIndexPath:(NSIndexPath *)indexPath{
//    id imageObj = [self.assets objectAtIndex:indexPath.item];
    DHUserAlbumModel *item = self.albumArr[indexPath.item];
    ZLPhotoPickerBrowserPhoto *photo = [ZLPhotoPickerBrowserPhoto photoAnyImageObjWith:item.b58];
    // 包装下imageObj 成 ZLPhotoPickerBrowserPhoto 传给数据源
    NPhotoCell *cell = (NPhotoCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    // 缩略图
//    if ([imageObj isKindOfClass:[ZLPhotoAssets class]]) {
//        photo.asset = imageObj;
//    }
    photo.toView = cell.simage;
    photo.thumbImage = cell.simage.image;
    return photo;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
