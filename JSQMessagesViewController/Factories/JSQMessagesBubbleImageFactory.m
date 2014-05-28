//
//  Created by Jesse Squires
//  http://www.hexedbits.com
//
//
//  Documentation
//  http://cocoadocs.org/docsets/JSQMessagesViewController
//
//
//  GitHub
//  https://github.com/jessesquires/JSQMessagesViewController
//
//
//  License
//  Copyright (c) 2014 Jesse Squires
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

#import "JSQMessagesBubbleImageFactory.h"
#import "JSQMessages.h"
#import "UIImage+JSQMessages.h"
#import "UIColor+JSQMessages.h"


@interface JSQMessagesBubbleImageFactory ()

+ (UIImageView *)bubbleImageViewWithColor:(UIColor *)color flippedForIncoming:(BOOL)flippedForIncoming;

+ (UIImage *)jsq_horizontallyFlippedImageFromImage:(UIImage *)image;

+ (UIImage *)jsq_stretchableImageFromImage:(UIImage *)image withCapInsets:(UIEdgeInsets)capInsets;

@end



@implementation JSQMessagesBubbleImageFactory

#pragma mark - Public

+ (UIImageView *)outgoingMessageBubbleImageViewWithColor:(UIColor *)color
{
    NSAssert(color, @"ERROR: color must not be nil: %s", __PRETTY_FUNCTION__);
    return [JSQMessagesBubbleImageFactory bubbleImageViewWithColor:color flippedForIncoming:NO];
}

+ (UIImageView *)incomingMessageBubbleImageViewWithColor:(UIColor *)color
{
    NSAssert(color, @"ERROR: color must not be nil: %s", __PRETTY_FUNCTION__);
    return [JSQMessagesBubbleImageFactory bubbleImageViewWithColor:color flippedForIncoming:YES];
}

#pragma mark - Private

+ (UIImageView *)bubbleImageViewWithColor:(UIColor *)color flippedForIncoming:(BOOL)flippedForIncoming
{
    UIImage *bubble = [UIImage imageNamed:@"bubble_min_triangle_tail"];
    
    UIImage *normalBubble = [bubble jsq_imageMaskedWithColor:color];
    UIImage *highlightedBubble = [bubble jsq_imageMaskedWithColor:[color jsq_colorByDarkeningColorWithValue:0.12f]];
    
    if (flippedForIncoming) {
        normalBubble = [JSQMessagesBubbleImageFactory jsq_horizontallyFlippedImageFromImage:normalBubble];
        highlightedBubble = [JSQMessagesBubbleImageFactory jsq_horizontallyFlippedImageFromImage:highlightedBubble];
    }
    
    // make image stretchable from center point
    //CGPoint center = CGPointMake(bubble.size.width / 2.0f, bubble.size.height / 2.0f);
    //UIEdgeInsets capInsets = UIEdgeInsetsMake(center.y, center.x, center.y, center.x);
    
    UIEdgeInsets capInsets = UIEdgeInsetsMake(28, 10, 10, 20);
//    if (flippedForIncoming)
//    {
//        capInsets = UIEdgeInsetsMake(28, 20, 10, 10);
//    }
    
    
    
    normalBubble = [JSQMessagesBubbleImageFactory jsq_stretchableImageFromImage:normalBubble withCapInsets:capInsets];
    highlightedBubble = [JSQMessagesBubbleImageFactory jsq_stretchableImageFromImage:highlightedBubble withCapInsets:capInsets];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:normalBubble highlightedImage:highlightedBubble];
    imageView.backgroundColor = [UIColor whiteColor];
    return imageView;
}

+ (void)prepareMaskedBubbleImageView:(UIImageView *)bubbleView withSize:(CGSize)size forIncoming:(BOOL)incoming
{
    bubbleView.contentMode = UIViewContentModeScaleAspectFill;

    CALayer *bubbleLayer = bubbleView.layer;

    // add gradient
    CAGradientLayer *gradient = [CAGradientLayer layer];
    CGFloat gradientHeight = 30;
    gradient.frame = CGRectMake(0, size.height - gradientHeight, size.width, gradientHeight);
    UIColor *startColor = [UIColor colorWithWhite:0 alpha:0];
    UIColor *endColor = [UIColor colorWithWhite:0 alpha:0.7];
    gradient.colors = [NSArray arrayWithObjects:
                       (__bridge id)[startColor CGColor],
                       (__bridge id)[endColor CGColor],
                       nil];
    
    [bubbleView.layer insertSublayer:gradient atIndex:0];
    
    // create mask
    UIImage *bubble = [UIImage imageNamed:(incoming?  @"bubble_min_triangle_tail_flipped": @"bubble_min_triangle_tail")];
    UIEdgeInsets capInsets = incoming? UIEdgeInsetsMake(28, 20, 10, 10): UIEdgeInsetsMake(28, 10, 10, 20);
    UIImage *maskImage = [bubble resizableImageWithCapInsets:capInsets];
    
    
    CALayer *mask = [CALayer layer];
    mask.contents = (id)[maskImage CGImage];
    mask.contentsScale = [UIScreen mainScreen].scale;
    
    mask.contentsCenter =
    CGRectMake(capInsets.left/maskImage.size.width,
               capInsets.top/maskImage.size.height,
               1.0/maskImage.size.width,
               1.0/maskImage.size.height);
    
    mask.frame = CGRectMake(0, 0, size.width, size.height);
    
    bubbleLayer.mask = mask;
    bubbleLayer.masksToBounds = YES;
}

+ (void)clearMaskedBubbleImageView:(UIImageView *)bubbleView
{
    CALayer *bubbleLayer = bubbleView.layer;
    CALayer *gradientLayer = [[bubbleLayer sublayers] objectAtIndex:0];
    [gradientLayer removeFromSuperlayer];
    
    bubbleLayer.mask = nil;
    bubbleLayer.masksToBounds = NO;
    
    bubbleView.contentMode = UIViewContentModeScaleToFill;
}

+ (UIImage *)jsq_horizontallyFlippedImageFromImage:(UIImage *)image
{
    return [UIImage imageWithCGImage:image.CGImage
                               scale:image.scale
                         orientation:UIImageOrientationUpMirrored];
}

+ (UIImage *)jsq_stretchableImageFromImage:(UIImage *)image withCapInsets:(UIEdgeInsets)capInsets
{
    return [image resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch];
}

+ (JSImageOrientation)imageOrientation:(UIImage *)image
{
    if (!image) {
        return JSImageOrientationNone;
    }
    if (image.size.width > image.size.height)
    {
        return JSImageOrientationLandscape;
    }
    else if (image.size.width < image.size.height)
    {
        return JSImageOrientationPortrait;
    }
    else
    {
        return JSImageOrientationSquare;
    }
}

+ (CGSize)neededSizeForImageOrientation:(JSImageOrientation)imageOrientation
{
    switch (imageOrientation) {
        case JSImageOrientationLandscape:
            return IMAGE_LANDSCAPE_SIZE;
            break;
        case JSImageOrientationPortrait:
            return IMAGE_PORTRAIT_SIZE;
            break;
        case JSImageOrientationSquare:
        case JSImageOrientationNone:
            return IMAGE_SQUARE_SIZE;
            break;
        default:
            return IMAGE_SQUARE_SIZE;
            break;
    }
}

@end
