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

#import "DemoMessagesAdapter.h"

@interface DemoMessagesAdapter ()

@property (nonatomic, assign) BOOL showCellTopLabel;
@property (nonatomic, assign) BOOL showMessageBubbleTopLabel;

@end


@implementation DemoMessagesAdapter

- (instancetype)initWithModel:(DemoModelData *)model
{
    JSQArrayItemDataSource *dataSource = [[JSQArrayItemDataSource alloc] initWithItems:model.messages];
    self = [self initWithDataSource:dataSource senderId:nil];
    if (self) {
        self.model = model;
    }
    return self;
}

#pragma mark - JSQCollectionViewAdapter overrides

- (void)setCurrentItemIndexPath:(NSIndexPath *)indexPath
{
    [super setCurrentItemIndexPath:indexPath];
    
    /**
     *  Logic in `attributedTextForCellTopLabel` and `cellTopLabelHeight` must be consistent.
     *  The other label-related protocol methods should follow similarly
     *
     *  Show a timestamp for every 3rd message
     */
    self.showCellTopLabel = (indexPath.item % 3 == 0);
    
    /**
     *  iOS7-style sender name labels
     */
    BOOL prevMessageHasSameSender = self.prevMessage && [[self.prevMessage senderId] isEqualToString:[self.currMessage senderId]];
    self.showMessageBubbleTopLabel = ![self isOutgoingMessage] && !prevMessageHasSameSender;
}

#pragma mark - JSQMessagesCollectionViewCellData

- (id<JSQMessageAvatarImageDataSource>)avatarImageData
{
    /**
     *  Return `nil` here if you do not want avatars.
     *  If you do return `nil`, be sure to do the following in `viewDidLoad`:
     *
     *  self.incomingAvatarViewSize = CGSizeZero;
     *  self.outgoingAvatarViewSize = CGSizeZero;
     *
     *  It is possible to have only outgoing avatars or only incoming avatars, too.
     */
    
    /**
     *  Return your previously created avatar image data objects.
     *
     *  Note: these the avatars will be sized according to these values:
     *
     *  self.incomingAvatarViewSize
     *  self.outgoingAvatarViewSize
     *
     *  Override the defaults in `viewDidLoad`
     */

    return [self.model.avatars objectForKey:self.currMessage.senderId];
}

- (id<JSQMessageBubbleImageDataSource>)messageBubbleImageData
{
    /**
     *  You may return nil here if you do not want bubbles.
     *  In this case, you should set the background color of your collection view cell's textView.
     *
     *  Otherwise, return your previously created bubble image data objects.
     */
    
    return [self isOutgoingMessage]? self.model.outgoingBubbleImageData: self.model.incomingBubbleImageData;
}

- (CGFloat)cellTopLabelHeight
{
    if (self.showCellTopLabel) {
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    return 0.0f;
}

- (NSAttributedString *)attributedTextForCellTopLabel
{
    if (self.showCellTopLabel) {
        return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:[self.currMessage date]];
    }
    
    return nil;
}

- (CGFloat)messageBubbleTopLabelHeight
{
    if (self.showMessageBubbleTopLabel) {
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    
    return 0.0f;
}

- (NSAttributedString *)attributedTextForMessageBubbleTopLabel
{
    if (self.showMessageBubbleTopLabel) {
        /**
         *  Don't specify attributes to use the defaults.
         */
        return [[NSAttributedString alloc] initWithString:[self.currMessage senderDisplayName]];
    }
    return nil;
}

- (CGFloat)cellBottomLabelHeight
{
    return 0.0f;
}

- (NSAttributedString *)attributedTextForCellBottomLabel
{
    return nil;
}

@end
