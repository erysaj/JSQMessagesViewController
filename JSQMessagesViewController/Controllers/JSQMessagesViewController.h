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

#import "JSQMessagesCollectionView.h"
#import "JSQMessagesCollectionViewFlowLayout.h"
#import "JSQMessagesItemDataSource.h"

@class JSQMessagesInputToolbar;
@protocol JSQMessagesCellConfigurator;



/**
 *  The `JSQMessagesViewController` class is an abstract class that represents a view controller whose content consists of
 *  a `JSQMessagesCollectionView` and `JSQMessagesInputToolbar` and is specialized to display a messaging interface.
 *
 *  @warning This class is intended to be subclassed. You should not use it directly.
 */
@interface JSQMessagesViewController : UIViewController <UICollectionViewDataSource,
                                                         UICollectionViewDelegateFlowLayout>

/**
 *  Returns the collection view object managed by this view controller. 
 *  This view controller is the collection view's data source and delegate.
 */
@property (weak, nonatomic, readonly) JSQMessagesCollectionView *collectionView;

/**
 *  Returns the input toolbar view object managed by this view controller. 
 *  This view controller is the toolbar's delegate.
 */
@property (weak, nonatomic, readonly) JSQMessagesInputToolbar *inputToolbar;

/**
 *  The user sending messages. This value must not be `nil`. 
 */
@property (strong, nonatomic) id sender;

@property (strong, nonatomic) id<JSQMessagesItemDataSource> dataSource;

@property (strong, nonatomic) id<JSQMessagesCellConfigurator> cellConfigurator;

/**
 *  Specifies whether or not the view controller should automatically scroll to the most recent message 
 *  when the view appears and when sending, receiving, and composing a new message.
 *
 *  @discussion The default value is `YES`, which allows the view controller to scroll automatically to the most recent message. 
 *  Set to `NO` if you want to manage scrolling yourself.
 */
@property (assign, nonatomic) BOOL automaticallyScrollsToMostRecentMessage;

/**
 *  The color for the typing indicator for incoming messages.
 *
 *  @discussion The color specified is used for the typing indicator bubble image color.
 *  This color is then slightly darkened and used to color the typing indicator ellipsis.
 *  The default value is the light gray color value return by `[UIColor jsq_messageBubbleLightGrayColor]`.
 */
@property (strong, nonatomic) UIColor *typingIndicatorColor;

/**
 *  Specifies whether or not the view controller should show the typing indicator for an incoming message.
 *  @discussion Setting this property to `YES` will animate showing the typing indicator immediately.
 *  Setting this property to `NO` will animate hiding the typing indicator immediately.
 */
@property (assign, nonatomic) BOOL showTypingIndicator;

/**
 *  Specifies whether or not the view controller should show the "load earlier messages" header view.
 *  @discussion Setting this property to `YES` will show the header view immediately.
 *  Settings this property to `NO` will hide the header view immediately.
 */
@property (assign, nonatomic) BOOL showLoadEarlierMessagesHeader;

#pragma mark - Class methods

/**
 *  Returns the `UINib` object initialized for `JSQMessagesViewController`.
 *
 *  @return The initialized `UINib` object or `nil` if there were errors during initialization 
 *  or the nib file could not be located.
 */
+ (UINib *)nib;

/**
 *  Creates and returns a new `JSQMessagesViewController` object.
 *  
 *  @discussion This is the designated initializer for programmatic instantiation.
 *
 *  @return The initialized messages view controller if successful, otherwise `nil`.
 */
+ (instancetype)messagesViewController;

#pragma mark - Messages view controller

/**
 *  This method is called when the user taps the send button on the inputToolbar
 *  after composing a message with the specified data.
 *
 *  @param button The send button that was pressed by the user.
 *  @param text   The message text.
 *  @param sender The message sender.
 *  @param date   The message date.
 */
- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                    sender:(id)sender
                      date:(NSDate *)date;

/**
 *  This method is called when the user taps the accessory button on the `inputToolbar`.
 *
 *  @param sender The accessory button that was pressed by the user.
 */
- (void)didPressAccessoryButton:(UIButton *)sender;

/**
 *  Completes the "sending" of a new message by animating and resetting the `inputToolbar`, 
 *  animating the addition of a new collection view cell in the collection view,
 *  reloading the collection view, and scrolling to the newly sent message 
 *  as specified by `automaticallyScrollsToMostRecentMessage`.
 *
 *  @discussion You should call this method at the end of `didPressSendButton:withMessage:` 
 *  after adding the new message to your data source and performing any related tasks.
 *
 *  @see `automaticallyScrollsToMostRecentMessage`.
 *  @see `didPressSendButton: withMessage:`.
 */
- (void)finishSendingMessage;

/**
 *  Completes the "receiving" of a new message by animating the typing indicator,
 *  animating the addition of a new collection view cell in the collection view,
 *  reloading the collection view, and scrolling to the newly sent message
 *  as specified by `automaticallyScrollsToMostRecentMessage`.
 *
 *  @discussion You should call this method after adding a new "received" message
 *  to your data source and performing any related tasks.
 *
 *  @see `automaticallyScrollsToMostRecentMessage`.
 */
- (void)finishReceivingMessage;

/**
 *  Scrolls the collection view such that the bottom most cell is completely visible, above the `inputToolbar`.
 *
 *  @param animated Pass `YES` if you want to animate scrolling, `NO` if it should be immediate.
 */
- (void)scrollToBottomAnimated:(BOOL)animated;

@end
