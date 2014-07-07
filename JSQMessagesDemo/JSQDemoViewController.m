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

#import "JSQDemoViewController.h"
#import "JSQDemoMessage.h"
#import "JSQDemoUser.h"
#import "JSQDemoImageCache.h"
#import "UIImageView+JSQDemoImageCache.h"


static NSString * const kJSQDemoUserNameCook = @"Tim Cook";
static NSString * const kJSQDemoUserNameJobs = @"Jobs";
static NSString * const kJSQDemoUserNameWoz = @"Steve Wozniak";
static NSString * const kJSQDemoUserNameJSQ = @"Jesse Squires";

static CGSize const kDefaultAvatarSize = {34.0, 34.0};
static CGFloat const kDefaultCellLabelHeight = 20.0f;

static NSString * const kTextCellIdentifier = @"JSQDemoTextMessage";
static NSString * const kMediaCellIdentifier = @"JSQDemoMediaMessage";

typedef NS_ENUM(NSInteger, JSQDemoMessageDirection)
{
    JSQDemoMessageDirectionNone,
    JSQDemoMessageDirectionOutgoing,
    JSQDemoMessageDirectionIncoming,
};

@interface JSQDemoViewController () <JSQMessagesCollectionViewCellDelegate,
                                    JSQMessagesLoadEarlierHeaderViewDelegate>


@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) NSMutableDictionary *users;

@property (strong, nonatomic) JSQDemoImageCache *cache;

@property (strong, nonatomic) JSQMessagesBubbleMessageViewMetrics *defaultIncomingMessageContentMetrics;
@property (strong, nonatomic) JSQMessagesBubbleMessageViewMetrics *defaultOutgoingMessageContentMetrics;

- (void)receiveMessagePressed:(UIBarButtonItem *)sender;

- (void)closePressed:(UIBarButtonItem *)sender;

- (void)setupTestModel;
- (void)setupCollectionView;

@end


@implementation JSQDemoViewController

#pragma mark - Demo setup

- (void)setupTestModel
{
    /**
     * Load facke users
     */
    JSQDemoUser *userJSQ = [[JSQDemoUser alloc] initWithName:kJSQDemoUserNameJSQ
                                                   avatarURL:[NSURL URLWithString:@"dummy://avatar/jesse.squires"]];
    JSQDemoUser *userCook = [[JSQDemoUser alloc] initWithName:kJSQDemoUserNameCook
                                                    avatarURL:[NSURL URLWithString:@"dummy://avatar/tim.cook"]];
    JSQDemoUser *userJobs = [[JSQDemoUser alloc] initWithName:kJSQDemoUserNameJobs
                                                    avatarURL:[NSURL URLWithString:@"dummy://avatar/steve.jobs"]];
    JSQDemoUser *userWoz = [[JSQDemoUser alloc] initWithName:kJSQDemoUserNameWoz
                                                   avatarURL:[NSURL URLWithString:@"dummy://avatar/steve.wozniak"]];
    for (JSQDemoUser *user in @[userJSQ, userCook, userJobs, userWoz]) {
        self.users[user.displayName] = user;
    }

    
    /**
     *  Load some fake messages for demo.
     *
     *  You should have a mutable array or orderedSet, or something.
     */
    NSArray *predefinedMessages = @[
        [JSQDemoTextMessage messageWithText:@"http://wikipedia.org"
                                     sender:userJSQ
                                       date:[NSDate distantPast]],

//        [JSQDemoTextMessage messageWithText:@"Welcome to JSQMessages: A messaging UI framework for iOS."
//                                     sender:userJSQ
//                                       date:[NSDate distantPast]],
//        [JSQDemoTextMessage messageWithText:@"It is simple, elegant, and easy to use. There are super sweet default settings, but you can customize like crazy."
//                                     sender:userWoz
//                                       date:[NSDate distantPast]],
//        [JSQDemoTextMessage messageWithText:@"It even has data detectors. You can call me tonight. My cell number is 123-456-7890. My website is www.hexedbits.com."
//                                     sender:userJSQ
//                                       date:[NSDate distantPast]],
//        [JSQDemoTextMessage messageWithText:@"JSQMessagesViewController is nearly an exact replica of the iOS Messages App. And perhaps, better."
//                                     sender:userJobs
//                                       date:[NSDate date]],
//        [JSQDemoTextMessage messageWithText:@"It is unit-tested, free, and open-source."
//                                     sender:userCook
//                                       date:[NSDate date]],
//        [JSQDemoTextMessage messageWithText:@"Oh, and there's sweet documentation."
//                                     sender:userJSQ
//                                       date:[NSDate date]],
//        [JSQDemoImageMessage messageWithImage:[UIImage imageNamed:@"LaunchImage-700"]
//                                       sender:userJSQ
//                                         date:[NSDate distantPast]],

    ];
    self.messages = [[NSMutableArray alloc] initWithArray:predefinedMessages];
    
    /**
     *  Create avatar images once.
     *
     *  Be sure to create your avatars one time and reuse them for good performance.
     *
     *  If you are not using avatars, ignore this.
     */
    CGFloat outgoingDiameter = kDefaultAvatarSize.width;
    
    UIImage *avatarJSQ = [JSQMessagesAvatarFactory avatarWithUserInitials:@"JSQ"
                                                          backgroundColor:[UIColor colorWithWhite:0.85f alpha:1.0f]
                                                                textColor:[UIColor colorWithWhite:0.60f alpha:1.0f]
                                                                     font:[UIFont systemFontOfSize:14.0f]
                                                                 diameter:outgoingDiameter];
    [self.cache cacheImage:avatarJSQ forURL:userJSQ.avatarURL];
    
    
    CGFloat incomingDiameter = kDefaultAvatarSize.width;
    UIImage *avatarCook = [JSQMessagesAvatarFactory avatarWithImage:[UIImage imageNamed:@"demo_avatar_cook"]
                                                           diameter:incomingDiameter];
    [self.cache cacheImage:avatarCook forURL:userCook.avatarURL];

    UIImage *avatarJobs = [JSQMessagesAvatarFactory avatarWithImage:[UIImage imageNamed:@"demo_avatar_jobs"]
                                                           diameter:incomingDiameter];
    [self.cache cacheImage:avatarJobs forURL:userJobs.avatarURL];

    UIImage *avatarWoz = [JSQMessagesAvatarFactory avatarWithImage:[UIImage imageNamed:@"demo_avatar_woz"]
                                                          diameter:incomingDiameter];
    [self.cache cacheImage:avatarWoz forURL:userWoz.avatarURL];


    /**
     *  Change to add more messages for testing
     */
    NSUInteger messagesToAdd = 0;
    NSArray *copyOfMessages = [self.messages copy];
    for (NSUInteger i = 0; i < messagesToAdd; i++) {
        [self.messages addObjectsFromArray:copyOfMessages];
    }
    
    /**
     *  Change to YES to add a super long message for testing
     *  You should see "END" twice
     */
    BOOL addREALLYLongMessage = NO;
    if (addREALLYLongMessage) {
        JSQDemoTextMessage *reallyLongMessage = [JSQDemoTextMessage messageWithText:@"Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur? END Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur? END" sender:userJSQ];
        [self.messages addObject:reallyLongMessage];
    }
}



#pragma mark - View lifecycle

/**
 *  Override point for customization.
 *
 *  Customize your view.
 *  Look at the properties on `JSQMessagesViewController` to see what is possible.
 *
 *  Customize your layout.
 *  Look at the properties on `JSQMessagesCollectionViewFlowLayout` to see what is possible.
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"JSQMessages";

    [self setupTestModel];
    self.sender = self.users[kJSQDemoUserNameJSQ];
    

    [self setupCollectionView];
    
    /**
     *  Remove camera button since media messages are not yet implemented
     *
     *   self.inputToolbar.contentView.leftBarButtonItem = nil;
     *
     *  Or, you can set a custom `leftBarButtonItem` and a custom `rightBarButtonItem`
     */
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"typing"]
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(receiveMessagePressed:)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.delegateModal) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                                                              target:self
                                                                                              action:@selector(closePressed:)];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    /**
     *  Enable/disable springy bubbles, default is YES.
     *  For best results, toggle from `viewDidAppear:`
     */
    self.collectionView.collectionViewLayout.springinessEnabled = YES;
}

#pragma mark - Actions

- (void)receiveMessagePressed:(UIBarButtonItem *)sender
{
    /**
     *  The following is simply to simulate received messages for the demo.
     *  Do not actually do this.
     */
    
    
    /**
     *  Show the typing indicator
     */
    self.showTypingIndicator = !self.showTypingIndicator;
    
    JSQDemoTextMessage *prototype = nil;
    for (JSQDemoMessage *msg in self.messages) {
        if (msg.type == JSQDemoMessageTypeText) {
            prototype = (JSQDemoTextMessage *)msg;
        }
    }
    
    if (!prototype) {
        return;
    }

    NSMutableArray *copyUsers = [[self.users allValues] mutableCopy];
    [copyUsers removeObject:self.sender];
    JSQDemoUser *randomUser = [copyUsers objectAtIndex:arc4random_uniform((uint32_t)[copyUsers count])];
    
    JSQDemoMessage *msg = [JSQDemoTextMessage messageWithText:prototype.text sender:randomUser];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        /**
         *  This you should do upon receiving a message:
         *
         *  1. Play sound (optional)
         *  2. Add new id<JSQMessageData> object to your data source
         *  3. Call `finishReceivingMessage`
         */
        [JSQSystemSoundPlayer jsq_playMessageReceivedSound];
        [self.messages addObject:msg];
        [self finishReceivingMessage];
    });
}

- (void)closePressed:(UIBarButtonItem *)sender
{
    [self.delegateModal didDismissJSQDemoViewController:self];
}

#pragma mark - Messages collection view cell delegate

- (void)messagesCollectionViewCellDidTapAvatar:(JSQMessagesGenericCell *)cell
{
    NSLog(@"Avatar tapped!");
}

#pragma mark - JSQMessagesViewController method overrides

- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                    sender:(id)sender
                      date:(NSDate *)date
{
    /**
     *  Sending a message. Your implementation of this method should do *at least* the following:
     *
     *  1. Play sound (optional)
     *  2. Add new id<JSQMessageData> object to your data source
     *  3. Call `finishSendingMessage`
     */
    [JSQSystemSoundPlayer jsq_playMessageSentSound];
    
    JSQDemoTextMessage *message = [JSQDemoTextMessage messageWithText:text sender:sender date:date];
    [self.messages addObject:message];
    
    [self finishSendingMessage];
}

- (void)didPressAccessoryButton:(UIButton *)sender
{
    NSLog(@"Camera pressed!");
    /**
     *  Accessory button has no default functionality, yet.
     */
}

#pragma mark - UICollectionView data source

//- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    JSQDemoMessage *message = [_messages objectAtIndex:indexPath.item];
//    BOOL isOutgoing = [self.sender isEqual:message.sender];
//    JSQDemoMessageDirection direction = isOutgoing? JSQDemoMessageDirectionOutgoing: JSQDemoMessageDirectionIncoming;
//    NSString *reuseIdentifier = [self reuseIdentifierForMessageType:message.type direction:direction];
//    
//    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
//    
//    id metrics = [self metricsForMessage:message atIndexPath:indexPath];
//    CGSize contentSize = [self contentSizeOfMessage:message atIndexPath:indexPath];
//    CGSize cellSizeConstraint = CGSizeMake([self.collectionView.collectionViewLayout itemWidth], CGFLOAT_MAX);
//
//    switch (message.type) {
//        case JSQDemoMessageTypeText: {
//            JSQDemoTextMessage *textMsg = (JSQDemoTextMessage *)message;
//            JSQMessagesGenericTextCell *textCell = (JSQMessagesGenericTextCell *)cell;
//            
//            [self configureCell:textCell withTextMessage:textMsg indexPath:indexPath];
//            [textCell applyMetrics:metrics contentSize:contentSize cellSizeConstraint:cellSizeConstraint];
//            break;
//        }
//        
//        case JSQDemoMessageTypeImage: {
//            JSQDemoImageMessage *imageMsg = (JSQDemoImageMessage *)message;
//            JSQMessagesGenericMediaCell *mediaCell = (JSQMessagesGenericMediaCell *)cell;
//            
//            [self configureCell:mediaCell withImageMessage:imageMsg indexPath:indexPath];
//            [mediaCell applyMetrics:metrics contentSize:contentSize cellSizeConstraint:cellSizeConstraint];
//            break;
//        }
//            
//        default:
//            break;
//    }
//
//    return cell;
//}

#pragma mark - setup UICollectionView

- (NSString *)reuseIdentifierForMessageType:(JSQDemoMessageType)type direction:(JSQDemoMessageDirection)direction
{
    NSString *suffix = nil;
    switch (direction) {
        case JSQDemoMessageDirectionNone:
            suffix = @"";
            break;
        case JSQDemoMessageDirectionIncoming:
            suffix = @"-Incoming";
            break;
        case JSQDemoMessageDirectionOutgoing:
            suffix = @"-Outgoing";
            break;
    }
    
    switch (type) {
        case JSQDemoMessageTypeText:
            return [kTextCellIdentifier stringByAppendingString:suffix];
            
        case JSQDemoMessageTypeImage:
            return [kMediaCellIdentifier stringByAppendingString:suffix];
            
        default:
            break;
    }
    return nil;
}

- (void)setupCollectionView
{
    JSQMessagesArrayItemDataSource *messages = [[JSQMessagesArrayItemDataSource alloc] initWithItems:self.messages];
    self.dataSource = messages;
    
    // text messages
    [self.collectionView registerClass:[JSQMessagesGenericTextCell class]
            forCellWithReuseIdentifier:[self reuseIdentifierForMessageType:JSQDemoMessageTypeText direction:JSQDemoMessageDirectionOutgoing]];
    [self.collectionView registerClass:[JSQMessagesGenericTextCell class]
            forCellWithReuseIdentifier:[self reuseIdentifierForMessageType:JSQDemoMessageTypeText direction:JSQDemoMessageDirectionIncoming]];
    
    // media messages
    [self.collectionView registerClass:[JSQMessagesGenericMediaCell class]
            forCellWithReuseIdentifier:[self reuseIdentifierForMessageType:JSQDemoMessageTypeImage direction:JSQDemoMessageDirectionOutgoing]];
    [self.collectionView registerClass:[JSQMessagesGenericMediaCell class]
            forCellWithReuseIdentifier:[self reuseIdentifierForMessageType:JSQDemoMessageTypeImage direction:JSQDemoMessageDirectionIncoming]];
    
    // footer
    [self.collectionView registerNib:[JSQMessagesTypingIndicatorFooterView nib]
          forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                 withReuseIdentifier:[JSQMessagesTypingIndicatorFooterView footerReuseIdentifier]];

    // header
    [self.collectionView registerNib:[JSQMessagesLoadEarlierHeaderView nib]
          forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                 withReuseIdentifier:[JSQMessagesLoadEarlierHeaderView headerReuseIdentifier]];
    
    // bubble metrics
    JSQMessagesBubbleMessageViewMetrics *contentMetrics;
    contentMetrics = [[JSQMessagesBubbleMessageViewMetrics alloc] init];
    contentMetrics.insets = UIEdgeInsetsMake(0.0f, 40.0f, 0.0f, 0.0f);
    contentMetrics.contentInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 6.0f);
    contentMetrics.avatarSize = kDefaultAvatarSize;
    self.defaultOutgoingMessageContentMetrics = contentMetrics;
    
    contentMetrics = [[JSQMessagesBubbleMessageViewMetrics alloc] init];
    contentMetrics.insets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 40.0f);
    contentMetrics.contentInsets = UIEdgeInsetsMake(0.0f, 6.0f, 0.0f, 0.0f);
    contentMetrics.avatarSize = kDefaultAvatarSize;
    self.defaultIncomingMessageContentMetrics = contentMetrics;
}

#pragma mark - cell metrics / style

- (id)styleForMessage:(JSQDemoMessage *)message atIndexPath:(NSIndexPath *)index
{
    id style = nil;
    
    switch (message.type) {
        case JSQDemoMessageTypeText: {
            JSQMessagesGenericTextCellAttributes *textStyle = [[JSQMessagesGenericTextCellAttributes alloc] init];
            textStyle.textFont = [UIFont systemFontOfSize:15.0f];
            style = textStyle;
            break;
        }
            
        default:
            break;
    }
    
    return style;
}

- (id)metricsForMessage:(JSQDemoMessage *)message atIndexPath:(NSIndexPath *)indexPath
{
    JSQMessagesGenericTextCellMetrics *metrics = nil;
    BOOL isOutgoing = [message.sender isEqual:self.sender];

    switch (message.type) {
        case JSQDemoMessageTypeText: {
            JSQMessagesGenericTextCellMetrics *textMetrics = [[JSQMessagesGenericTextCellMetrics alloc] init];
            textMetrics.textContainerInsets = UIEdgeInsetsMake(10.0f, 8.0f, 10.0f, 8.0f);
            metrics = textMetrics;
            break;
        }
            
        case JSQDemoMessageTypeImage: {
            metrics = [[JSQMessagesGenericTextCellMetrics alloc] init];
            break;
        }
            
        default:
            return nil;
    }
    
    // timestamp
    BOOL shouldDisplayTimestamp = indexPath.item % 3 == 0;
    metrics.cellTopLabelHeight = shouldDisplayTimestamp? kDefaultCellLabelHeight: 0.0;
    
    // iOS7-style sender name labels
    JSQDemoMessage *prevMessage = (indexPath.item > 0)? _messages[indexPath.item - 1]: nil;
    BOOL isMatchingPreviousSender = [message.sender isEqual:prevMessage.sender];
    BOOL shouldDisplayName = !isMatchingPreviousSender && !isOutgoing;
    metrics.messageTopLabelHeight = shouldDisplayName? kDefaultCellLabelHeight: 0.0;
    
    // bottom label
    metrics.cellBottomLabelHeight = 0.0f;
    
    // bubble
    metrics.messageMetrics = isOutgoing? self.defaultOutgoingMessageContentMetrics: self.defaultIncomingMessageContentMetrics;

    return metrics;
}

- (void)configureCell:(JSQMessagesGenericCell *)cell withMessage:(JSQDemoMessage *)message atIndexPath:(NSIndexPath *)indexPath
{
    cell.delegate = self;

    UIColor *outgoingBubbleColor = [UIColor jsq_messageBubbleLightGrayColor];
    UIColor *incomingBubbleColor = [UIColor jsq_messageBubbleGreenColor];
    
    UIImage *bubbleMask = [UIImage imageNamed:@"bubble_min"];
    UIEdgeInsets maskInsets = UIEdgeInsetsMake(bubbleMask.size.width * 0.5f, bubbleMask.size.height * 0.5f, bubbleMask.size.width * 0.5f, bubbleMask.size.height * 0.5);
    //    UIImageView *outgoingBubbleImageView = [JSQMessagesBubbleImageFactory
    //                                            outgoingMessageBubbleImageViewWithColor:outgoingBubbleColor];
    //    UIImageView *incomingBubbleImageView = [JSQMessagesBubbleImageFactory
    //                                            incomingMessageBubbleImageViewWithColor:incomingBubbleColor];
    
    JSQDemoUser *messageSender = message.sender;
    NSParameterAssert(messageSender != nil);
    
    BOOL isOutgoing = [message.sender isEqual:self.sender];
    
    // setup message direction
    cell.messageView.avatarHorizontalAlign = isOutgoing? NSLayoutAttributeRight: NSLayoutAttributeLeft;
    cell.messageView.avatarVerticalAlign = NSLayoutAttributeBottom;
    cell.messageTopLabel.textAlignment = isOutgoing? NSTextAlignmentRight: NSTextAlignmentLeft;
    cell.cellBottomLabel.textAlignment = isOutgoing? NSTextAlignmentRight: NSTextAlignmentLeft;
    cell.messageView.bubbleView.flipped = !isOutgoing;
    
    // avatar
    NSURL *avatarURL = messageSender.avatarURL;
    // set avatar image synchronously ...
    cell.messageView.avatarView.image = [self.cache imageForURL:avatarURL];
    
    // ... or asynchronously
    //        [cell.messageContent.avatarView jsq_setImageURL:avatarURL fromCache:self.cache];
    
    // timestamp
    /**
     *  This logic should be consistent with logic in metricsForMessage:atIndexPath:direction:
     *  Show a timestamp for every 3rd message
     */
    BOOL shouldDisplayTimestamp = indexPath.item % 3 == 0;
    cell.cellTopLabel.attributedText = shouldDisplayTimestamp? [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date]: nil;
    
    
    // iOS7-style sender name labels
    JSQDemoMessage *prevMessage = (indexPath.item > 0)? _messages[indexPath.item - 1]: nil;
    BOOL isMatchingPreviousSender = [messageSender isEqual:prevMessage.sender];
    BOOL shouldDisplayName = !isMatchingPreviousSender && !isOutgoing;
    cell.messageTopLabel.text = shouldDisplayName? messageSender.displayName: nil;
    cell.messageTopLabel.textInsets = isOutgoing? UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 60.0): UIEdgeInsetsMake(0.0f, 60.0f, 0.0f, 0.0);
    
    // additional bottom label
    cell.cellBottomLabel.attributedText = nil;
    
    // configure background
    cell.backgroundColor = [UIColor clearColor];
    if (isOutgoing) {
        //            [cell.messageContent.bubbleView setBubbleImage:outgoingBubbleImageView.image
        //                                          highlightedImage:outgoingBubbleImageView.highlightedImage];
        [cell.messageView.bubbleView setMask:bubbleMask
                                   capInsets:maskInsets
                                 bubbleColor:outgoingBubbleColor
                             highligtedColor:[outgoingBubbleColor jsq_colorByDarkeningColorWithValue:0.12f]];
    }
    else {
        //            [cell.messageContent.bubbleView setBubbleImage:incomingBubbleImageView.image
        //                                          highlightedImage:incomingBubbleImageView.highlightedImage];
        
        [cell.messageView.bubbleView setMask:bubbleMask
                                   capInsets:maskInsets
                                 bubbleColor:incomingBubbleColor
                             highligtedColor:[incomingBubbleColor jsq_colorByDarkeningColorWithValue:0.12f]];
    }
}

- (CGSize)contentSizeOfMessage:(JSQDemoMessage *)message
                   atIndexPath:(NSIndexPath *)indexPath
{
    NSValue *cachedContentSize = [self.collectionView.collectionViewLayout cachedContentSizeForItemAtIndexPath:indexPath];
    if (cachedContentSize) {
        return [cachedContentSize CGSizeValue];
    }
    
    id metrics = [self metricsForMessage:message atIndexPath:indexPath];
    id style = [self styleForMessage:message atIndexPath:indexPath];
    
    CGSize contentSize = CGSizeZero;
    CGSize cellSizeConstraint = CGSizeMake(self.collectionView.collectionViewLayout.itemWidth, CGFLOAT_MAX);
    
    switch (message.type) {
        case JSQDemoMessageTypeText: {
            JSQDemoTextMessage *textMessage = (JSQDemoTextMessage *)message;
            contentSize = [JSQMessagesGenericTextCell contentSizeForText:textMessage.text metrics:metrics style:style sizeConstraint:cellSizeConstraint];
            break;
        }
            
        case JSQDemoMessageTypeImage:
            contentSize = CGSizeMake(100.0f, 150.0f);
            break;
            
        default:
            break;
    }
    
    [self.collectionView.collectionViewLayout cacheContentSize:contentSize forItemAtIndexPath:indexPath];
    return contentSize;
}

- (void)configureCell:(JSQMessagesGenericTextCell *)cell withTextMessage:(JSQDemoTextMessage *)message indexPath:(NSIndexPath *)indexPath
{
    [self configureCell:cell withMessage:message atIndexPath:indexPath];
    
    JSQDemoUser *messageSender = message.sender;
    NSParameterAssert(messageSender != nil);
    
    JSQMessagesGenericTextCellAttributes *style = [self styleForMessage:message atIndexPath:indexPath];
    BOOL isOutgoing = [message.sender isEqual:self.sender];
    
    // message content
    NSString *messageText = message.text;
    NSParameterAssert(messageText != nil);
    cell.textView.text = messageText;
    cell.textView.font = style.textFont;
    cell.textView.textColor = isOutgoing? [UIColor blackColor]: [UIColor whiteColor];
    cell.textView.dataDetectorTypes = UIDataDetectorTypeAll;
    cell.textView.linkTextAttributes = @{
        NSForegroundColorAttributeName : cell.textView.textColor,
        NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid)
    };
}

- (void)configureCell:(JSQMessagesGenericMediaCell *)cell withImageMessage:(JSQDemoImageMessage *)message indexPath:(NSIndexPath *)indexPath
{
    
    [self configureCell:cell withMessage:message atIndexPath:indexPath];
    
    // message content
    cell.thumbnailImageView.image = message.image;
}

#pragma mark - Load earlier messages header delegate

- (void)headerView:(JSQMessagesLoadEarlierHeaderView *)headerView didPressLoadButton:(UIButton *)sender
{
    NSLog(@"Load earlier messages!");
}

#pragma mark - Properties

- (NSMutableDictionary *)users
{
    if (!_users) {
        _users = [[NSMutableDictionary alloc] init];
    }
    return _users;
}

- (JSQDemoImageCache *)cache
{
    if (!_cache) {
        _cache = [[JSQDemoImageCache alloc] init];
    }
    return _cache;
}

@end
