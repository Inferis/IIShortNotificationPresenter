//
//  IIShortNotificationPresenter.h
//  Copyright (c) 2014 Tom Adriaenssen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IIShortNotificationPresentation.h"
#import "IIShortNotificationView.h"
#import "IIShortNotificationConfiguration.h"

/**
 *  This category adds the notification presentation methods to UIViewControllers.
 */
@interface UIViewController (IIShortNotificationPresenter) <IIShortNotificationPresentation>

@end


@interface IIShortNotificationPresenter : NSObject <IIShortNotificationPresentation>

@property (nonatomic, weak, readonly) UIView* containerView;
@property (nonatomic, assign) NSTimeInterval autoDismissDelay;

+ (IIShortNotificationConfiguration*)defaultConfiguration;

/**
 *  Initializes this presenter to present notifications on a certain view.
 *
 *  @param view The view to present the notifications on.
 *
 *  @return An initialized instance of the presenter.
 */
- (id)initWithContainerView:(UIView*)view;



@end
