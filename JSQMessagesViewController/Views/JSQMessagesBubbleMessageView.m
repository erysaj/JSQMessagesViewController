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

#import "JSQMessagesBubbleMessageView.h"

#import <math.h>
#import "UIView+JSQMessages.h"


@implementation JSQMessagesBubbleMessageViewMetrics


@end


@interface JSQMessagesBubbleMessageView ()

@property (strong, nonatomic, readwrite) UIImageView *avatarView;
@property (strong, nonatomic, readwrite) JSQMessagesBubbleView *bubbleView;
@property (strong, nonatomic, readwrite) UIView *contentView;

@property (strong, nonatomic) UIView *avatarContainer;

@property (strong, nonatomic) NSLayoutConstraint *contentInsetTConstraint;
@property (strong, nonatomic) NSLayoutConstraint *contentInsetLConstraint;
@property (strong, nonatomic) NSLayoutConstraint *contentInsetRConstraint;
@property (strong, nonatomic) NSLayoutConstraint *contentInsetBConstraint;

@property (strong, nonatomic) NSLayoutConstraint *insetTConstraint;
@property (strong, nonatomic) NSLayoutConstraint *insetLConstraint;
@property (strong, nonatomic) NSLayoutConstraint *insetRConstraint;
@property (strong, nonatomic) NSLayoutConstraint *insetBConstraint;

@property (strong, nonatomic) NSLayoutConstraint *avatarWConstraint;
@property (strong, nonatomic) NSLayoutConstraint *avatarHConstraint;
@property (strong, nonatomic) NSLayoutConstraint *avatarYConstraint;

@property (strong, nonatomic) NSMutableArray *createdConstraints;

@property (strong, nonatomic) UIImageView *bubbleImageView;

@end


@implementation JSQMessagesBubbleMessageView

#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _createdConstraints = [[NSMutableArray alloc] initWithCapacity:12];
        
        _avatarHorizontalAlign = NSLayoutAttributeRight;
        _avatarVerticalAlign = NSLayoutAttributeBottom;
        
        self.avatarContainer.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.avatarContainer];
        
        self.avatarView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.avatarContainer addSubview:self.avatarView];
        
        self.bubbleView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.bubbleView];
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.bubbleView addSubview:self.contentView];

        
        [self jsq_resetConstraints];
    }
    return self;
}

- (void)jsq_resetConstraints
{
    [self removeConstraints:_createdConstraints];
    [_createdConstraints removeAllObjects];

    NSDictionary *views = @{
        @"a": self.avatarView,
        @"A": self.avatarContainer,
        @"B": self.bubbleView,
        @"C": self.contentView,
    };

    JSQLayoutConstraintsFactory cf = [self jsq_constraintsFactoryWithOptions:0 metrics:nil views:views];
    cf(@"H:|[a]|", ^(NSArray *constraints) {
        [_createdConstraints addObjectsFromArray:constraints];
    });
    cf(@"V:[a(0)]", ^(NSArray *constraints) {
        _avatarHConstraint = constraints[0];
        [_createdConstraints addObjectsFromArray:constraints];
    });
    cf(@"H:[A(0)]", ^(NSArray *constraints) {
        _avatarWConstraint = constraints[0];
        [_createdConstraints addObjectsFromArray:constraints];
    });

    
    // place bubble & avatar
    cf(_avatarVerticalAlign == NSLayoutAttributeBottom? @"V:[a]|": @"V:|[a]", ^(NSArray *constraints) {
        _avatarYConstraint = constraints[0];
        [_createdConstraints addObjectsFromArray:constraints];
    });
    cf(@"V:|-(0)-[A]-(0)-|", ^(NSArray *constraints) {
        [_createdConstraints addObjectsFromArray:constraints];
    });

    cf(_avatarHorizontalAlign == NSLayoutAttributeLeft? @"H:|-(0)-[A]-(0)-[B]-(0)-|": @"H:|-(0)-[B]-(0)-[A]-(0)-|", ^(NSArray *constraints) {
        _insetLConstraint = constraints[0];
        _insetRConstraint = constraints[2];
        [_createdConstraints addObjectsFromArray:constraints];
    });

    cf(@"V:|-(0)-[B]-(0)-|", ^(NSArray *constraints) {
        _insetTConstraint = constraints[0];
        _insetBConstraint = constraints[1];
        [_createdConstraints addObjectsFromArray:constraints];
    });

    // place content view
    cf(@"H:|-(0)-[C]-(0)-|", ^(NSArray *constraints) {
        _contentInsetLConstraint = constraints[0];
        _contentInsetRConstraint = constraints[1];
        [_createdConstraints addObjectsFromArray:constraints];
    });

    cf(@"V:|-(0)-[C]-(0)-|", ^(NSArray *constraints) {
        _contentInsetTConstraint = constraints[0];
        _contentInsetBConstraint = constraints[1];
        [_createdConstraints addObjectsFromArray:constraints];        
    });
}

#pragma mark - Lazily create subviews

+ (Class)bubbleViewClass
{
    return [JSQMessagesBubbleView class];
}

- (UIImageView *)avatarView
{
    if (!_avatarView) {
        _avatarView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _avatarView;
}

- (UIView *)avatarContainer
{
    if (!_avatarContainer) {
        _avatarContainer = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _avatarContainer;
}

- (JSQMessagesBubbleView *)bubbleView
{
    if (!_bubbleView) {
        _bubbleView = [[[[self class] bubbleViewClass] alloc] initWithFrame:CGRectZero];
    }
    return _bubbleView;
}

- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _contentView;
}

#pragma mark - Setters

- (void)setAvatarHorizontalAlign:(NSLayoutAttribute)avatarHorizontalAlign
{
    NSParameterAssert(avatarHorizontalAlign == NSLayoutAttributeLeft || avatarHorizontalAlign == NSLayoutAttributeRight);
    if (_avatarHorizontalAlign == avatarHorizontalAlign) {
        return;
    }
    _avatarHorizontalAlign = avatarHorizontalAlign;
    
    [self jsq_resetConstraints];
}

- (void)setAvatarVerticalAlign:(NSLayoutAttribute)avatarVerticalAlign
{
    NSParameterAssert(avatarVerticalAlign == NSLayoutAttributeBottom || avatarVerticalAlign == NSLayoutAttributeTop);
    if (_avatarVerticalAlign == avatarVerticalAlign) {
        return;
    }
    _avatarVerticalAlign = avatarVerticalAlign;

    [self removeConstraint:_avatarYConstraint];
    [_createdConstraints removeObject:_avatarYConstraint];
    
    _avatarYConstraint = [NSLayoutConstraint constraintWithItem:self.avatarView
                                                      attribute:avatarVerticalAlign
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self.avatarContainer
                                                      attribute:avatarVerticalAlign
                                                     multiplier:1.0f
                                                       constant:0.0f];

    [_createdConstraints addObject:_avatarYConstraint];
    [self addConstraint:_avatarYConstraint];
    
    [self jsq_resetConstraints];
}

#pragma mark - Layout

- (void)setInsets:(UIEdgeInsets)insets
{
    [self jsq_updateConstraint:_insetTConstraint withConstant:insets.top];
    [self jsq_updateConstraint:_insetLConstraint withConstant:insets.left];
    [self jsq_updateConstraint:_insetBConstraint withConstant:insets.bottom];
    [self jsq_updateConstraint:_insetRConstraint withConstant:insets.right];
}

- (void)setAvatarSize:(CGSize)avatarSize
{
    [self jsq_updateConstraint:_avatarWConstraint withConstant:avatarSize.width];
    [self jsq_updateConstraint:_avatarHConstraint withConstant:avatarSize.height];
}

- (void)setContentInsets:(UIEdgeInsets)contentInsets
{
    [self jsq_updateConstraint:_contentInsetTConstraint withConstant:contentInsets.top];
    [self jsq_updateConstraint:_contentInsetLConstraint withConstant:contentInsets.left];
    [self jsq_updateConstraint:_contentInsetBConstraint withConstant:contentInsets.bottom];
    [self jsq_updateConstraint:_contentInsetRConstraint withConstant:contentInsets.right];
}

- (void)applyMetrics:(id)metrics
         contentSize:(CGSize)contentSize
          constraint:(CGSize)constraint
{
    JSQMessagesBubbleMessageViewMetrics *m = metrics;
    UIEdgeInsets insets = m.insets;
    CGFloat extraWidth = constraint.width - contentSize.width;
    if (extraWidth > 0.0f) {
        if (_avatarHorizontalAlign == NSLayoutAttributeLeft) {
            insets.right += extraWidth;
        }
        else {
            insets.left += extraWidth;
        }
    }
    
    CGFloat extraHeight = constraint.height - contentSize.height;
    if (extraHeight > 0.0f) {
        if (_avatarVerticalAlign == NSLayoutAttributeTop) {
            insets.bottom += extraHeight;
        }
        else {
            insets.top += extraHeight;
        }
    }
    
    [self setInsets:insets];
    [self setAvatarSize:m.avatarSize];
    [self setContentInsets:m.contentInsets];
}

#pragma mark - Size computation

+ (CGSize)sizeWithContentSize:(CGSize)contentSize metrics:(id)metrics
{
    JSQMessagesBubbleMessageViewMetrics *m = metrics;
    CGSize avatarSize = m.avatarSize;
    UIEdgeInsets contentInsets = m.contentInsets;
    UIEdgeInsets insets = m.insets;

    contentSize.width  += contentInsets.left + contentInsets.right;
    contentSize.height += contentInsets.top + contentInsets.bottom;
    
    contentSize.width += avatarSize.width;
    if (avatarSize.height > contentSize.height) {
        contentSize.height = avatarSize.height;
    }
    
    contentSize.width  += insets.left + insets.right;
    contentSize.height += insets.top + insets.bottom;
    return contentSize;
}

+ (CGSize)contentSizeConstraintForSizeConstraint:(CGSize)constraint withMetrics:(id)metrics
{
    JSQMessagesBubbleMessageViewMetrics *m = metrics;
    CGSize avatarSize = m.avatarSize;
    UIEdgeInsets contentInsets = m.contentInsets;
    UIEdgeInsets insets = m.insets;

    constraint.width  -= insets.left + insets.right;
    constraint.height -= insets.top + insets.bottom;
    constraint.width  -= avatarSize.width + contentInsets.left + contentInsets.right;
    constraint.height -= contentInsets.top + contentInsets.bottom;
    return constraint;
}


@end
