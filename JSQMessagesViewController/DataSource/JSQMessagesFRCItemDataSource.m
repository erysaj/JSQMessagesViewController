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

#import "JSQMessagesFRCItemDataSource.h"

@interface JSQMessagesFRCItemDataSource ()

@property (strong, nonatomic) NSFetchedResultsController *frc;

@end

@implementation JSQMessagesFRCItemDataSource

- (instancetype)initWithFetchedResultsController:(NSFetchedResultsController *)frc
{
    self = [super init];
    if (self) {
        self.frc = frc;
    }
    return self;
}

#pragma mark - JSQMessagesItemDataSource

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.frc objectAtIndexPath:indexPath];
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo> sectionInfo = self.frc.sections[section];
    return [sectionInfo numberOfObjects];
}

- (NSInteger)numberOfSections
{
    return [self.frc.sections count];
}

@end
