//
//  PYImageView.h
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

//#import "PYResponderView.h"
#import <PYCore/PYCore.h>
#import <PYControllers/PYControllers.h>

@interface PYImageView : UIImageView
{
    PYInnerShadowLayer              *_shadowLayer;
    BOOL                            _hasInvokeInit;
    UIImage                         *_originImage;
    UIImage                         *_placeholdImage;
    NSString                        *_loadingUrl;
    PYMutex                         *_mutex;
    
    // Blur
    CGFloat                         _blurRadius;
}

//@property (nonatomic, readonly) PYImageLayer        *layer;
@property (nonatomic, assign)   PYPadding           innerShadowRect;
@property (nonatomic, strong)   UIColor             *innerShadowColor;

// create the layer with the placehold image.
- (PYImageView *)initWithPlaceholdImage:(UIImage *)image;
+ (PYImageView *)viewWithPlaceholdImage:(UIImage *)image;

// Placehold image.
@property (nonatomic, strong)   UIImage             *placeholdImage;

// Loading URL
@property (nonatomic, readonly) NSString            *loadingUrl;

// Set the image's blur radius
@property (nonatomic, assign)   CGFloat             blurRadius;

// Get the origin image without blur
@property (nonatomic, readonly) UIImage             *originImage;

// Start to load the image from the URL
- (void)setImageUrl:(NSString *)imageUrl;
- (void)setImageUrl:(NSString *)imageUrl done:(PYActionDone)done failed:(PYActionFailed)failed;

// Refresh the content after reset the frame.
- (void)refreshContent;

@end

// @littlepush
// littlepush@gmail.com
// PYLab
