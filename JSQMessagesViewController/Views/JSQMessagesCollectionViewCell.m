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

#import "JSQMessagesCollectionViewCell.h"

#import "UIView+JSQMessages.h"

@interface JSQMessagesCollectionViewCell ()

@property (strong, nonatomic) UIView *container;

@property (strong, nonatomic) NSLayoutConstraint *topMarginConstraint;
@property (strong, nonatomic) NSLayoutConstraint *bottomMarginConstraint;
@property (strong, nonatomic) NSLayoutConstraint *horizontalOffsetConstraint;

@end


@implementation JSQMessagesCollectionViewCell

#pragma mark - Initialization

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *container = nil;
        
        Class containerClass = [[self class] containerClass];
        if (containerClass) {
            container = [[containerClass alloc] initWithFrame:frame];
        }
        else {
            container = [[UIView alloc] initWithFrame:frame];
        }
        [container setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.contentView addSubview:container];
        self.container = container;
        
        self.topMarginConstraint = [self.contentView jsq_alignSubview:container
                                                          withSubview:self.contentView
                                                            attribute:NSLayoutAttributeTop];
        self.bottomMarginConstraint = [self.contentView jsq_alignSubview:self.contentView
                                                             withSubview:container
                                                               attribute:NSLayoutAttributeBottom];
        self.horizontalOffsetConstraint = [self.contentView jsq_alignSubview:container
                                                                 withSubview:self.contentView
                                                                   attribute:NSLayoutAttributeLeading];
        [self.contentView jsq_alignSubview:container
                               withSubview:self.contentView
                                 attribute:NSLayoutAttributeWidth];
    }
    return self;
}

#pragma mark - JSQMessagesCollectionViewCell protocol

+ (CGSize)contentSizeWithData:(id<JSQMessagesCollectionViewCellData>)data
           cellSizeConstraint:(CGSize)cellSizeConstraint
{
    Class<JSQMessagesContainerView> containerClass = [self containerClass];
    
    CGSize containerSizeConstraint = cellSizeConstraint;
    CGFloat margin = [data cellTopMargin] + [data cellBottomMargin];
    cellSizeConstraint.height -= margin;
    
    CGSize contentSizeConstraint = [self contentSizeConstraintWithData:data containerSizeConstraint:containerSizeConstraint];
    CGSize contentSize = [self contentSizeWithData:data contentSizeConstraint:contentSizeConstraint];
    return contentSize;
}

+ (CGSize)cellSizeWithData:(id<JSQMessagesCollectionViewCellData>)data
               contentSize:(CGSize)contentSize
        cellSizeConstraint:(CGSize)cellSizeConstraint
{
    Class<JSQMessagesContainerView> containerClass = [self containerClass];
    
    CGSize containerSizeConstraint = cellSizeConstraint;
    CGFloat margin = [data cellTopMargin] + [data cellBottomMargin];
    containerSizeConstraint.height -= margin;
    
    CGSize containerSize = [self containerSizeWithData:data
                                           contentSize:contentSize
                               containerSizeConstraint:containerSizeConstraint];
    CGSize cellSize = containerSize;
    cellSize.height += margin;
    return cellSize;
}

- (void)configureWithData:(id<JSQMessagesCollectionViewCellData>)data
              contentSize:(CGSize)contentSize
       cellSizeConstraint:(CGSize)cellSizeConstraint
{
    [self jsq_updateConstraint:self.topMarginConstraint withConstant:[data cellTopMargin]];
    [self jsq_updateConstraint:self.bottomMarginConstraint withConstant:[data cellBottomMargin]];
}

#pragma mark - 

+ (Class<JSQMessagesContainerView>)containerClass
{
    return NULL;
}

+ (CGSize)contentSizeWithData:(id)cellData
        contentSizeConstraint:(CGSize)contentSizeConstraint
{
    NSAssert(NO, @"Method %s not implemented!", __PRETTY_FUNCTION__);
    contentSizeConstraint.height = 0.0f;
    return contentSizeConstraint;
}

+ (CGSize)contentSizeConstraintWithData:(id<JSQMessagesCollectionViewCellData>)data
                containerSizeConstraint:(CGSize)containerSizeConstraint
{
    Class<JSQMessagesContainerView> containerClass = [self containerClass];
    
    if (containerClass) {
        return [containerClass contentSizeConstraintWithData:[data cellContainerData]
                                              sizeConstraint:containerSizeConstraint];
    }
    return containerSizeConstraint;
}

+ (CGSize)containerSizeWithData:(id<JSQMessagesCollectionViewCellData>)data
                    contentSize:(CGSize)contentSize
        containerSizeConstraint:(CGSize)containerSizeConstraint
{
    Class<JSQMessagesContainerView> containerClass = [self containerClass];
    if (containerClass) {
        return [containerClass sizeWithData:[data cellContainerData]
                                contentSize:contentSize
                             sizeConstraint:containerSizeConstraint];
    }
    CGSize containerSize = containerSizeConstraint;
    containerSize.height = contentSize.height;
    return containerSize;
}

@end
