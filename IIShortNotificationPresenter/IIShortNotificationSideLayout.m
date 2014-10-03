//
//  IIShortNotificationSideLayout.m
//  NotificationDemo
//
//  Created by Tom Adriaenssen on 03/10/14.
//  Copyright (c) 2014 Tom Adriaenssen. All rights reserved.
//

#import "IIShortNotificationSideLayout.h"

@implementation IIShortNotificationSideLayout {
    UIView* _containerView;
}

- (instancetype)initWithContainerView:(UIView *)containerView
{
    self = [super init];
    if (self) {
        _containerView = containerView;
    }
    return self;
}

- (void)addInstance:(IIShortNotificationViewInstance*)instance
{

}

- (void)beginPresentAnimation:(IIShortNotificationViewInstance*)instance
{

}

- (void)endPresentAnimation:(IIShortNotificationViewInstance*)instance
{

}

- (void)beginDismissAnimation:(IIShortNotificationViewInstance*)instance
{

}

- (void)endDismissAnimation:(IIShortNotificationViewInstance*)instance
{

}

- (void)removeInstance:(IIShortNotificationViewInstance*)instance
{
    
}

@end
