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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "JSQItemDataSource.h"
#import "JSQCollectionViewAdapter.h"
#import "JSQCollectionViewCell.h"


@protocol JSQCollectionViewCellDisplayData;


/**
 *  `JSQCollectionViewAdapterBase` is an abstract class conforming to `JSQCollectionViewAdapter` protocol.
 *  It provides a template implementation and requires certain methods to be overridden by subclass.
 */
@interface JSQCollectionViewAdapterBase : NSObject<JSQCollectionViewAdapter>

/**
 *  Items to display in `UICollectionView`.
 */
@property (nonatomic, readonly) id<JSQItemDataSource> dataSource;

/**
 *  Cache to store precomputed metrics information.
 */
@property (nonatomic, readonly) NSCache *metricsCache;


/**
 *  Initialize and returns collection view adapter instance
 *  that uses specified data source.
 */
- (instancetype)initWithDataSource:(id<JSQItemDataSource>)dataSource;

/**
 *  Makes model item at specified index path 'current'.
 *  The idea is that some info may for the item may be calculated multiple times,
 *  so this method provides an opportunity to cache expencive computations.
 *  You *MUST* override this method in subclass.
 */
- (void)setCurrentItemIndexPath:(NSIndexPath *)indexPath;

/**
 *  Returns cell class to use for displaying current item.
 *  This is required for geometry calculation and configuring cells.
 *  You *MUST* override this method in subclass.
 */
- (Class<JSQCollectionViewCell>)cellClassForCurrentItem;

/**
 *  Cell reuse identifier to dequeue the cell for current item.
 *  You *MUST* override this method in subclass.
 */
- (NSString *)reuseIdentifierForCurrentItem;

/**
 *  Returns data required to display the cell corresponding to current item.
 */
- (id<JSQCollectionViewCellDisplayData>)displayDataForCurrentItem;

/**
 *  Returns cache key to use for caching current item's info in `metricsCache`.
 *  You *MUST* override this method in subclass.
 */
- (id)cacheKeyForCurrentItem;

@end
