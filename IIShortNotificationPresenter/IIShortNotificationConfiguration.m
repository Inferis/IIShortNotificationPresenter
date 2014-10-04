//
//  IIShortNotificationConfiguration.m
//  NotificationDemo
//
//  Created by Tom Adriaenssen on 03/10/14.
//  Copyright (c) 2014 Tom Adriaenssen. All rights reserved.
//

#import "IIShortNotificationConfiguration.h"
#import "IIShortNotificationSerialQueue.h"
#import "IIShortNotificationTopLayout.h"
#import "IIShortNotificationDefaultView.h"

@implementation IIShortNotificationConfiguration {
    void (^_notificationQueueClassConfigurator)(id<IIShortNotificationQueue>);
    void (^_notificationLayoutClassConfigurator)(id<IIShortNotificationLayout>);
}

- (instancetype)init
{
    self = [super init];
    if (self) {
         // force defaults
        self.notificationLayoutClass = nil;
        self.notificationQueueClass = nil;
        self.notificationViewClass = nil;
        _autoDismissDelay = 5;
    }
    return self;
}

- (void)setNotificationLayoutClass:(Class)notificationLayoutClass
{
    [self setNotificationLayoutClass:notificationLayoutClass configured:nil];
}

- (void)setNotificationLayoutClass:(Class)notificationLayoutClass configured:(void (^)(id<IIShortNotificationLayout>))configure
{
    _notificationLayoutClass = notificationLayoutClass ?: [IIShortNotificationTopLayout class];
    _notificationLayoutClassConfigurator = configure;
}

- (void)setNotificationQueueClass:(Class)notificationQueueClass
{
    [self setNotificationQueueClass:notificationQueueClass configured:nil];
}

- (void)setNotificationQueueClass:(Class)notificationQueueClass configured:(void (^)(id<IIShortNotificationQueue>))configure
{
    _notificationQueueClass = notificationQueueClass ?: [IIShortNotificationSerialQueue class];
    _notificationQueueClassConfigurator = configure;
}

- (void)setNotificationViewClass:(Class)notificationViewClass
{
    _notificationViewClass = notificationViewClass ?: [IIShortNotificationDefaultView class];
}

- (id<IIShortNotificationQueue>)queueWithHandler:(id<IIShortNotificationQueueHandler>)handler
{
    id<IIShortNotificationQueue> queue = [[self.notificationQueueClass alloc] initWithHandler:handler];
    if (_notificationQueueClassConfigurator) {
        _notificationQueueClassConfigurator(queue);
    }
    return queue;
}

- (id<IIShortNotificationLayout>)layoutWithContext:(id<IIShortNotificationLayoutContext>)context
{
    id<IIShortNotificationLayout> layout = [[self.notificationLayoutClass alloc] initWithLayoutContext:context];
    if (_notificationLayoutClassConfigurator) {
        _notificationLayoutClassConfigurator(layout);
    }
    return layout;
}

- (UIView<IIShortNotificationView>*)view
{
    return [_notificationViewClass new];
}

- (id)copyWithZone:(NSZone *)zone
{
    IIShortNotificationConfiguration *copy = [IIShortNotificationConfiguration new];
    copy->_notificationLayoutClass = _notificationLayoutClass;
    copy->_notificationLayoutClassConfigurator = [_notificationLayoutClassConfigurator copy];
    copy->_notificationQueueClass = _notificationQueueClass;
    copy->_notificationQueueClassConfigurator = [_notificationQueueClassConfigurator copy];
    copy->_notificationViewClass = _notificationViewClass;
    copy->_autoDismissDelay = _autoDismissDelay;
    return copy;
}

@end
