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

#import "JSQMessagesBubbleView.h"

#import "UIView+JSQMessages.h"


@interface JSQMessagesBubbleView ()

@property (assign, nonatomic) JSQMessagesBubbleBgMode mode;

@property (strong, nonatomic) UIImage *bubbleMask;
@property (assign, nonatomic) UIEdgeInsets capInsets;
@property (strong, nonatomic) CALayer *maskLayer;
@property (strong, nonatomic) UIColor *bubbleColor;
@property (strong, nonatomic) UIColor *highlightedBubbleColor;

@property (strong, nonatomic) UIImageView *bubbleImageView;


@end


@implementation JSQMessagesBubbleView

- (void)setBubbleImage:(UIImage *)image
      highlightedImage:(UIImage *)highlightedImage;
{
    self.mode = JSQMessagesBubbleBgModeImage;
    _bubbleImageView.image = image;
    _bubbleImageView.highlightedImage = highlightedImage;
    
    [self updateTransform];
}

- (void)setMask:(UIImage *)mask
      capInsets:(UIEdgeInsets)capInsets
    bubbleColor:(UIColor *)color
highligtedColor:(UIColor *)highlightedColor
{
    self.bubbleColor = color;
    self.highlightedBubbleColor = highlightedColor;
    
    if (_bubbleMask == mask && UIEdgeInsetsEqualToEdgeInsets(_capInsets, capInsets)) {
        [self updateColor];
        return;
    }
    
    if (!mask) {
        self.mode = JSQMessagesBubbleBgModeNone;
        return;
    }
    
    self.mode = JSQMessagesBubbleBgModeMask;
    _bubbleMask = mask;
    _capInsets = capInsets;
    
    _maskLayer.contents = (__bridge id)[mask CGImage];
    
    CGSize maskImageSize = mask.size;
    _maskLayer.contentsCenter = CGRectMake(
        capInsets.left / maskImageSize.width,
        capInsets.top / maskImageSize.height,
        1.0f - (capInsets.left + capInsets.right) / maskImageSize.width,
        1.0f - (capInsets.top + capInsets.bottom) / maskImageSize.height
    );
    
    [self updateMask];
    [self updateTransform];
    [self updateColor];
}

- (void)setFlipped:(BOOL)flipped
{
    if (_flipped == flipped) {
        return;
    }
    
    _flipped = flipped;
    [self updateTransform];
}

- (void)setHighlighted:(BOOL)highlighted
{
    if (_highlighted == highlighted) {
        return;
    }
    _highlighted = highlighted;
    
    switch (_mode) {
        case JSQMessagesBubbleBgModeImage:
            _bubbleImageView.highlighted = highlighted;
            break;
            
        case JSQMessagesBubbleBgModeMask:
            [self updateColor];
            break;
            
        case JSQMessagesBubbleBgModeNone:
            break;
    }
}

- (void)setMode:(JSQMessagesBubbleBgMode)mode
{
    if (_mode == mode) {
        return;
    }
    
    switch (_mode) {
        case JSQMessagesBubbleBgModeImage:
            [_bubbleImageView removeFromSuperview];
            _bubbleImageView = nil;
            break;
            
        case JSQMessagesBubbleBgModeMask:
            self.layer.mask = nil;
            self.layer.masksToBounds = NO;
            _maskLayer = nil;
            _bubbleMask = nil;
            break;
            
        case JSQMessagesBubbleBgModeNone:
            break;
    }
    
    _mode = mode;
    
    switch (_mode) {
        case JSQMessagesBubbleBgModeImage:
            _bubbleImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
            _bubbleImageView.translatesAutoresizingMaskIntoConstraints = NO;
            [self addSubview:_bubbleImageView];
            [self sendSubviewToBack:_bubbleImageView];
            [self jsq_pinAllEdgesOfSubview:_bubbleImageView];
            break;
            
        case JSQMessagesBubbleBgModeMask:
            _maskLayer = [CALayer layer];
            _maskLayer.contentsScale = [UIScreen mainScreen].scale;
            self.layer.mask = _maskLayer;
            self.layer.masksToBounds = YES;
            break;
            
        case JSQMessagesBubbleBgModeNone:
            break;
    }
}

#pragma mark - UIView overrides

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self updateMask];
}

#pragma mark - Helpers

- (void)updateTransform
{
    CALayer *layer = nil;
    switch (_mode) {
        case JSQMessagesBubbleBgModeMask:
            layer = _maskLayer;
            break;
            
        case JSQMessagesBubbleBgModeImage:
            layer = _bubbleImageView.layer;
            break;
            
        case JSQMessagesBubbleBgModeNone:
            break;
    }
    
    layer.transform = _flipped? CATransform3DMakeScale(-1, 1, 1): CATransform3DIdentity;
}

- (void)updateMask
{
    _maskLayer.frame = [self bounds];
}

- (void)updateColor
{
    switch (_mode) {
        case JSQMessagesBubbleBgModeImage:
            break;
            
        case JSQMessagesBubbleBgModeMask:
            self.backgroundColor = _highlighted? self.highlightedBubbleColor: self.bubbleColor;
            break;
            
        case JSQMessagesBubbleBgModeNone:
            break;
    }
}
@end
