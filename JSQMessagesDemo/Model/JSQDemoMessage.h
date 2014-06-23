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

#import "JSQDemoUser.h"


typedef NS_ENUM(NSInteger, JSQDemoMessageType) {
    JSQDemoMessageTypeUnknown,
    JSQDemoMessageTypeText,
    JSQDemoMessageTypeImage,
};


@interface JSQDemoMessage : NSObject

@property (assign, nonatomic, readonly) JSQDemoMessageType type;
@property (strong, nonatomic, readonly) JSQDemoUser *sender;
@property (strong, nonatomic, readonly) NSDate *date;

@end


@interface JSQDemoTextMessage : JSQDemoMessage

@property (strong, nonatomic, readonly) NSString *text;

+ (instancetype)messageWithText:(NSString *)text
                         sender:(JSQDemoUser *)sender
                           date:(NSDate *)date;

+ (instancetype)messageWithText:(NSString *)text
                         sender:(JSQDemoUser *)sender;
@end


@interface JSQDemoImageMessage : JSQDemoMessage

@property (strong, nonatomic, readonly) UIImage *image;

+ (instancetype)messageWithImage:(UIImage *)image
                          sender:(JSQDemoUser *)sender
                            date:(NSDate *)date;

@end
