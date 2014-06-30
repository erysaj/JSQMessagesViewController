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

#import "JSQMessagesCollectionViewCell.h"

#import "JSQMessagesCollectionViewCellIncoming.h"
#import "JSQMessagesCollectionViewCellOutgoing.h"
#import "JSQMessagesCollectionViewCellSystem.h"
#import "JSQMessagesCollectionViewLayoutAttributes.h"

#import "UIView+JSQMessages.h"


@interface JSQMessagesCollectionViewCell ()

@property (weak, nonatomic) IBOutlet JSQMessagesLabel *cellTopLabel;
@property (weak, nonatomic) IBOutlet JSQMessagesLabel *messageBubbleTopLabel;
@property (weak, nonatomic) IBOutlet JSQMessagesLabel *cellBottomLabel;
@property (weak, nonatomic) IBOutlet JSQMessagesLabel *timestampLabel;
@property (weak, nonatomic) IBOutlet JSQMessagesLabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bubbleImageIconOverlay;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UIView *messageBubbleContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *messageBubbleImageView;

@property (weak, nonatomic) IBOutlet UIView *avatarContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewTopVerticalSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewBottomVerticalSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewAvatarHorizontalSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewMarginHorizontalSpaceConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellTopLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageBubbleTopLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellBottomLabelHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatarContainerViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatarContainerViewHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageBubbleWidthConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bubbleImageIconCenterConstraint;

@property (assign, nonatomic) UIEdgeInsets textViewFrameInsets;

@property (assign, nonatomic) CGSize avatarViewSize;

@property (weak, nonatomic, readwrite) UILongPressGestureRecognizer *longPressGestureRecognizer;
@property (weak, nonatomic, readwrite) UITapGestureRecognizer *avatarTapGestureRecognizer;
@property (weak, nonatomic, readwrite) UITapGestureRecognizer *bubbleTapGestureRecognizer;
@property (weak, nonatomic, readwrite) UITapGestureRecognizer *cellTapGestureRecognizer;

- (void)jsq_handleLongPressGesture:(UILongPressGestureRecognizer *)longPress;
- (void)jsq_handleAvatarTapGesture:(UITapGestureRecognizer *)tap;
- (void)jsq_handleBubbleTapGesture:(UITapGestureRecognizer *)tap;

- (void)jsq_didReceiveMenuWillHideNotification:(NSNotification *)notification;
- (void)jsq_didReceiveMenuWillShowNotification:(NSNotification *)notification;

- (void)jsq_updateConstraint:(NSLayoutConstraint *)constraint withConstant:(CGFloat)constant;

- (IBAction)resendFailedMessage:(id)sender;
@end



@implementation JSQMessagesCollectionViewCell

#pragma mark - Class methods

+ (UINib *)nib
{
    NSAssert(NO, @"ERROR: method must be overridden in subclasses: %s", __PRETTY_FUNCTION__);
    return nil;
}

+ (NSString *)cellReuseIdentifier
{
    NSAssert(NO, @"ERROR: method must be overridden in subclasses: %s", __PRETTY_FUNCTION__);
    return nil;
}

#pragma mark - Initialization

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.backgroundColor = [UIColor whiteColor];
    
    self.cellTopLabelHeightConstraint.constant = 0.0f;
    self.messageBubbleTopLabelHeightConstraint.constant = 0.0f;
    self.bubbleImageIconCenterConstraint.constant = 0.0f;
    self.cellBottomLabelHeightConstraint.constant = 0.0f;
    
    self.avatarViewSize = CGSizeZero;
    
    self.cellTopLabel.textAlignment = NSTextAlignmentCenter;
    self.cellTopLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    self.cellTopLabel.textColor = [UIColor lightGrayColor];
    
    self.messageBubbleTopLabel.font = [UIFont systemFontOfSize:12.0f];
    self.messageBubbleTopLabel.textColor = [UIColor lightGrayColor];
    
    self.cellBottomLabel.font = [UIFont systemFontOfSize:11.0f];
    self.cellBottomLabel.textColor = [UIColor lightGrayColor];
    
    self.textView.textColor = [UIColor whiteColor];
    self.textView.editable = NO;
    self.textView.selectable = YES;
    self.textView.userInteractionEnabled = YES;
    self.textView.dataDetectorTypes = UIDataDetectorTypeNone;
    self.textView.showsHorizontalScrollIndicator = NO;
    self.textView.showsVerticalScrollIndicator = NO;
    self.textView.scrollEnabled = NO;
    self.textView.backgroundColor = [UIColor clearColor];
    self.textView.contentInset = UIEdgeInsetsZero;
    self.textView.scrollIndicatorInsets = UIEdgeInsetsZero;
    self.textView.contentOffset = CGPointZero;
    self.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : [UIColor whiteColor],
                                          NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(jsq_handleLongPressGesture:)];
    longPress.minimumPressDuration = 0.4f;
    [self addGestureRecognizer:longPress];
    [self.messageBubbleContainerView addGestureRecognizer:longPress];
    self.longPressGestureRecognizer = longPress;
    
    UITapGestureRecognizer *avatarTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jsq_handleAvatarTapGesture:)];
    [self.avatarContainerView addGestureRecognizer:avatarTap];
    self.avatarTapGestureRecognizer = avatarTap;
    
    UITapGestureRecognizer *bubbleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jsq_handleBubbleTapGesture:)];
    [self.messageBubbleContainerView addGestureRecognizer:bubbleTap];
    self.bubbleTapGestureRecognizer = bubbleTap;
    
    UITapGestureRecognizer *cellTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jsq_handleCellTapGesture:)];
    [self addGestureRecognizer:cellTap];
    self.cellTapGestureRecognizer = cellTap;
}

- (void)dealloc
{
    _delegate = nil;
    
    _cellTopLabel = nil;
    _messageBubbleTopLabel = nil;
    _cellBottomLabel = nil;
    _textView = nil;
    _messageBubbleImageView = nil;
    _avatarImageView = nil;
    _bubbleImageIconOverlay = nil;
    _menuItems = JSQMenuItemsNone;
    
    [_avatarImageSource bindImageView:nil];
    [_messageBubbleImageSource bindImageView:nil];

    
    [_longPressGestureRecognizer removeTarget:nil action:NULL];
    _longPressGestureRecognizer = nil;
    
    [_avatarTapGestureRecognizer removeTarget:nil action:NULL];
    _avatarTapGestureRecognizer = nil;
    
    [_bubbleTapGestureRecognizer removeTarget:nil action:NULL];
    _bubbleTapGestureRecognizer = nil;
    
    [_cellTapGestureRecognizer removeTarget:nil action:NULL];
    _cellTapGestureRecognizer = nil;
}

#pragma mark - Collection view cell

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.menuItems = JSQMenuItemsNone;
    self.imageOverlayIconType = JSQImageOverlayIconTypeNone;
    self.cellTopLabel.text = nil;
    self.messageBubbleTopLabel.text = nil;
    self.cellBottomLabel.text = nil;
    self.timestampLabel.text = nil;
    self.messageBubbleImageView.image = nil;
    [self.activityIndicator stopAnimating];
    if ([self isKindOfClass:[JSQMessagesCollectionViewCellOutgoing class]])
    {
        ((JSQMessagesCollectionViewCellOutgoing *) self).resendFailedMessageErrorButton.alpha = 0;
        ((JSQMessagesCollectionViewCellOutgoing *) self).resendFailedMessageErrorButton.enabled = NO;
    }

    self.cellTopLabelHeightConstraint.constant = self.cellTopLabelHeightConstraint.constant ?: 0.0f; 
    self.messageBubbleTopLabelHeightConstraint.constant = self.messageBubbleTopLabelHeightConstraint.constant ?: 0.0f;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    [super applyLayoutAttributes:layoutAttributes];
    
    JSQMessagesCollectionViewLayoutAttributes *customAttributes = (JSQMessagesCollectionViewLayoutAttributes *)layoutAttributes;
    
    if (self.messageLabel.font != customAttributes.systemMessageFont) {
        self.messageLabel.font = customAttributes.systemMessageFont;
    }
    
    if (self.timestampLabel.font != customAttributes.timestampFont) {
        self.timestampLabel.font = customAttributes.timestampFont;
    }
    
    UITextView *textView = self.textView;
    if (textView.font != customAttributes.messageBubbleFont) {
        textView.font = customAttributes.messageBubbleFont;
    }
    if (!UIEdgeInsetsEqualToEdgeInsets(textView.textContainerInset, customAttributes.textViewTextContainerInsets)) {
        textView.textContainerInset = customAttributes.textViewTextContainerInsets;
    }
    
    self.textViewFrameInsets = customAttributes.textViewFrameInsets;
    [self jsq_updateConstraint:self.messageBubbleWidthConstraint withConstant:customAttributes.messageBubbleWidth];
    [self jsq_updateConstraint:self.cellTopLabelHeightConstraint withConstant:customAttributes.cellTopLabelHeight];
    [self jsq_updateConstraint:self.messageBubbleTopLabelHeightConstraint withConstant:customAttributes.messageBubbleTopLabelHeight];
    [self jsq_updateConstraint:self.cellBottomLabelHeightConstraint withConstant:customAttributes.cellBottomLabelHeight];
    [self jsq_updateConstraint:self.bubbleImageIconCenterConstraint withConstant:[self isKindOfClass:[JSQMessagesCollectionViewCellIncoming class]] ? -customAttributes.messageBubbleImageIconCenterOffset : customAttributes.messageBubbleImageIconCenterOffset];

    if ([self isKindOfClass:[JSQMessagesCollectionViewCellIncoming class]])
    {
        self.avatarViewSize = customAttributes.incomingAvatarViewSize;
    }
    else if ([self isKindOfClass:[JSQMessagesCollectionViewCellOutgoing class]])
    {
        self.avatarViewSize = customAttributes.outgoingAvatarViewSize;
    }
    else if ([self isKindOfClass:[JSQMessagesCollectionViewCellSystem class]])
    {
        self.avatarViewSize = CGSizeZero;
    }
}

#pragma mark - Setters

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    
    self.cellTopLabel.backgroundColor = backgroundColor;
    self.messageBubbleTopLabel.backgroundColor = backgroundColor;
    self.cellBottomLabel.backgroundColor = backgroundColor;
    
    self.messageBubbleImageView.backgroundColor = backgroundColor;
    self.avatarImageView.backgroundColor = backgroundColor;
    
    self.messageBubbleContainerView.backgroundColor = backgroundColor;
    self.avatarContainerView.backgroundColor = backgroundColor;
}

- (void)setMessageBubbleImageSource:(id<JSQMessagesImageViewSource>)messageBubbleImageSource
{
    if (_messageBubbleImageSource) {
        [_messageBubbleImageSource bindImageView:nil];
    }
    
    UIImageView *bubbleView = self.messageBubbleImageView;
    _messageBubbleImageSource = messageBubbleImageSource;
    
    if (!messageBubbleImageSource) {
        bubbleView.hidden = YES;
        return;
    }
    
    bubbleView.hidden = NO;
    [messageBubbleImageSource bindImageView:bubbleView];
}

- (void)setAvatarImageSource:(id<JSQMessagesImageViewSource>)avatarImageSource
{
    if (_avatarImageSource) {
        [_avatarImageSource bindImageView:nil];
    }
    
    UIImageView *avatarView = self.avatarImageView;
    _avatarImageSource = avatarImageSource;
    
    if (!avatarImageSource) {
        self.avatarViewSize = CGSizeZero;
        avatarView.hidden = YES;
        return;
    }
    
    [avatarImageSource bindImageView:avatarView];
    self.avatarViewSize = [avatarImageSource imageSize];
    avatarView.hidden = NO;
}

- (void)setAvatarViewSize:(CGSize)avatarViewSize
{
    [self jsq_updateConstraint:self.avatarContainerViewWidthConstraint withConstant:avatarViewSize.width];
    [self jsq_updateConstraint:self.avatarContainerViewHeightConstraint withConstant:avatarViewSize.height];
}

- (void)setTextViewFrameInsets:(UIEdgeInsets)textViewFrameInsets
{
    [self jsq_updateConstraint:self.textViewTopVerticalSpaceConstraint withConstant:textViewFrameInsets.top];
    [self jsq_updateConstraint:self.textViewBottomVerticalSpaceConstraint withConstant:textViewFrameInsets.bottom];
    [self jsq_updateConstraint:self.textViewAvatarHorizontalSpaceConstraint withConstant:textViewFrameInsets.right];
    [self jsq_updateConstraint:self.textViewMarginHorizontalSpaceConstraint withConstant:textViewFrameInsets.left];
}

- (void)setImageOverlayCustomIcon:(UIImage *)imageOverlayCustomIcon
{
    _imageOverlayCustomIcon = imageOverlayCustomIcon;
    self.imageOverlayIconType = JSQImageOverlayIconTypeCustom;
}

- (void)setImageOverlayIconType:(JSQImageOverlayIconType)imageOverlayIconType
{
    switch (imageOverlayIconType) {
        case JSQImageOverlayIconTypeNone:
            self.bubbleImageIconOverlay.image = nil;
            self.bubbleImageIconOverlay.hidden = YES;
            break;
            
        case JSQImageOverlayIconTypePlayButton:
            self.bubbleImageIconOverlay.image = [UIImage imageNamed:@"play_icon"];
            self.bubbleImageIconOverlay.hidden = NO;
            break;
            
        case JSQImageOverlayIconTypeCamera:
            self.bubbleImageIconOverlay.image = [UIImage imageNamed:@"camera_icon"];
            self.bubbleImageIconOverlay.hidden = NO;
            break;

        case JSQImageOverlayIconTypeCustom:
            self.bubbleImageIconOverlay.image = _imageOverlayCustomIcon;
            self.bubbleImageIconOverlay.hidden = NO;
            break;
    }
}

#pragma mark - Getters

- (CGSize)avatarViewSize
{
    return CGSizeMake(self.avatarContainerViewWidthConstraint.constant,
                      self.avatarContainerViewHeightConstraint.constant);
}

- (UIEdgeInsets)textViewFrameInsets
{
    return UIEdgeInsetsMake(self.textViewTopVerticalSpaceConstraint.constant,
                            self.textViewMarginHorizontalSpaceConstraint.constant,
                            self.textViewBottomVerticalSpaceConstraint.constant,
                            self.textViewAvatarHorizontalSpaceConstraint.constant);
}

#pragma mark - Helpers

- (void)jsq_updateConstraint:(NSLayoutConstraint *)constraint withConstant:(CGFloat)constant
{
    if (constraint.constant == constant) {
        return;
    }
    
    constraint.constant = constant;
    [self setNeedsUpdateConstraints];
}

#pragma mark - UIResponder

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)becomeFirstResponder
{
    return [super becomeFirstResponder];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (self.menuItems == JSQMenuItemsNone) return NO;
    
    if (action == @selector(copy:))
    {
        return self.menuItems & JSQMenuItemsCopy;
    }
    
    if (action == @selector(delete:))
    {
        return self.menuItems & JSQMenuItemsDelete;
    }
    
    if (action == @selector(share:))
    {
        return self.menuItems & JSQMenuItemsShare;
    }
    return NO;
}

- (void)copy:(id)sender
{
    [[UIPasteboard generalPasteboard] setString:self.textView.text];
    
    if ([self.delegate respondsToSelector:@selector(messagesCollectionViewCellDidTapCopy:)])
    {
        [self.delegate messagesCollectionViewCellDidTapCopy:self];
    }
    [self resignFirstResponder];
}

- (void)delete:(id)sender
{
    [self.delegate messagesCollectionViewCellDidTapDelete:self];
    [self resignFirstResponder];
}

- (void)share:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(messagesCollectionViewCellDidTapShare:)])
    {
        [self.delegate messagesCollectionViewCellDidTapShare:self];
    }
    [self resignFirstResponder];
}

#pragma mark - Gesture recognizers

- (void)jsq_handleLongPressGesture:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state != UIGestureRecognizerStateBegan || ![self becomeFirstResponder]) {
        return;
    }
    
    if (longPress.view == self && ![self isKindOfClass:[JSQMessagesCollectionViewCellSystem class]])
    {
        return;
    }
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    UIView *presentingView = (longPress.view == self) ? self.messageLabel : self.messageBubbleImageView;
    CGRect targetRect = [self convertRect:presentingView.bounds fromView:presentingView];

    [menu setTargetRect:CGRectInset(targetRect, 0.0f, 4.0f) inView:self];
    
    if (self.menuItems & JSQMenuItemsShare)
    {
        UIMenuItem *shareMenuItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"Share", nil) action:@selector(share:)];
        [[UIMenuController sharedMenuController] setMenuItems:@[shareMenuItem]];
    }
    self.messageBubbleImageView.highlighted = YES;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(jsq_didReceiveMenuWillShowNotification:)
                                                 name:UIMenuControllerWillShowMenuNotification
                                               object:menu];
    
    [menu setMenuVisible:YES animated:YES];
}

- (BOOL)hideMenu
{
    if ([UIMenuController sharedMenuController].isMenuVisible)
    {
        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
        return YES;
    }
    return NO;
}

- (void)jsq_handleAvatarTapGesture:(UITapGestureRecognizer *)tap
{
    [self.delegate messagesCollectionViewCellDidTapAvatar:self];
    [self hideMenu];
}

- (void)jsq_handleBubbleTapGesture:(UITapGestureRecognizer *)tap
{
    if ([UIMenuController sharedMenuController].isMenuVisible)
    {
        [self hideMenu];
        return;
    }
    [self.delegate messagesCollectionViewCellDidTapBubble:self];
}

- (void)jsq_handleCellTapGesture:(UITapGestureRecognizer *)tap
{
     if (![self hideMenu])
     {
         [self.delegate messagesCollectionViewCellDidTapCell:self];
     }
}

#pragma mark - Notifications

- (void)jsq_didReceiveMenuWillHideNotification:(NSNotification *)notification
{
    self.messageBubbleImageView.highlighted = NO;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillHideMenuNotification
                                                  object:nil];
}

- (void)jsq_didReceiveMenuWillShowNotification:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillShowMenuNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(jsq_didReceiveMenuWillHideNotification:)
                                                 name:UIMenuControllerWillHideMenuNotification
                                               object:[notification object]];
}


#pragma mark - Send error handling 

- (void)showErrorIndicator:(BOOL)show
{
    if (show == (((JSQMessagesCollectionViewCellOutgoing *) self).resendFailedMessageErrorButton.alpha == 1))
    {
        return;
    }
    
    if ([self isKindOfClass:[JSQMessagesCollectionViewCellOutgoing class]]) {
        [UIView animateWithDuration:.5f animations:^{
            ((JSQMessagesCollectionViewCellOutgoing *) self).resendFailedMessageErrorButton.alpha = show ? 1 : 0;
        } completion:^(BOOL finished) {
            ((JSQMessagesCollectionViewCellOutgoing *) self).resendFailedMessageErrorButton.enabled = show;
        }];
    }
}

- (IBAction)resendFailedMessage:(id)sender
{
    [self.delegate messagesCollectionViewCellDidTapResendFaildMessage:self];
}

@end
