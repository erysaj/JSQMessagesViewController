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

#import "JSQDemoImageCache.h"


@interface JSQDemoImageCacheRequest : NSObject <JSQDemoImageCacheRequest>
{
    NSURL *_imageURL;
    
    BOOL _isCompleted;
    BOOL _isCancelled;
    
    NSMutableArray *_completionBlocks;
}

- (instancetype)initWithImageURL:(NSURL *)imageURL;
- (void)resolveWithImage:(UIImage *)image;
- (void)addCompletionBlock:(JSQDemoImageCacheCompletionBlock)block;

@end


@implementation JSQDemoImageCacheRequest

- (instancetype)initWithImageURL:(NSURL *)imageURL
{
    self = [super init];
    if (self) {
        _imageURL = imageURL;
        _completionBlocks = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - JSQDemoImageCacheRequest protocol

- (NSURL *)imageURL
{
    return _imageURL;
}

- (BOOL)isCompleted
{
    return _isCompleted;
}

- (BOOL)isCancelled
{
    return _isCancelled;
}

- (void)cancel
{
    if (!_isCompleted) {
        _isCompleted = YES;
        _isCompleted = YES;
    }
}

#pragma mark -

- (void)resolveWithImage:(UIImage *)image
{
    if (!_isCompleted) {
        _isCompleted = YES;
        for (JSQDemoImageCacheCompletionBlock block in _completionBlocks) {
            block(image);
        }
    }
}

- (void)addCompletionBlock:(JSQDemoImageCacheCompletionBlock)block
{
    if (!block) {
        return;
    }
    [_completionBlocks addObject:[block copy]];
}

@end


@interface JSQDemoImageCache ()
{
    NSMutableDictionary *_cachedImages;
    NSMutableSet *_requestedKeys;
    NSMutableDictionary *_activeRequests;
}

@end


@implementation JSQDemoImageCache

- (instancetype)init
{
    self = [super init];
    if (self) {
        _cachedImages = [[NSMutableDictionary alloc] init];
        _requestedKeys = [[NSMutableSet alloc] init];
        _activeRequests = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)cacheImage:(UIImage *)image forURL:(NSURL *)imageURL
{
    NSParameterAssert(imageURL != nil);
    NSParameterAssert(image != nil);
    
    _cachedImages[imageURL] = image;
}

- (id<JSQDemoImageCacheRequest>)fetchImageForURL:(NSURL *)imageURL
                                  withCompletion:(JSQDemoImageCacheCompletionBlock)block
{
    JSQDemoImageCacheRequest *request = [[JSQDemoImageCacheRequest alloc] initWithImageURL:imageURL];
    [request addCompletionBlock:block];
    
    NSMutableArray *pendingRequests = _activeRequests[imageURL];
    if (pendingRequests) {
        [pendingRequests addObject:request];
        return request;
    }
    pendingRequests = [[NSMutableArray alloc] initWithObjects:request, nil];
    _activeRequests[imageURL] = pendingRequests;
    
    
    BOOL isFirstLoading = [_requestedKeys member:imageURL] == nil;
    if (isFirstLoading) {
        [_requestedKeys addObject:imageURL];
    }
    
    UIImage *image = [self imageForURL:imageURL];
    
    // simulate I/O
    NSTimeInterval delay = 0.05;
    if (isFirstLoading) {
        // make first load last longer 0.3 - 0.8 s: "fetching from network"
        delay = 0.1 * (3 + arc4random_uniform(5));
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (JSQDemoImageCacheRequest *req in _activeRequests[imageURL]) {
            [req resolveWithImage:image];
        }
        [_activeRequests removeObjectForKey:imageURL];
    });
    
    return request;
}

- (UIImage *)imageForURL:(NSURL *)imageURL
{
    NSParameterAssert(imageURL != nil);
    return _cachedImages[imageURL];
}

@end
