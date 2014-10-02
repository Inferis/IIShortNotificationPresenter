//
//  IIShortNotificationView.h
//  Copyright (c) 2014 Tom Adriaenssen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IIShortNotificationPresentation.h"

/**
 *  This protocol should be implemented by the
 */
@protocol IIShortNotificationView <NSObject>

- (void)setShortNotificationType:(IIShortNotificationType)type
                           title:(NSString*)title
                          message:(NSString*)message
                 accessoryVisible:(BOOL)accessoryVisible;

@end
