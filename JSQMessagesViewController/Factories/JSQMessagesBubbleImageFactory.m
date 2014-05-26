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

+ (UIImageView *)outgoingMessageBubbleImageViewWithImage:(UIImage *)image imageOrientation:(JSImageOrientation)imageOrientation
{
    NSAssert(image, @"ERROR: image must not be nil: %s", __PRETTY_FUNCTION__);
    return [JSQMessagesBubbleImageFactory maskedBubbleImageViewFromImage:image flippedForIncoming:NO imageOrientation:imageOrientation];
}

+ (UIImageView *)incomingMessageBubbleImageViewWithImage:(UIImage *)image imageOrientation:(JSImageOrientation)imageOrientation
{
    NSAssert(image, @"ERROR: image must not be nil: %s", __PRETTY_FUNCTION__);
    return [JSQMessagesBubbleImageFactory maskedBubbleImageViewFromImage:image flippedForIncoming:YES imageOrientation:imageOrientation];
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

+ (UIImageView *)maskedBubbleImageViewFromImage:(UIImage *)image flippedForIncoming:(BOOL)flippedForIncoming imageOrientation:(JSImageOrientation)imageOrientation
{
    CGSize sizeForOrientation = [self neededSizeForImageOrientation:imageOrientation];

    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0, 0, sizeForOrientation.width, sizeForOrientation.height);
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [JSQMessagesBubbleImageFactory addGradientToImageView:imageView];
    
    UIEdgeInsets capInsets = UIEdgeInsetsMake(28, 10, 10, 20);
    NSString *bubbleImageName = @"bubble_min_triangle_tail";
    
    if (flippedForIncoming)
    {
        bubbleImageName = @"bubble_min_triangle_tail_flipped";
        capInsets = UIEdgeInsetsMake(28, 20, 10, 10);
    }
    
    UIImage *bubble = [JSQMessagesBubbleImageFactory jsq_stretchableImageFromImage:[UIImage imageNamed:bubbleImageName] withCapInsets:capInsets];
    
    CALayer *mask = [CALayer layer];
    mask.contents = (id)[bubble CGImage];
    mask.contentsScale = [UIScreen mainScreen].scale;
    
    mask.contentsCenter =
    CGRectMake(capInsets.left/bubble.size.width,
               capInsets.top/bubble.size.height,
               1.0/bubble.size.width,
               1.0/bubble.size.height);
    
    mask.frame = imageView.layer.bounds;
    imageView.layer.mask = mask;
    imageView.layer.masksToBounds = YES;
    
    return imageView;
}

+ (void)addGradientToImageView:(UIImageView *)imageView
{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    CGFloat gradientHeight = 30;
    gradient.frame = CGRectMake(0, CGRectGetHeight(imageView.frame) - gradientHeight, CGRectGetWidth(imageView.frame), gradientHeight);
    
    // Add colors to layer
    UIColor *startColor = [UIColor colorWithWhite:0 alpha:0];
    UIColor *endColor = [UIColor colorWithWhite:0 alpha:0.7];
    gradient.colors = [NSArray arrayWithObjects:
                       (id)[startColor CGColor],
                       (id)[endColor CGColor],
                       nil];
    
    [imageView.layer insertSublayer:gradient atIndex:0];
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
