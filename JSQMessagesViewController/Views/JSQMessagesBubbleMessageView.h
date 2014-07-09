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


@interface JSQMessagesBubbleContainerData : NSObject

@property (assign, nonatomic) CGSize avatarSize;
@property (assign, nonatomic) CGFloat avatarMarginLeft;
@property (assign, nonatomic) CGFloat avatarMarginRight;
@property (assign, nonatomic) CGFloat bubbleMinimumMargin;
@property (assign, nonatomic) UIEdgeInsets contentPadding;

@end


@interface JSQMessagesBubbleContainer : UIView

+ (Class)bubbleViewClass;

@property (strong, nonatomic, readonly) UIImageView *avatarView;
@property (strong, nonatomic, readonly) JSQMessagesBubbleView *bubbleView;
@property (strong, nonatomic, readonly) UIView *contentView;

@property (assign, nonatomic) NSLayoutAttribute avatarHorizontalAlign;
@property (assign, nonatomic) NSLayoutAttribute avatarVerticalAlign;

- (void)setAvatarSize:(CGSize)avatarSize;
- (void)setContentSize:(CGSize)contentSize;
- (void)setAvatarMarginLeft:(CGFloat)margin;
- (void)setAvatarMarginRight:(CGFloat)margin;
- (void)setContentPadding:(UIEdgeInsets)padding;

- (void)configureWithData:(id)containerData
              contentSize:(CGSize)contentSize
           sizeConstraint:(CGSize)sizeConstraint;

+ (CGSize)contentSizeConstraintWithData:(id)containerData
                         sizeConstraint:(CGSize)sizeConstraint;

+ (CGSize)sizeWithData:(id)containerData
           contentSize:(CGSize)contentSize
        sizeConstraint:(CGSize)sizeConstraint;

@end
