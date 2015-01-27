//
//  PYImageView.m
//  PYUIKit
//
//  Created by Push Chen on 7/29/13.
//  Copyright (c) 2013 Push Lab. All rights reserved.
//

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

#import "PYImageView.h"
#import "PYImageLayer.h"
#import "PYImageCache.h"

@implementation PYImageView

@synthesize blurRadius = _blurRadius;
- (void)setBlurRadius:(CGFloat)blurRadius
{
    [self willChangeValueForKey:@"blurRadius"];
    _blurRadius = blurRadius;
    UIImage *_blurImage = PYUIBlurImage(_originImage, _blurRadius);
    [super setImage:_blurImage];
    [self didChangeValueForKey:@"blurRadius"];
}

@synthesize originImage = _originImage;

- (void)viewJustBeenCreated
{
    // Default message
    _mutex = [PYMutex object];
}

- (PYImageView *)initWithPlaceholdImage:(UIImage *)image
{
    self = [super init];
    if ( self ) {
        if ( _hasInvokeInit == NO ) {
            [self viewJustBeenCreated];
        }
        _hasInvokeInit = YES;
        _placeholdImage = image;
        self.image = image;
    }
    return self;
}

- (id)init
{
    self = [super init];
    if ( self ) {
        if ( _hasInvokeInit == NO ) {
            [self viewJustBeenCreated];
        }
        _hasInvokeInit = YES;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if ( self ) {
        if ( _hasInvokeInit == NO ) {
            [self viewJustBeenCreated];
        }
        _hasInvokeInit = YES;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self ) {
        if ( _hasInvokeInit == NO ) {
            [self viewJustBeenCreated];
        }
        _hasInvokeInit = YES;
    }
    return self;
}

- (void)dealloc
{
    if ( [PYLayer isDebugEnabled] ) {
        __formatLogLine(__FILE__, __FUNCTION__, __LINE__,
                        [NSString stringWithFormat:@"***[%@:%p] Dealloced [Layer: %p]***",
                         NSStringFromClass([self class]), self, self.layer]);
    }
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

// Add sub layer or sub view.
- (void)addChild:(id)child
{
    if ( [child isKindOfClass:[CALayer class]] ) {
        [self.layer addSublayer:child];
    } else if ( [child isKindOfClass:[UIView class]] ) {
        [self addSubview:child];
    }
}

// Inner Shadow
@dynamic innerShadowRect;
- (PYPadding)innerShadowRect
{
    if ( _shadowLayer == nil ) return PYPaddingZero;
    return _shadowLayer.shadowPadding;
}
- (void)setInnerShadowRect:(PYPadding)innerShadowRect
{
    if ( _shadowLayer == nil ) {
        _shadowLayer = [PYInnerShadowLayer layer];
        _shadowLayer.zPosition = MAXFLOAT;
        [_shadowLayer setFrame:self.bounds];
        [self.layer addSublayer:_shadowLayer];
    }
    [_shadowLayer setShadowPadding:innerShadowRect];
    [_shadowLayer setNeedsDisplay];
}

@dynamic innerShadowColor;
- (UIColor *)innerShadowColor
{
    if ( _shadowLayer == nil ) return [UIColor clearColor];
    return _shadowLayer.innerShadowColor;
}
- (void)setInnerShadowColor:(UIColor *)aColor
{
    if ( _shadowLayer == nil ) {
        _shadowLayer = [PYInnerShadowLayer layer];
        _shadowLayer.zPosition = MAXFLOAT;
        [_shadowLayer setFrame:self.bounds];
        [self.layer addSublayer:_shadowLayer];
    }
    [_shadowLayer setInnerShadowColor:aColor];
    [_shadowLayer setNeedsDisplay];
}

// Override
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if ( _shadowLayer == nil ) return;
    [_shadowLayer setFrame:self.bounds];
    [_shadowLayer setNeedsDisplay];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if ( newSuperview == nil ) {
        if ( _shadowLayer != nil ) {
            [_shadowLayer removeFromSuperlayer];
            _shadowLayer = nil;
        }
    } else {
        if ( _shadowLayer != nil ) {
            //[_shadowLayer setFrame:self.bounds];
            [_shadowLayer setNeedsDisplay];
        }
    }
}

+ (PYImageView *)viewWithPlaceholdImage:(UIImage *)image
{
    return [[PYImageView alloc] initWithPlaceholdImage:image];
}

@synthesize placeholdImage = _placeholdImage;
- (void)setPlaceholdImage:(UIImage *)placehold
{
    _placeholdImage = placehold;
    if ( self.image == nil ) {
        self.image = placehold;
    }
}
@synthesize loadingUrl = _loadingUrl;

- (void)setImage:(UIImage *)image
{
    _originImage = image;
    if ( image == nil ) {
        _originImage = _placeholdImage;
    }
    UIImage *_blurImage = PYUIBlurImage(_originImage, _blurRadius);
    [super setImage:_blurImage];
}

- (void)setImageUrl:(NSString *)imageUrl
{
    [self setImageUrl:imageUrl done:nil failed:nil];
}

- (void)setImageUrl:(NSString *)imageUrl done:(PYActionDone)done failed:(PYActionFailed)failed
{
    if ( [imageUrl length] == 0 ) {
        // Clean self's status
        _loadingUrl = @"";
        self.image = _placeholdImage;
        return;
    }
    
    [_mutex lockAndDo:^id{
        // Check if is loading the image.
        if ( [_loadingUrl length] > 0 && [_loadingUrl isEqualToString:imageUrl] ) {
            return nil;
        }
        
        [super setImage:nil];
        
        _loadingUrl = [imageUrl copy];
        // Fetch the cache.
        UIImage *_image = [SHARED_IMAGECACHE imageByName:_loadingUrl];
        if ( _image != nil ) {
            [self setImage:_image];
            if ( done ) done();
            return nil;
        }
        
        __weak PYImageView *_wss = self;
        [SHARED_IMAGECACHE
         loadImageNamed:_loadingUrl
         get:^(UIImage *loadedImage, NSString *imageName){
             // Did loaded the image...
             if ( ![imageName isEqualToString:_wss.loadingUrl] ) {
                 if ( failed )
                     failed( [self errorWithCode:10002 message:@"image loading has been cancelled"]);
             };
             [_wss setImage:loadedImage];
             if ( done ) done();
         } failed:^(NSError *error) {
             if ( failed ) failed( error );
         }];
        return nil;
    }];
}

- (void)refreshContent
{
    [self setNeedsDisplay];
}

@end

// @littlepush
// littlepush@gmail.com
// PYLab
