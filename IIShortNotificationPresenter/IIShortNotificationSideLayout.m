//
//  IIShortNotificationSideLayout.m
//  NotificationDemo
//
//  Created by Tom Adriaenssen on 03/10/14.
//  Copyright (c) 2014 Tom Adriaenssen. All rights reserved.
//

#import "IIShortNotificationSideLayout.h"
#import "IIShortNotificationPresentation+Internal.h"
#import <objc/runtime.h>

@interface IIShortNotificationViewInstance (IIShortNotificationSideLayout)

- (NSLayoutConstraint *)sideConstraint;

@property (nonatomic, strong) NSLayoutConstraint *attachmentConstraint;
@property (nonatomic, strong) IIShortNotificationViewInstance *nextInstance;

@end


@implementation IIShortNotificationSideLayout {
    id<IIShortNotificationLayoutContext> _layoutContext;
}

- (instancetype)initWithLayoutContext:(id<IIShortNotificationLayoutContext>)layoutContext
{
    self = [super init];
    if (self) {
        _layoutContext = layoutContext;
        _spacing = 10;
    }
    return self;
}

- (void)addInstance:(IIShortNotificationViewInstance*)instance
{
    NSArray* constraints = @[
                             // right
                             [NSLayoutConstraint constraintWithItem:instance.view
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_layoutContext.containerView
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1
                                                           constant:-self.spacing],
                             // width
                             [NSLayoutConstraint constraintWithItem:instance.view
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1
                                                           constant:200],
                             ];
    instance.constraints = constraints;
    [_layoutContext.containerView addSubview:instance.view];
    [_layoutContext.containerView addConstraints:constraints];
}

- (void)beginPresentAnimation:(IIShortNotificationViewInstance*)instance
{
    [self attachToPrevious:instance];
    instance.sideConstraint.constant = instance.view.intrinsicContentSize.width;
}

- (void)endPresentAnimation:(IIShortNotificationViewInstance*)instance
{
    instance.sideConstraint.constant = -self.spacing;
}

- (void)beginDismissAnimation:(IIShortNotificationViewInstance*)instance
{
}

- (void)endDismissAnimation:(IIShortNotificationViewInstance*)instance
{
    instance.sideConstraint.constant = instance.view.intrinsicContentSize.width;
    instance.nextInstance = [_layoutContext nextNotificationInstance:instance];
}

- (void)removeInstance:(IIShortNotificationViewInstance*)instance
{
    [self detach:instance];
    if (instance.nextInstance) {
        [self attachToPrevious:instance.nextInstance];
        instance.nextInstance = nil;
        [_layoutContext.containerView layoutIfNeeded];
    }
}

- (void)attachToPrevious:(IIShortNotificationViewInstance*)instance {
    UIView *relativeView = [_layoutContext previousNotificationInstance:instance].view;
    NSLayoutAttribute relativeAttribute = NSLayoutAttributeBottom;
    CGFloat relativeConstant = 0;

    if (!relativeView) {
        relativeView = _layoutContext.containerView;
        relativeAttribute = NSLayoutAttributeTop;
        relativeConstant = IIStatusBarHeight(_layoutContext.containerView);
    }

    // right
    NSLayoutConstraint* constraint = [NSLayoutConstraint constraintWithItem:instance.view
                                                                  attribute:NSLayoutAttributeTop
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:relativeView
                                                                  attribute:relativeAttribute
                                                                 multiplier:1
                                                                   constant:relativeConstant  + self.spacing];
    [self detach:instance];
    [instance setAttachmentConstraint:constraint];
    [_layoutContext.containerView addConstraint:constraint];
    [_layoutContext.containerView setNeedsUpdateConstraints];
}

- (void)detach:(IIShortNotificationViewInstance*)instance
{
    NSLayoutConstraint *existing = instance.attachmentConstraint;
    if (existing) {
        [_layoutContext.containerView removeConstraint:existing];
        [_layoutContext.containerView setNeedsUpdateConstraints];
    }
    instance.attachmentConstraint = nil;
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

- (void)setAttachmentConstraint:(NSLayoutConstraint *)attachmentConstraint
{
    NSMutableArray *constraints = [self.constraints mutableCopy];
    BOOL changed = NO;
    NSLayoutConstraint *existing = self.attachmentConstraint;
    if (existing) {
        [constraints removeObject:existing];
        changed = YES;
    }
    if (attachmentConstraint) {
        [constraints addObject:attachmentConstraint];
        changed = YES;
    }
    if (changed) {
        self.constraints = [constraints copy];
    }
}

- (NSLayoutConstraint *)attachmentConstraint {
    if (self.constraints.count > 2) {
        return [self.constraints lastObject];
    }
    return nil;
}

@end
