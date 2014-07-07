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

#import "JSQMessagesArrayItemDataSource.h"

@interface JSQMessagesArrayItemDataSource ()

@property (strong, nonatomic) NSArray *items;

@end


@implementation JSQMessagesArrayItemDataSource

- (instancetype)initWithItems:(NSArray *)items
{
    self = [super init];
    if (self) {
        self.items = items;
    }
    return self;
}

#pragma mark - JSQMessagesItemDataSource

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section != 0) {
        return nil;
    }
    return self.items[indexPath.item];
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section
{
    if (section != 0) {
        return 0;
    }
    return [self.items count];
}

- (NSInteger)numberOfSections
{
    return 1;
}

@end
