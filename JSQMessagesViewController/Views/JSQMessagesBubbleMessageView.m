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


@implementation JSQMessagesBubbleContainerData


@end


@interface JSQMessagesBubbleContainer ()

@property (strong, nonatomic, readwrite) UIImageView *avatarView;
@property (strong, nonatomic, readwrite) JSQMessagesBubbleView *bubbleView;
@property (strong, nonatomic, readwrite) UIView *contentView;

@property (strong, nonatomic) NSLayoutConstraint *avatarWConstraint;
@property (strong, nonatomic) NSLayoutConstraint *avatarHConstraint;
@property (strong, nonatomic) NSLayoutConstraint *avatarYConstraint;
@property (strong, nonatomic) NSLayoutConstraint *avatarSpacingLConstraint;
@property (strong, nonatomic) NSLayoutConstraint *avatarSpacingRConstraint;

@property (strong, nonatomic) NSLayoutConstraint *contentPaddingTConstraint;
@property (strong, nonatomic) NSLayoutConstraint *contentPaddingLConstraint;
@property (strong, nonatomic) NSLayoutConstraint *contentPaddingRConstraint;
@property (strong, nonatomic) NSLayoutConstraint *contentPaddingBConstraint;

@property (strong, nonatomic) NSLayoutConstraint *contentWConstraint;
@property (strong, nonatomic) NSLayoutConstraint *contentHConstraint;

@property (strong, nonatomic) NSLayoutConstraint *bubbleYConstraint;

@end


@implementation JSQMessagesBubbleContainer

#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _avatarHorizontalAlign = NSLayoutAttributeNotAnAttribute;
        _avatarVerticalAlign = NSLayoutAttributeNotAnAttribute;
        
        self.avatarView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.avatarView];
        
        self.bubbleView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.bubbleView];
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.bubbleView addSubview:self.contentView];

        
        NSDictionary *views = @{
            @"A" : self.avatarView,
            @"B" : self.bubbleView,
            @"C" : self.contentView,
        };
        
        JSQLayoutConstraintsFactory cf = [self jsq_constraintsFactoryWithOptions:0 metrics:nil views:views];
        
        // avatar size
        cf(@"H:[A(0)]", ^(NSArray *constraints) {
            _avatarWConstraint = constraints[0];
        });
        cf(@"V:[A(0)]", ^(NSArray *constraints) {
            _avatarHConstraint = constraints[0];
        });
        
        // content size
        cf(@"H:[C(0)]", ^(NSArray *constraints) {
            _contentWConstraint = constraints[0];
        });
        cf(@"V:[C(0)]", ^(NSArray *constraints) {
            _contentHConstraint = constraints[0];
        });
        
        cf(@"H:|-(0)-[C]-(0)-|", ^(NSArray *constraints) {
            _contentPaddingLConstraint = constraints[0];
            _contentPaddingRConstraint = constraints[1];
        });
        
        cf(@"V:|-(0)-[C]-(0)-|", ^(NSArray *constraints) {
            _contentPaddingTConstraint = constraints[0];
            _contentPaddingBConstraint = constraints[1];
        });
        
        self.avatarHorizontalAlign = NSLayoutAttributeRight;
        self.avatarVerticalAlign = NSLayoutAttributeBottom;
    }
    return self;
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
    if (_avatarHorizontalAlign == avatarHorizontalAlign) {
        return;
    }

    CGFloat sL = 0.0f;
    if (_avatarSpacingLConstraint) {
        sL = _avatarSpacingLConstraint.constant;
        [self removeConstraint:_avatarSpacingLConstraint];
        _avatarSpacingLConstraint = nil;
    }
    
    CGFloat sR = 0.0f;
    if (_avatarSpacingRConstraint) {
        sR = _avatarSpacingRConstraint.constant;
        [self removeConstraint:_avatarSpacingRConstraint];
        _avatarSpacingRConstraint = nil;
    }

    NSDictionary *views = @{
        @"A" : self.avatarView,
        @"B" : self.bubbleView,
    };
    
    NSDictionary *metrics = @{
        @"sL" : @(sL),
        @"sR" : @(sR),
    };
    
    JSQLayoutConstraintsFactory cf = [self jsq_constraintsFactoryWithOptions:0 metrics:metrics views:views];
    NSString *fmt = nil;
    switch (avatarHorizontalAlign) {
        case NSLayoutAttributeLeft:
            fmt = @"|-(0)-[A]-(0)-[B]";
            break;
            
        case NSLayoutAttributeRight:
            fmt = @"[B]-(0)-[A]-(0)-|";
            break;
            
        default:
            NSAssert(NO, @"Unsupported avatar horizontal align: %d", avatarHorizontalAlign);
            return;
    }
    
    cf(fmt, ^(NSArray *constraints) {
        _avatarSpacingLConstraint = constraints[0];
        _avatarSpacingRConstraint = constraints[1];
    });
    
    _avatarHorizontalAlign = avatarHorizontalAlign;
}

- (void)setAvatarVerticalAlign:(NSLayoutAttribute)avatarVerticalAlign
{
    if (_avatarVerticalAlign == avatarVerticalAlign) {
        return;
    }
    
    CGFloat yA = 0.0f;
    if (_avatarYConstraint) {
        yA = _avatarYConstraint.constant;
        [self removeConstraint:_avatarYConstraint];
        _avatarYConstraint = nil;
    }
    
    CGFloat yB = 0.0f;
    if (_bubbleYConstraint) {
        yB = _bubbleYConstraint.constant;
        [self removeConstraint:_bubbleYConstraint];
        _bubbleYConstraint = nil;
    }
    
    switch (avatarVerticalAlign) {
        case NSLayoutAttributeTop:
            _avatarYConstraint = [self jsq_alignSubview:_avatarView
                                            withSubview:self
                                              attribute:avatarVerticalAlign];
            _bubbleYConstraint = [self jsq_alignSubview:_bubbleView
                                            withSubview:self
                                              attribute:avatarVerticalAlign];
            break;
            
        case NSLayoutAttributeBottom:
            _avatarYConstraint = [self jsq_alignSubview:self
                                            withSubview:_avatarView
                                              attribute:avatarVerticalAlign];
            _bubbleYConstraint = [self jsq_alignSubview:self
                                            withSubview:_bubbleView
                                              attribute:avatarVerticalAlign];
            break;
            
        default:
            NSAssert(NO, @"Unsupported vertical avatar align: %d", avatarVerticalAlign);
            return;
    }
    
    _avatarYConstraint.constant = yA;
    _bubbleYConstraint.constant = yB;
    
    _avatarVerticalAlign = avatarVerticalAlign;
}

#pragma mark - Layout

- (void)setAvatarSize:(CGSize)avatarSize
{
    [self jsq_updateConstraint:_avatarWConstraint withConstant:avatarSize.width];
    [self jsq_updateConstraint:_avatarHConstraint withConstant:avatarSize.height];
}

- (void)setContentSize:(CGSize)contentSize
{
    [self jsq_updateConstraint:_contentWConstraint withConstant:contentSize.width];
    [self jsq_updateConstraint:_contentHConstraint withConstant:contentSize.height];
}

- (void)setAvatarMarginLeft:(CGFloat)margin
{
    [self jsq_updateConstraint:_avatarSpacingLConstraint withConstant:margin];
}

- (void)setAvatarMarginRight:(CGFloat)margin
{
    [self jsq_updateConstraint:_avatarSpacingRConstraint withConstant:margin];
}

- (void)setContentPadding:(UIEdgeInsets)padding
{
    [self jsq_updateConstraint:_contentPaddingTConstraint withConstant:padding.top];
    [self jsq_updateConstraint:_contentPaddingLConstraint withConstant:padding.left];
    [self jsq_updateConstraint:_contentPaddingBConstraint withConstant:padding.bottom];
    [self jsq_updateConstraint:_contentPaddingRConstraint withConstant:padding.right];
}

#pragma mark - Container

- (void)configureWithData:(id)containerData
              contentSize:(CGSize)contentSize
           sizeConstraint:(CGSize)sizeConstraint
{
    JSQMessagesBubbleContainerData *data = containerData;
    
    [self setContentSize:contentSize];
    [self setAvatarSize:data.avatarSize];
    [self setContentPadding:data.contentPadding];
    [self setAvatarMarginLeft:data.avatarMarginLeft];
    [self setAvatarMarginRight:data.avatarMarginRight];
}

+ (CGSize)contentSizeConstraintWithData:(id)containerData
                         sizeConstraint:(CGSize)sizeConstraint
{
    JSQMessagesBubbleContainerData *data = containerData;
    
    CGSize avatarSize = data.avatarSize;
    UIEdgeInsets contentPadding = data.contentPadding;

    CGSize contentConstraint = sizeConstraint;
    
    contentConstraint.width -= avatarSize.width + data.avatarMarginLeft + data.avatarMarginRight;
    contentConstraint.width -= data.bubbleMinimumMargin;
    contentConstraint.width -= contentPadding.left + contentPadding.right;
    contentConstraint.height -= contentPadding.top + contentPadding.bottom;
    
    return contentConstraint;
}

+ (CGSize)sizeWithData:(id)containerData
           contentSize:(CGSize)contentSize
        sizeConstraint:(CGSize)sizeConstraint
{
    JSQMessagesBubbleContainerData *data = containerData;
    
    CGSize avatarSize = data.avatarSize;
    UIEdgeInsets contentPadding = data.contentPadding;
    
    CGSize size = CGSizeMake(sizeConstraint.width, contentSize.height);
    
    size.height += contentPadding.top + contentPadding.bottom;
    
    if (avatarSize.height > size.height) {
        size.height = avatarSize.height;
    }
    return size;
}

@end
