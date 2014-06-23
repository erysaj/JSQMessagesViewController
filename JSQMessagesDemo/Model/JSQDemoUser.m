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

#import "JSQDemoUser.h"

@implementation JSQDemoUser

- (instancetype)initWithName:(NSString *)displayName avatarURL:(NSURL *)avatarURL
{
    self = [super init];
    if (self) {
        self.displayName = displayName;
        self.avatarURL = avatarURL;
    }
    return self;
}

@end
