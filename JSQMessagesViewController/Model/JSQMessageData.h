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

#import <Foundation/Foundation.h>
#import "JSQMessagesBubbleImageFactory.h"


typedef NS_ENUM(NSUInteger, JSMessageType) {
    
    JSMessageTypeText,
    JSMessageTypeImage,
    JSMessageTypeVideo,
    JSMessageTypeSystem,
    /**
     *  Specifies a system message with action button.
     */
    JSMessageTypeSystemAction,
    
};

/**
 *  The `JSQMessageData` protocol defines the common interface through
 *  which `JSQMessagesViewController` and `JSQMessagesCollectionView` interacts with message model objects.
 *
 *  It declares the required and optional methods that a class must implement so that instances of that class
 *  can be displayed properly with a `JSQMessagesCollectionViewCell`.
 */
@protocol JSQMessageData <NSObject>

@required

/**
 *  @return The body text of the message.
 *  @warning You must not return `nil` from this method.
 */
- (NSString *)text;

/**
 *  @return The name of the user who sent the message.
 *  @warning You must not return `nil` from this method.
 */
- (NSString *)sender;

/**
 *  @return The date that the message was sent.
 *  @warning You must not return `nil` from this method.
 */
- (NSDate *)date;

/**
 *  @return The image url for that the image message.
 */
- (NSURL *)imageURL;


/**
 *  @return The image orientation
 */
- (JSImageOrientation)imageOrientation;

/**
 *  @return The message type
 *  @warning You must not return `nil` from this method.
 */
- (JSMessageType)messageType;

@end
