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

#import "JSQMessagesCollectionViewAdapter.h"

#import "JSQMessagesCollectionViewCellIncoming.h"
#import "JSQMessagesCollectionViewCellOutgoing.h"
#import "JSQMessagesTypingIndicatorFooterView.h"
#import "JSQMessagesLoadEarlierHeaderView.h"


@interface JSQMessagesCollectionViewAdapter ()
{
    NSString *_senderId;
}

@property (nonatomic, strong) id<JSQMessageData> currMessage;
@property (nonatomic, strong) id<JSQMessageData> prevMessage;
@property (nonatomic, assign) BOOL isOutgoingMessage;

@end


@implementation JSQMessagesCollectionViewAdapter

- (instancetype)initWithDataSource:(id<JSQItemDataSource>)dataSource senderId:(NSString *)senderId
{
    NSParameterAssert(senderId);
    
    self = [self initWithDataSource:dataSource];
    if (self) {
        _senderId = senderId;
        
        self.incomingCellIdentifier = [JSQMessagesCollectionViewCellIncoming cellReuseIdentifier];
        self.outgoingCellIdentifier = [JSQMessagesCollectionViewCellOutgoing cellReuseIdentifier];
        self.incomingMediaCellIdentifier = [JSQMessagesCollectionViewCellIncoming mediaCellReuseIdentifier];
        self.outgoingMediaCellIdentifier = [JSQMessagesCollectionViewCellOutgoing mediaCellReuseIdentifier];
    }
    return self;
}

#pragma mark - JSQCollectionViewAdapterBase overrides

- (void)registerCellsForCollectionView:(UICollectionView *)collectionView
{
    [collectionView registerNib:[JSQMessagesCollectionViewCellIncoming nib]
     forCellWithReuseIdentifier:self.incomingCellIdentifier];
    
    [collectionView registerNib:[JSQMessagesCollectionViewCellOutgoing nib]
     forCellWithReuseIdentifier:self.outgoingCellIdentifier];
    
    [collectionView registerNib:[JSQMessagesCollectionViewCellIncoming nib]
     forCellWithReuseIdentifier:self.incomingMediaCellIdentifier];
    
    [collectionView registerNib:[JSQMessagesCollectionViewCellOutgoing nib]
     forCellWithReuseIdentifier:self.outgoingMediaCellIdentifier];
    
    [collectionView registerNib:[JSQMessagesTypingIndicatorFooterView nib]
     forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
            withReuseIdentifier:[JSQMessagesTypingIndicatorFooterView footerReuseIdentifier]];
    
    [collectionView registerNib:[JSQMessagesLoadEarlierHeaderView nib]
     forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
            withReuseIdentifier:[JSQMessagesLoadEarlierHeaderView headerReuseIdentifier]];
}

- (void)setCurrentItemIndexPath:(NSIndexPath *)indexPath
{
    self.currMessage = [self.dataSource itemAtIndexPath:indexPath];
    if (indexPath.item > 0) {
        NSIndexPath *prevIndexPath = [NSIndexPath indexPathForItem:(indexPath.item - 1) inSection:indexPath.section];
        self.prevMessage = [self.dataSource itemAtIndexPath:prevIndexPath];
    }
    else {
        self.prevMessage = nil;
    }
    
    self.isOutgoingMessage = [_senderId isEqualToString:[_currMessage senderId]];
}

- (Class<JSQCollectionViewCell>)cellClassForCurrentItem
{
    return [JSQMessagesCollectionViewCell class];
}

- (NSString *)reuseIdentifierForCurrentItem
{
    BOOL isMediaMessage = [_currMessage isMediaMessage];
    
    if (isMediaMessage) {
        return _isOutgoingMessage ? self.outgoingMediaCellIdentifier : self.incomingMediaCellIdentifier;
    }
    else {
        return _isOutgoingMessage ? self.outgoingCellIdentifier : self.incomingCellIdentifier;
    }
}

- (id<JSQCollectionViewCellDisplayData>)displayDataForCurrentItem
{
    return nil;
}

- (id)cacheKeyForCurrentItem
{
    return @([self.currMessage messageHash]);
}

@end
