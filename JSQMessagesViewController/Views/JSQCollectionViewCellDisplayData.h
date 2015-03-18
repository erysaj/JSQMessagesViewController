//
//  Created by Jesse Squires
//  http://www.jessesquires.com
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


/**
 *  The `JSQCollectionViewCellDisplayData` is a base protocol to define what
 *  custom cells need to properly configure their displayed data (texts, images, etc.),
 *  style (fonts, colors, etc.) and layout (padding, offsets, element sizes, etc.).
 *
 *  When implementing custom cell class you are expected to create an appropriate
 *  protocol inheriting from `JSQCollectionViewCellDisplayData`.
 */
@protocol JSQCollectionViewCellDisplayData <NSObject>

@end
