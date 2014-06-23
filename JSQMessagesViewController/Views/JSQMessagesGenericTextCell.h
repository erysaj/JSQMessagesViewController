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

#import "JSQMessagesGenericCell.h"


@interface JSQMessagesGenericTextCellMetrics : JSQMessagesGenericCellMetrics

@property (assign, nonatomic) UIEdgeInsets textContainerInsets;

@end


@interface JSQMessagesGenericTextCellAttributes : NSObject

@property (strong, nonatomic) UIColor *textColor;
@property (strong, nonatomic) UIFont *textFont;

@end


@interface JSQMessagesGenericTextCell : JSQMessagesGenericCell

/**
 *  Returns the text view of the cell. This text view contains the message body text.
 */
@property (strong, nonatomic) UITextView *textView;

/**
 *  Returns the underlying gesture recognizer for long press gestures in the cell.
 *  This gesture handles the copy action for the cell.
 *  Access this property when you need to override or more precisely control the long press gesture.
 */
@property (weak, nonatomic, readonly) UILongPressGestureRecognizer *longPressGestureRecognizer;

- (void)setTextContainerInsets:(UIEdgeInsets)insets;

+ (CGSize)contentSizeForText:(NSString *)text
                     metrics:(id)metrics
                       style:(id)style
              sizeConstraint:(CGSize)sizeConstraint;

@end
