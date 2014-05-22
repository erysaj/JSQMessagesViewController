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

@class JSQMessagesDateHeaderView;

/**
 *  A constant defining the default height of a `JSQMessagesLoadEarlierHeaderView`.
 */
FOUNDATION_EXPORT const CGFloat kJSQMessagesDateHeaderViewHeight;


/**
 *  The `JSQMessagesDateHeaderView` class implements a reusable view that can be placed
 *  at the top of a `JSQMessagesCollectionView`.
 */
@interface JSQMessagesDateHeaderView : UICollectionReusableView

/**
 *  Returns the load button of the header view.
 */
@property (weak, nonatomic, readonly) UILabel *dateLabel;

#pragma mark - Class methods

/**
 *  Returns the `UINib` object initialized for the collection reusable view.
 *
 *  @return The initialized `UINib` object or `nil` if there were errors during
 *  initialization or the nib file could not be located.
 */
+ (UINib *)nib;

/**
 *  Returns the default string used to identify the reusable header view.
 *
 *  @return The string used to identify the reusable header view.
 */
+ (NSString *)headerReuseIdentifier;

@end
