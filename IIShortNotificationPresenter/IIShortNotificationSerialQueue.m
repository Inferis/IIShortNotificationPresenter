//
//  IIShortNotificationQueue.m
//  NotificationDemo
//
//  Created by Tom Adriaenssen on 01/10/14.
//  Copyright (c) 2014 Tom Adriaenssen. All rights reserved.
//

#import "IIShortNotificationSerialQueue.h"
#import "IIShortNotificationPresenter.h"


// Blatantly picked up from [Wil Shipley](http://blog.wilshipley.com/2005/10/pimp-my-code-interlude-free-code.html)
//
// > Essentially, if you're wondering if an NSString or NSData or
// > NSAttributedString or NSArray or NSSet has actual useful data in
// > it, this is your macro. Instead of checking things like
// > `if (inputString == nil || [inputString length] == 0)` you just
// > say, "if (IsEmpty(inputString))".
//
// It rocks.
static inline BOOL IsEmpty(id thing) {
    if (thing == nil) return YES;
    if ([thing isEqual:[NSNull null]]) return YES;
    if ([thing respondsToSelector:@selector(count)]) return [thing performSelector:@selector(count)] == 0;
    if ([thing respondsToSelector:@selector(length)]) return [thing performSelector:@selector(length)] == 0;
    return NO;
}



@implementation IIShortNotificationSerialQueue {
    NSMutableArray* _queue;
    BOOL _presenting;
    id<IIShortNotificationQueueHandler> _presenter;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Cannot init IIShortNotificationSerialQueue without presenter" userInfo:nil];
}

- (instancetype)initWithHandler:(id<IIShortNotificationQueueHandler>)presenter
{
    self = [super init];
    if (self) {
        _presenter = presenter;
        _queue = [NSMutableArray array];
    }
    return self;
}

- (void)queuePresentation:(IIShortNotificationType)type message:(NSString *)message title:(NSString *)title accessory:(BOOL)accessory completion:(void (^)(IIShortNotificationDismissal dismissal))completion
{
    if (IsEmpty(message) && IsEmpty(title))
        return;

    NSMutableDictionary* msg = [@{@"type": @(type)} mutableCopy];
    if (message) msg[@"message"] = message;
    if (title) msg[@"title"] = title;
    if (accessory) msg[@"accessory"] = @YES;
    if (completion) msg[@"completion"] = completion;

    [_queue insertObject:msg atIndex:0];
    [self handleQueue];
}

- (void)handleQueue
{
    if (_presenting)
        return;

    NSDictionary* msg = [_queue lastObject];
    [_queue removeLastObject];
    if (msg) {
        _presenting = YES;
        [_presenter handlePresentation:[msg[@"type"] unsignedIntegerValue]
                               message:msg[@"message"]
                                 title:msg[@"title"]
                              accesory:[msg[@"accessory"] boolValue]
                            completion:msg[@"completion"]];
    }
    else {
        [_presenter handlePresentationsFinished];
    }
}

- (void)dismissedPresentation
{
    _presenting = NO;
    [self handleQueue];
}

@end
