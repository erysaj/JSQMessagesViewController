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

#import "JSQDemoMessage.h"

@interface JSQDemoMessage ()

@property (assign, nonatomic) JSQDemoMessageType type;
@property (strong, nonatomic) JSQDemoUser *sender;
@property (strong, nonatomic) NSDate *date;

- (instancetype)initWithType:(JSQDemoMessageType)type
                      sender:(JSQDemoUser *)sender
                        date:(NSDate *)date;

@end


@implementation JSQDemoMessage

- (instancetype)initWithType:(JSQDemoMessageType)type
                      sender:(JSQDemoUser *)sender
                        date:(NSDate *)date;
{
    self = [super init];
    if (self) {
        self.type = type;
        self.sender = sender;
        self.date = date;
    }
    return self;
}

@end


@interface JSQDemoTextMessage ()

@property (strong, nonatomic) NSString *text;

@end


@implementation JSQDemoTextMessage

+ (instancetype)messageWithText:(NSString *)text sender:(JSQDemoUser *)sender date:(NSDate *)date
{
    JSQDemoTextMessage *msg = [[self alloc] initWithType:JSQDemoMessageTypeText
                                                  sender:sender
                                                    date:date];
    msg.text = text;
    return msg;
}

+ (instancetype)messageWithText:(NSString *)text sender:(JSQDemoUser *)sender
{
    NSDate *date = [NSDate date];
    return [self messageWithText:text sender:sender date:date];
}

@end


@interface JSQDemoImageMessage ()

@property (strong, nonatomic) UIImage *image;

@end


@implementation JSQDemoImageMessage

+ (instancetype)messageWithImage:(UIImage *)image sender:(JSQDemoUser *)sender date:(NSDate *)date
{
    JSQDemoImageMessage *msg = [[self alloc] initWithType:JSQDemoMessageTypeImage
                                                  sender:sender
                                                    date:date];
    msg.image = image;
    return msg;
}

@end
