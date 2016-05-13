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

#import "JSQMessagesToolbarContentView.h"

#import "JSQMessagesComposerTextView.h"

#import "UIView+JSQMessages.h"

const CGFloat kJSQMessagesToolbarContentViewHorizontalSpacingDefault = 4.0f;


@interface JSQMessagesToolbarContentView () <UITextViewDelegate>
{
    BOOL _isObserving;
}

@property (weak, nonatomic) IBOutlet JSQMessagesComposerTextView *textView;

@property (weak, nonatomic) IBOutlet UIView *leftBarButtonContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftBarButtonContainerViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftBarButtonContainerViewSpacingLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftBarButtonContainerViewSpacingRightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftBarButtonBottomVerticalSpaceConstraint;

@property (weak, nonatomic) IBOutlet UIView *rightBarButtonContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightBarButtonContainerViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightBarButtonContainerViewSpacingLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightBarButtonContainerViewSpacingRightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightBarButtonBottomVerticalSpaceConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewBottomVerticalSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewTopVerticalSpaceConstraint;

@property (strong, nonatomic) NSMutableArray *accessoryItemsConstraints;

@end



@implementation JSQMessagesToolbarContentView

#pragma mark - Class methods

+ (UINib *)nib
{
    return [UINib nibWithNibName:NSStringFromClass([JSQMessagesToolbarContentView class])
                          bundle:[NSBundle mainBundle]];
}

#pragma mark - Initialization

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.leftBarButtonContainerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.rightBarButtonContainerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    self.leftBarButtonContainerViewSpacingLeftConstraint.constant = kJSQMessagesToolbarContentViewHorizontalSpacingDefault;
    self.leftBarButtonContainerViewSpacingRightConstraint.constant = kJSQMessagesToolbarContentViewHorizontalSpacingDefault;
    self.rightBarButtonContainerViewSpacingLeftConstraint.constant = kJSQMessagesToolbarContentViewHorizontalSpacingDefault;
    self.rightBarButtonContainerViewSpacingRightConstraint.constant = kJSQMessagesToolbarContentViewHorizontalSpacingDefault;
    
    self.leftBarButtonItem = nil;
    self.rightBarButtonItem = nil;
    
    self.backgroundColor = [UIColor clearColor];
    
    self.textView.delegate = self;
    [self jsq_addObservers];
}

- (void)dealloc
{
    [self jsq_removeObservers];
    
    _textView.delegate = nil;
    _textView = nil;
    _leftBarButtonItem = nil;
    _rightBarButtonItem = nil;
    _leftBarButtonContainerView = nil;
    _rightBarButtonContainerView = nil;
}

- (void)updateConstraints
{
    [super updateConstraints];
    
    if (!_accessoryItemsConstraints && _accessoryItems)
    {
        CGFloat const padding = 5.0;
        NSUInteger itemsCount = _accessoryItems.count;
        
        NSMutableArray *constraints = [[NSMutableArray alloc] init];
        UIView *container = self.inputContainer;
        
        [_accessoryItems enumerateObjectsUsingBlock:^(UIButton *currItem, NSUInteger idx, BOOL *stop) {
            
            [constraints addObject:[NSLayoutConstraint constraintWithItem:currItem
                                                                attribute:NSLayoutAttributeCenterY
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:container
                                                                attribute:NSLayoutAttributeCenterY
                                                               multiplier:1.0
                                                                 constant:0.0]];

            if (idx + 1 == itemsCount)
            {
                [constraints addObject:[NSLayoutConstraint constraintWithItem:currItem
                                                                    attribute:NSLayoutAttributeTrailing
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:container
                                                                    attribute:NSLayoutAttributeTrailing
                                                                   multiplier:1.0
                                                                     constant:-padding]];
            }
            else
            {
                [constraints addObject:[NSLayoutConstraint constraintWithItem:currItem
                                                                    attribute:NSLayoutAttributeTrailing
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:_accessoryItems[idx + 1]
                                                                    attribute:NSLayoutAttributeLeading
                                                                   multiplier:1.0
                                                                     constant:-padding]];
            }
        }];

        _accessoryItemsConstraints = constraints;
        [self addConstraints:constraints];
    }
}

#pragma mark - KVO

- (void)jsq_addObservers
{
    if (_isObserving)
        return;
    _isObserving = YES;
    
    [_textView addObserver:self
                forKeyPath:NSStringFromSelector(@selector(contentSize))
                   options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                   context:NULL];
}

- (void)jsq_removeObservers
{
    if (!_isObserving)
        return;
    _isObserving = NO;
    
    [_textView removeObserver:self
                   forKeyPath:NSStringFromSelector(@selector(contentSize))
                      context:NULL];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context
{
    if (object == _textView) {
        if ([keyPath isEqualToString:NSStringFromSelector(@selector(contentSize))]) {
            CGSize oldContentSize = [[change objectForKey:NSKeyValueChangeOldKey] CGSizeValue];
            CGSize newContentSize = [[change objectForKey:NSKeyValueChangeNewKey] CGSizeValue];

            [self.delegate messagesToolbarContent:self didChangeSize:oldContentSize toSize:newContentSize];
            return;
        }
    }
    
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

#pragma mark - Text view delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self.delegate messagesToolbarContentDidBeginEditing:self];
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self.delegate messagesToolbarContentDidChange:self];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self.delegate messagesToolbarContentDidEndEditing:self];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (self.maximumMessageLength == 0)
        return YES;
    
    NSString *currText = textView.text;
    NSString *nextText = [currText stringByReplacingCharactersInRange:range withString:text];
    return nextText.length <= self.maximumMessageLength;
}

#pragma mark - Setters

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    self.leftBarButtonContainerView.backgroundColor = backgroundColor;
    self.rightBarButtonContainerView.backgroundColor = backgroundColor;
}

- (void)setLeftBarButtonItem:(UIButton *)leftBarButtonItem
{
    if (_leftBarButtonItem) {
        [_leftBarButtonItem removeFromSuperview];
    }
    
    if (!leftBarButtonItem) {
        self.leftBarButtonContainerViewSpacingLeftConstraint.constant = 0.0f;
        self.leftBarButtonItemWidth = 0.0f;
        _leftBarButtonItem = nil;
        self.leftBarButtonContainerView.hidden = YES;
        return;
    }
    
    if (CGRectEqualToRect(leftBarButtonItem.frame, CGRectZero)) {
        leftBarButtonItem.frame = CGRectMake(0.0f,
                                             0.0f,
                                             CGRectGetWidth(self.leftBarButtonContainerView.frame),
                                             CGRectGetHeight(self.leftBarButtonContainerView.frame));
    }
    
    self.leftBarButtonContainerView.hidden = NO;
    self.leftBarButtonContainerViewSpacingLeftConstraint.constant = kJSQMessagesToolbarContentViewHorizontalSpacingDefault;
    self.leftBarButtonItemWidth = CGRectGetWidth(leftBarButtonItem.frame);
    
    [leftBarButtonItem setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.leftBarButtonContainerView addSubview:leftBarButtonItem];
    [self.leftBarButtonContainerView jsq_pinAllEdgesOfSubview:leftBarButtonItem];
    [self setNeedsUpdateConstraints];
    
    _leftBarButtonItem = leftBarButtonItem;
}

- (void)setLeftBarButtonItemWidth:(CGFloat)leftBarButtonItemWidth
{
    self.leftBarButtonContainerViewWidthConstraint.constant = leftBarButtonItemWidth;
    [self setNeedsUpdateConstraints];
}

- (void)setLeftBarButtonItemLeftSpacing:(CGFloat)leftBarButtonItemLeftSpacing
{
    self.leftBarButtonContainerViewSpacingLeftConstraint.constant = leftBarButtonItemLeftSpacing;
    [self setNeedsUpdateConstraints];
}

- (void)setLeftBarButtonItemRightSpacing:(CGFloat)leftBarButtonItemRightSpacing
{
    self.leftBarButtonContainerViewSpacingRightConstraint.constant = leftBarButtonItemRightSpacing;
    [self setNeedsUpdateConstraints];
}

- (void)setLeftBarButtonBottomSpacing:(CGFloat)leftBarButtonBottomSpacing
{
    self.leftBarButtonBottomVerticalSpaceConstraint.constant = leftBarButtonBottomSpacing;
    [self setNeedsUpdateConstraints];
}

- (void)setRightBarButtonItem:(UIButton *)rightBarButtonItem
{
    if (_rightBarButtonItem) {
        [_rightBarButtonItem removeFromSuperview];
    }
    
    if (!rightBarButtonItem) {
        self.rightBarButtonContainerViewSpacingRightConstraint.constant = 0.0f;
        self.rightBarButtonItemWidth = 0.0f;
        _rightBarButtonItem = nil;
        self.rightBarButtonContainerView.hidden = YES;
        return;
    }
    
    if (CGRectEqualToRect(rightBarButtonItem.frame, CGRectZero)) {
        rightBarButtonItem.frame = CGRectMake(0.0f,
                                              0.0f,
                                              CGRectGetWidth(self.rightBarButtonContainerView.frame),
                                              CGRectGetHeight(self.rightBarButtonContainerView.frame));
    }
    
    self.rightBarButtonContainerView.hidden = NO;
    self.rightBarButtonContainerViewSpacingRightConstraint.constant = kJSQMessagesToolbarContentViewHorizontalSpacingDefault;
    self.rightBarButtonItemWidth = CGRectGetWidth(rightBarButtonItem.frame);
    
    [rightBarButtonItem setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.rightBarButtonContainerView addSubview:rightBarButtonItem];
    [self.rightBarButtonContainerView jsq_pinAllEdgesOfSubview:rightBarButtonItem];
    [self setNeedsUpdateConstraints];
    
    _rightBarButtonItem = rightBarButtonItem;
}

- (void)setRightBarButtonItemWidth:(CGFloat)rightBarButtonItemWidth
{
    self.rightBarButtonContainerViewWidthConstraint.constant = rightBarButtonItemWidth;
    [self setNeedsUpdateConstraints];
}

- (void)setRightBarButtonItemLeftSpacing:(CGFloat)rightBarButtonItemLeftSpacing
{
    self.rightBarButtonContainerViewSpacingLeftConstraint.constant = rightBarButtonItemLeftSpacing;
    [self setNeedsUpdateConstraints];
}

- (void)setRightBarButtonItemRighttSpacing:(CGFloat)rightBarButtonItemRightSpacing
{
    self.rightBarButtonContainerViewSpacingRightConstraint.constant = rightBarButtonItemRightSpacing;
    [self setNeedsUpdateConstraints];
}

- (void)setRightBarButtonBottomSpacing:(CGFloat)rightBarButtonBottomSpacing
{
    self.rightBarButtonBottomVerticalSpaceConstraint.constant = rightBarButtonBottomSpacing;
    [self setNeedsUpdateConstraints];
}

- (void)setTextViewTopVerticalSpacing:(CGFloat)textViewTopVerticalSpacing
{
    self.textViewTopVerticalSpaceConstraint.constant = textViewTopVerticalSpacing;
    [self setNeedsUpdateConstraints];
}

- (void)setTextViewBottomVerticalSpacing:(CGFloat)textViewBottomVerticalSpacing
{
    self.textViewBottomVerticalSpaceConstraint.constant = textViewBottomVerticalSpacing;
    [self setNeedsUpdateConstraints];
}

#pragma mark - Getters

- (CGFloat)leftBarButtonItemWidth
{
    return self.leftBarButtonContainerViewWidthConstraint.constant;
}

- (CGFloat)rightBarButtonItemWidth
{
    return self.rightBarButtonContainerViewWidthConstraint.constant;
}

- (UIView *)composerView
{
    return _textView;
}

- (UIScrollView *)scrollView
{
    return _textView;
}

- (UIView *)inputContainer
{
    return _textView;
}

#pragma mark - UIView overrides

- (void)setNeedsDisplay
{
    [super setNeedsDisplay];
    [self.composerView setNeedsDisplay];
}

#pragma mark -

- (NSString *)placeholderText
{
    return [_textView placeHolder];
}

- (void)setPlaceholderText:(NSString *)placeholderText
{
    [_textView setPlaceHolder:placeholderText];
}

- (NSString *)text
{
    return [_textView text];
}

- (void)setText:(NSString *)text
{
    [_textView setText:text];
}

- (UITextAutocorrectionType)autocorrectionType
{
    return [_textView autocorrectionType];
}

- (void)setAutocorrectionType:(UITextAutocorrectionType)autocorrectionType
{
    [_textView setAutocorrectionType:autocorrectionType];
}

- (NSTextAlignment)textAlignment
{
    return [_textView textAlignment];
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    [_textView setTextAlignment:textAlignment];
}

- (void)scrollToBottomAnimated:(BOOL)animated
{
    CGPoint contentOffsetToShowLastLine = CGPointMake(0.0f, self.textView.contentSize.height - CGRectGetHeight(self.textView.bounds));
    
    if (!animated) {
        self.textView.contentOffset = contentOffsetToShowLastLine;
        return;
    }
    
    [UIView animateWithDuration:0.01
                          delay:0.01
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.textView.contentOffset = contentOffsetToShowLastLine;
                     }
                     completion:nil];

}

- (void)setAccessoryItems:(NSArray<UIButton *> *)accessoryItems
{
    if (self.accessoryItemsConstraints)
    {
        [self removeConstraints:self.accessoryItemsConstraints];
        self.accessoryItemsConstraints = nil;
    }
    
    for (UIButton *buttonItem in _accessoryItems)
    {
        [buttonItem removeFromSuperview];
    }
    
    _accessoryItems = [accessoryItems copy];
    
    for (UIButton *buttonItem in _accessoryItems)
    {
        [buttonItem setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:buttonItem];
    }
    
    [self setNeedsUpdateConstraints];
}

@end
