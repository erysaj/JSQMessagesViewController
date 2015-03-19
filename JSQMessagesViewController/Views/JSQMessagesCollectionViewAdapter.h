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


@protocol JSQMessageData;


/**
 *  `JSQMessagesCollectionViewAdapter` is a concrete class representing a
 *  collection view adapter that is designed to display model objects conforming to
 *  `JSQMessageData` protocol using cells of `JSQMessagesCollectionViewCell` class.
 */
@interface JSQMessagesCollectionViewAdapter : JSQCollectionViewAdapterBase

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



@end
