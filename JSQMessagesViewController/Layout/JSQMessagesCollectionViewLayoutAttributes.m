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

#import "JSQMessagesCollectionViewLayoutAttributes.h"


@implementation JSQMessagesCollectionViewLayoutAttributes

#pragma mark - Lifecycle

- (void)dealloc
{
    _messageBubbleFont = nil;
    _systemMessageFont = nil;
    _timestampFont = nil;
    _messageBubbleImageIconCenterOffset = 0;
}

#pragma mark - Setters

- (void)setMessageBubbleFont:(UIFont *)messageBubbleFont
{
    NSAssert(messageBubbleFont, @"ERROR: messageBubbleFont must not be nil: %s", __PRETTY_FUNCTION__);
    _messageBubbleFont = messageBubbleFont;
}

- (void)setTimestampFont:(UIFont *)timestampFont
{
    NSAssert(timestampFont, @"ERROR: timestampFont must not be nil: %s", __PRETTY_FUNCTION__);
    _timestampFont = timestampFont;
}

- (void)setSystemMessageFont:(UIFont *)systemMessageFont
{
    NSAssert(systemMessageFont, @"ERROR: systemMessageFont must not be nil: %s", __PRETTY_FUNCTION__);
    _systemMessageFont = systemMessageFont;
}

- (void)setMessageBubbleWidth:(CGFloat)messageBubbleWidth
{
    NSAssert(messageBubbleWidth >= 0.0f, @"ERROR: messageBubbleWidth must be greater than or equal to 0: %s", __PRETTY_FUNCTION__);
    _messageBubbleWidth = ceilf(messageBubbleWidth);
}

- (void)setIncomingAvatarViewSize:(CGSize)incomingAvatarViewSize
{
    NSAssert(incomingAvatarViewSize.width >= 0.0f && incomingAvatarViewSize.height >= 0.0f,
             @"ERROR: incomingAvatarViewSize values must be greater than or equal to 0: %s", __PRETTY_FUNCTION__);
    
    _incomingAvatarViewSize = CGSizeMake(ceil(incomingAvatarViewSize.width), ceilf(incomingAvatarViewSize.height));
}

- (void)setOutgoingAvatarViewSize:(CGSize)outgoingAvatarViewSize
{
    NSAssert(outgoingAvatarViewSize.width >= 0.0f && outgoingAvatarViewSize.height >= 0.0f,
             @"ERROR: outgoingAvatarViewSize values must be greater than or equal to 0: %s", __PRETTY_FUNCTION__);
    
    _outgoingAvatarViewSize = CGSizeMake(ceil(outgoingAvatarViewSize.width), ceilf(outgoingAvatarViewSize.height));
}

- (void)setActionButtonHeight:(CGFloat)actionButtonHeight
{
    NSAssert(actionButtonHeight >= 0.0f,
             @"ERROR: actionButtonHeight value must be greater than or equal to 0: %s", __PRETTY_FUNCTION__);
    
    _actionButtonHeight = actionButtonHeight;
}

- (void)setCellTopLabelHeight:(CGFloat)cellTopLabelHeight
{
    NSAssert(cellTopLabelHeight >= 0.0f, @"ERROR: cellTopLabelHeight must be greater than or equal to 0: %s", __PRETTY_FUNCTION__);
    _cellTopLabelHeight = floorf(cellTopLabelHeight);
}

- (void)setMessageBubbleTopLabelHeight:(CGFloat)messageBubbleTopLabelHeight
{
    NSAssert(messageBubbleTopLabelHeight >= 0.0f, @"ERROR: messageBubbleTopLabelHeight must be greater than or equal to 0: %s", __PRETTY_FUNCTION__);
    _messageBubbleTopLabelHeight = floorf(messageBubbleTopLabelHeight);
}

- (void)setCellBottomLabelHeight:(CGFloat)cellBottomLabelHeight
{
    NSAssert(cellBottomLabelHeight >= 0.0f, @"ERROR: cellBottomLabelHeight must be greater than or equal to 0: %s", __PRETTY_FUNCTION__);
    _cellBottomLabelHeight = floorf(cellBottomLabelHeight);
}

- (void)setmessageBubbleImageIconCenterOffset:(CGFloat)messageBubbleImageIconCenterOffset
{
    _messageBubbleImageIconCenterOffset = floorf(messageBubbleImageIconCenterOffset);
}

#pragma mark - NSObject

- (BOOL)isEqual:(id)object
{
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    JSQMessagesCollectionViewLayoutAttributes *layoutAttributes = (JSQMessagesCollectionViewLayoutAttributes *)object;
    
    if (![layoutAttributes.messageBubbleFont isEqual:self.messageBubbleFont]
        || ![layoutAttributes.timestampFont isEqual:self.timestampFont]
        || ![layoutAttributes.systemMessageFont isEqual:self.systemMessageFont]
        || !UIEdgeInsetsEqualToEdgeInsets(layoutAttributes.textViewFrameInsets, self.textViewFrameInsets)
        || !UIEdgeInsetsEqualToEdgeInsets(layoutAttributes.textViewTextContainerInsets, self.textViewTextContainerInsets)
        || !CGSizeEqualToSize(layoutAttributes.incomingAvatarViewSize, self.incomingAvatarViewSize)
        || !CGSizeEqualToSize(layoutAttributes.outgoingAvatarViewSize, self.outgoingAvatarViewSize)
        || (int)layoutAttributes.messageBubbleWidth != (int)self.messageBubbleWidth
        || (int)layoutAttributes.cellTopLabelHeight != (int)self.cellTopLabelHeight
        || (int)layoutAttributes.messageBubbleTopLabelHeight != (int)self.messageBubbleTopLabelHeight
        || (int)layoutAttributes.cellBottomLabelHeight != (int)self.cellBottomLabelHeight
        || (int)layoutAttributes.messageBubbleImageIconCenterOffset != (int)self.messageBubbleImageIconCenterOffset
        || (int)layoutAttributes.actionButtonHeight != (int)self.actionButtonHeight)
    {
        return NO;
    }
    
    return [super isEqual:object];
}

- (NSUInteger)hash
{
    return [self.indexPath hash]
            ^ (NSUInteger)self.cellTopLabelHeight
            ^ (NSUInteger)self.messageBubbleTopLabelHeight
            ^ (NSUInteger)self.cellBottomLabelHeight
            ^ (NSUInteger)self.actionButtonHeight;
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone
{
    JSQMessagesCollectionViewLayoutAttributes *copy = [super copyWithZone:zone];
    copy.messageBubbleFont = self.messageBubbleFont;
    copy.timestampFont = self.timestampFont;
    copy.systemMessageFont = self.systemMessageFont;
    copy.messageBubbleWidth = self.messageBubbleWidth;
    copy.textViewFrameInsets = self.textViewFrameInsets;
    copy.textViewTextContainerInsets = self.textViewTextContainerInsets;
    copy.incomingAvatarViewSize = self.incomingAvatarViewSize;
    copy.outgoingAvatarViewSize = self.outgoingAvatarViewSize;
    copy.cellTopLabelHeight = self.cellTopLabelHeight;
    copy.messageBubbleTopLabelHeight = self.messageBubbleTopLabelHeight;
    copy.cellBottomLabelHeight = self.cellBottomLabelHeight;
    copy.messageBubbleImageIconCenterOffset = self.messageBubbleImageIconCenterOffset;
    copy.actionButtonHeight = self.actionButtonHeight;
    return copy;
}

@end
