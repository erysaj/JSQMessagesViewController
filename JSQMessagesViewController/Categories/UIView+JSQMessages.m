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

#import "UIView+JSQMessages.h"

@implementation UIView (JSQMessages)

- (void)jsq_pinSubview:(UIView *)subview toEdge:(NSLayoutAttribute)attribute
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                     attribute:attribute
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:subview
                                                     attribute:attribute
                                                    multiplier:1.0f
                                                      constant:0.0f]];
}

- (void)jsq_pinAllEdgesOfSubview:(UIView *)subview
{
    [self jsq_pinSubview:subview toEdge:NSLayoutAttributeBottom];
    [self jsq_pinSubview:subview toEdge:NSLayoutAttributeTop];
    [self jsq_pinSubview:subview toEdge:NSLayoutAttributeLeading];
    [self jsq_pinSubview:subview toEdge:NSLayoutAttributeTrailing];
}

- (void)jsq_updateConstraint:(NSLayoutConstraint *)constraint
                withConstant:(CGFloat)constant
{
    if (constant == constraint.constant) {
        return;
    }
    constraint.constant = constant;
    [self setNeedsUpdateConstraints];
}

- (NSLayoutConstraint *)jsq_alignSubview:(UIView *)subview1
                               attribute:(NSLayoutAttribute)attribute1
                             withSubview:(UIView *)subview2
                               attribute:(NSLayoutAttribute)attribute2
{
    NSLayoutConstraint *c = [NSLayoutConstraint constraintWithItem:subview1
                                                         attribute:attribute1
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:subview2
                                                         attribute:attribute2
                                                        multiplier:1.0f
                                                          constant:0.0f];
    [self addConstraint:c];
    return c;
}

- (NSLayoutConstraint *)jsq_alignSubview:(UIView *)subview1
                             withSubview:(UIView *)subview2
                               attribute:(NSLayoutAttribute)attribute
{
    NSLayoutConstraint *c = [NSLayoutConstraint constraintWithItem:subview1
                                                         attribute:attribute
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:subview2
                                                         attribute:attribute
                                                        multiplier:1.0f
                                                          constant:0.0f];
    [self addConstraint:c];
    return c;
}


- (JSQLayoutConstraintsFactory)jsq_constraintsFactoryWithOptions:(NSLayoutFormatOptions)options
                                                         metrics:(NSDictionary *)metrics
                                                           views:(NSDictionary *)views
{
    JSQLayoutConstraintsFactory factory = ^(NSString *fmt, JSQLayoutConstraintsConsumer consumer) {
        NSArray *layoutConstraints = [NSLayoutConstraint constraintsWithVisualFormat:fmt
                                                                             options:options
                                                                             metrics:metrics
                                                                               views:views];
        [self addConstraints:layoutConstraints];
        if (consumer) {
            consumer(layoutConstraints);
        }
    };
    return factory;
}

@end
