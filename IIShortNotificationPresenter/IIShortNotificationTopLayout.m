//
//  IIShortNotificationTopLayout.m
//  NotificationDemo
//
//  Created by Tom Adriaenssen on 02/10/14.
//  Copyright (c) 2014 Tom Adriaenssen. All rights reserved.
//

#import "IIShortNotificationTopLayout.h"
#import "IIShortNotificationViewInstance.h"
#import "IIShortNotificationPresentation+Internal.h"

@interface IIShortNotificationViewInstance (IIShortNotificationTopLayout)

- (NSLayoutConstraint *)topConstraint;

@end

@implementation IIShortNotificationTopLayout {
    id<IIShortNotificationLayoutContext> _layoutContainer;
}

- (instancetype)initWithLayoutContext:(id<IIShortNotificationLayoutContext>)layoutContainer
{
    self = [super init];
    if (self) {
        _layoutContainer = layoutContainer;
    }
    return self;
}

- (void)addInstance:(IIShortNotificationViewInstance*)instance
{
    NSArray* constraints = @[
                             // top
                             [NSLayoutConstraint constraintWithItem:instance.view
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_layoutContainer.containerView
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1
                                                           constant:0],
                             // left
                             [NSLayoutConstraint constraintWithItem:instance.view
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_layoutContainer.containerView
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1
                                                           constant:0],
                             // right
                             [NSLayoutConstraint constraintWithItem:instance.view
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_layoutContainer.containerView
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1
                                                           constant:0],
                             ];
    instance.constraints = constraints;
    [_layoutContainer.containerView addSubview:instance.view];
    [_layoutContainer.containerView addConstraints:constraints];
}

- (void)beginPresentAnimation:(IIShortNotificationViewInstance*)instance;
{
    instance.topConstraint.constant = -instance.view.intrinsicContentSize.height;
}

- (void)endPresentAnimation:(IIShortNotificationViewInstance*)instance;
{
    instance.topConstraint.constant = IIStatusBarHeight(_layoutContainer.containerView);
}

- (void)beginDismissAnimation:(IIShortNotificationViewInstance*)instance;
{

}

- (void)endDismissAnimation:(IIShortNotificationViewInstance*)instance;
{
    instance.topConstraint.constant = -instance.view.intrinsicContentSize.height;
}

- (void)removeInstance:(IIShortNotificationViewInstance*)instance;
{

}



@end

@implementation IIShortNotificationViewInstance (IIShortNotificationTopLayout)

- (NSLayoutConstraint *)topConstraint
{
    return [self.constraints firstObject];
}

@end
