//
//  PYImageCropViewController.m
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

#import "PYImageCropViewController.h"
#import "UIImage+FixOrientation.h"

@interface PYImageCropViewController () <UIScrollViewDelegate>
{
    UIView                  *_actionPanel;
    UIButton                *_retakeBtn;
    UIButton                *_confirmBtn;
    UIScrollView            *_containerView;
    UIImageView             *_originaImageView;
    
    UIView                  *_topMask;
    UIView                  *_bottomMask;
    UIView                  *_staticMask;
}

@end

@implementation PYImageCropViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // We do not need to display the navigation bar here
    [self.navigationController setNavigationBarHidden:YES];
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [_containerView setContentInset:UIEdgeInsetsZero];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _originaImageView;
}

- (void)viewControllerWillLoad
{
    [super viewControllerWillLoad];
    
    self.originImage = [self.originImage fixOrientation];
    
    _containerView = [UIScrollView object];
    [_containerView setShowsHorizontalScrollIndicator:NO];
    [_containerView setShowsVerticalScrollIndicator:NO];
    [_containerView setAlwaysBounceHorizontal:YES];
    [_containerView setAlwaysBounceVertical:YES];
    [_containerView setMultipleTouchEnabled:YES];
    [_containerView setMinimumZoomScale:1.f];
    [_containerView setMaximumZoomScale:3.f];
    [_containerView setClipsToBounds:NO];
    [_containerView setDelegate:self];
    [self.view addSubview:_containerView];
    
    _originaImageView = [UIImageView object];
    [_originaImageView setImage:self.originImage];
    [_originaImageView setContentMode:UIViewContentModeScaleAspectFit];
    [_containerView addSubview:_originaImageView];
    
    _actionPanel = [UIView object];
    [_actionPanel setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:_actionPanel];
    
    _retakeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_retakeBtn setTitle:[PYImagePickerApperance sharedApperance].retakeTitle
                forState:UIControlStateNormal];
    [_retakeBtn setTitleColor:[UIColor whiteColor]
                     forState:UIControlStateNormal];
    [_retakeBtn setTitleColor:[UIColor colorWithString:@"#909192"]
                     forState:UIControlStateHighlighted];
    [_retakeBtn.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
    [_retakeBtn addTarget:self action:@selector(_actionRetake:)
         forControlEvents:UIControlEventTouchUpInside];
    [_actionPanel addSubview:_retakeBtn];
    
    _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_confirmBtn setTitle:[PYImagePickerApperance sharedApperance].confirmTitle
                 forState:UIControlStateNormal];
    [_confirmBtn setTitleColor:[UIColor whiteColor]
                      forState:UIControlStateNormal];
    [_confirmBtn setTitleColor:[UIColor colorWithString:@"#909192"]
                      forState:UIControlStateHighlighted];
    [_confirmBtn.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
    [_confirmBtn addTarget:self action:@selector(_actionConfirmSelection:)
          forControlEvents:UIControlEventTouchUpInside];
    [_actionPanel addSubview:_confirmBtn];
    
    UIView * __strong *_maskView[2] = { &_topMask, &_bottomMask };
    for ( int i = 0; i < 2; ++i ) {
        (*_maskView[i]) = [UIView object];
        [(*_maskView[i]) setBackgroundColor:[UIColor blackColor]];
        [(*_maskView[i]) setAlpha:.5];
        [self.view addSubview:(*_maskView[i])];
    }
    _staticMask = [UIView object];
    [_staticMask setBorderColor:[UIColor whiteColor]];
    [_staticMask setBorderWidth:1.f];
    [_staticMask setBackgroundColor:[UIColor clearColor]];
    [_staticMask setUserInteractionEnabled:NO];
    [self.view addSubview:_staticMask];
}

- (void)layoutSubviewsInRect:(CGRect)visiableRect
{
    CGFloat _actionPanelHeight = 88.f;
    CGRect _actionPanelFrame = CGRectMake(0, visiableRect.size.height - _actionPanelHeight,
                                          visiableRect.size.width, _actionPanelHeight);
    [_actionPanel setFrame:_actionPanelFrame];
    CGFloat _btnHeight = 44.f;
    CGFloat _btnWidth = 64.f;
    [_retakeBtn setFrame:CGRectMake(15, (_actionPanelHeight - _btnHeight) / 2,
                                    _btnWidth, _btnHeight)];
    [_confirmBtn setFrame:CGRectMake(visiableRect.size.width - _btnWidth - 15,
                                     (_actionPanelHeight - _btnHeight) / 2,
                                     _btnWidth, _btnHeight)];
    
    CGRect _contentRect = visiableRect;
    _contentRect.size.height -= _actionPanelHeight;
    
    CGFloat _staticWidth = visiableRect.size.width;
    CGFloat _maskHeigth = (_contentRect.size.height - _staticWidth) / 2;
    
    CGRect _tFrame = CGRectMake(0, 0, _staticWidth, _maskHeigth);
    [_topMask setFrame:_tFrame];
    
    CGRect _sFrame = CGRectMake(0, _maskHeigth, _staticWidth, _staticWidth);
    [_staticMask setFrame:_sFrame];
    
    CGRect _bFrame = CGRectMake(0, _maskHeigth + _staticWidth, _staticWidth, _maskHeigth);
    [_bottomMask setFrame:_bFrame];
    
    // Get the image size
    CGSize _imageSize = self.originImage.size;
    [_containerView setFrame:_sFrame];
    [_containerView setContentSize:_imageSize];
    
    CGRect _cBounds = _containerView.bounds;
    CGRect _imageFrame = CGRectMake((_cBounds.size.width - _imageSize.width) / 2,
                                    (_cBounds.size.height - _imageSize.height) / 2,
                                    _imageSize.width,
                                    _imageSize.height);
    [_originaImageView setFrame:CGRectMake(0, 0, _imageSize.width, _imageSize.height)];
    [_containerView scrollRectToVisible:_imageFrame animated:NO];
    
    CGFloat _minSide = MIN(_imageSize.width, _imageSize.height);
    CGFloat _minZoom = _staticWidth / _minSide;
    [_containerView setMinimumZoomScale:_minZoom];
    [_containerView setMaximumZoomScale:(_minZoom * 3)];
    [_containerView setZoomScale:_minZoom animated:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_containerView setContentInset:UIEdgeInsetsZero];
}

- (void)_actionConfirmSelection:(id)sender
{
    // Crop the image and send notification, then dismiss self
    
    // Calculate the image crop rect
    CGRect _cropRect = _staticMask.bounds;
    CGFloat _zoomScale = _containerView.zoomScale;
    _cropRect.size.width = _cropRect.size.width / _zoomScale;
    _cropRect.size.height = _cropRect.size.width;
    _cropRect.origin.x = _containerView.contentOffset.x / _zoomScale;
    _cropRect.origin.y = _containerView.contentOffset.y / _zoomScale;
    UIImage *_cropImage = [self.originImage cropInRect:_cropRect];
    _cropImage = [_cropImage scaledToSize:CGSizeMake(1024, 1024)];
    // Post the notification
    if ( self.selectedImageEvent ) self.selectedImageEvent(_cropImage);
    // Dismiss the view
    [[PYApperance sharedApperance] dismissLastPoppedViewController];
}

- (void)_actionRetake:(id)sender
{
    // Go back
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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
