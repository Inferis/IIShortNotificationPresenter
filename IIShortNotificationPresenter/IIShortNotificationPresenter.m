//
//  IIShortNotificationPresenter.m
//  Copyright (c) 2014 Tom Adriaenssen. All rights reserved.
//

#import "IIShortNotificationPresenter.h"
#import "IIShortNotificationQueue.h"
#import "IIShortNotificationSerialQueue.h"
#import "IIShortNotificationDefaultView.h"
#import "IIShortNotificationViewInstance.h"
#import "IIShortNotificationLayout.h"
#import "IIShortNotificationTopLayout.h"
#import <objc/runtime.h>

@interface IIShortNotificationPresenter () <IIShortNotificationQueueHandler>

@end

@interface IIShortNotificationPresenterLayoutContext : NSObject <IIShortNotificationLayoutContext>

- (instancetype)initWithPresenter:(IIShortNotificationPresenter*)presenter;

@end

@implementation IIShortNotificationPresenter {
    @public
    NSMutableArray *_usedNotificationViews;
    UIView* _overlayView;
    @private
    IIShortNotificationConfiguration *_configuration;
    id<IIShortNotificationQueue> _queue;
    IIShortNotificationPresenterLayoutContext *_layoutContainer;
    id<IIShortNotificationLayout> _layout;
    __weak UIView* _superview;
}

- (id)initWithContainerView:(UIView *)view
{
    self = [super init];
    if (self) {
        _configuration = [[self.class defaultConfiguration] copy];
        self.autoDismissDelay = _configuration.autoDismissDelay;
        _queue = [_configuration queueWithHandler:self];
        _superview = view;
        _usedNotificationViews = [NSMutableArray array];
    }
    return self;
}

- (UIView *)containerView {
    return _superview;
}

#pragma mark - configuration

IIShortNotificationConfiguration *_defaultConfiguration;

+ (IIShortNotificationConfiguration *)defaultConfiguration
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultConfiguration = [IIShortNotificationConfiguration new];
    });
    return _defaultConfiguration;
}

#pragma mark - Error

- (void)presentError:(NSError *)error
{
    [self presentError:error title:nil completion:nil];
}

- (void)presentErrorMessage:(NSString *)message
{
    [self presentErrorMessage:message title:nil completion:nil];
}

- (void)presentError:(NSError *)error title:(NSString *)title
{
    [self presentError:error title:title completion:nil];
}

- (void)presentErrorMessage:(NSString *)message title:(NSString *)title
{
    [self presentErrorMessage:message title:title completion:nil];
}

- (void)presentError:(NSError *)error title:(NSString *)title completion:(void (^)(void))completion
{
    [self presentErrorMessage:error.localizedDescription title:title completion:completion];
}

- (void)presentErrorMessage:(NSString *)message title:(NSString *)title completion:(void (^)(void))completion
{
    [self queuePresentation:IIShortNotificationError
                    message:message
                      title:title
                  accessory:NO
                 completion:completion ? ^(IIShortNotificationDismissal dismissal){ completion(); } : nil];
}

#pragma mark - Confirmation

- (void)presentConfirmation:(NSString *)confirmation
{
    [self presentConfirmation:confirmation title:nil accessory:NO completion:nil];
}

- (void)presentConfirmation:(NSString *)confirmation title:(NSString *)title
{
    [self presentConfirmation:confirmation title:title accessory:NO completion:nil];
}

- (void)presentConfirmation:(NSString *)confirmation title:(NSString *)title accessory:(BOOL)accessory completion:(void (^)(IIShortNotificationDismissal dismissal))completion
{
    [self queuePresentation:IIShortNotificationConfirmation
                    message:confirmation
                      title:title
                  accessory:accessory
                 completion:completion];
}

#pragma mark - Notification

- (void)presentNotification:(NSString *)notification
{
    [self presentNotification:notification title:nil accessory:NO completion:nil];
}

- (void)presentNotification:(NSString *)notification title:(NSString *)title
{
    [self presentNotification:notification title:title accessory:NO completion:nil];
}

- (void)presentNotification:(NSString *)notification title:(NSString *)title accessory:(BOOL)accessory completion:(void (^)(IIShortNotificationDismissal dismissal))completion
{
    [self queuePresentation:IIShortNotificationNotification
                    message:notification
                      title:title
                  accessory:accessory
                 completion:completion];
}

#pragma mark - Hard work

- (void)queuePresentation:(IIShortNotificationType)type message:(NSString *)message title:(NSString *)title accessory:(BOOL)accessory completion:(void (^)(IIShortNotificationDismissal dismissal))completion
{
    [_queue queuePresentation:type message:message title:title accessory:accessory completion:completion];
}

- (void)handlePresentation:(IIShortNotificationType)type message:(NSString *)message title:(NSString *)title accessory:(BOOL)accessory completion:(void (^)(IIShortNotificationDismissal dismissal))completion
{
    if (!_overlayView) {
        _overlayView = [UIView new];
        _overlayView.translatesAutoresizingMaskIntoConstraints = NO;
        _overlayView.clipsToBounds = YES;

        _layoutContainer = [[IIShortNotificationPresenterLayoutContext alloc] initWithPresenter:self];
        _layout = [_configuration layoutWithContext:_layoutContainer];

        UITapGestureRecognizer* tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        [_overlayView addGestureRecognizer:tapper];

        if ([_layout respondsToSelector:@selector(directionsForSwipingDismissal)]) {
            UISwipeGestureRecognizerDirection directions = [_layout directionsForSwipingDismissal];

            if ((directions & UISwipeGestureRecognizerDirectionUp) > 0) {
                UISwipeGestureRecognizer* swiper = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swiped:)];
                swiper.direction = UISwipeGestureRecognizerDirectionUp;
                [_overlayView addGestureRecognizer:swiper];
            }
            if ((directions & UISwipeGestureRecognizerDirectionDown) > 0) {
                UISwipeGestureRecognizer* swiper = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swiped:)];
                swiper.direction = UISwipeGestureRecognizerDirectionDown;
                [_overlayView addGestureRecognizer:swiper];
            }
            if ((directions & UISwipeGestureRecognizerDirectionLeft) > 0) {
                UISwipeGestureRecognizer* swiper = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swiped:)];
                swiper.direction = UISwipeGestureRecognizerDirectionLeft;
                [_overlayView addGestureRecognizer:swiper];
            }
            if ((directions & UISwipeGestureRecognizerDirectionRight) > 0) {
                UISwipeGestureRecognizer* swiper = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swiped:)];
                swiper.direction = UISwipeGestureRecognizerDirectionRight;
                [_overlayView addGestureRecognizer:swiper];
            }
        }
    }

    if (_overlayView.superview != _superview) {
        [_superview addSubview:_overlayView];
        [_superview addConstraints:@[
                                    // top
                                    [NSLayoutConstraint constraintWithItem:_overlayView
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_superview
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1
                                                                  constant:0],
                                    // left
                                    [NSLayoutConstraint constraintWithItem:_overlayView
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_superview
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1
                                                                  constant:0],
                                    // right
                                    [NSLayoutConstraint constraintWithItem:_overlayView
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_superview
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1
                                                                  constant:0],
                                    // bottom
                                    [NSLayoutConstraint constraintWithItem:_overlayView
                                                                 attribute:NSLayoutAttributeBottom
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_superview
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1
                                                                  constant:0],
                                    ]];

    }

    IIShortNotificationViewInstance *instance = [self dequeueNotificationView];

    [instance.view setShortNotificationType:type title:title message:message accessoryVisible:accessory];
    instance.accessory = accessory;
    instance.completion = [completion copy];

    [_overlayView sendSubviewToBack:instance.view];
    [_layout beginPresentAnimation:instance];
    [_overlayView setNeedsLayout];
    [_overlayView layoutIfNeeded];

    CGFloat duration = -1;
    if ([_layout respondsToSelector:@selector(presentingAnimationDuration)]) {
        duration = [_layout presentingAnimationDuration];
    }
    if (duration < 0) duration = 0.6;
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.6 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [_layout endPresentAnimation:instance];
        [_overlayView layoutIfNeeded];
        instance.view.alpha = 1;
    } completion:^(BOOL finished) {
    }];

    if ([_configuration shouldAutoDismiss:type]) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoDismiss:) object:instance];
        [self performSelector:@selector(autoDismiss:) withObject:instance afterDelay:self.autoDismissDelay];
    }
}

- (void)handlePresentationsFinished
{
    [_overlayView removeFromSuperview];
}

- (void)autoDismiss:(IIShortNotificationViewInstance*)instance
{
    [self dismiss:IIShortNotificationAutomaticDismissal instance:instance];
}


- (void)dismiss:(IIShortNotificationDismissal)dismissal instance:(IIShortNotificationViewInstance *)instance {
    if (!instance) return;
    // don't dismiss non active instances
    if (![_usedNotificationViews containsObject:instance]) return;

    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoDismiss:) object:instance];
    [_layout beginDismissAnimation:instance];
    [_overlayView layoutIfNeeded];

    CGFloat duration = -1;
    if ([_layout respondsToSelector:@selector(dismissingAnimationDuration)]) {
        duration = [_layout dismissingAnimationDuration];
    }
    if (duration < 0) duration = 0.2;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [_layout endDismissAnimation:instance];
        [_overlayView layoutIfNeeded];
        instance.view.alpha = 0;
    } completion:^(BOOL finished) {
        @synchronized(_usedNotificationViews) {
            [_usedNotificationViews removeObject:instance];
        }

        CGFloat duration = -1;
        if ([_layout respondsToSelector:@selector(removingAnimationDuration)]) {
            duration = [_layout removingAnimationDuration];
        }
        if (duration < 0) duration = 0.2;
        if (duration == 0) { // don't animate
            [_layout removeInstance:instance];
            [_overlayView layoutIfNeeded];
            [instance.view removeFromSuperview];
        }
        else {
            [UIView animateWithDuration:duration animations:^{
                [_layout removeInstance:instance];
                [_overlayView layoutIfNeeded];
            } completion:^(BOOL finished) {
                [instance.view removeFromSuperview];
            }];
        }
        [_queue dismissedPresentation];
        if (instance.completion) instance.completion(dismissal);
    }];
}

#pragma mark - notification views

- (IIShortNotificationViewInstance*)dequeueNotificationView {
    IIShortNotificationViewInstance *instance = nil;

    if (!instance) {
        instance = [IIShortNotificationViewInstance new];
        instance.view = [_configuration view];
        instance.view.translatesAutoresizingMaskIntoConstraints = NO;
    }

    [_overlayView addSubview:instance.view];
    [_layout addInstance:instance];
    instance.view.alpha = 0;
    @synchronized(_usedNotificationViews) {
        [_usedNotificationViews addObject:instance];
    }
    return instance;
}

#pragma mark - dismissing tap

- (void)tapped:(UITapGestureRecognizer*)tapper {
    IIShortNotificationViewInstance *tappedInstance;
    BOOL viewTapped = NO;

    @synchronized(_usedNotificationViews) {
        for (IIShortNotificationViewInstance* instance in _usedNotificationViews) {
            if (CGRectContainsPoint(instance.view.bounds, [tapper locationInView:instance.view])) {
                tappedInstance = instance;
                viewTapped = YES;
                break;
            }
        }

        tappedInstance = tappedInstance ?: [_usedNotificationViews firstObject];
    }

    if (!tappedInstance) return;

    if (tappedInstance.accessory & viewTapped) {
        [self dismiss:IIShortNotificationUserAccessoryDismissal instance:tappedInstance];
    }
    else
        [self dismiss:IIShortNotificationUserDismissal instance:tappedInstance];
}

- (void)swiped:(UITapGestureRecognizer*)swiper {
    IIShortNotificationViewInstance *topInstance;
    @synchronized(_usedNotificationViews) {
        topInstance = [_usedNotificationViews firstObject];
    }

    if (!topInstance) return;

    [self dismiss:IIShortNotificationUserDismissal instance:topInstance];
}

@end

@implementation UIViewController (IIShortNotificationPresenter)

- (id<IIShortNotificationPresentation>)presenter {
    IIShortNotificationPresenter* presenter = objc_getAssociatedObject(self, @selector(presenter));
    if (!presenter) {
        UIView *view = nil;
        UIView*(^viewProvider)(UIViewController *controller) = [[IIShortNotificationPresenter defaultConfiguration] containerViewProvider];
        if (viewProvider) {
            view = viewProvider(self);
        }
        if (!view) {
            view = self.view;
        }
        presenter = [[IIShortNotificationPresenter alloc] initWithContainerView:view];
        objc_setAssociatedObject(self, @selector(presenter), presenter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }

    return presenter;
}

- (void)presentError:(NSError *)error
{
    [[self presenter] presentError:error];
}

- (void)presentErrorMessage:(NSString *)message
{
    [[self presenter] presentErrorMessage:message];
}

- (void)presentError:(NSError *)error title:(NSString *)title
{
    [[self presenter] presentError:error title:title];
}

- (void)presentErrorMessage:(NSString *)message title:(NSString *)title
{
    [[self presenter] presentErrorMessage:message title:title];
}

- (void)presentError:(NSError *)error title:(NSString *)title completion:(void (^)(void))completion
{
    [[self presenter] presentError:error title:title completion:completion];
}

- (void)presentErrorMessage:(NSString *)message title:(NSString *)title completion:(void (^)(void))completion
{
    [[self presenter] presentErrorMessage:message title:title completion:completion];
}
- (void)presentConfirmation:(NSString*)confirmation
{
    [[self presenter] presentConfirmation:confirmation];
}

- (void)presentConfirmation:(NSString*)confirmation title:(NSString*)title
{
    [[self presenter] presentConfirmation:confirmation title:title];
}

- (void)presentConfirmation:(NSString *)confirmation title:(NSString*)title accessory:(BOOL)accessory completion:(void(^)(IIShortNotificationDismissal dismissal))completion
{
    [[self presenter] presentConfirmation:confirmation title:title accessory:accessory completion:completion];
}

- (void)presentNotification:(NSString*)notification;
{
    [[self presenter] presentNotification:notification];
}

- (void)presentNotification:(NSString *)notification title:(NSString*)title
{
    [[self presenter] presentNotification:notification title:title];
}

- (void)presentNotification:(NSString *)notification title:(NSString*)title accessory:(BOOL)accessory completion:(void(^)(IIShortNotificationDismissal dismissal))completion
{
    [[self presenter] presentNotification:notification title:title accessory:accessory completion:completion];
}

@end

@implementation IIShortNotificationPresenterLayoutContext {
    IIShortNotificationPresenter *_presenter;
}

- (instancetype)initWithPresenter:(IIShortNotificationPresenter *)presenter
{
    self = [super init];
    if (self) {
        _presenter = presenter;
    }
    return self;
}

- (UIView *)containerView
{
    return _presenter->_overlayView;
}

- (IIShortNotificationViewInstance*)previousNotificationInstance:(IIShortNotificationViewInstance*)instance;
{
    return [self previousNotificationInstance:instance in:_presenter->_usedNotificationViews];
}

- (IIShortNotificationViewInstance*)nextNotificationInstance:(IIShortNotificationViewInstance*)instance;
{
    return [self nextNotificationInstance:instance in:_presenter->_usedNotificationViews];
}

- (IIShortNotificationViewInstance*)previousNotificationInstance:(IIShortNotificationViewInstance*)instance in:(NSArray*)instances
{
    BOOL next = NO;
    for (IIShortNotificationViewInstance *other in [instances reverseObjectEnumerator]) {
        if (next) {
            return other;
        }

        if (other == instance) {
            next = YES;
        }
    }

    return nil;
}

- (IIShortNotificationViewInstance*)nextNotificationInstance:(IIShortNotificationViewInstance*)instance in:(NSArray*)instances
{
    IIShortNotificationViewInstance *last = nil;
    for (IIShortNotificationViewInstance *other in [instances reverseObjectEnumerator]) {
        if (other == instance) {
            return last;
        }
        last = other;
    }

    return nil;
}


@end