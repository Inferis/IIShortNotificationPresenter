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
    void (^_notificationQueueClassConfigurator)(id<IIShortNotificationQueue> layout);
    void (^_notificationLayoutClassConfigurator)(id<IIShortNotificationLayout> queue);
    void (^_notificationViewClassConfigurator)(UIView<IIShortNotificationView>* view);

}

- (instancetype)init
{
    self = [super init];
    if (self) {
         // force defaults
        self.notificationLayoutClass = nil;
        self.notificationQueueClass = nil;
        self.notificationViewClass = nil;
        self.autoDismissingTypes = @[@(IIShortNotificationConfirmation), @(IIShortNotificationNotification)];
        _autoDismissDelay = 5;
    }
    return self;
}

- (void)setNotificationLayoutClass:(Class)notificationLayoutClass
{
    [self setNotificationLayoutClass:notificationLayoutClass configured:nil];
}

- (void)setNotificationLayoutClass:(Class)notificationLayoutClass configured:(void (^)(id<IIShortNotificationLayout> layout))configure
{
    _notificationLayoutClass = notificationLayoutClass ?: [IIShortNotificationTopLayout class];
    _notificationLayoutClassConfigurator = configure;
}

- (void)setNotificationQueueClass:(Class)notificationQueueClass
{
    [self setNotificationQueueClass:notificationQueueClass configured:nil];
}

- (void)setNotificationQueueClass:(Class)notificationQueueClass configured:(void (^)(id<IIShortNotificationQueue> queue))configure
{
    _notificationQueueClass = notificationQueueClass ?: [IIShortNotificationSerialQueue class];
    _notificationQueueClassConfigurator = configure;
}

- (void)setNotificationViewClass:(Class)notificationViewClass
{
    [self setNotificationViewClass:notificationViewClass configured:nil];
}

- (void)setNotificationViewClass:(Class)notificationViewClass configured:(void (^)(UIView<IIShortNotificationView>* view))configure
{
    _notificationViewClass = notificationViewClass ?: [IIShortNotificationDefaultView class];
    _notificationViewClassConfigurator = configure;
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

- (BOOL)shouldAutoDismiss:(IIShortNotificationType)type
{
    for (NSNumber *configuredType in self.autoDismissingTypes) {
        if ([configuredType unsignedIntegerValue] == type) return YES;
    }

    return NO;
}

- (UIView<IIShortNotificationView>*)view
{
    UIView<IIShortNotificationView>* view = [_notificationViewClass new];
    if (_notificationViewClassConfigurator) {
        _notificationViewClassConfigurator(view);
    }
    return view;
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
    copy->_containerViewProvider = _containerViewProvider;
    return copy;
}

@end
