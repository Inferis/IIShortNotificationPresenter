//
//  IIShortNotificationTopLayout.m
//  NotificationDemo
//
//  Created by Tom Adriaenssen on 02/10/14.
//  Copyright (c) 2014 Tom Adriaenssen. All rights reserved.
//

#import "IIShortNotificationTopLayout.h"
#import "IIShortNotificationViewInstance.h"

@implementation IIShortNotificationTopLayout {
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
    NSArray* constraints = @[
                             // top
                             [NSLayoutConstraint constraintWithItem:instance.view
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_containerView
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1
                                                           constant:0],
                             // left
                             [NSLayoutConstraint constraintWithItem:instance.view
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_containerView
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1
                                                           constant:0],
                             // right
                             [NSLayoutConstraint constraintWithItem:instance.view
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_containerView
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1
                                                           constant:0],
                             ];
    instance.constraints = constraints;
    [_containerView addSubview:instance.view];
    [_containerView addConstraints:constraints];
}

- (void)beginPresentAnimation:(IIShortNotificationViewInstance*)instance;
{
    instance.topConstraint.constant = -instance.view.intrinsicContentSize.height;
    [_containerView layoutIfNeeded];
}

- (void)endPresentAnimation:(IIShortNotificationViewInstance*)instance;
{
    instance.topConstraint.constant = [self statusBarHeight];
    [_containerView layoutIfNeeded];
}

- (void)beginDismissAnimation:(IIShortNotificationViewInstance*)instance;
{

}

- (void)endDismissAnimation:(IIShortNotificationViewInstance*)instance;
{
    instance.topConstraint.constant = -instance.view.intrinsicContentSize.height;
    [_containerView layoutIfNeeded];
}

- (void)removeInstance:(IIShortNotificationViewInstance*)instance;
{

}

- (CGFloat)statusBarHeight {
    UIView* sv = [_containerView superview];
    UIView* psv = nil;
    while (sv) {
        CGFloat diff = CGRectGetHeight(psv.bounds) > 0 ? (CGRectGetHeight(sv.bounds) - CGRectGetHeight(psv.bounds)) : 0;
        if (diff > 0) {
            return 0;
        }
        if ([sv isKindOfClass:NSClassFromString(@"UIViewControllerWrapperView")]) {
            CGFloat height = UIInterfaceOrientationIsPortrait([[UIDevice currentDevice] orientation]) ? 64 : 52;
            return height;
        }
        psv = sv;
        sv = [sv superview];
    }
    return 20;
}

@end

@implementation IIShortNotificationViewInstance (IIShortNotificationTopLayout)

- (NSLayoutConstraint *)topConstraint
{
    return [self.constraints firstObject];
}

@end
