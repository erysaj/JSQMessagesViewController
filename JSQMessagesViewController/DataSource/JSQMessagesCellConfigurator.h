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

#import "JSQMessagesCollectionViewCell.h"

@protocol JSQMessagesItemDataSource;
@class JSQMessagesCollectionView;
@class JSQMessagesCollectionViewFlowLayout;


@protocol JSQMessagesCellConfigurator

@required

- (void)registerCells:(JSQMessagesCollectionView *)collectionView;

- (JSQMessagesCollectionViewCell *)dequeueCellForItemAtIndexPath:(NSIndexPath *)indexPath
                                                  collectionView:(JSQMessagesCollectionView *)collectionView;

- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath
                  collectionView:(JSQMessagesCollectionView *)collectionView
                          layout:(JSQMessagesCollectionViewFlowLayout *)layout;

@end


@interface JSQMessagesCellConfigurator : NSObject <JSQMessagesCellConfigurator, JSQMessagesCollectionViewCellData>

// methods to override
- (id)currItem;

- (void)selectItemAtIndexPath:(NSIndexPath *)indexPath;
- (Class<JSQMessagesCollectionViewCell>)cellClass;
- (NSString *)reuseIdentifier;

@end
