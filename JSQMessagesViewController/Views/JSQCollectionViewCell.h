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

#import "JSQCollectionViewCellDisplayData.h"


/**
 *  The `JSQCollectionViewCell` protocol must be implemented by any custom
 *  `UICollectionViewCell` subclass that is intended to be used in `JSQMessagesCollectionView`.
 */
@protocol JSQCollectionViewCell <NSObject>

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
+ (id)computeMetricsWithData:(id<JSQCollectionViewCellDisplayData>)data
          cellSizeConstraint:(CGSize)constraint;

/**
 *  Compute size required by the cell of this class to display provided data.
 */
+ (CGSize)cellSizeWithData:(id<JSQCollectionViewCellDisplayData>)data
                   metrics:(id)metrics
        cellSizeConstraint:(CGSize)constraint;

/**
 *  Configure cell instance for displaying provided data.
 */
- (void)configureWithData:(id<JSQCollectionViewCellDisplayData>)data
                  metrics:(id)metrics
                 cellSize:(CGSize)cellSize;

@end
