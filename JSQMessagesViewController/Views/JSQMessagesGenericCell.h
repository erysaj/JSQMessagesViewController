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

#import "JSQMessagesLabel.h"
#import "JSQMessagesBubbleMessageView.h"


/**
 *  A `JSQMessagesCollectionViewLayoutAttributes` is an object that stores internal metrics
 *  of a given `JSQMessagesCollectionViewCell`.
 */
@interface JSQMessagesGenericCellMetrics : NSObject

/**
 *  The height of the `cellTopLabel` of a `JSQMessagesCollectionViewCell`.
 *  This value should be greater than or equal to `0.0`.
 *
 *  @see `JSQMessagesCollectionViewCell`.
 */
@property (assign, nonatomic) CGFloat cellTopLabelHeight;

/**
 *  The height of the `messageBubbleTopLabel` of a `JSQMessagesCollectionViewCell`.
 *  This value should be greater than or equal to `0.0`.
 *
 *  @see `JSQMessagesCollectionViewCell`.
 */
@property (assign, nonatomic) CGFloat messageTopLabelHeight;

/**
 *  The height of the `cellBottomLabel` of a `JSQMessagesCollectionViewCell`.
 *  This value should be greater than or equal to `0.0`.
 *
 *  @see `JSQMessagesCollectionViewCell`.
 */
@property (assign, nonatomic) CGFloat cellBottomLabelHeight;


@property (strong, nonatomic) id messageMetrics;

@end


@class JSQMessagesGenericCell;

/**
 *  The `JSQMessagesCollectionViewCellDelegate` protocol defines methods that allow you to manage
 *  additional interactions within the collection view cell.
 */
@protocol JSQMessagesCollectionViewCellDelegate <NSObject>

@required

/**
 *  Tells the delegate that the avatarImageView of a cell has been tapped.
 *
 *  @param cell The cell that received the tap.
 */
- (void)messagesCollectionViewCellDidTapAvatar:(JSQMessagesGenericCell *)cell;

@end


/**
 *  The `JSQMessagesCollectionViewCell` is an abstract class that presents the content for a single message data item
 *  when that item is within the collection view’s visible bounds. The layout and presentation 
 *  of cells is managed by the collection view and its corresponding layout object.
 *
 *  @warning This class is intended to be subclassed. You should not use it directly.
 */
@interface JSQMessagesGenericCell : UICollectionViewCell

/**
 *  The object that acts as the delegate for the cell.
 */
@property (weak, nonatomic) id<JSQMessagesCollectionViewCellDelegate> delegate;

/**
 *  Returns the label that is pinned to the top of the cell.
 *  This label is most commonly used to display message timestamps.
 */
@property (strong, nonatomic) JSQMessagesLabel *cellTopLabel;

/**
 *  Returns the label that is pinned just above the messageView, and below the cellTopLabel.
 *  This label is most commonly used to display the message sender.
 */
@property (strong, nonatomic) JSQMessagesLabel *messageTopLabel;

/**
 *  Returns the view that displays message's content and sender's avatar
 */
@property (strong, nonatomic) JSQMessagesBubbleContainer *messageView;

/**
 *  Returns the label that is pinned to the bottom of the cell.
 *  This label is most commonly used to display message delivery status.
 */
@property (strong, nonatomic) JSQMessagesLabel *cellBottomLabel;


/**
 *  Returns the underlying gesture recognizer for tap gestures in the avatarImageView of the cell.
 *  This gesture handles the tap event for the avatarImageView and notifies the cell's delegate.
 */
@property (weak, nonatomic, readonly) UITapGestureRecognizer *tapGestureRecognizer;



/**
 *  TODO: document this
 *
 */
+ (CGSize)sizeWithContentSize:(CGSize)contentSize
                      metrics:(id)metrics;

+ (CGSize)contentSizeConstraintForSizeConstraint:(CGSize)constraint
                                     withMetrics:(id)metrics;


- (void)applyMetrics:(id)metrics contentSize:(CGSize)contentSize cellSizeConstraint:(CGSize)constraint;
- (void)applyStyle:(id)style;

@end
