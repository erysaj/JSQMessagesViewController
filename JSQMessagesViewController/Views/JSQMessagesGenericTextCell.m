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

#import "JSQMessagesGenericTextCell.h"
#import "UIView+JSQMessages.h"

@implementation JSQMessagesGenericTextCellMetrics


@end


@implementation JSQMessagesGenericTextCellAttributes


@end


@interface JSQMessagesGenericTextCell ()

@property (weak, nonatomic, readwrite) UILongPressGestureRecognizer *longPressGestureRecognizer;

- (void)jsq_handleLongPressGesture:(UILongPressGestureRecognizer *)longPress;

- (void)jsq_didReceiveMenuWillHideNotification:(NSNotification *)notification;
- (void)jsq_didReceiveMenuWillShowNotification:(NSNotification *)notification;

@end


@implementation JSQMessagesGenericTextCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.messageView.contentView addSubview:self.textView];
        [self.messageView.contentView jsq_pinAllEdgesOfSubview:self.textView];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(jsq_handleLongPressGesture:)];
        longPress.minimumPressDuration = 0.4f;
        [self addGestureRecognizer:longPress];
        self.longPressGestureRecognizer = longPress;
    }
    
    return self;
}

#pragma mark - Subviews

- (UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectZero];
        _textView.textColor = [UIColor whiteColor];
        _textView.editable = NO;
        _textView.selectable = YES;
        _textView.userInteractionEnabled = YES;
        _textView.dataDetectorTypes = UIDataDetectorTypeNone;
        _textView.showsHorizontalScrollIndicator = NO;
        _textView.showsVerticalScrollIndicator = NO;
        _textView.scrollEnabled = NO;
        _textView.backgroundColor = [UIColor clearColor];
        _textView.contentInset = UIEdgeInsetsZero;
        _textView.scrollIndicatorInsets = UIEdgeInsetsZero;
        _textView.contentOffset = CGPointZero;
        _textView.linkTextAttributes = @{
            NSForegroundColorAttributeName : [UIColor whiteColor],
            NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid)
        };
    }
    return _textView;
}

#pragma mark - Layout

- (void)setTextContainerInsets:(UIEdgeInsets)insets
{
    if (!UIEdgeInsetsEqualToEdgeInsets(insets, _textView.textContainerInset)) {
        _textView.textContainerInset = insets;
    }
}

- (void)applyMetrics:(id)metrics contentSize:(CGSize)contentSize cellSizeConstraint:(CGSize)constraint
{
    [super applyMetrics:metrics contentSize:contentSize cellSizeConstraint:constraint];
    
    JSQMessagesGenericTextCellMetrics *m = metrics;
    [self setTextContainerInsets:m.textContainerInsets];
}

#pragma mark - Attributes

- (void)applyAttributes:(id)attributes
{
    JSQMessagesGenericTextCellAttributes *attrs = attributes;
    
    _textView.textColor = attrs.textColor;
    _textView.font = attrs.textFont;
    
    _textView.linkTextAttributes = @{
        NSForegroundColorAttributeName : attrs.textColor,
        NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid)
    };
}

#pragma mark - Size computation

+ (CGSize)contentSizeForText:(NSString *)text
                     metrics:(id)metrics
                       style:(id)style
              sizeConstraint:(CGSize)sizeConstraint
{
    JSQMessagesGenericTextCellMetrics *m = metrics;
    JSQMessagesGenericTextCellAttributes *s = style;
    
    sizeConstraint = [JSQMessagesGenericCell contentSizeConstraintForSizeConstraint:sizeConstraint withMetrics:metrics];
    
    UIEdgeInsets textContainerInsets = m.textContainerInsets;
    CGFloat textHPadding = textContainerInsets.left + textContainerInsets.right;
    CGFloat textVPadding = textContainerInsets.top + textContainerInsets.bottom;
    
    sizeConstraint.width -= textHPadding + textVPadding;
    sizeConstraint.height = CGFLOAT_MAX;
    CGRect textRect = [text boundingRectWithSize:sizeConstraint
                                         options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                      attributes:@{ NSFontAttributeName : s.textFont }
                                         context:nil];
    
    CGSize contentSize = CGRectIntegral(textRect).size;
    contentSize.width += textHPadding + textVPadding;
    contentSize.height += textVPadding;

    return contentSize;
}

#pragma mark - gesture recognizers

- (void)jsq_handleLongPressGesture:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state != UIGestureRecognizerStateBegan || ![self becomeFirstResponder]) {
        return;
    }
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    UIView *bubble = self.messageView.bubbleView;
    CGRect targetRect = [self convertRect:bubble.bounds fromView:bubble];
    
    [menu setTargetRect:CGRectInset(targetRect, 0.0f, 4.0f) inView:self];
    
    self.messageView.bubbleView.highlighted = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(jsq_didReceiveMenuWillShowNotification:)
                                                 name:UIMenuControllerWillShowMenuNotification
                                               object:menu];
    
    [menu setMenuVisible:YES animated:YES];
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
    return (action == @selector(copy:));
}

- (void)copy:(id)sender
{
    [[UIPasteboard generalPasteboard] setString:self.textView.text];
    [self resignFirstResponder];
}

#pragma mark - Notifications

- (void)jsq_didReceiveMenuWillHideNotification:(NSNotification *)notification
{
    self.messageView.bubbleView.highlighted = NO;
    
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

@end
