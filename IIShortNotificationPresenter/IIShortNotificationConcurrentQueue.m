//
//  IIShortNotificationConcurrentQueue.m
//  Copyright (c) 2014 Tom Adriaenssen. All rights reserved.
//

#import "IIShortNotificationConcurrentQueue.h"
#import "IIShortNotificationPresentation+Internal.h"

@implementation IIShortNotificationConcurrentQueue {
    __weak id<IIShortNotificationQueueHandler> _handler;
    NSMutableArray* _queue;
    NSUInteger _presenting;
}

static NSUInteger _limit = 30;

- (instancetype)initWithHandler:(id<IIShortNotificationQueueHandler>)handler
{
    self = [super init];
    if (self) {
        _handler = handler;
        _presenting = 0;
        _queue = [NSMutableArray array];
    }
    return self;
}

- (void)queuePresentation:(IIShortNotificationType)type message:(NSString *)message title:(NSString *)title accessory:(BOOL)accessory completion:(void (^)(IIShortNotificationDismissal))completion
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

- (void)dismissedPresentation
{
    @synchronized(_queue) {
        if (_presenting == 0) return;
        --_presenting;
    }

    [self handleQueue];
}

- (void)handleQueue
{
    @synchronized(_queue) {
        if (_presenting >= _limit)
            return;
        
        NSDictionary* msg = [_queue lastObject];
        [_queue removeLastObject];
        if (msg) {
            _presenting++;
            [_handler handlePresentation:[msg[@"type"] unsignedIntegerValue]
                                 message:msg[@"message"]
                                   title:msg[@"title"]
                               accessory:[msg[@"accessory"] boolValue]
                              completion:msg[@"completion"]];
        }
        else if (_presenting == 0) {
            [_handler handlePresentationsFinished];
        }
    }
}

@end
