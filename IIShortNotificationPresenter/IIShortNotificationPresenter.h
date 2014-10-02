//
//  IIShortNotificationPresenter.h
//  Copyright (c) 2014 Tom Adriaenssen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IIShortNotificationPresentation.h"
#import "IIShortNotificationView.h"

/**
 *  This category adds the notification presentation methods to UIViewControllers.
 */
@interface UIViewController (IIShortNotificationPresenter) <IIShortNotificationPresentation>

@end


@interface IIShortNotificationPresenter : NSObject <IIShortNotificationPresentation>

@property (nonatomic, weak, readonly) UIView* containerView;
@property (nonatomic, assign) NSTimeInterval autoDismissDelay;

/**
 *  Set the class of the View to present when presenting a notification.
 *  This class should implement the IIShortNotificationView protocol.
 *
 *  @param viewClass The class of the view to use to present a notification.
 */
+ (void)setNotificationViewClass:(Class)viewClass;

/**
 *  Sets the default autodismiss delay. This value will be used to set
 *  the initial value for each IIShortNotificationPresenter instance's autoDismissDelay
 *  property.
 *
 *  @param delay The default delay to set (in seconds). Should be any value larger than 0.
 */
+ (void)setDefaultAutoDismissDelay:(NSTimeInterval)delay;
/**
 *  Returns the default autodismiss delay.
 *
 *  @return the current default delay (in seconds).
 */
+ (NSTimeInterval)defaultAutoDismissDelay;

/**
 *  Set the class of the queue to use when presenting a notification.
 *  This class should implement the IIShortNotificationView protocol.
 *
 *  @param viewClass The class of the view to use to present a notification.
 */
+ (void)setNotificationQueueClass:(Class)queueClass;

/**
 *  Initializes this presenter to present notifications on a certain view.
 *
 *  @param view The view to present the notifications on.
 *
 *  @return An initialized instance of the presenter.
 */
- (id)initWithContainerView:(UIView*)view;



@end
