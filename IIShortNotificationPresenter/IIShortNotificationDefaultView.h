//
//  IIShortNotificationDefaultView.h
//  NotificationDemo
//
//  Created by Tom Adriaenssen on 02/02/14.
//  Copyright (c) 2014 Tom Adriaenssen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IIShortNotificationView.h"

@interface IIShortNotificationDefaultView : UIView<IIShortNotificationView>

- (UIView*)viewForAccessory;
- (UIColor*)colorForType:(IIShortNotificationType)type;
- (NSAttributedString*)attributedTitle:(NSString*)title;
- (NSAttributedString*)attributedMessage:(NSString*)message;

@end
