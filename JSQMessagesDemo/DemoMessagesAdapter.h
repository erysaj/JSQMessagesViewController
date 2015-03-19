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

#import "JSQMessagesCollectionViewAdapter.h"
#import "DemoModelData.h"

@interface DemoMessagesAdapter : JSQMessagesCollectionViewAdapter

@property (nonatomic, strong) DemoModelData *model;

- (instancetype)initWithModel:(DemoModelData *)model;

@end
