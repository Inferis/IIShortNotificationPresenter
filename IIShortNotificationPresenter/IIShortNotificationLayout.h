//
//  IIShortNotificationLayout.h
//  NotificationDemo
//
//  Created by Tom Adriaenssen on 02/10/14.
//  Copyright (c) 2014 Tom Adriaenssen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IIShortNotificationViewInstance;

@protocol IIShortNotificationLayout <NSObject>

- (instancetype)initWithContainerView:(UIView *)containerView;

- (void)addInstance:(IIShortNotificationViewInstance*)instance;

- (void)beginPresentAnimation:(IIShortNotificationViewInstance*)instance;
- (void)endPresentAnimation:(IIShortNotificationViewInstance*)instance;

- (void)beginDismissAnimation:(IIShortNotificationViewInstance*)instance;
- (void)endDismissAnimation:(IIShortNotificationViewInstance*)instance;

- (void)removeInstance:(IIShortNotificationViewInstance*)instance;

@end
