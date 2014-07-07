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

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, JSQMessagesBubbleBgMode) {
    JSQMessagesBubbleBgModeNone = 0,
    JSQMessagesBubbleBgModeImage,
    JSQMessagesBubbleBgModeMask,
};


@interface JSQMessagesBubbleView : UIView

@property (assign, nonatomic, readonly) JSQMessagesBubbleBgMode mode;
@property (assign, nonatomic, getter = isFlipped) BOOL flipped;
@property (assign, nonatomic, getter = isHighlighted) BOOL highlighted;

- (void)setBubbleImage:(UIImage *)image
      highlightedImage:(UIImage *)highlightedImage;

- (void)setMask:(UIImage *)mask
      capInsets:(UIEdgeInsets)capInsets
    bubbleColor:(UIColor *)color
highligtedColor:(UIColor *)highlightedColor;

@end
