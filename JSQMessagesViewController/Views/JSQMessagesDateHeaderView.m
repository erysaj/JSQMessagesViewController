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


#import "JSQMessagesDateHeaderView.h"

const CGFloat kJSQMessagesDateHeaderViewHeight = 32.0f;


@interface JSQMessagesDateHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;


@end



@implementation JSQMessagesDateHeaderView

#pragma mark - Class methods

+ (UINib *)nib
{
    return [UINib nibWithNibName:NSStringFromClass([JSQMessagesDateHeaderView class])
                          bundle:[NSBundle mainBundle]];
}

+ (NSString *)headerReuseIdentifier
{
    return NSStringFromClass([JSQMessagesDateHeaderView class]);
}

#pragma mark - Initialization

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.backgroundColor = [UIColor clearColor];
}

- (void)dealloc
{
    _dateLabel = nil;
}

#pragma mark - Reusable view
- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
}

@end
