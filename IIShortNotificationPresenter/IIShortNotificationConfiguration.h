//
//  IIShortNotificationConfiguration.h
//  NotificationDemo
//
//  Created by Tom Adriaenssen on 03/10/14.
//  Copyright (c) 2014 Tom Adriaenssen. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IIShortNotificationLayout;
@protocol IIShortNotificationLayoutContext;
@protocol IIShortNotificationQueue;
@protocol IIShortNotificationQueueHandler;
@protocol IIShortNotificationView;

@interface IIShortNotificationConfiguration : NSObject<NSCopying>

/**
 *  Set the class of the View to present when presenting a notification.
 *  This class should implement the IIShortNotificationView protocol.
 */
@property (nonatomic, strong) Class notificationViewClass;

/**
 *  Set the class of the queue to use when presenting a notification.
 *  This class should implement the IIShortNotificationQueue protocol.
 */
@property (nonatomic, strong) Class notificationQueueClass;

/**
 *  Sets the notification layout class with an configuration block.
 */
- (void)setNotificationQueueClass:(Class)notificationQueueClass configured:(void(^)(id<IIShortNotificationQueue> queue))configure;

/**
 *  Set the class of the object to handle the placement of the notifications.
 *  This class should implement the IIShortNotificationView protocol.
 */
@property (nonatomic, strong) Class notificationLayoutClass;

/**
 *  Sets the notification layout class with an configuration block.
 */
- (void)setNotificationLayoutClass:(Class)notificationLayoutClass configured:(void(^)(id<IIShortNotificationLayout> layout))configure;

/**
 *  Sets the default autodismiss delay (in seconds). This value will be used to set
 *  the initial value for each IIShortNotificationPresenter instance's autoDismissDelay
 *  property.
 */
@property (nonatomic, assign) NSTimeInterval autoDismissDelay;


- (id<IIShortNotificationQueue>)queueWithHandler:(id<IIShortNotificationQueueHandler>)handler;
- (id<IIShortNotificationLayout>)layoutWithContext:(id<IIShortNotificationLayoutContext>)context;
- (UIView<IIShortNotificationView>*)view;

@end
