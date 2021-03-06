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

#import "JSQMessagesCollectionViewFlowLayout.h"

#import "JSQMessagesCollectionView.h"
#import "JSQMessagesGenericCell.h"

#import "JSQMessagesCollectionViewLayoutAttributes.h"
#import "JSQMessagesCollectionViewFlowLayoutInvalidationContext.h"


@interface JSQMessagesCollectionViewFlowLayout ()

@property (strong, nonatomic) NSMutableDictionary *cellContentSizes;
@property (strong, nonatomic) UIDynamicAnimator *dynamicAnimator;
@property (strong, nonatomic) NSMutableSet *visibleIndexPaths;


@property (assign, nonatomic) CGFloat latestDelta;

- (void)jsq_configureFlowLayout;

- (void)jsq_didReceiveApplicationMemoryWarningNotification:(NSNotification *)notification;
- (void)jsq_didReceiveDeviceOrientationDidChangeNotification:(NSNotification *)notification;

- (void)jsq_configureMessageCellLayoutAttributes:(JSQMessagesCollectionViewLayoutAttributes *)layoutAttributes;

- (UIAttachmentBehavior *)jsq_springBehaviorWithLayoutAttributesItem:(UICollectionViewLayoutAttributes *)item;

- (void)jsq_addNewlyVisibleBehaviorsFromVisibleItems:(NSArray *)visibleItems;

- (void)jsq_removeNoLongerVisibleBehaviorsFromVisibleItemsIndexPaths:(NSSet *)visibleItemsIndexPaths;

- (void)jsq_adjustSpringBehavior:(UIAttachmentBehavior *)springBehavior forTouchLocation:(CGPoint)touchLocation;

@end



@implementation JSQMessagesCollectionViewFlowLayout

#pragma mark - Initialization

- (void)jsq_configureFlowLayout
{
    _cellContentSizes = [[NSMutableDictionary alloc] init];
    
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.sectionInset = UIEdgeInsetsMake(10.0f, 4.0f, 10.0f, 4.0f);
    self.minimumLineSpacing = 4.0f;
    
    _springinessEnabled = NO;
    _springResistanceFactor = 1000;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(jsq_didReceiveApplicationMemoryWarningNotification:)
                                                 name:UIApplicationDidReceiveMemoryWarningNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(jsq_didReceiveDeviceOrientationDidChangeNotification:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self jsq_configureFlowLayout];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self jsq_configureFlowLayout];
}

+ (Class)layoutAttributesClass
{
    return [JSQMessagesCollectionViewLayoutAttributes class];
}

+ (Class)invalidationContextClass
{
    return [JSQMessagesCollectionViewFlowLayoutInvalidationContext class];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    _dynamicAnimator = nil;
    _visibleIndexPaths = nil;
}

#pragma mark - Setters

- (void)setSpringinessEnabled:(BOOL)springinessEnabled
{
    _springinessEnabled = springinessEnabled;
    
    if (!springinessEnabled) {
        [_dynamicAnimator removeAllBehaviors];
        [_visibleIndexPaths removeAllObjects];
    }
    [self invalidateLayoutWithContext:[JSQMessagesCollectionViewFlowLayoutInvalidationContext context]];
}

#pragma mark - Getters

- (CGFloat)itemWidth
{
    return CGRectGetWidth(self.collectionView.frame) - self.sectionInset.left - self.sectionInset.right;
}

- (UIDynamicAnimator *)dynamicAnimator
{
    if (!_dynamicAnimator) {
        _dynamicAnimator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
    }
    return _dynamicAnimator;
}

- (NSMutableSet *)visibleIndexPaths
{
    if (!_visibleIndexPaths) {
        _visibleIndexPaths = [NSMutableSet new];
    }
    return _visibleIndexPaths;
}

#pragma mark - Cache

- (void)cacheContentSize:(CGSize)contentSize forItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.cellContentSizes setObject:[NSValue valueWithCGSize:contentSize]
                             forKey:indexPath];
}

- (NSValue *)cachedContentSizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.cellContentSizes objectForKey:indexPath];
}

#pragma mark - Notifications

- (void)jsq_didReceiveApplicationMemoryWarningNotification:(NSNotification *)notification
{
    [self.cellContentSizes removeAllObjects];
    if (self.springinessEnabled) {
        [self.dynamicAnimator removeAllBehaviors];
        [self.visibleIndexPaths removeAllObjects];
    }
}

- (void)jsq_didReceiveDeviceOrientationDidChangeNotification:(NSNotification *)notification
{
    if (self.springinessEnabled) {
        [self.dynamicAnimator removeAllBehaviors];
        [self.visibleIndexPaths removeAllObjects];
    }
    [self invalidateLayoutWithContext:[JSQMessagesCollectionViewFlowLayoutInvalidationContext context]];
}

#pragma mark - Collection view flow layout

- (void)invalidateLayoutWithContext:(JSQMessagesCollectionViewFlowLayoutInvalidationContext *)context
{
    if (context.invalidateDataSourceCounts) {
        context.invalidateFlowLayoutAttributes = YES;
        context.invalidateFlowLayoutDelegateMetrics = YES;
    }
    
    UICollectionViewFlowLayoutInvalidationContext *flowContext = (UICollectionViewFlowLayoutInvalidationContext *)context;
    if (flowContext.invalidateFlowLayoutAttributes || flowContext.invalidateFlowLayoutDelegateMetrics) {
        [self.cellContentSizes removeAllObjects];
    }
    
    [super invalidateLayoutWithContext:context];
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    if (self.springinessEnabled) {
        //  pad rect to avoid flickering
        CGFloat padding = -100.0f;
        CGRect visibleRect = CGRectInset(self.collectionView.bounds, padding, padding);
        
        NSArray *visibleItems = [super layoutAttributesForElementsInRect:visibleRect];
        NSSet *visibleItemsIndexPaths = [NSSet setWithArray:[visibleItems valueForKey:NSStringFromSelector(@selector(indexPath))]];
        
        [self jsq_removeNoLongerVisibleBehaviorsFromVisibleItemsIndexPaths:visibleItemsIndexPaths];
        
        [self jsq_addNewlyVisibleBehaviorsFromVisibleItems:visibleItems];
    }
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *attributes;
    
    if (self.springinessEnabled) {
        attributes = [self.dynamicAnimator itemsInRect:rect];
    }
    else {
        attributes = [super layoutAttributesForElementsInRect:rect];
    }
    
    [attributes enumerateObjectsUsingBlock:^(JSQMessagesCollectionViewLayoutAttributes *attributes, NSUInteger idx, BOOL *stop) {
        if (attributes.representedElementCategory == UICollectionElementCategoryCell) {
            [self jsq_configureMessageCellLayoutAttributes:attributes];
        }
        else {
            attributes.zIndex = -1;
        }
    }];
    
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessagesCollectionViewLayoutAttributes *customAttributes = (JSQMessagesCollectionViewLayoutAttributes *)[super layoutAttributesForItemAtIndexPath:indexPath];
    if (customAttributes.representedElementCategory == UICollectionElementCategoryCell) {
        [self jsq_configureMessageCellLayoutAttributes:customAttributes];
    }
    return customAttributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    if (self.springinessEnabled) {
        UIScrollView *scrollView = self.collectionView;
        CGFloat delta = newBounds.origin.y - scrollView.bounds.origin.y;
        
        self.latestDelta = delta;
        
        CGPoint touchLocation = [self.collectionView.panGestureRecognizer locationInView:self.collectionView];
        
        [self.dynamicAnimator.behaviors enumerateObjectsUsingBlock:^(UIAttachmentBehavior *springBehaviour, NSUInteger idx, BOOL *stop) {
            [self jsq_adjustSpringBehavior:springBehaviour forTouchLocation:touchLocation];
            [self.dynamicAnimator updateItemUsingCurrentState:[springBehaviour.items firstObject]];
        }];
    }
    
    CGRect oldBounds = self.collectionView.bounds;
    if (CGRectGetWidth(newBounds) != CGRectGetWidth(oldBounds)) {
        return YES;
    }
    
    return NO;
}

- (void)prepareForCollectionViewUpdates:(NSArray *)updateItems
{
    [super prepareForCollectionViewUpdates:updateItems];
    
    if (self.springinessEnabled) {
        [updateItems enumerateObjectsUsingBlock:^(UICollectionViewUpdateItem *updateItem, NSUInteger index, BOOL *stop) {
            if (updateItem.updateAction == UICollectionUpdateActionInsert) {
                
                if ([self.dynamicAnimator layoutAttributesForCellAtIndexPath:updateItem.indexPathAfterUpdate]) {
                    *stop = YES;
                }
                
                CGSize size = self.collectionView.bounds.size;
                JSQMessagesCollectionViewLayoutAttributes *attributes = [JSQMessagesCollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:updateItem.indexPathAfterUpdate];
                
                if (attributes.representedElementCategory == UICollectionElementCategoryCell) {
                    [self jsq_configureMessageCellLayoutAttributes:attributes];
                }

                attributes.frame = CGRectMake(0.0f,
                                              size.height - size.width,
                                              size.width,
                                              size.width);
                
                UIAttachmentBehavior *springBehaviour = [self jsq_springBehaviorWithLayoutAttributesItem:attributes];
                [self.dynamicAnimator addBehavior:springBehaviour];
            }
        }];
    }
}

#pragma mark - Message cell layout utilities

- (void)jsq_configureMessageCellLayoutAttributes:(JSQMessagesCollectionViewLayoutAttributes *)layoutAttributes
{
    NSIndexPath *indexPath = layoutAttributes.indexPath;
    
    NSValue *contentSize = _cellContentSizes[indexPath];
    if (contentSize) {
        layoutAttributes.contentSize = [contentSize CGSizeValue];
    }
}

#pragma mark - Spring behavior utilities

- (UIAttachmentBehavior *)jsq_springBehaviorWithLayoutAttributesItem:(UICollectionViewLayoutAttributes *)item
{
    UIAttachmentBehavior *springBehavior = [[UIAttachmentBehavior alloc] initWithItem:item attachedToAnchor:item.center];
    springBehavior.length = 1.0f;
    springBehavior.damping = 1.0f;
    springBehavior.frequency = 1.0f;
    return springBehavior;
}

- (void)jsq_addNewlyVisibleBehaviorsFromVisibleItems:(NSArray *)visibleItems
{
    //  a "newly visible" item is in `visibleItems` but not in `self.visibleIndexPaths`
    NSIndexSet *indexSet = [visibleItems indexesOfObjectsPassingTest:^BOOL(UICollectionViewLayoutAttributes *item, NSUInteger index, BOOL *stop) {
        return ![self.visibleIndexPaths containsObject:item.indexPath];
    }];
    
    NSArray *newlyVisibleItems = [visibleItems objectsAtIndexes:indexSet];
    
    CGPoint touchLocation = [self.collectionView.panGestureRecognizer locationInView:self.collectionView];
    
    [newlyVisibleItems enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *item, NSUInteger index, BOOL *stop) {
        UIAttachmentBehavior *springBehaviour = [self jsq_springBehaviorWithLayoutAttributesItem:item];
        [self jsq_adjustSpringBehavior:springBehaviour forTouchLocation:touchLocation];
        [self.dynamicAnimator addBehavior:springBehaviour];
        [self.visibleIndexPaths addObject:item.indexPath];
    }];
}

- (void)jsq_removeNoLongerVisibleBehaviorsFromVisibleItemsIndexPaths:(NSSet *)visibleItemsIndexPaths
{
    NSArray *behaviors = self.dynamicAnimator.behaviors;
    
    NSIndexSet *indexSet = [behaviors indexesOfObjectsPassingTest:^BOOL(UIAttachmentBehavior *springBehaviour, NSUInteger index, BOOL *stop) {
        UICollectionViewLayoutAttributes *layoutAttributes = [springBehaviour.items firstObject];
        return ![visibleItemsIndexPaths containsObject:layoutAttributes.indexPath];
    }];
    
    NSArray *behaviorsToRemove = [self.dynamicAnimator.behaviors objectsAtIndexes:indexSet];
    
    [behaviorsToRemove enumerateObjectsUsingBlock:^(UIAttachmentBehavior *springBehaviour, NSUInteger index, BOOL *stop) {
        UICollectionViewLayoutAttributes *layoutAttributes = [springBehaviour.items firstObject];
        [self.dynamicAnimator removeBehavior:springBehaviour];
        [self.visibleIndexPaths removeObject:layoutAttributes.indexPath];
    }];
}

- (void)jsq_adjustSpringBehavior:(UIAttachmentBehavior *)springBehavior forTouchLocation:(CGPoint)touchLocation
{
    UICollectionViewLayoutAttributes *item = [springBehavior.items firstObject];
    CGPoint center = item.center;
    
    //  if touch is not (0,0) -- adjust item center "in flight"
    if (!CGPointEqualToPoint(CGPointZero, touchLocation)) {
        CGFloat distanceFromTouch = fabsf(touchLocation.y - springBehavior.anchorPoint.y);
        CGFloat scrollResistance = distanceFromTouch / self.springResistanceFactor;
        
        if (self.latestDelta < 0.0f) {
            center.y += MAX(self.latestDelta, self.latestDelta * scrollResistance);
        }
        else {
            center.y += MIN(self.latestDelta, self.latestDelta * scrollResistance);
        }
        item.center = center;
    }
}

@end
