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

#import "JSQMessagesGenericCell.h"
#import "JSQMessagesCollectionViewLayoutAttributes.h"

#import "UIView+JSQMessages.h"

@implementation JSQMessagesGenericCellMetrics

- (void)setCellTopLabelHeight:(CGFloat)cellTopLabelHeight
{
    NSParameterAssert(cellTopLabelHeight >= 0.0f);
    _cellTopLabelHeight = floorf(cellTopLabelHeight);
}

- (void)setMessageTopLabelHeight:(CGFloat)messageBubbleTopLabelHeight
{
    NSParameterAssert(messageBubbleTopLabelHeight >= 0.0f);
    _messageTopLabelHeight = floorf(messageBubbleTopLabelHeight);
}

- (void)setCellBottomLabelHeight:(CGFloat)cellBottomLabelHeight
{
    NSParameterAssert(cellBottomLabelHeight >= 0.0f);
    _cellBottomLabelHeight = floorf(cellBottomLabelHeight);
}

@end


@interface JSQMessagesGenericCell ()

@property (weak, nonatomic) NSLayoutConstraint *cellTopLabelHeightConstraint;
@property (weak, nonatomic) NSLayoutConstraint *messageBubbleTopLabelHeightConstraint;
@property (weak, nonatomic) NSLayoutConstraint *cellBottomLabelHeightConstraint;

@property (weak, nonatomic, readwrite) UITapGestureRecognizer *tapGestureRecognizer;

- (void)jsq_handleTapGesture:(UITapGestureRecognizer *)tap;

- (void)setCellTopLabelHeight:(CGFloat)height;
- (void)setMessageBubbleTopLabelHeight:(CGFloat)height;
- (void)setCellBottomLabelHeight:(CGFloat)height;

@end



@implementation JSQMessagesGenericCell

#pragma mark - Initialization

+ (UINib *)nib
{
    return nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.cellTopLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.cellTopLabel];
        
        self.messageTopLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.messageTopLabel];
        
        self.messageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.messageView];
        
        self.cellBottomLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.cellBottomLabel];
        
        NSDictionary *views = @{
            @"T": self.cellTopLabel,
            @"L": self.messageTopLabel,
            @"M": self.messageView,
            @"B": self.cellBottomLabel,
        };
        JSQLayoutConstraintsFactory cf = [self jsq_constraintsFactoryWithOptions:0 metrics:nil views:views];
        cf(@"H:|[T]|", nil);
        cf(@"H:|[L]|", nil);
        cf(@"H:|[M]|", nil);
        cf(@"H:|[B]|", nil);
        cf(@"V:|-(0)-[T(0)]-(0)-[L(0)]-(0)-[M]-(0)-[B(0)]-(0)-|", ^(NSArray *constraints) {
            _cellTopLabelHeightConstraint = constraints[1];
            _messageBubbleTopLabelHeightConstraint = constraints[3];
            _cellBottomLabelHeightConstraint = constraints[6];
        });
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jsq_handleTapGesture:)];
        [self.messageView.avatarView addGestureRecognizer:tap];
        self.tapGestureRecognizer = tap;        
    }
    return self;
}

#pragma mark - Lazily create subviews

- (JSQMessagesLabel *)cellTopLabel
{
    if (!_cellTopLabel) {
        _cellTopLabel = [[JSQMessagesLabel alloc] initWithFrame:CGRectZero];
        _cellTopLabel.textAlignment = NSTextAlignmentCenter;
        _cellTopLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        _cellTopLabel.textColor = [UIColor lightGrayColor];
    }
    return _cellTopLabel;
}

- (JSQMessagesLabel *)messageTopLabel
{
    if (!_messageTopLabel) {
        _messageTopLabel = [[JSQMessagesLabel alloc] initWithFrame:CGRectZero];
        
        _messageTopLabel.font = [UIFont systemFontOfSize:12.0f];
        _messageTopLabel.textColor = [UIColor lightGrayColor];
    }
    return _messageTopLabel;
}

- (JSQMessagesBubbleMessageView *)messageView
{
    if (!_messageView) {
        _messageView = [[JSQMessagesBubbleMessageView alloc] initWithFrame:CGRectZero];
    }
    return _messageView;
}

- (JSQMessagesLabel *)cellBottomLabel
{
    if (!_cellBottomLabel) {
        _cellBottomLabel = [[JSQMessagesLabel alloc] initWithFrame:CGRectZero];
        _cellBottomLabel.font = [UIFont systemFontOfSize:11.0f];
        _cellBottomLabel.textColor = [UIColor lightGrayColor];
    }
    return _cellBottomLabel;
}

#pragma mark - Collection view cell

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.cellTopLabel.text = nil;
    self.messageTopLabel.text = nil;
    self.cellBottomLabel.text = nil;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    [super applyLayoutAttributes:layoutAttributes];
}

#pragma mark - Layout

- (void)setCellTopLabelHeight:(CGFloat)height
{
    [self jsq_updateConstraint:_cellTopLabelHeightConstraint withConstant:height];
}

- (void)setMessageBubbleTopLabelHeight:(CGFloat)height
{
    [self jsq_updateConstraint:_messageBubbleTopLabelHeightConstraint withConstant:height];
}

- (void)setCellBottomLabelHeight:(CGFloat)height
{
    [self jsq_updateConstraint:_cellBottomLabelHeightConstraint withConstant:height];
}

- (void)applyMetrics:(id)metrics contentSize:(CGSize)contentSize cellSizeConstraint:(CGSize)constraint;
{
    JSQMessagesGenericCellMetrics *m = metrics;
    [self setCellTopLabelHeight:m.cellTopLabelHeight];
    [self setMessageBubbleTopLabelHeight:m.messageTopLabelHeight];
    [self setCellBottomLabelHeight:m.cellBottomLabelHeight];
    
    CGSize contentSizeConstraint = [JSQMessagesGenericCell contentSizeConstraintForSizeConstraint:constraint
                                                                                      withMetrics:metrics];
    [self.messageView applyMetrics:m.messageMetrics contentSize:contentSize constraint:contentSizeConstraint];
}

#pragma mark - Style attributes

- (void)applyStyle:(id)style
{
    
}

#pragma mark - Size computation

+ (CGSize)sizeWithContentSize:(CGSize)contentSize
                      metrics:(id)metrics
{
    JSQMessagesGenericCellMetrics *m = metrics;
    
    contentSize = [JSQMessagesBubbleMessageView sizeWithContentSize:contentSize metrics:m.messageMetrics];
    contentSize.height += m.messageTopLabelHeight;
    contentSize.height += m.cellTopLabelHeight;
    contentSize.height += m.cellBottomLabelHeight;
    
    return contentSize;

}

+ (CGSize)contentSizeConstraintForSizeConstraint:(CGSize)constraint
                                     withMetrics:(id)metrics
{
    JSQMessagesGenericCellMetrics *m = metrics;
    
    constraint.height -= m.messageTopLabelHeight;
    constraint.height -= m.cellTopLabelHeight;
    constraint.height -= m.cellBottomLabelHeight;
    
    constraint = [JSQMessagesBubbleMessageView contentSizeConstraintForSizeConstraint:constraint
                                                                          withMetrics:m.messageMetrics];
    
    return constraint;
}

#pragma mark - Setters

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    
    self.cellTopLabel.backgroundColor = backgroundColor;
    self.messageTopLabel.backgroundColor = backgroundColor;
    self.cellBottomLabel.backgroundColor = backgroundColor;
    self.messageView.backgroundColor = backgroundColor;
}

#pragma mark - Gesture recognizers

- (void)jsq_handleTapGesture:(UITapGestureRecognizer *)tap
{
    [self.delegate messagesCollectionViewCellDidTapAvatar:self];
}

@end
