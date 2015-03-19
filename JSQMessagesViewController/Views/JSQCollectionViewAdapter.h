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


@protocol JSQMessagesItemDataSource;
@class JSQMessagesCollectionView;
@class JSQMessagesCollectionViewFlowLayout;


/**
 *  `JSQCollectionViewAdapter` defines an objects that makes the heavy work
 *  required to implement `UICollectionViewDataSource` and `UICollectionViewDelegateFlowLayout`.
 *  Such object will also encapsulate knowledge of what kinds of custom cells are used and how to
 *  configure each cell kind for displaying model data.
 */
@protocol JSQCollectionViewAdapter <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@required

/**
 *  Register required cell classes / xibs.
 */
- (void)registerCellsForCollectionView:(UICollectionView *)collectionView;


@end
