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
//
//  Ideas for springy collection view layout taken from Ash Furrow
//  ASHSpringyCollectionView
//  https://github.com/AshFurrow/ASHSpringyCollectionView
//

#import <UIKit/UIKit.h>

@class JSQMessagesCollectionView;

/**
 *  The `JSQMessagesCollectionViewFlowLayout` is a concrete layout object that inherits 
 *  from `UICollectionViewFlowLayout` and organizes message items in a vertical list.
 *  Each `JSQMessagesCollectionViewCell` in the layout can display messages of arbitrary sizes and avatar images, 
 *  as well as metadata such as a timestamp and sender.
 *  You can easily customize the layout via its properties or its delegate methods 
 *  defined in `JSQMessagesCollectionViewDelegateFlowLayout`.
 *
 *  @see `JSQMessagesCollectionViewDelegateFlowLayout`
 *  @see `JSQMessagesCollectionViewCell`
 */
@interface JSQMessagesCollectionViewFlowLayout : UICollectionViewFlowLayout

/**
 *  The collection view object currently using this layout object.
 */
@property (readonly, nonatomic) JSQMessagesCollectionView *collectionView;

/**
 *  Specifies whether or not the layout should enable spring behavior dynamics for its items using `UIDynamics`.
 *
 *  @discussion The default value is `NO`, which disables "springy" or "bouncy" items in the layout. 
 *  Set to `YES` if you want items to have spring behavior dynamics.
 */
@property (assign, nonatomic) BOOL springinessEnabled;

/**
 *  Specifies the degree of resistence for the "springiness" of items in the layout. 
 *  This property has no effect if `springinessEnabled` is set to `NO`.
 *
 *  @discussion The default value is `1000`. Increasing this value increases the resistance, that is, items become less "bouncy". 
 *  Decrease this value in order to make items more "bouncy".
 */
@property (assign, nonatomic) NSUInteger springResistanceFactor;

/**
 *  Returns the width of items in the layout.
 */
@property (readonly, nonatomic) CGFloat itemWidth;

/**
 *  Cache computed content size for specified item. This cache will be cleared by `JSQMessagesCollectionViewFlowLayout`
 *  (e.g. when content width is changed)
 *
 *  @param contentSize    Size occupied by item's cell content
 *  @param indexPath      Index path identifying item's location.
 *
 */
- (void)cacheContentSize:(CGSize)contentSize forItemAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  Retrieve previously cached with `cacheContentSize:forItemAtIndexPath:` content size.
 *
 *  @param indexPath      Index path identifying item of interest lcoation.
 *
 *  @return Item's content size value wrapped in `NSValue` or `nil` if no value was found in the cache.
 */
- (NSValue *)cachedContentSizeForItemAtIndexPath:(NSIndexPath *)indexPath;


@end
