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

#import <Foundation/Foundation.h>

#import "JSQMessagesBubbleView.h"


@interface JSQMessagesBubbleMessageViewMetrics : NSObject

@property (assign, nonatomic) CGSize avatarSize;
@property (assign, nonatomic) UIEdgeInsets insets;
@property (assign, nonatomic) UIEdgeInsets contentInsets;

@end


@interface JSQMessagesBubbleMessageView : UIView

+ (Class)bubbleViewClass;

@property (strong, nonatomic, readonly) UIImageView *avatarView;
@property (strong, nonatomic, readonly) JSQMessagesBubbleView *bubbleView;
@property (strong, nonatomic, readonly) UIView *contentView;

@property (assign, nonatomic) NSLayoutAttribute avatarHorizontalAlign;
@property (assign, nonatomic) NSLayoutAttribute avatarVerticalAlign;

- (void)setInsets:(UIEdgeInsets)insets;
- (void)setAvatarSize:(CGSize)avatarSize;
- (void)setContentInsets:(UIEdgeInsets)contentInsets;

- (void)applyMetrics:(id)metrics
         contentSize:(CGSize)contentSize
          constraint:(CGSize)constraint;

+ (CGSize)sizeWithContentSize:(CGSize)contentSize metrics:(id)metrics;
+ (CGSize)contentSizeConstraintForSizeConstraint:(CGSize)constraint withMetrics:(id)metrics;

@end
