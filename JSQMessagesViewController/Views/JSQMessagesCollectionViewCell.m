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

#import "JSQMessagesCollectionViewCell.h"

#import "JSQMessagesCollectionViewCellIncoming.h"
#import "JSQMessagesCollectionViewCellOutgoing.h"
#import "JSQMessagesCollectionViewLayoutAttributes.h"

#import "UIView+JSQMessages.h"
#import "UIDevice+JSQMessages.h"


@interface JSQMessagesCollectionViewCell ()

@property (weak, nonatomic) IBOutlet JSQMessagesLabel *cellTopLabel;
@property (weak, nonatomic) IBOutlet JSQMessagesLabel *messageBubbleTopLabel;
@property (weak, nonatomic) IBOutlet JSQMessagesLabel *cellBottomLabel;

@property (weak, nonatomic) IBOutlet UIView *messageBubbleContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *messageBubbleImageView;
@property (weak, nonatomic) IBOutlet JSQMessagesCellTextView *textView;

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIView *avatarContainerView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageBubbleContainerWidthConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewTopVerticalSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewBottomVerticalSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewAvatarHorizontalSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewMarginHorizontalSpaceConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellTopLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageBubbleTopLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellBottomLabelHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatarContainerViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatarContainerViewHeightConstraint;

@property (assign, nonatomic) UIEdgeInsets textViewFrameInsets;

@property (assign, nonatomic) CGSize avatarViewSize;

@property (weak, nonatomic, readwrite) UITapGestureRecognizer *tapGestureRecognizer;

- (void)jsq_handleTapGesture:(UITapGestureRecognizer *)tap;

- (void)jsq_updateConstraint:(NSLayoutConstraint *)constraint withConstant:(CGFloat)constant;

@end



@implementation JSQMessagesCollectionViewCell

#pragma mark - Class methods

+ (UINib *)nib
{
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:[NSBundle bundleForClass:[self class]]];
}

+ (NSString *)cellReuseIdentifier
{
    return NSStringFromClass([self class]);
}

+ (NSString *)mediaCellReuseIdentifier
{
    return [NSString stringWithFormat:@"%@_JSQMedia", NSStringFromClass([self class])];
}

#pragma mark - Initialization

- (void)awakeFromNib
{
    [super awakeFromNib];

    [self setTranslatesAutoresizingMaskIntoConstraints:NO];

    self.backgroundColor = [UIColor whiteColor];

    self.cellTopLabelHeightConstraint.constant = 0.0f;
    self.messageBubbleTopLabelHeightConstraint.constant = 0.0f;
    self.cellBottomLabelHeightConstraint.constant = 0.0f;

    self.avatarViewSize = CGSizeZero;

    self.cellTopLabel.textAlignment = NSTextAlignmentCenter;
    self.cellTopLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    self.cellTopLabel.textColor = [UIColor lightGrayColor];

    self.messageBubbleTopLabel.font = [UIFont systemFontOfSize:12.0f];
    self.messageBubbleTopLabel.textColor = [UIColor lightGrayColor];

    self.cellBottomLabel.font = [UIFont systemFontOfSize:11.0f];
    self.cellBottomLabel.textColor = [UIColor lightGrayColor];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jsq_handleTapGesture:)];
    [self addGestureRecognizer:tap];
    self.tapGestureRecognizer = tap;
}

- (void)dealloc
{
    _delegate = nil;

    _cellTopLabel = nil;
    _messageBubbleTopLabel = nil;
    _cellBottomLabel = nil;

    _textView = nil;
    _messageBubbleImageView = nil;
    _mediaView = nil;

    _avatarImageView = nil;

    [_tapGestureRecognizer removeTarget:nil action:NULL];
    _tapGestureRecognizer = nil;
}

#pragma mark - Collection view cell

- (void)prepareForReuse
{
    [super prepareForReuse];

    self.cellTopLabel.text = nil;
    self.messageBubbleTopLabel.text = nil;
    self.cellBottomLabel.text = nil;

    self.textView.dataDetectorTypes = UIDataDetectorTypeNone;
    self.textView.text = nil;
    self.textView.attributedText = nil;

    self.avatarImageView.image = nil;
    self.avatarImageView.highlightedImage = nil;
}

- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    return layoutAttributes;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    [super applyLayoutAttributes:layoutAttributes];

//    JSQMessagesCollectionViewLayoutAttributes *customAttributes = (JSQMessagesCollectionViewLayoutAttributes *)layoutAttributes;
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    self.messageBubbleImageView.highlighted = highlighted;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    self.messageBubbleImageView.highlighted = selected;
}

//  FIXME: radar 18326340
//         remove when fixed
//         hack for Xcode6 / iOS 8 SDK rendering bug that occurs on iOS 7.x
//         see issue #484
//         https://github.com/jessesquires/JSQMessagesViewController/issues/484
//
- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];

    if ([UIDevice jsq_isCurrentDeviceBeforeiOS8]) {
        self.contentView.frame = bounds;
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

- (void)setAvatarViewSize:(CGSize)avatarViewSize
{
    if (CGSizeEqualToSize(avatarViewSize, self.avatarViewSize)) {
        return;
    }

    [self jsq_updateConstraint:self.avatarContainerViewWidthConstraint withConstant:avatarViewSize.width];
    [self jsq_updateConstraint:self.avatarContainerViewHeightConstraint withConstant:avatarViewSize.height];
}

- (void)setTextViewFrameInsets:(UIEdgeInsets)textViewFrameInsets
{
    if (UIEdgeInsetsEqualToEdgeInsets(textViewFrameInsets, self.textViewFrameInsets)) {
        return;
    }

    [self jsq_updateConstraint:self.textViewTopVerticalSpaceConstraint withConstant:textViewFrameInsets.top];
    [self jsq_updateConstraint:self.textViewBottomVerticalSpaceConstraint withConstant:textViewFrameInsets.bottom];
    [self jsq_updateConstraint:self.textViewAvatarHorizontalSpaceConstraint withConstant:textViewFrameInsets.right];
    [self jsq_updateConstraint:self.textViewMarginHorizontalSpaceConstraint withConstant:textViewFrameInsets.left];
}

- (void)setMediaView:(UIView *)mediaView
{
    [self.messageBubbleImageView removeFromSuperview];
    [self.textView removeFromSuperview];

    [mediaView setTranslatesAutoresizingMaskIntoConstraints:NO];
    mediaView.frame = self.messageBubbleContainerView.bounds;

    [self.messageBubbleContainerView addSubview:mediaView];
    [self.messageBubbleContainerView jsq_pinAllEdgesOfSubview:mediaView];
    _mediaView = mediaView;

    //  because of cell re-use (and caching media views, if using built-in library media item)
    //  we may have dequeued a cell with a media view and add this one on top
    //  thus, remove any additional subviews hidden behind the new media view
    dispatch_async(dispatch_get_main_queue(), ^{
        for (NSUInteger i = 0; i < self.messageBubbleContainerView.subviews.count; i++) {
            if (self.messageBubbleContainerView.subviews[i] != _mediaView) {
                [self.messageBubbleContainerView.subviews[i] removeFromSuperview];
            }
        }
    });
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

#pragma mark - Utilities

- (void)jsq_updateConstraint:(NSLayoutConstraint *)constraint withConstant:(CGFloat)constant
{
    if (constraint.constant == constant) {
        return;
    }

    constraint.constant = constant;
}

#pragma mark - Gesture recognizers

- (void)jsq_handleTapGesture:(UITapGestureRecognizer *)tap
{
    CGPoint touchPt = [tap locationInView:self];

    if (CGRectContainsPoint(self.avatarContainerView.frame, touchPt)) {
        [self.delegate messagesCollectionViewCellDidTapAvatar:self];
    }
    else if (CGRectContainsPoint(self.messageBubbleContainerView.frame, touchPt)) {
        [self.delegate messagesCollectionViewCellDidTapMessageBubble:self];
    }
    else {
        [self.delegate messagesCollectionViewCellDidTapCell:self atPosition:touchPt];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint touchPt = [touch locationInView:self];

    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
        return CGRectContainsPoint(self.messageBubbleContainerView.frame, touchPt);
    }

    return YES;
}

#pragma mark - JSQMessagesCollectionViewCell protocol

+ (id)computeMetricsWithData:(id<JSQMessagesCollectionViewCellData>)data
          cellSizeConstraint:(CGSize)constraint
{
    NSParameterAssert(data);
    
    id<JSQMessageData> message = [data messageData];
    
    CGSize finalSize = CGSizeZero;
    
    if ([message isMediaMessage]) {
        finalSize = [[message media] mediaViewDisplaySize];
    }
    else {
        CGSize avatarSize = [data avatarViewSize];
        
        UIEdgeInsets textContainerInsets = [data messageBubbleTextViewTextContainerInsets];
        UIEdgeInsets textFrameInsets = [data messageBubbleTextViewFrameInsets];
        //  from the cell xibs, there is a 2 point space between avatar and bubble
        CGFloat spacingBetweenAvatarAndBubble = 2.0f;
        CGFloat horizontalContainerInsets = textContainerInsets.left + textContainerInsets.right;
        CGFloat horizontalFrameInsets = textFrameInsets.left + textFrameInsets.right;
        CGFloat horizontalInsetsTotal = horizontalContainerInsets + horizontalFrameInsets + spacingBetweenAvatarAndBubble;
        
        CGFloat maximumTextWidth = constraint.width - avatarSize.width - [data messageBubbleLeftRightMargin] - horizontalInsetsTotal;
        
        CGRect stringRect = [[message text] boundingRectWithSize:CGSizeMake(maximumTextWidth, CGFLOAT_MAX)
                                                         options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                                      attributes:@{ NSFontAttributeName : [data messageBubbleFont] }
                                                         context:nil];
        
        CGSize stringSize = CGRectIntegral(stringRect).size;
        
        CGFloat verticalContainerInsets = textContainerInsets.top + textContainerInsets.bottom;
        CGFloat verticalFrameInsets = textFrameInsets.top + textFrameInsets.bottom;
        
        //  add extra 2 points of space, because `boundingRectWithSize:` is slightly off
        //  not sure why. magix. (shrug) if you know, submit a PR
        CGFloat verticalInsets = verticalContainerInsets + verticalFrameInsets + 2.0f;
        
        // FIXME: use cached value of [UIImage jsq_bubbleCompactImage].size.width
        CGFloat bubbleWidth = 48;
        //  same as above, an extra 2 points of magix
        CGFloat finalWidth = MAX(stringSize.width + horizontalInsetsTotal, bubbleWidth) + 2.0f;
        
        finalSize = CGSizeMake(finalWidth, stringSize.height + verticalInsets);
    }
    
    return [NSValue valueWithCGSize:finalSize];
}

+ (CGSize)cellSizeWithData:(id<JSQMessagesCollectionViewCellData>)data
                   metrics:(id)metrics
        cellSizeConstraint:(CGSize)constraint
{
    NSParameterAssert(data);
    NSParameterAssert(metrics);
    
    CGSize messageBubbleSize = [(NSValue *)metrics CGSizeValue];
    
    CGFloat finalHeight = messageBubbleSize.height;
    finalHeight += [data cellTopLabelHeight];
    finalHeight += [data messageBubbleTopLabelHeight];
    finalHeight += [data cellBottomLabelHeight];
    
    return CGSizeMake(constraint.width, ceilf(finalHeight));
}

- (void)configureWithData:(id<JSQMessagesCollectionViewCellData>)data
                  metrics:(id)metrics
                 cellSize:(CGSize)cellSize
{
    NSParameterAssert(data);
    NSParameterAssert(metrics);

    id<JSQMessageData> message = [data messageData];
    BOOL isMediaMessage = [message isMediaMessage];

    // configure content
    UIFont *messageBubbleFont = [data messageBubbleFont];
    if (self.textView.font != messageBubbleFont) {
        self.textView.font = messageBubbleFont;
    }
    
    if (!isMediaMessage) {
        self.textView.text = [message text];

        if ([UIDevice jsq_isCurrentDeviceBeforeiOS8]) {
            //  workaround for iOS 7 textView data detectors bug
            self.textView.text = nil;
            self.textView.attributedText = [[NSAttributedString alloc] initWithString:[message text]
                                                                           attributes:@{ NSFontAttributeName : messageBubbleFont }];
        }

        NSParameterAssert(self.textView.text != nil);

        // FIXME: move to display data
//        id<JSQMessageBubbleImageDataSource> bubbleImageDataSource = [collectionView.dataSource collectionView:collectionView messageBubbleImageDataForItemAtIndexPath:indexPath];
//        if (bubbleImageDataSource != nil) {
//            cell.messageBubbleImageView.image = [bubbleImageDataSource messageBubbleImage];
//            cell.messageBubbleImageView.highlightedImage = [bubbleImageDataSource messageBubbleHighlightedImage];
//        }
    }
    else {
        id<JSQMessageMediaData> messageMedia = [message media];
        self.mediaView = [messageMedia mediaView] ?: [messageMedia mediaPlaceholderView];
        NSParameterAssert(self.mediaView != nil);
    }
    
    UIEdgeInsets textContainerInsets = [data messageBubbleTextViewTextContainerInsets];
    if (!UIEdgeInsetsEqualToEdgeInsets(self.textView.textContainerInset, textContainerInsets)) {
        self.textView.textContainerInset = textContainerInsets;
    }
    self.textView.dataDetectorTypes = UIDataDetectorTypeAll;

    // configure avatar
    CGSize avatarViewSize = [data avatarViewSize];
    BOOL needsAvatar = !CGSizeEqualToSize(avatarViewSize, CGSizeZero);
    if (needsAvatar) {
        id<JSQMessageAvatarImageDataSource> avatarImageDataSource = [data avatarData];
        if (avatarImageDataSource != nil) {
            
            UIImage *avatarImage = [avatarImageDataSource avatarImage];
            if (avatarImage == nil) {
                self.avatarImageView.image = [avatarImageDataSource avatarPlaceholderImage];
                self.avatarImageView.highlightedImage = nil;
            }
            else {
                self.avatarImageView.image = avatarImage;
                self.avatarImageView.highlightedImage = [avatarImageDataSource avatarHighlightedImage];
            }
        }
    }
    self.avatarViewSize = [data avatarViewSize];

//
//    cell.cellTopLabel.attributedText = [collectionView.dataSource collectionView:collectionView attributedTextForCellTopLabelAtIndexPath:indexPath];
//    cell.messageBubbleTopLabel.attributedText = [collectionView.dataSource collectionView:collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:indexPath];
//    cell.cellBottomLabel.attributedText = [collectionView.dataSource collectionView:collectionView attributedTextForCellBottomLabelAtIndexPath:indexPath];
//
//    CGFloat bubbleTopLabelInset = (avatarImageDataSource != nil) ? 60.0f : 15.0f;
//
//    if (isOutgoingMessage) {
//        cell.messageBubbleTopLabel.textInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, bubbleTopLabelInset);
//    }
//    else {
//        cell.messageBubbleTopLabel.textInsets = UIEdgeInsetsMake(0.0f, bubbleTopLabelInset, 0.0f, 0.0f);
//    }
//

    
    self.textViewFrameInsets = [data messageBubbleTextViewFrameInsets];
    
    CGSize messageBubbleSize = [(NSValue *)metrics CGSizeValue];

    [self jsq_updateConstraint:self.messageBubbleContainerWidthConstraint
                  withConstant:messageBubbleSize.width];
    
    [self jsq_updateConstraint:self.cellTopLabelHeightConstraint
                  withConstant:[data cellTopLabelHeight]];
    
    [self jsq_updateConstraint:self.messageBubbleTopLabelHeightConstraint
                  withConstant:[data messageBubbleTopLabelHeight]];
    
    [self jsq_updateConstraint:self.cellBottomLabelHeightConstraint
                  withConstant:[data cellBottomLabelHeight]];
    
    self.backgroundColor = [UIColor clearColor];
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.layer.shouldRasterize = YES;

}

@end
