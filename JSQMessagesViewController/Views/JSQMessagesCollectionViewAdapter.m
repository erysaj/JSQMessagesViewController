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


const CGFloat kJSQMessagesCollectionViewCellLabelHeightDefault = 20.0f;
const CGFloat kJSQMessagesCollectionViewAvatarSizeDefault = 30.0f;


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
        
        _messageBubbleFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            _messageBubbleLeftRightMargin = 240.0f;
        }
        else {
            _messageBubbleLeftRightMargin = 50.0f;
        }
        
        _messageBubbleTextViewFrameInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 6.0f);
        _messageBubbleTextViewTextContainerInsets = UIEdgeInsetsMake(7.0f, 14.0f, 7.0f, 14.0f);
        
        CGSize defaultAvatarSize = CGSizeMake(kJSQMessagesCollectionViewAvatarSizeDefault, kJSQMessagesCollectionViewAvatarSizeDefault);
        _incomingAvatarViewSize = defaultAvatarSize;
        _outgoingAvatarViewSize = defaultAvatarSize;
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
    return self;
}

- (id)cacheKeyForCurrentItem
{
    return @([self.currMessage messageHash]);
}

#pragma mark -

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [super collectionView:collectionView cellForItemAtIndexPath:indexPath];
}

#pragma mark - Setters

- (void)setMessageBubbleFont:(UIFont *)messageBubbleFont
{
    if ([_messageBubbleFont isEqual:messageBubbleFont]) {
        return;
    }
    
    NSParameterAssert(messageBubbleFont != nil);
    _messageBubbleFont = messageBubbleFont;
// FIXME:
//    [self invalidateLayoutWithContext:[JSQMessagesCollectionViewFlowLayoutInvalidationContext context]];
}

- (void)setMessageBubbleLeftRightMargin:(CGFloat)messageBubbleLeftRightMargin
{
    NSParameterAssert(messageBubbleLeftRightMargin >= 0.0f);
    _messageBubbleLeftRightMargin = ceilf(messageBubbleLeftRightMargin);
// FIXME:
//    [self invalidateLayoutWithContext:[JSQMessagesCollectionViewFlowLayoutInvalidationContext context]];
}

- (void)setMessageBubbleTextViewTextContainerInsets:(UIEdgeInsets)messageBubbleTextContainerInsets
{
    if (UIEdgeInsetsEqualToEdgeInsets(_messageBubbleTextViewTextContainerInsets, messageBubbleTextContainerInsets)) {
        return;
    }
    
    _messageBubbleTextViewTextContainerInsets = messageBubbleTextContainerInsets;
// FIXME:
//    [self invalidateLayoutWithContext:[JSQMessagesCollectionViewFlowLayoutInvalidationContext context]];
}

- (void)setIncomingAvatarViewSize:(CGSize)incomingAvatarViewSize
{
    if (CGSizeEqualToSize(_incomingAvatarViewSize, incomingAvatarViewSize)) {
        return;
    }
    
    _incomingAvatarViewSize = incomingAvatarViewSize;
// FIXME:
//    [self invalidateLayoutWithContext:[JSQMessagesCollectionViewFlowLayoutInvalidationContext context]];
}

- (void)setOutgoingAvatarViewSize:(CGSize)outgoingAvatarViewSize
{
    if (CGSizeEqualToSize(_outgoingAvatarViewSize, outgoingAvatarViewSize)) {
        return;
    }
    
    _outgoingAvatarViewSize = outgoingAvatarViewSize;
// FIXME:
//    [self invalidateLayoutWithContext:[JSQMessagesCollectionViewFlowLayoutInvalidationContext context]];
}

#pragma mark - Cell display data

- (id<JSQMessageData>)messageData
{
    return _currMessage;
}

- (CGSize)avatarViewSize
{
    return _isOutgoingMessage? _outgoingAvatarViewSize: _incomingAvatarViewSize;
}

- (CGFloat)cellTopLabelHeight
{
    return 0.0f;
}

- (CGFloat)cellBottomLabelHeight
{
    return 0.0f;
}

- (CGFloat)messageBubbleTopLabelHeight
{
    return 0.0f;
}

@end
