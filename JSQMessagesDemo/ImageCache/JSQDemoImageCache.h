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

typedef void (^JSQDemoImageCacheCompletionBlock)(UIImage *fetchedImage);

@protocol JSQDemoImageCacheRequest <NSObject>

- (NSURL *)imageURL;
- (void)cancel;
- (BOOL)isCompleted;
- (BOOL)isCancelled;

@end


@interface JSQDemoImageCache : NSObject

- (void)cacheImage:(UIImage *)image forURL:(NSURL *)imageURL;
- (UIImage *)imageForURL:(NSURL *)imageURL;
- (id<JSQDemoImageCacheRequest>)fetchImageForURL:(NSURL *)imageURL
                                  withCompletion:(JSQDemoImageCacheCompletionBlock)block;

@end
