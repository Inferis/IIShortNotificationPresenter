//
//  IIShortNotificationPresenter.h
//  NotificationDemo
//
//  Created by Tom Adriaenssen on 02/02/14.
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

@property (nonatomic, weak, readonly) UIView<IIShortNotificationView>* presenterView;
@property (nonatomic, weak, readonly) UIView* containerView;

/**
 *  Set the class of the View to present when presenting a notification.
 *  This class should implement the IIShortNotificationView protocol.
 *
 *  @param viewClass The class of the view to use to present a notification.
 */
+ (void)setNotificationViewClass:(Class)viewClass;

/**
 *  Initializes this presenter to present notifications on a certain view.
 *
 *  @param view The view to present the notifications on.
 *
 *  @return An initialized instance of the presenter.
 */
- (id)initWithContainerView:(UIView*)view;

@end
