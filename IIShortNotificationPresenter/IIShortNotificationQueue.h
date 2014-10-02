//
//  IIShortNotificationQueue.h
//  Copyright (c) 2014 Tom Adriaenssen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IIShortNotificationPresentation.h"

@class IIShortNotificationPresenter;
@protocol IIShortNotificationQueueHandler;

@protocol IIShortNotificationQueue <NSObject>

@required
- (instancetype)initWithHandler:(id<IIShortNotificationQueueHandler>)handler;
- (void)queuePresentation:(IIShortNotificationType)type message:(NSString *)message title:(NSString *)title accessory:(BOOL)accessory completion:(void (^)(IIShortNotificationDismissal dismissal))completion;
- (void)dismissedPresentation;

@end

@protocol IIShortNotificationQueueHandler <NSObject>

@required
- (void)handlePresentation:(IIShortNotificationType)type message:(NSString *)message title:(NSString *)title accessory:(BOOL)accessory completion:(void (^)(IIShortNotificationDismissal dismissal))completion;
- (void)handlePresentationsFinished;

@end
