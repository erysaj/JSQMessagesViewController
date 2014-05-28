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

#import "JSQMessagesSimpleImageViewSource.h"


@interface JSQMessagesSimpleImageViewSource()

@property (weak  , nonatomic) UIImageView *view;

@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIImage *highlightedImage;

@end


@implementation JSQMessagesSimpleImageViewSource

- (instancetype)initWithImage:(UIImage *)image
{
    self = [super init];
    if (self) {
        self.imageSize = image.size;
        self.image = image;
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage
{
    self = [super init];
    if (self) {
        self.imageSize = image.size;
        self.image = image;
        self.highlightedImage = highlightedImage;
    }
    return self;
}

- (void)bindImageView:(UIImageView *)newView
{
    UIImageView *oldView = self.view;
    
    [self unbindImageView:oldView];
    self.view = newView;
    
    if (self.bindBlock)
    {
        self.bindBlock(newView);
    }
    else
    {
        newView.image = self.image;
        newView.highlightedImage = self.highlightedImage;
    }
}

- (void)unbindImageView:(UIImageView *)view
{
    if (self.unbindBlock)
    {
        self.unbindBlock(view);
    }
    else
    {
        view.image = nil;
        view.highlightedImage = nil;
    }
}
@end
