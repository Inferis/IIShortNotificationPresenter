//
//  IIShortNotificationSideLayout.h
//  NotificationDemo
//
//  Created by Tom Adriaenssen on 03/10/14.
//  Copyright (c) 2014 Tom Adriaenssen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IIShortNotificationLayout.h"

@interface IIShortNotificationRightSideLayout : NSObject <IIShortNotificationLayout>

@property (nonatomic, assign) CGFloat spacing;
@property (nonatomic, assign) CGFloat minimumTopSpacing;
@property (nonatomic, assign) CGFloat notificationWidth;

@end
