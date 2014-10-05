//
//  IIShortNotificationQueue.m
//  Copyright (c) 2014 Tom Adriaenssen. All rights reserved.
//

#import "IIShortNotificationSerialQueue.h"
#import "IIShortNotificationPresenter.h"
#import "IIShortNotificationPresentation+Internal.h"

@implementation IIShortNotificationSerialQueue {
    NSMutableArray* _queue;
    BOOL _presenting;
    __weak id<IIShortNotificationQueueHandler> _presenter;
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
                             accessory:[msg[@"accessory"] boolValue]
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
