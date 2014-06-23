//
//  Created by Jesse Squires
//  http://www.hexedbits.com
//
//
//  MIT License
//  Copyright (c) 2014 Jesse Squires
//  http://opensource.org/licenses/MIT
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "JSQMessagesCollectionViewLayoutAttributes.h"


@interface JSQMessagesCollectionViewLayoutAttributesTests : XCTestCase
@end


@implementation JSQMessagesCollectionViewLayoutAttributesTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testLayoutAttributesInitAndIsEqual
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    JSQMessagesCollectionViewLayoutAttributes *attrs = [JSQMessagesCollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    XCTAssertNotNil(attrs, @"Layout attributes should not be nil");
    
    JSQMessagesCollectionViewLayoutAttributes *copy = [attrs copy];
    XCTAssertEqualObjects(attrs, copy, @"Copied attributes should be equal");
    XCTAssertEqual([attrs hash], [copy hash], @"Copied attributes hashes should be equal");
}

@end
