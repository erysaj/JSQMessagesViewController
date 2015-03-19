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

@end
