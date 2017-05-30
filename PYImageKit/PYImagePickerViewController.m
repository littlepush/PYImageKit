//
//  PYImagePickerViewController.m
//  ExportApp
//
//  Created by Push Chen on 30/05/2017.
//  Copyright © 2017 BaoSteel. All rights reserved.
//

/*
 LGPL V3 Lisence
 This file is part of cleandns.
 
 PYAudioKit is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 PYData is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with cleandns.  If not, see <http://www.gnu.org/licenses/>.
 */

/*
 LISENCE FOR IPY
 COPYRIGHT (c) 2013, Push Chen.
 ALL RIGHTS RESERVED.
 
 REDISTRIBUTION AND USE IN SOURCE AND BINARY
 FORMS, WITH OR WITHOUT MODIFICATION, ARE
 PERMITTED PROVIDED THAT THE FOLLOWING CONDITIONS
 ARE MET:
 
 YOU USE IT, AND YOU JUST USE IT!.
 WHY NOT USE THIS LIBRARY IN YOUR CODE TO MAKE
 THE DEVELOPMENT HAPPIER!
 ENJOY YOUR LIFE AND BE FAR AWAY FROM BUGS.
 */

#import "PYImagePickerViewController.h"
#import "PYImagePickerTableViewCell.h"
#import "PYImageCropViewController.h"

@interface PYImagePickerViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    UITableView                         *_imageList;
    UITableManager                      *_imageManager;
}

@end

@implementation PYImagePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.navigationItem setTitle:[PYImagePickerApperance sharedApperance].title];
    
    UIBarButtonItem *_cancel = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                target:self
                                action:@selector(_actionCancelHandler:)];
    [self.navigationItem setRightBarButtonItem:_cancel];
}

- (void)_actionCancelHandler:(id)sender
{
    [[PYApperance sharedApperance] dismissLastPoppedViewController];
}

- (void)viewControllerWillLoad
{
    [super viewControllerWillLoad];
    
    _imageList = [UITableView object];
    [_imageList setTableFooterView:[UIView object]];
    [_imageList setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_imageList];
    
    _imageManager = [UITableManager object];
    _imageManager.defaultTarget = self;
    _imageManager.defaultCellClass = [PYImagePickerTableViewCell class];
    _imageManager.identify = @"ImageManager";
    [_imageManager bindTableView:_imageList];
    
    if ( [PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized ) {
        [self _getAllPhotoFromLibrary];
    } else {
        __weak typeof(self) _ws = self;
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            // Cancel if the status is not Authorized
            if ( status != PHAuthorizationStatusAuthorized) {
                [_ws _actionCancelHandler:nil];
            } else {
                [_ws _getAllPhotoFromLibrary];
            }
        }];
    }
}

- (void)layoutSubviewsInRect:(CGRect)visiableRect
{
    [_imageList setFrame:visiableRect];
}

- (void)_didSelectedAsset:(PHAsset *)asset
{
    PYLog(@"did selected asset");
    if ( asset == nil ) {
        //[self performSegueWithIdentifier:@"kGroupTakePhoto" sender:self];
        // Star to take photo
        UIImagePickerController *_picker = [[UIImagePickerController alloc] init];
        _picker.modalPresentationStyle = UIModalPresentationCurrentContext;
        _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        _picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        _picker.delegate = self;
        [self presentViewController:_picker animated:YES completion:nil];
    } else {
        // Set Image and pop
        PHImageRequestOptions *option = [PHImageRequestOptions new];
        option.synchronous = YES;
        
        __weak typeof(self) _ws = self;
        [[PHImageManager defaultManager]
         requestImageForAsset:asset
         targetSize:CGSizeMake(asset.pixelWidth, asset.pixelHeight)
         contentMode:PHImageContentModeDefault
         options:option
         resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
             if ( [PYImagePickerApperance sharedApperance].needCrop ) {
                 PYImageCropViewController *_icvc = [PYImageCropViewController object];
                 _icvc.originImage = result;
                 _icvc.selectedImageEvent = self.selectedImageEvent;
                 [_ws.navigationController pushViewController:_icvc animated:YES];
             } else {
                 if ( self.selectedImageEvent ) {
                     self.selectedImageEvent(result);
                 }
                 [[PYApperance sharedApperance] dismissLastPoppedViewController];
             }
         }];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    DUMPObj(info);
    UIImage *_image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if ( [PYImagePickerApperance sharedApperance].needCrop ) {
        __weak PYImagePickerViewController *_ = self;
        [self dismissViewControllerAnimated:YES completion:^{
            PYImageCropViewController *_icvc = [PYImageCropViewController object];
            _icvc.originImage = _image;
            _icvc.selectedImageEvent = self.selectedImageEvent;
            [_.navigationController pushViewController:_icvc animated:YES];
        }];
    } else {
        if ( self.selectedImageEvent ) {
            self.selectedImageEvent(_image);
        }
        [[PYApperance sharedApperance] dismissLastPoppedViewController];
    }
}

- (void)PYEventHandler(ImageManager, PYTableManagerEventCreateNewCell) {
    PYImagePickerTableViewCell *_cell = (PYImagePickerTableViewCell *)obj1;
    __weak PYImagePickerViewController *_ = self;
    _cell.selectedBlock = ^(PHAsset *asset) {
        [_ _didSelectedAsset:asset];
    };
}

- (void)_reloadPhotoListWithImages:(NSArray *)dataSource
{
    [_imageManager reloadTableDataWithDataSource:dataSource];
}

- (void)_getAllPhotoFromLibrary
{
    __block NSMutableArray *_images = [NSMutableArray array];
    __block NSMutableArray *_cellCollection = nil;
    __block NSMutableArray *_allImages = [NSMutableArray array];
    __block NSInteger _cellImageCount = 0;
    __weak PYImagePickerViewController *_ = self;
    
    PHFetchOptions *_photoOptions = [PHFetchOptions new];
    _photoOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    PHFetchResult *_allPhotos = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:_photoOptions];
    [_allPhotos enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL *stop) {
        if ( asset == nil ) return;
        PYPair *_pair = [PYPair object];
        _pair.firstObj = nil;
        _pair.secondObj = asset;
        [_allImages insertObject:_pair atIndex:0];
        // All loaded
        if ( idx == _allPhotos.count - 1) {
            // Re-org
            _cellCollection = [NSMutableArray array];
            // First line, First one
            PYPair *_pair = [PYPair object];
            _pair.firstObj = [PYImagePickerApperance sharedApperance].cameraIcon;
            _pair.secondObj = nil;
            //[_cellCollection addObject:_pair];
            [_cellCollection addObject:_pair];
            _cellImageCount = 1;
            
            for ( NSUInteger i = 0; i < _allImages.count; ++i ) {
                [_cellCollection addObject:_allImages[i]];
                _cellImageCount += 1;
                if ( _cellImageCount == 3 ) {
                    [_images addObject:_cellCollection];
                    _cellCollection = [NSMutableArray array];
                    _cellImageCount = 0;
                }
            }
            if ( _cellCollection.count > 0 ) {
                [_images addObject:_cellCollection];
            }
            [_ _reloadPhotoListWithImages:_images];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

// @littlepush
// littlepush@gmail.com
// PYLab
