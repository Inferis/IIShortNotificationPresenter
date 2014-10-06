//
//  IIShortNotificationSideLayout.m
//  NotificationDemo
//
//  Created by Tom Adriaenssen on 03/10/14.
//  Copyright (c) 2014 Tom Adriaenssen. All rights reserved.
//

#import "IIShortNotificationRightSideLayout.h"
#import "IIShortNotificationPresentation+Internal.h"
#import <objc/runtime.h>

@interface IIShortNotificationViewInstance (IIShortNotificationSideLayout)

@property (nonatomic, assign) CGFloat initialWidth;

- (NSLayoutConstraint *)sideConstraint;

@end

@implementation IIShortNotificationRightSideLayout {
    id<IIShortNotificationLayoutContext> _layoutContext;
    NSMutableArray *_attachmentConstraints;
    NSMutableArray *_instances;
}

- (instancetype)initWithLayoutContext:(id<IIShortNotificationLayoutContext>)layoutContext
{
    self = [super init];
    if (self) {
        _layoutContext = layoutContext;
        _spacing = 10;
        _instances = [NSMutableArray new];
        _attachmentConstraints = [NSMutableArray new];
        _notificationWidth = 260;
    }
    return self;
}

- (UISwipeGestureRecognizerDirection)directionsForSwipingDismissal
{
    return UISwipeGestureRecognizerDirectionRight;
}

- (void)addInstance:(IIShortNotificationViewInstance*)instance
{
    NSArray* constraints = @[
                             // side
                             [NSLayoutConstraint constraintWithItem:instance.view
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_layoutContext.containerView
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1
                                                           constant:0],
                             // width
                             [NSLayoutConstraint constraintWithItem:instance.view
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1
                                                           constant:_notificationWidth],
                             ];
    instance.constraints = constraints;
    [_layoutContext.containerView addConstraints:constraints];
    [_layoutContext.containerView setNeedsUpdateConstraints];
}

- (void)beginPresentAnimation:(IIShortNotificationViewInstance*)instance
{
    [_instances addObject:instance];
    instance.initialWidth = [instance.view systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].width;
    instance.sideConstraint.constant = instance.initialWidth;
    [self rebuildAttachments];
}

- (void)endPresentAnimation:(IIShortNotificationViewInstance*)instance
{
    instance.sideConstraint.constant = -self.spacing;
    [_layoutContext.containerView setNeedsUpdateConstraints];
}

- (void)beginDismissAnimation:(IIShortNotificationViewInstance*)instance
{
}

- (void)endDismissAnimation:(IIShortNotificationViewInstance*)instance
{
    instance.sideConstraint.constant = instance.initialWidth;
    [_layoutContext.containerView setNeedsUpdateConstraints];
}

- (void)removeInstance:(IIShortNotificationViewInstance*)instance
{
    [_instances removeObject:instance];
    [self rebuildAttachments];
}

- (void)rebuildAttachments {
    [_layoutContext.containerView removeConstraints:_attachmentConstraints];
    [_attachmentConstraints removeAllObjects];

    UIView *relativeView = _layoutContext.containerView;
    NSLayoutAttribute relativeAttribute = NSLayoutAttributeTop;
    CGFloat relativeConstant = MAX(IIStatusBarHeight(_layoutContext.containerView), self.minimumTopSpacing);
    for (IIShortNotificationViewInstance *instance in _instances) {
        NSLayoutConstraint* constraint = [NSLayoutConstraint constraintWithItem:instance.view
                                                                      attribute:NSLayoutAttributeTop
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:relativeView
                                                                      attribute:relativeAttribute
                                                                     multiplier:1
                                                                       constant:relativeConstant  + self.spacing];
        [_attachmentConstraints addObject:constraint];
        relativeAttribute = NSLayoutAttributeBottom;
        relativeView = instance.view;
        relativeConstant = 0;
    }

    [_layoutContext.containerView addConstraints:_attachmentConstraints];
    [_layoutContext.containerView setNeedsUpdateConstraints];
    [_layoutContext.containerView setNeedsLayout];
}

@end

@implementation IIShortNotificationViewInstance (IIShortNotificationSideLayout)

- (IIShortNotificationViewInstance *)nextInstance {
    return objc_getAssociatedObject(self, @selector(nextInstance));
}

- (void)setNextInstance:(IIShortNotificationViewInstance *)nextInstance {
    objc_setAssociatedObject(self, @selector(nextInstance), nextInstance, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)sideConstraint
{
    return [self.constraints firstObject];
}

- (CGFloat)initialWidth
{
    return [objc_getAssociatedObject(self, @selector(initialWidth)) floatValue];
}

- (void)setInitialWidth:(CGFloat)initialWidth
{
    objc_setAssociatedObject(self, @selector(initialWidth), @(initialWidth), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
