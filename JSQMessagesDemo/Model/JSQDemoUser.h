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

#import <Foundation/Foundation.h>

@interface JSQDemoUser : NSObject

@property (strong, nonatomic) NSString *displayName;
@property (strong, nonatomic) NSURL *avatarURL;

- (instancetype)initWithName:(NSString *)displayName avatarURL:(NSURL *)avatarURL;

@end
