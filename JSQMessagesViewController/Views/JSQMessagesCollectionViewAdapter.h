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

#import "JSQCollectionViewAdapterBase.h"
#import "JSQMessagesCollectionViewCell.h"


@protocol JSQMessageData;


/**
 *  A constant that describes the default height for all label subviews in a `JSQMessagesCollectionViewCell`.
 *
 *  @see JSQMessagesCollectionViewCell.
 */
FOUNDATION_EXPORT const CGFloat kJSQMessagesCollectionViewCellLabelHeightDefault;

/**
 *  A constant that describes the default size for avatar images in a `JSQMessagesCollectionViewFlowLayout`.
 */
FOUNDATION_EXPORT const CGFloat kJSQMessagesCollectionViewAvatarSizeDefault;


/**
 *  `JSQMessagesCollectionViewAdapter` is a concrete class representing a
 *  collection view adapter that is designed to display model objects conforming to
 *  `JSQMessageData` protocol using cells of `JSQMessagesCollectionViewCell` class.
 */
@interface JSQMessagesCollectionViewAdapter : JSQCollectionViewAdapterBase <JSQMessagesCollectionViewCellData>

/**
 *  Current item as selected by calling `setCurrentItemIndexPath:`.
 */
@property (nonatomic, readonly) id<JSQMessageData> currMessage;

/**
 *  Messagee immediately before `currMessage` (section borders are not crossed).
 */
@property (nonatomic, readonly) id<JSQMessageData> prevMessage;

/**
 *  Specifies if current message is outgoing (`senderId` of message and adapter match)
 */
@property (nonatomic, readonly) BOOL isOutgoingMessage;

/**
 *  The collection view cell identifier to use for dequeuing outgoing message collection view cells
 *  in the collectionView for text messages.
 *
 *  @discussion This cell identifier is used for outgoing text message data items.
 *  The default value is the string returned by `[JSQMessagesCollectionViewCellOutgoing cellReuseIdentifier]`.
 *  This value must not be `nil`.
 *
 *  @see JSQMessagesCollectionViewCellOutgoing.
 *
 *  @warning Overriding this property's default value is *not* recommended.
 *  You should only override this property's default value if you are proividing your own cell prototypes.
 *  These prototypes must be registered with the collectionView for reuse and you are then responsible for
 *  completely overriding many delegate and data source methods for the collectionView,
 *  including `collectionView:cellForItemAtIndexPath:`.
 */
@property (copy, nonatomic) NSString *outgoingCellIdentifier;

/**
 *  The collection view cell identifier to use for dequeuing outgoing message collection view cells
 *  in the collectionView for media messages.
 *
 *  @discussion This cell identifier is used for outgoing media message data items.
 *  The default value is the string returned by `[JSQMessagesCollectionViewCellOutgoing mediaCellReuseIdentifier]`.
 *  This value must not be `nil`.
 *
 *  @see JSQMessagesCollectionViewCellOutgoing.
 *
 *  @warning Overriding this property's default value is *not* recommended.
 *  You should only override this property's default value if you are proividing your own cell prototypes.
 *  These prototypes must be registered with the collectionView for reuse and you are then responsible for
 *  completely overriding many delegate and data source methods for the collectionView,
 *  including `collectionView:cellForItemAtIndexPath:`.
 */
@property (copy, nonatomic) NSString *outgoingMediaCellIdentifier;

/**
 *  The collection view cell identifier to use for dequeuing incoming message collection view cells
 *  in the collectionView for text messages.
 *
 *  @discussion This cell identifier is used for incoming text message data items.
 *  The default value is the string returned by `[JSQMessagesCollectionViewCellIncoming cellReuseIdentifier]`.
 *  This value must not be `nil`.
 *
 *  @see JSQMessagesCollectionViewCellIncoming.
 *
 *  @warning Overriding this property's default value is *not* recommended.
 *  You should only override this property's default value if you are proividing your own cell prototypes.
 *  These prototypes must be registered with the collectionView for reuse and you are then responsible for
 *  completely overriding many delegate and data source methods for the collectionView,
 *  including `collectionView:cellForItemAtIndexPath:`.
 */
@property (copy, nonatomic) NSString *incomingCellIdentifier;

/**
 *  The collection view cell identifier to use for dequeuing incoming message collection view cells
 *  in the collectionView for media messages.
 *
 *  @discussion This cell identifier is used for incoming media message data items.
 *  The default value is the string returned by `[JSQMessagesCollectionViewCellIncoming mediaCellReuseIdentifier]`.
 *  This value must not be `nil`.
 *
 *  @see JSQMessagesCollectionViewCellIncoming.
 *
 *  @warning Overriding this property's default value is *not* recommended.
 *  You should only override this property's default value if you are proividing your own cell prototypes.
 *  These prototypes must be registered with the collectionView for reuse and you are then responsible for
 *  completely overriding many delegate and data source methods for the collectionView,
 *  including `collectionView:cellForItemAtIndexPath:`.
 */
@property (copy, nonatomic) NSString *incomingMediaCellIdentifier;

/**
 *  Returns an initialized instance of `JSQMessagesCollectionViewAdapter`.
 *
 *  @param dataSource Data source of message objects conforming to `JSQMessageData` protocol.
 *  @param senderId Unique string identifying the sender. Used to determine the message direction (incoming or outgoing).
 */
- (instancetype)initWithDataSource:(id<JSQItemDataSource>)dataSource
                          senderId:(NSString *)senderId;

/**
 *  The font used to display the body a text message in the message bubble of each
 *  `JSQMessagesCollectionViewCell` in the collectionView.
 *
 *  @discussion The default value is the preferred system font for `UIFontTextStyleBody`. This value must not be `nil`.
 */
@property (strong, nonatomic) UIFont *messageBubbleFont;

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
@property (assign, nonatomic) CGFloat messageBubbleLeftRightMargin;

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
@property (assign, nonatomic) UIEdgeInsets messageBubbleTextViewFrameInsets;

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
@property (assign, nonatomic) UIEdgeInsets messageBubbleTextViewTextContainerInsets;

/**
 *  The size of the avatar image view for incoming messages.
 *
 *  @discussion The default value is `(30.0f, 30.0f)`. Set to `CGSizeZero` to remove incoming avatars.
 *  You may use `kJSQMessagesCollectionViewAvatarSizeDefault` to size your avatars to the default value.
 */
@property (assign, nonatomic) CGSize incomingAvatarViewSize;

/**
 *  The size of the avatar image view for outgoing messages.
 *
 *  @discussion The default value is `(30.0f, 30.0f)`. Set to `CGSizeZero` to remove outgoing avatars.
 *  You may use `kJSQMessagesCollectionViewAvatarSizeDefault` to size your avatars to the default value.
 */
@property (assign, nonatomic) CGSize outgoingAvatarViewSize;

@end
