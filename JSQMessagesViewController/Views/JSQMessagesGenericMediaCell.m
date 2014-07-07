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

#import "JSQMessagesGenericMediaCell.h"
#import "UIView+JSQMessages.h"

@implementation JSQMessagesGenericMediaCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.thumbnailImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.messageView.contentView addSubview:self.thumbnailImageView];
        [self.messageView.contentView jsq_pinAllEdgesOfSubview:self.thumbnailImageView];
    }
    return self;
}

#pragma mark -

- (UIImageView *)thumbnailImageView
{
    if (!_thumbnailImageView) {
        _thumbnailImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _thumbnailImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _thumbnailImageView;
}

@end
