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
 *  @see JSQMessagesCollectionViewDelegateFlowLayout.
 *  @see JSQMessagesCollectionViewCell.
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
 *  Set to `YES` if you want items to have spring behavior dynamics. You *must* set this property from `viewDidAppear:`
 *  in your `JSQMessagesViewController` subclass.
 *
 *  @warning Though this feature is mostly stable, it is still considered an experimental feature.
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
 *  The cache to be cleared when layout is invalidated.
 *
 *  @discussion The default value is `200`. A limit of `0` means no limit. This is not a strict limit.
 */
@property (strong, nonatomic) NSCache *layoutCache;

@end
