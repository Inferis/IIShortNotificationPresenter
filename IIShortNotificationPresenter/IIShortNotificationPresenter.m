//
//  IIShortNotificationPresenter.m
//
//  Created by Tom Adriaenssen on 02/02/14.
//  Copyright (c) 2014 Tom Adriaenssen. All rights reserved.
//

#import "IIShortNotificationPresenter.h"
#import "IIShortNotificationDefaultView.h"
#import <objc/runtime.h>

// Blatantly picked up from [Wil Shipley](http://blog.wilshipley.com/2005/10/pimp-my-code-interlude-free-code.html)
//
// > Essentially, if you're wondering if an NSString or NSData or
// > NSAttributedString or NSArray or NSSet has actual useful data in
// > it, this is your macro. Instead of checking things like
// > `if (inputString == nil || [inputString length] == 0)` you just
// > say, "if (IsEmpty(inputString))".
//
// It rocks.
static inline BOOL IsEmpty(id thing) {
    if (thing == nil) return YES;
    if ([thing isEqual:[NSNull null]]) return YES;
    if ([thing respondsToSelector:@selector(count)]) return [thing performSelector:@selector(count)] == 0;
    if ([thing respondsToSelector:@selector(length)]) return [thing performSelector:@selector(length)] == 0;
    return NO;
}

@implementation IIShortNotificationPresenter {
    UIView<IIShortNotificationView>* _notificationView;
    UIView* _overlayView;
    __weak NSLayoutConstraint* _topConstraint;
    __weak UIView* _superview;
    NSMutableArray* _queue;
    BOOL _presenting;
    BOOL _accessory;
    void (^_completion)(IIShortNotificationDismissal dismissal);
    BOOL _allowUserDismissal;
}

- (id)initWithContainerView:(UIView *)view
{
    self = [super init];
    if (self) {
        _superview = view;
        _queue = [NSMutableArray array];
    }
    return self;
}

- (UIView<IIShortNotificationView> *)presenterView {
    return _notificationView;
}

- (UIView *)containerView {
    return _superview;
}

#pragma mark - Error

- (void)presentError:(NSString *)error
{
    [self presentError:error title:nil completion:nil];
}

- (void)presentError:(NSString *)error title:(NSString *)title
{
    [self presentError:error title:title completion:nil];
}

- (void)presentError:(NSString *)error title:(NSString *)title completion:(void (^)(void))completion
{
    [self queuePresentation:IIShortNotificationError
                    message:error
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
    if (IsEmpty(message) && IsEmpty(title))
        return;

    NSMutableDictionary* msg = [@{@"type": @(type)} mutableCopy];
    if (message) msg[@"message"] = message;
    if (title) msg[@"title"] = title;
    if (accessory) msg[@"accessory"] = @YES;
    if (completion) msg[@"completion"] = completion;

    [_queue insertObject:msg atIndex:0];
    [self handleQueue];
}

- (void)handleQueue
{
    if (_presenting)
        return;

    NSDictionary* msg = [_queue lastObject];
    [_queue removeLastObject];
    if (msg) {
        [self present:[msg[@"type"] unsignedIntegerValue]
              message:msg[@"message"]
                title:msg[@"title"]
             accesory:[msg[@"accessory"] boolValue]
           completion:msg[@"completion"]];
    }
    else {
        [_overlayView removeFromSuperview];
        _overlayView = nil;
        _notificationView = nil;
    }
}

- (void)present:(IIShortNotificationType)type message:(NSString *)message title:(NSString *)title accesory:(BOOL)accessory completion:(void (^)(IIShortNotificationDismissal dismissal))completion
{
    if (!_overlayView) {
        _overlayView = [UIView new];
        _overlayView.translatesAutoresizingMaskIntoConstraints = NO;
        _overlayView.clipsToBounds = YES;

        UITapGestureRecognizer* tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        [_overlayView addGestureRecognizer:tapper];

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

    if (!_notificationView) {
        UIView<IIShortNotificationView>* notificationView = [[[self class] notificationViewClass] new];
        _notificationView = notificationView;
        _notificationView.translatesAutoresizingMaskIntoConstraints = NO;
        _notificationView.alpha = 0;
        [_overlayView addSubview:_notificationView];

        UISwipeGestureRecognizer* swiper = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swiped:)];
        swiper.direction = UISwipeGestureRecognizerDirectionUp;
        [_overlayView addGestureRecognizer:swiper];

        NSArray* constraints = @[
                                 // top
                                 [NSLayoutConstraint constraintWithItem:_notificationView
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:_overlayView
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1
                                                               constant:0],
                                 // left
                                 [NSLayoutConstraint constraintWithItem:_notificationView
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:_overlayView
                                                              attribute:NSLayoutAttributeLeft
                                                             multiplier:1
                                                               constant:0],
                                 // right
                                 [NSLayoutConstraint constraintWithItem:_notificationView
                                                              attribute:NSLayoutAttributeRight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:_overlayView
                                                              attribute:NSLayoutAttributeRight
                                                             multiplier:1
                                                               constant:0],
                                 ];
        _topConstraint = [constraints firstObject];
        [_overlayView addConstraints:constraints];
    }

    _notificationView.alpha = 0;
    [_notificationView setShortNotificationType:type];
    [_notificationView setShortNotificationTitle:title];
    [_notificationView setShortNotificationMessage:message];
    [_notificationView setShortNotificationAccessoryVisible:accessory];
    _topConstraint.constant = -_notificationView.intrinsicContentSize.height;
    [_overlayView layoutIfNeeded];

    _presenting = YES;
    _accessory = accessory;
    _completion = [completion copy];
    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.6 options:0 animations:^{
        _notificationView.alpha = 1;
        _topConstraint.constant = 0;
        [_overlayView layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];

    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    if (type != IIShortNotificationError) {
        [self performSelector:@selector(autoDismiss) withObject:nil afterDelay:3];
    }
}

- (void)autoDismiss {
    [self dismiss:IIShortNotificationAutomaticDismissal];
}

- (void)dismiss:(IIShortNotificationDismissal)dismissal {
    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.6 options:0 animations:^{
        _notificationView.alpha = 0;
        _topConstraint.constant = -_notificationView.intrinsicContentSize.height;
        [_overlayView layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (_completion) _completion(dismissal);
        _completion = nil;
        _accessory = NO;
        _presenting = NO;
        [self handleQueue];
    }];
}

#pragma mark - dismissing tap

- (void)tapped:(UITapGestureRecognizer*)tapper {
    if (_accessory & CGRectContainsPoint(_notificationView.bounds, [tapper locationInView:_notificationView])) {
        [self dismiss:IIShortNotificationUserAccessoryDismissal];
    }
    else
        [self dismiss:IIShortNotificationUserDismissal];
}

- (void)swiped:(UITapGestureRecognizer*)swiper {
    [self dismiss:IIShortNotificationUserDismissal];
}

#pragma mark - View class

static Class _viewClass;

+ (void)setNotificationViewClass:(Class)viewClass {
    _viewClass = viewClass;
}

+ (Class)notificationViewClass {
    return _viewClass ?: [IIShortNotificationDefaultView class];
}

@end

@implementation UIViewController (IIShortNotificationPresenter)

- (id<IIShortNotificationPresentation>)presenter {
    IIShortNotificationPresenter* presenter = objc_getAssociatedObject(self, @selector(presenter));
    if (!presenter) {
        presenter = [[IIShortNotificationPresenter alloc] initWithContainerView:self.view];
        objc_setAssociatedObject(self, @selector(presenter), presenter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }

    return presenter;
}

- (void)presentError:(NSString*)error
{
    [[self presenter] presentError:error];
}

- (void)presentError:(NSString*)error title:(NSString*)title;
{
    [[self presenter] presentError:error title:title];
}

- (void)presentError:(NSString *)error title:(NSString*)title completion:(void(^)(void))completion
{
    [[self presenter] presentError:error title:title completion:completion];
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