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

#import "JSQMessagesCollectionViewFlowLayout.h"


/**
 *  The `JSQMessagesCollectionView` class manages an ordered collection of message data items and presents
 *  them using a specialized layout for messages.
 */
@interface JSQMessagesCollectionView : UICollectionView

/**
 *  The layout used to organize the collection view’s items.
 */
@property (strong, nonatomic) JSQMessagesCollectionViewFlowLayout *collectionViewLayout;


@end
