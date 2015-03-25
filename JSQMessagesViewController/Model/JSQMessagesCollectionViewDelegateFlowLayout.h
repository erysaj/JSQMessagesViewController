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

@class JSQMessagesCollectionView;
@class JSQMessagesCollectionViewFlowLayout;
@class JSQMessagesCollectionViewCell;
@class JSQMessagesLoadEarlierHeaderView;


@protocol JSQMessagesCollectionViewDelegateFlowLayout <UICollectionViewDelegateFlowLayout>

/**
 *  Asks the delegate for computed metrics of specified item.
 *
 *  @param collectionView       The collection view object displaying the flow layout.
 *  @param collectionViewLayout The layout object requesting the information.
 *  @param indexPath            The index path of the item.
 *
 *  @see JSQMessagesCollectionViewCell.
 */
- (id)collectionView:(JSQMessagesCollectionView *)collectionView
              layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout metricsForItemAtIndexPath:(NSIndexPath *)indexPath;

@end
