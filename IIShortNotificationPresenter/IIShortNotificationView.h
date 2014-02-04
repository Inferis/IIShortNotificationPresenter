//
//  IIShortNotificationView.h
//  NotificationDemo
//
//  Created by Tom Adriaenssen on 02/02/14.
//  Copyright (c) 2014 Tom Adriaenssen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IIShortNotificationPresentation.h"

/**
 *  This protocol should be implemented by the
 */
@protocol IIShortNotificationView <NSObject>

- (void)setShortNotificationTitle:(NSString*)title;
- (void)setShortNotificationMessage:(NSString*)message;
- (void)setShortNotificationType:(IIShortNotificationType)type;
- (void)setShortNotificationAccessoryVisible:(BOOL)accessoryVisible;

@end
