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

#import "JSQCollectionViewAdapterBase.h"


@interface JSQCollectionViewAdapterBase ()

@property (strong, nonatomic) id<JSQItemDataSource> dataSource;
@property (strong, nonatomic) NSCache *metricsCache;

@end


@implementation JSQCollectionViewAdapterBase

- (instancetype)initWithDataSource:(id<JSQItemDataSource>)dataSource
{
    self = [self init];
    if (self) {
        _dataSource = dataSource;
        
        _metricsCache = [[NSCache alloc] init];
        _metricsCache.name = [NSString stringWithFormat:@"%@.metricsCache", [self class]];
        _metricsCache.countLimit = 200;
    }
    return self;
}

- (id)metricsForCurrentItemWithComputeBlock:(id(^)())compute
{
    id cacheKey = [self cacheKeyForCurrentItem];
    id metrics = [_metricsCache objectForKey:cacheKey];
    if (!metrics)
    {
        metrics = compute();
        [_metricsCache setObject:metrics forKey:cacheKey];
    }
    return metrics;
}

#pragma mark - UICollectionViewDataSource protocol

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [_dataSource numberOfSections];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_dataSource numberOfItemsInSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self setCurrentItemIndexPath:indexPath];
    
    NSString *reuseIdentifier = [self reuseIdentifierForCurrentItem];
    Class<JSQCollectionViewCell> cellClass = [self cellClassForCurrentItem];
    id<JSQCollectionViewCellDisplayData> displayData = [self displayDataForCurrentItem];
    
    UICollectionViewCell<JSQCollectionViewCell> *cell = nil;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionView.collectionViewLayout;
    UIEdgeInsets sectionInset = layout.sectionInset;
    CGFloat maxWidth = CGRectGetWidth(collectionView.frame) - sectionInset.left - sectionInset.right;
    CGSize cellSizeConstraint = CGSizeMake(maxWidth, CGFLOAT_MAX);

    id metrics = [self metricsForCurrentItemWithComputeBlock:^id{
        return [cellClass computeMetricsWithData:displayData cellSizeConstraint:cellSizeConstraint];
    }];
    
    CGSize cellSize = [cellClass cellSizeWithData:displayData
                                          metrics:metrics
                               cellSizeConstraint:cellSizeConstraint];

    [cell configureWithData:displayData metrics:metrics cellSize:cellSize];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout protocol

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewFlowLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self setCurrentItemIndexPath:indexPath];
    
    Class<JSQCollectionViewCell> cellClass = [self cellClassForCurrentItem];
    id<JSQCollectionViewCellDisplayData> displayData = [self displayDataForCurrentItem];
    
    UIEdgeInsets sectionInset = collectionViewLayout.sectionInset;
    CGFloat maxWidth = CGRectGetWidth(collectionView.frame) - sectionInset.left - sectionInset.right;
    CGSize cellSizeConstraint = CGSizeMake(maxWidth, CGFLOAT_MAX);
    
    id metrics = [self metricsForCurrentItemWithComputeBlock:^id{
        return [cellClass computeMetricsWithData:displayData cellSizeConstraint:cellSizeConstraint];
    }];
    
    CGSize size = [cellClass cellSizeWithData:displayData
                                      metrics:metrics
                           cellSizeConstraint:cellSizeConstraint];
    return size;
}

- (id)collectionView:(JSQMessagesCollectionView *)collectionView
              layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout metricsForItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self setCurrentItemIndexPath:indexPath];
    id metrics = [self metricsForCurrentItemWithComputeBlock:nil];
    
//    NSParameterAssert(metrics);
    return metrics;
}

#pragma mark - JSQCollectionViewAdapter protocol

- (void)registerCellsForCollectionView:(UICollectionView *)collectionView
{
    NSAssert(NO, @"ERROR: required method not implemented: %s", __PRETTY_FUNCTION__);
}

#pragma mark - methods to override

- (void)setCurrentItemIndexPath:(NSIndexPath *)indexPath
{
    NSAssert(NO, @"ERROR: required method not implemented: %s", __PRETTY_FUNCTION__);
}

- (Class<JSQCollectionViewCell>)cellClassForCurrentItem
{
    NSAssert(NO, @"ERROR: required method not implemented: %s", __PRETTY_FUNCTION__);
    return nil;
}

- (NSString *)reuseIdentifierForCurrentItem
{
    NSAssert(NO, @"ERROR: required method not implemented: %s", __PRETTY_FUNCTION__);
    return nil;
}

- (id<JSQCollectionViewCellDisplayData>)displayDataForCurrentItem;
{
    NSAssert(NO, @"ERROR: required method not implemented: %s", __PRETTY_FUNCTION__);
    return nil;
}

- (id)cacheKeyForCurrentItem
{
    NSAssert(NO, @"ERROR: required method not implemented: %s", __PRETTY_FUNCTION__);
    return nil;
}

@end
