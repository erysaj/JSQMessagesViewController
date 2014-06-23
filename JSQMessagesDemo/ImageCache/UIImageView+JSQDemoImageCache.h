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

#import <UIKit/UIKit.h>

@class JSQDemoImageCache;
@protocol JSQDemoImageCacheRequest;

@interface UIImageView (JSQDemoImageCache)

- (id<JSQDemoImageCacheRequest>)jsq_imageCacheRequest;
- (void)jsq_setImageCacheRequest:(id<JSQDemoImageCacheRequest>)request;
- (void)jsq_setImageURL:(NSURL *)imageURL fromCache:(JSQDemoImageCache *)cache;

@end
