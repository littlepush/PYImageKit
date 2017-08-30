//
//  PYImagePickerApperance.m
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

#import "PYImagePickerApperance.h"
#import "PYImagePickerViewController.h"
#import "PYImageCropViewController.h"
#import <PYCore/PYCore.h>

NSString *const PY_IPCameraIcon = @"data:image/png;base64,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";
NSString *const kPYIPStringTitle = @"kPYIPStringTitle";
NSString *const kPYIPStringRetake = @"kPYIPStringRetake";
NSString *const kPYIPStringConfirm = @"kPYIPStringConfirm";

@interface PYImagePickerApperance()
{
    UIImage             *_cameraIcon;
    BOOL                _needCrop;
}
@end


// Singleton
static PYImagePickerApperance *_gPYIPapperance = nil;

@implementation PYImagePickerApperance

PYSingletonAllocWithZone(_gPYIPapperance);
PYSingletonDefaultImplementation

+ (instancetype)sharedApperance
{
    PYSingletonLock
    if ( _gPYIPapperance == nil ) {
        _gPYIPapperance = [PYImagePickerApperance object];
    }
    PYSingletonUnLock
    return _gPYIPapperance;
}

@dynamic title;
- (NSString *)title { return [PYLocalizedString stringForKey:kPYIPStringTitle]; }
- (void)setTitle:(NSString *)title
{
    [PYLocalizedString
     addStrings:@{[PYLocalizedString defaultLanguage]:title}
     forKey:kPYIPStringTitle];
}

@dynamic retakeTitle;
- (NSString *)retakeTitle { return [PYLocalizedString stringForKey:kPYIPStringRetake]; }
- (void)setRetakeTitle:(NSString *)retakeTitle
{
    [PYLocalizedString
     addStrings:@{[PYLocalizedString defaultLanguage]:retakeTitle}
     forKey:kPYIPStringRetake];
}

@dynamic confirmTitle;
- (NSString *)confirmTitle { return [PYLocalizedString stringForKey:kPYIPStringConfirm]; }
- (void)setConfirmTitle:(NSString *)confirmTitle
{
    [PYLocalizedString
     addStrings:@{[PYLocalizedString defaultLanguage]:confirmTitle}
     forKey:kPYIPStringConfirm];
}

@synthesize needCrop = _needCrop;

@synthesize cameraIcon = _cameraIcon;

- (id)init
{
    self = [super init];
    if ( self ) {
        [PYLocalizedString
         addStrings:@{PYLanguageChineseSimplified:@"选择照片",
                      PYLanguageChineseTraditional:@"選擇照片",
                      PYLanguageEnglish:@"Choose Photo"}
         forKey:kPYIPStringTitle];
        [PYLocalizedString
         addStrings:@{PYLanguageChineseSimplified:@"重拍",
                      PYLanguageChineseTraditional:@"重拍",
                      PYLanguageEnglish:@"Retake"}
         forKey:kPYIPStringRetake];
        [PYLocalizedString
         addStrings:@{PYLanguageChineseSimplified:@"确定",
                      PYLanguageChineseTraditional:@"確定",
                      PYLanguageEnglish:@"Confirm"}
         forKey:kPYIPStringConfirm];
        _cameraIcon = [UIImage imageWithData:
                       [NSData dataWithContentsOfURL:
                        [NSURL URLWithString:PY_IPCameraIcon]]];
        _needCrop = YES;
    }
    return self;
}


+ (void)show:(PYImagePickerSelectedImage)onSelected
{
    PYImagePickerViewController *_ipvc = [PYImagePickerViewController object];
    _ipvc.selectedImageEvent = [onSelected copy];
    [[PYApperance sharedApperance]
     presentPopViewController:_ipvc
     animation:kPopUpAnimationTypeSlideFromBottom];
}

+ (void)show:(PYImagePickerSelectedImage)onSelected orVideo:(PYImagePickerRecordedVideo)onRecorded
{
    PYImagePickerViewController *_ipvc = [PYImagePickerViewController object];
    _ipvc.selectedImageEvent = [onSelected copy];
    _ipvc.recordedVideoEvent = [onRecorded copy];
    [[PYApperance sharedApperance]
     presentPopViewController:_ipvc
     animation:kPopUpAnimationTypeSlideFromBottom];
}

@end

// @littlepush
// littlepush@gmail.com
// PYLab
