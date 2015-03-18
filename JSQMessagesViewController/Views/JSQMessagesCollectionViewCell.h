//
//  Created by Jesse Squires
//  http://www.jessesquires.com
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

#import "JSQMessageData.h"
#import "JSQMessagesLabel.h"
#import "JSQMessagesCellTextView.h"


/**
 *  The `JSQMessagesCollectionViewCellData` protocol defines properties necessary to
 *  configure cell's displayed data (texts, images, etc.), style (fonts, colors, etc.)
 *  and layout (paddings, offsets, etc.)
 */
@protocol JSQMessagesCollectionViewCellData <NSObject>

/**
 *  Message model object to be presented by the cell
 */
- (id<JSQMessageData>)message;

/**
 *  The size of the `avatarImageView` of a `JSQMessagesCollectionViewCell`.
 *  Dimensions must be greater than or equal to `0.0`.
 *
 *  @see JSQMessagesCollectionViewCell.
 */
- (CGSize)avatarViewSize;

/**
 *  The height of the `cellTopLabel` of a `JSQMessagesCollectionViewCell`.
 *  This value should be greater than or equal to `0.0`.
 *
 *  @see JSQMessagesCollectionViewCell.
 */
- (CGFloat)cellTopLabelHeight;

/**
 *  The height of the `messageBubbleTopLabel` of a `JSQMessagesCollectionViewCell`.
 *  This value should be greater than or equal to `0.0`.
 *
 *  @see JSQMessagesCollectionViewCell.
 */
- (CGFloat)messageBubbleTopLabelHeight;

/**
 *  The height of the `cellBottomLabel` of a `JSQMessagesCollectionViewCell`.
 *  This value should be greater than or equal to `0.0`.
 *
 *  @see JSQMessagesCollectionViewCell.
 */
- (CGFloat) cellBottomLabelHeight;

/**
 *  The font used to display the body a text message in the message bubble of each
 *  `JSQMessagesCollectionViewCell` in the collectionView.
 */
- (UIFont *)messageBubbleFont;

/**
 *  The horizontal spacing used to lay out the `messageBubbleContainerView` frame within each `JSQMessagesCollectionViewCell`.
 *  This container view holds the message bubble image and message contents of a cell.
 *
 *  This value specifies the horizontal spacing between the `messageBubbleContainerView` and
 *  the edge of the collection view cell in which it is displayed. That is, the edge that is opposite the avatar image.
 *
 *  @discussion The default value is `40.0f` on iPhone and `240.0f` on iPad. This value must be positive.
 *  For *outgoing* messages, this value specifies the amount of spacing from the left most
 *  edge of the collectionView to the left most edge of a message bubble within a cell.
 *
 *  For *incoming* messages, this value specifies the amount of spacing from the right most
 *  edge of the collectionView to the right most edge of a message bubble within a cell.
 *
 *  @warning This value may not be exact when the layout object finishes laying out its items, due to the constraints it must satisfy.
 *  This value should be considered more of a recommendation or suggestion to the layout, not an exact value.
 *
 *  @see JSQMessagesCollectionViewCellIncoming.
 *  @see JSQMessagesCollectionViewCellOutgoing.
 */
- (CGFloat)messageBubbleLeftRightMargin;

/**
 *  The inset of the frame of the text view within the `messageBubbleContainerView` of each `JSQMessagesCollectionViewCell`.
 *  The inset values should be positive and are applied in the following ways:
 *
 *  1. The right value insets the text view frame on the side adjacent to the avatar image
 *      (or where the avatar would normally appear). For outgoing messages this is the right side,
 *      for incoming messages this is the left side.
 *
 *  2. The left value insets the text view frame on the side opposite the avatar image
 *      (or where the avatar would normally appear). For outgoing messages this is the left side,
 *      for incoming messages this is the right side.
 *
 *  3. The top value insets the top of the frame.
 *
 *  4. The bottom value insets the bottom of the frame.
 *
 *  @discussion The default value is `{0.0f, 0.0f, 0.0f, 6.0f}`.
 *
 *  @warning Adjusting this value is an advanced endeavour and not recommended.
 *  You will only need to adjust this value should you choose to provide your own bubble image assets.
 *  Changing this value may also require you to manually calculate the itemSize for each cell
 *  in the layout by overriding the delegate method `collectionView:layout:sizeForItemAtIndexPath:`
 */
- (UIEdgeInsets)messageBubbleTextViewFrameInsets;

/**
 *  The inset of the text container's layout area within the text view's content area in each `JSQMessagesCollectionViewCell`.
 *  The specified inset values should be positive.
 *
 *  @discussion The default value is `{7.0f, 14.0f, 7.0f, 14.0f}`.
 *
 *  @warning Adjusting this value is an advanced endeavour and not recommended.
 *  You will only need to adjust this value should you choose to provide your own bubble image assets.
 *  Changing this value may also require you to manually calculate the itemSize for each cell
 *  in the layout by overriding the delegate method `collectionView:layout:sizeForItemAtIndexPath:`
 */
- (UIEdgeInsets)messageBubbleTextViewTextContainerInsets;

@end


/**
 *  The `JSQMessagesCollectionViewCell` protocol must be implemented
 *  by `UICollectionViewCell` subclass that is intended to be used in `JSQMessagesCollectionView`.
 */
@protocol JSQMessagesCollectionViewCell <NSObject>

/**
 *  Make computations necessary to layout cell of this class for displaying provided data withing
 *  given size limitations.
 * 
 *  @param data The data to display in the cell of this class.
 *  @param constraint The maximum space that the cell is allowed to occupy. Only `width` is relevant.
 *
 *  @return An opaque data that will simplify configuring the cell and determining its real size.
 *  It is intended to be cached. Must not be `nil`.
 *  For example, cell class designed for displaying text message might return the size occupied
 *  by the message text computed for given cell width, since computing a rect occupied by text
 *  is a rather expensive operation.
 */
+ (id)computeMetricsWithData:(id<JSQMessagesCollectionViewCellData>)data
          cellSizeConstraint:(CGSize)constraint;

/**
 *  Compute size required by the cell of this class to display provided data.
 */
+ (CGSize)cellSizeWithData:(id<JSQMessagesCollectionViewCellData>)data
                   metrics:(id)metrics
        cellSizeConstraint:(CGSize)constraint;

/**
 *  Configure cell instance for displaying provided data.
 */
- (void)configureWithData:(id<JSQMessagesCollectionViewCellData>)data
                  metrics:(id)metrics
       cellSizeConstraint:(CGSize)constraint;

@end


@class JSQMessagesCollectionViewCell;

/**
 *  The `JSQMessagesCollectionViewCellDelegate` protocol defines methods that allow you to manage
 *  additional interactions within the collection view cell.
 */
@protocol JSQMessagesCollectionViewCellDelegate <NSObject>

@required

/**
 *  Tells the delegate that the avatarImageView of the cell has been tapped.
 *
 *  @param cell The cell that received the tap touch event.
 */
- (void)messagesCollectionViewCellDidTapAvatar:(JSQMessagesCollectionViewCell *)cell;

/**
 *  Tells the delegate that the message bubble of the cell has been tapped.
 *
 *  @param cell The cell that received the tap touch event.
 */
- (void)messagesCollectionViewCellDidTapMessageBubble:(JSQMessagesCollectionViewCell *)cell;

/**
 *  Tells the delegate that the cell has been tapped at the point specified by position.
 *
 *  @param cell The cell that received the tap touch event.
 *  @param position The location of the received touch in the cell's coordinate system.
 *
 *  @discussion This method is *only* called if position is *not* within the bounds of the cell's
 *  avatar image view or message bubble image view. In other words, this method is *not* called when the cell's
 *  avatar or message bubble are tapped.
 *
 *  @see `messagesCollectionViewCellDidTapAvatar:`
 *  @see `messagesCollectionViewCellDidTapMessageBubble:`
 */
- (void)messagesCollectionViewCellDidTapCell:(JSQMessagesCollectionViewCell *)cell atPosition:(CGPoint)position;

@end


/**
 *  The `JSQMessagesCollectionViewCell` is an abstract base class that presents the content for 
 *  a single message data item when that item is within the collection view’s visible bounds. 
 *  The layout and presentation of cells is managed by the collection view and its corresponding layout object.
 *
 *  @warning This class is intended to be subclassed. You should not use it directly.
 *
 *  @see JSQMessagesCollectionViewCellIncoming.
 *  @see JSQMessagesCollectionViewCellOutgoing.
 */
@interface JSQMessagesCollectionViewCell : UICollectionViewCell <JSQMessagesCollectionViewCell>

/**
 *  The object that acts as the delegate for the cell.
 */
@property (weak, nonatomic) id<JSQMessagesCollectionViewCellDelegate> delegate;

/**
 *  Returns the label that is pinned to the top of the cell.
 *  This label is most commonly used to display message timestamps.
 */
@property (weak, nonatomic, readonly) JSQMessagesLabel *cellTopLabel;

/**
 *  Returns the label that is pinned just above the messageBubbleImageView, and below the cellTopLabel.
 *  This label is most commonly used to display the message sender.
 */
@property (weak, nonatomic, readonly) JSQMessagesLabel *messageBubbleTopLabel;

/**
 *  Returns the label that is pinned to the bottom of the cell.
 *  This label is most commonly used to display message delivery status.
 */
@property (weak, nonatomic, readonly) JSQMessagesLabel *cellBottomLabel;

/**
 *  Returns the text view of the cell. This text view contains the message body text.
 *
 *  @warning If mediaView returns a non-nil view, then this value will be `nil`.
 */
@property (weak, nonatomic, readonly) JSQMessagesCellTextView *textView;

/**
 *  Returns the bubble image view of the cell that is responsible for displaying message bubble images. 
 *
 *  @warning If mediaView returns a non-nil view, then this value will be `nil`.
 */
@property (weak, nonatomic, readonly) UIImageView *messageBubbleImageView;

/**
 *  Returns the message bubble container view of the cell. This view is the superview of
 *  the cell's textView and messageBubbleImageView.
 *
 *  @discussion You may customize the cell by adding custom views to this container view.
 *  To do so, override `collectionView:cellForItemAtIndexPath:`
 *
 *  @warning You should not try to manipulate any properties of this view, for example adjusting
 *  its frame, nor should you remove this view from the cell or remove any of its subviews. 
 *  Doing so could result in unexpected behavior.
 */
@property (weak, nonatomic, readonly) UIView *messageBubbleContainerView;

/**
 *  Returns the avatar image view of the cell that is responsible for displaying avatar images.
 */
@property (weak, nonatomic, readonly) UIImageView *avatarImageView;

/**
 *  Returns the avatar container view of the cell. This view is the superview of 
 *  the cell's avatarImageView.
 *
 *  @discussion You may customize the cell by adding custom views to this container view.
 *  To do so, override `collectionView:cellForItemAtIndexPath:`
 *
 *  @warning You should not try to manipulate any properties of this view, for example adjusting
 *  its frame, nor should you remove this view from the cell or remove any of its subviews.
 *  Doing so could result in unexpected behavior.
 */
@property (weak, nonatomic, readonly) UIView *avatarContainerView;

/**
 *  The media view of the cell. This view displays the contents of a media message.
 *
 *  @warning If this value is non-nil, then textView and messageBubbleImageView will both be `nil`.
 */
@property (weak, nonatomic) UIView *mediaView;

/**
 *  Returns the underlying gesture recognizer for tap gestures in the avatarImageView of the cell.
 *  This gesture handles the tap event for the avatarImageView and notifies the cell's delegate.
 */
@property (weak, nonatomic, readonly) UITapGestureRecognizer *tapGestureRecognizer;

#pragma mark - Class methods

/**
 *  Returns the `UINib` object initialized for the cell.
 *
 *  @return The initialized `UINib` object or `nil` if there were errors during 
 *  initialization or the nib file could not be located.
 */
+ (UINib *)nib;

/**
 *  Returns the default string used to identify a reusable cell for text message items.
 *
 *  @return The string used to identify a reusable cell.
 */
+ (NSString *)cellReuseIdentifier;

/**
 *  Returns the default string used to identify a reusable cell for media message items.
 *
 *  @return The string used to identify a reusable cell.
 */
+ (NSString *)mediaCellReuseIdentifier;

@end
