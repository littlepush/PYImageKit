//
//  PYImageLayer.h
//  PYUIKit
//
//  Created by Push Chen on 7/29/13.
//  Copyright (c) 2013 Push Lab. All rights reserved.
//

/*
 LGPL V3 Lisence
 This file is part of cleandns.
 
 PYImageKit is free software: you can redistribute it and/or modify
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

#import "PYStaticLayer.h"
#import <QuartzCore/QuartzCore.h>
#import <PYCore/PYCore.h>
#import <UIKit/UIKit.h>

// Create a blur image with specified radius
#ifdef __cplusplus
extern "C" {
#endif
    UIImage *PYUIBlurImage(UIImage *inputImage, CGFloat radius);
#ifdef __cplusplus
}
#endif

@interface PYImageLayer : PYStaticLayer
{
    // Inner Image Data
    UIImage                         *_image;
    UIImage                         *_placeholdImage;
    UIImage                         *_aspectImage;
    CGFloat                         _frameRate;
    NSString                        *_loadingUrl;
    PYMutex                         *_mutex;
    
    // Blur
    CGFloat                         _blurRadius;
}

// create the layer with the placehold image.
- (PYImageLayer *)initWithPlaceholdImage:(UIImage *)image;
+ (PYImageLayer *)layerWithPlaceholdImage:(UIImage *)image;

// The image to draw on the layer
@property (nonatomic, strong)	UIImage             *image;

// Placehold image.
@property (nonatomic, strong)   UIImage             *placeholdImage;

// Loading URL
@property (nonatomic, readonly) NSString            *loadingUrl;

// The content mode.
@property (nonatomic, assign)   UIViewContentMode   contentMode;

// Set the image's blur radius
@property (nonatomic, assign)   CGFloat             blurRadius;

// Start to load the image from the URL
- (void)setImageUrl:(NSString *)imageUrl;
- (void)setImageUrl:(NSString *)imageUrl done:(PYActionDone)done failed:(PYActionFailed)failed;

// force to update content image, without re-draw, just set the content.
- (void)forceUpdateContentWithImage:(UIImage *)image;

// Refresh the content after reset the frame.
- (void)refreshContent;

@end

// @littlepush
// littlepush@gmail.com
// PYLab
