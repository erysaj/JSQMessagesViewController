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

#import <UIKit/UIKit.h>

@protocol JSQMessagesCollectionViewCellData

- (id)cellModel;

- (CGFloat)cellTopMargin;
- (CGFloat)cellBottomMargin;
- (id)cellContainerData;

@end


@protocol JSQMessagesContainerView

+ (CGSize)contentSizeConstraintWithData:(id)containerData
                         sizeConstraint:(CGSize)sizeConstraint;

+ (CGSize)sizeWithData:(id)containerData
           contentSize:(CGSize)contentSize
        sizeConstraint:(CGSize)sizeConstraint;

- (void)configureWithData:(id)containerData
              contentSize:(CGSize)contentSize
           sizeConstraint:(CGSize)sizeConstraint;

- (UIView *)contentView;

@end


@protocol JSQMessagesCollectionViewCell <NSObject>

+ (CGSize)contentSizeWithData:(id<JSQMessagesCollectionViewCellData>)data
           cellSizeConstraint:(CGSize)cellSizeConstraint;

+ (CGSize)cellSizeWithData:(id<JSQMessagesCollectionViewCellData>)data
               contentSize:(CGSize)contentSize
        cellSizeConstraint:(CGSize)cellSizeConstraint;

- (void)configureWithData:(id<JSQMessagesCollectionViewCellData>)data
              contentSize:(CGSize)contentSize
       cellSizeConstraint:(CGSize)cellSizeConstraint;

@end


@interface JSQMessagesCollectionViewCell : UICollectionViewCell<JSQMessagesCollectionViewCell>

@property (strong, nonatomic, readonly) UIView *container;

+ (Class<JSQMessagesContainerView>)containerClass;

+ (CGSize)contentSizeWithData:(id<JSQMessagesCollectionViewCellData>)cellData
        contentSizeConstraint:(CGSize)contentSizeConstraint;

// override if no container class is used
+ (CGSize)contentSizeConstraintWithData:(id<JSQMessagesCollectionViewCellData>)data
                containerSizeConstraint:(CGSize)sizeConstraint;

+ (CGSize)containerSizeWithData:(id<JSQMessagesCollectionViewCellData>)data
                    contentSize:(CGSize)contentSize
        containerSizeConstraint:(CGSize)sizeConstraint;

@end
