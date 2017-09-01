//
//  PYImagePickerApperance.h
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^PYImagePickerSelectedImage)(UIImage *image);
typedef void (^PYImagePickerRecordedVideo)(NSString *videoPath);

@interface PYImagePickerApperance : NSObject

/*
 The singleton apperance object
 */
+ (instancetype)sharedApperance;

/*
 Image Picker View Controller's title
 */
@property (nonatomic, copy)     NSString        *title;

/*
 The image of the camera button
 */
@property (nonatomic, strong)   UIImage         *cameraIcon;

/*
 Retake Text
 */
@property (nonatomic, copy)     NSString        *retakeTitle;

/*
 Confirm Text
 */
@property (nonatomic, copy)     NSString        *confirmTitle;

/*
 Need Crop Image, default is YES
 */
@property (nonatomic, assign)   BOOL            needCrop;

/*
 Display the image picker view
 */
+ (void)show:(PYImagePickerSelectedImage)onSelected;
+ (void)show:(PYImagePickerSelectedImage)onSelected orVideo:(PYImagePickerRecordedVideo)onRecorded;

@end

// @littlepush
// littlepush@gmail.com
// PYLab
