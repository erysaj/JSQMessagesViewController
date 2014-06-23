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

#import "UIImageView+JSQDemoImageCache.h"
#import <objc/runtime.h>
#import "JSQDemoImageCache.h"

@implementation UIImageView (JSQDemoImageCache)

- (id<JSQDemoImageCacheRequest>)jsq_imageCacheRequest
{
    return objc_getAssociatedObject(self, @selector(jsq_imageCacheRequest));
}

- (void)jsq_setImageCacheRequest:(id<JSQDemoImageCacheRequest>)request
{
    objc_setAssociatedObject(self, @selector(jsq_imageCacheRequest), request, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)jsq_setImageURL:(NSURL *)imageURL fromCache:(JSQDemoImageCache *)cache
{
    id<JSQDemoImageCacheRequest> currentRequest = [self jsq_imageCacheRequest];
    if (currentRequest) {
        if ([imageURL isEqual:[currentRequest imageURL]]) {
            return;
        }
        
        [currentRequest cancel];
    }
    
    self.image = nil;
    
    if (!imageURL) {
        return;
    }
    
    UIImageView * __weak weakSelf = self;
    JSQDemoImageCacheCompletionBlock completion = ^(UIImage *image) {
        UIImageView *strongSelf = weakSelf;
        strongSelf.image = image;
    };
    
    id<JSQDemoImageCacheRequest> request = [cache fetchImageForURL:imageURL
                                                    withCompletion:completion];
    [self jsq_setImageCacheRequest:request];
}

@end
