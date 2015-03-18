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

@protocol JSQItemDataSource <NSObject>

@required

- (id)itemAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)numberOfItemsInSection:(NSInteger)section;
- (NSInteger)numberOfSections;

@end
