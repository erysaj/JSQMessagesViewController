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

#import "JSQMessagesCellConfigurator.h"
#import "JSQMessagesItemDataSource.h"
#import "JSQMessagesCollectionView.h"
#import "JSQMessagesCollectionViewCell.h"

@interface JSQMessagesCellConfigurator ()

@property (strong, nonatomic) id<JSQMessagesItemDataSource> items;
@property (strong, nonatomic) id sender;

@end


@implementation JSQMessagesCellConfigurator

#pragma mark - Precomputing content size

- (CGSize)contentSizeForItemAtIndexPath:(NSIndexPath *)indexPath layout:(JSQMessagesCollectionViewFlowLayout *)layout
{
    NSValue *cachedContentSize = [layout cachedContentSizeForItemAtIndexPath:indexPath];
    if (cachedContentSize) {
        return [cachedContentSize CGSizeValue];
    }
    
    Class<JSQMessagesCollectionViewCell> cellClass = [self cellClass];
    CGSize contentSize = [cellClass contentSizeWithData:self
                                     cellSizeConstraint:CGSizeMake([layout itemWidth], CGFLOAT_MAX)];
    [layout cacheContentSize:contentSize forItemAtIndexPath:indexPath];
    
    return contentSize;
}

#pragma mark - Methods for overriding

- (void)selectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSAssert(NO, @"Method %s not implemented!", __PRETTY_FUNCTION__);
}

- (Class<JSQMessagesCollectionViewCell>)cellClass
{
    NSAssert(NO, @"Method %s not implemented!", __PRETTY_FUNCTION__);
    return NULL;
}

- (NSString *)reuseIdentifier
{
    NSAssert(NO, @"Method %s not implemented!", __PRETTY_FUNCTION__);
    return nil;
}

#pragma mark - JSQMessagesCellConfigurator protocol

- (void)registerCells:(JSQMessagesCollectionView *)collectionView
{
    NSAssert(NO, @"Method %s not implemented!", __PRETTY_FUNCTION__);
}

- (JSQMessagesCollectionViewCell *)dequeueCellForItemAtIndexPath:(NSIndexPath *)indexPath
                                         collectionView:(JSQMessagesCollectionView *)collectionView
{
    [self selectItemAtIndexPath:indexPath];
    
    CGSize contentSize = [self contentSizeForItemAtIndexPath:indexPath layout:collectionView.collectionViewLayout];
    
    JSQMessagesCollectionViewCell *cell = nil;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.reuseIdentifier
                                                     forIndexPath:indexPath];
    
    CGSize cellSizeConstraint = CGSizeMake([collectionView.collectionViewLayout itemWidth], CGFLOAT_MAX);
    // compute real cell size for passing to -[configureWithData:contentSize:cellSizeConstraint:]
    cellSizeConstraint = [[cell class] cellSizeWithData:self contentSize:contentSize cellSizeConstraint:cellSizeConstraint];
    
    [cell configureWithData:self
                contentSize:contentSize
         cellSizeConstraint:cellSizeConstraint];
    
    return cell;
}

- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath
                  collectionView:(JSQMessagesCollectionView *)collectionView
                          layout:(JSQMessagesCollectionViewFlowLayout *)layout
{
    [self selectItemAtIndexPath:indexPath];
    
    CGSize contentSize = [self contentSizeForItemAtIndexPath:indexPath layout:layout];
    
    Class<JSQMessagesCollectionViewCell> cellClass = [self cellClass];
    CGFloat cellWidth = [layout itemWidth];
    CGSize size = [cellClass cellSizeWithData:self
                                  contentSize:contentSize
                           cellSizeConstraint:CGSizeMake(cellWidth, CGFLOAT_MAX)];
    return size;
}

#pragma mark - JSQMessagesCollectionViewCellData protocol

- (id)cellModel
{
    return nil;
}

- (CGFloat)cellTopMargin
{
    return 0.0f;
}

- (CGFloat)cellBottomMargin
{
    return 0.0f;
}

- (id)cellContainerData
{
    return nil;
}

@end
