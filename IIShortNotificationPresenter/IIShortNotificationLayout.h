//
//  IIShortNotificationLayout.h
//  NotificationDemo
//
//  Created by Tom Adriaenssen on 02/10/14.
//  Copyright (c) 2014 Tom Adriaenssen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IIShortNotificationViewInstance.h"

@protocol IIShortNotificationLayoutContext;

@protocol IIShortNotificationLayout <NSObject>

@optional

- (UISwipeGestureRecognizerDirection)directionsForSwipingDismissal;

- (CGFloat)presentingAnimationDuration;
- (CGFloat)dismissingAnimationDuration;
- (CGFloat)removingAnimationDuration;

@required
- (instancetype)initWithLayoutContext:(id<IIShortNotificationLayoutContext>)layoutContext;

- (void)addInstance:(IIShortNotificationViewInstance*)instance;

- (void)beginPresentAnimation:(IIShortNotificationViewInstance*)instance;
- (void)endPresentAnimation:(IIShortNotificationViewInstance*)instance;

- (void)beginDismissAnimation:(IIShortNotificationViewInstance*)instance;
- (void)endDismissAnimation:(IIShortNotificationViewInstance*)instance;

- (void)removeInstance:(IIShortNotificationViewInstance*)instance;

@end

@protocol IIShortNotificationLayoutContext <NSObject>

- (UIView*)containerView;
- (IIShortNotificationViewInstance*)previousNotificationInstance:(IIShortNotificationViewInstance*)instance;
- (IIShortNotificationViewInstance*)nextNotificationInstance:(IIShortNotificationViewInstance*)instance;

@end
