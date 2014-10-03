//
//  IIShortNotificationViewInstance.h
//  NotificationDemo
//
//  Created by Tom Adriaenssen on 02/10/14.
//  Copyright (c) 2014 Tom Adriaenssen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IIShortNotificationPresentation.h"
#import "IIShortNotificationView.h"

@interface IIShortNotificationViewInstance : NSObject

@property (nonatomic, strong) UIView<IIShortNotificationView>* view;
@property (nonatomic, strong) NSArray* constraints;
@property (nonatomic, assign) BOOL accessory;
@property (nonatomic, copy) void (^completion)(IIShortNotificationDismissal dismissal);

@end