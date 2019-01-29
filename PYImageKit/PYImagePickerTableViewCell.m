//
//  PYImagePickerTableViewCell.m
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

#import "PYImagePickerTableViewCell.h"

@interface PYImagePickerTableViewCell ()
{
    UIButton                    *_imageBtn[3];
    NSArray                     *_collections;
}

@end

@implementation PYImagePickerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self ) {
        [self setBackgroundColor:[UIColor clearColor]];
        CGFloat _sw = [UIScreen mainScreen].bounds.size.width;
        CGFloat _padding = 5;
        CGFloat _iw = (_sw - (_padding * 4)) / 3;
        for ( int i = 0; i < 3; ++i ) {
            _imageBtn[i] = [UIButton buttonWithType:UIButtonTypeCustom];
            [_imageBtn[i] setFrame:CGRectMake(_padding + i * (_iw + _padding), _padding, _iw, _iw)];
            [self addSubview:_imageBtn[i]];
            _imageBtn[i].tag = 1000 + i;
            [_imageBtn[i] addTarget:self action:@selector(_actionImageSelect:)
                   forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return self;
}

+ (NSNumber *)heightOfCellWithSpecifiedContentItem:(id)contentItem
{
    CGFloat _sw = [UIScreen mainScreen].bounds.size.width;
    CGFloat _padding = 5;
    CGFloat _iw = (_sw - (_padding * 4)) / 3;
    return @(_iw + _padding);
}

- (void)rendCellWithSpecifiedContentItem:(id)contentItem
{
    _collections = [(NSArray *)contentItem copy];
    for ( NSUInteger i = 0; i < 3; ++i ) {
        PYPair *_pair = [contentItem safeObjectAtIndex:i];
        if ( _pair == nil ) {
            [_imageBtn[i] setBackgroundImage:nil forState:UIControlStateNormal];
        } else {
            if ( _pair.firstObj != nil ) {
                [_imageBtn[i] setBackgroundImage:(UIImage *)_pair.firstObj forState:UIControlStateNormal];
            } else {
                PHAsset *_asset = (PHAsset *)_pair.secondObj;
                NSInteger _scale = [UIScreen mainScreen].scale;
                CGSize _bs = _imageBtn[i].bounds.size;
                _bs.width *= _scale;
                _bs.height *= _scale;
                
                PHImageRequestOptions *_cropOp = [[PHImageRequestOptions alloc] init];
                _cropOp.resizeMode = PHImageRequestOptionsResizeModeExact;
                
                CGFloat _cropSideLength = MIN(_asset.pixelWidth, _asset.pixelHeight);
                CGRect _square = CGRectMake(0, 0, _cropSideLength, _cropSideLength);
                CGRect _cropRect = CGRectApplyAffineTransform(_square,
                                                              CGAffineTransformMakeScale(1.0 / _asset.pixelWidth,
                                                                                         1.0 / _asset.pixelHeight));
                _cropOp.normalizedCropRect = _cropRect;
                
                [[PHImageManager defaultManager]
                 requestImageForAsset:_asset
                 targetSize:_bs
                 contentMode:PHImageContentModeAspectFit
                 options:_cropOp
                 resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                     [self->_imageBtn[i] setBackgroundImage:result forState:UIControlStateNormal];
                 }];
            }
        }
    }
}

- (void)_actionImageSelect:(UIButton *)imageButton
{
    NSInteger _index = imageButton.tag - 1000;
    if ( self.selectedBlock ) {
        PYPair *_data = [_collections safeObjectAtIndex:_index];
        if ( _data == nil ) return;
        self.selectedBlock( (PHAsset *)_data.secondObj );
    }
}

@end

// @littlepush
// littlepush@gmail.com
// PYLab
