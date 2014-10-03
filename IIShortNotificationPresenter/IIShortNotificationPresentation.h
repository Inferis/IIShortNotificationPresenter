//
//  IIShortNotificationPresentation.h
//  Copyright (c) 2014 Tom Adriaenssen. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  The types of notifications one can use.
 */
typedef NS_ENUM(NSUInteger, IIShortNotificationType) {
    /**
     *  Shows an error. The default implementation shows this as a red message.
     */
    IIShortNotificationError,
    /**
     *  Shows a confirmation. The default implementation shows this as a green message.
     */
    IIShortNotificationConfirmation,
    /**
     *  Shows a notification. The default implementation shows this as a blue message.
     */
    IIShortNotificationNotification
};


typedef NS_ENUM(NSUInteger, IIShortNotificationDismissal) {
    IIShortNotificationAutomaticDismissal,
    IIShortNotificationUserDismissal,
    IIShortNotificationUserAccessoryDismissal
};

@protocol IIShortNotificationPresentation <NSObject>

/**
 *  Present an error.
 *  The message does not autodismiss, and has to be dismissed by the user.
 *
 *  @note The class implementing this method has the freedom to choose a default title or not presenting the title.
 *
 *  @param error An NSString containing the errormessage to display.
 */
- (void)presentError:(NSError*)error;

/**
 *  Present an error message.
 *  The message does not autodismiss, and has to be dismissed by the user.
 *
 *  @note The class implementing this method has the freedom to choose a default title or not presenting the title.
 *
 *  @param error An NSString containing the errormessage to display.
 */
- (void)presentErrorMessage:(NSString*)message;

/**
 *  Present an error with a title.
 *  The message does not autodismiss, and has to be dismissed by the user.
 *
 *  @param error An NSString containing the error message to display.
 *  @param title An NSString containing the error title to display.
 */
- (void)presentError:(NSError*)error title:(NSString*)title;

/**
 *  Present an error message with a title.
 *  The message does not autodismiss, and has to be dismissed by the user.
 *
 *  @param error An NSString containing the error message to display.
 *  @param title An NSString containing the error title to display.
 */
- (void)presentErrorMessage:(NSString*)message title:(NSString*)title;

/**
 *  Present an error with a title.
 *  The message does not autodismiss, and has to be dismissed by the user.
 *
 *  @param error      An NSString containing the error message to display.
 *  @param title      An NSString containing the error title to display.
 *  @param completion A completion block called when the error is dismissed by the user.
 */
- (void)presentError:(NSError *)error title:(NSString*)title completion:(void(^)(void))completion;

/**
 *  Present an error message with a title.
 *  The message does not autodismiss, and has to be dismissed by the user.
 *
 *  @param error      An NSString containing the error message to display.
 *  @param title      An NSString containing the error title to display.
 *  @param completion A completion block called when the error is dismissed by the user.
 */
- (void)presentErrorMessage:(NSString *)message title:(NSString*)title completion:(void(^)(void))completion;

/**
 *  Present a confirmation message.
 *  The message does autodismiss, but the user can dismiss the confirmation earlier if he chooses to.
 *
 *  @note The class implementing this method has the freedom to choose a default title or not presenting the title.
 *
 *  @param confirmation An NSString containing the confirmation message to display.
 */
- (void)presentConfirmation:(NSString*)confirmation;

/**
 *  Present a confirmation message.
 *  The message does autodismiss, but the user can dismiss the confirmation earlier if he chooses to.
 *
 *  @param confirmation An NSString containing the confirmation message to display.
 *  @param title        An NSString containing the confirmation title to display.
 */
- (void)presentConfirmation:(NSString*)confirmation title:(NSString*)title;

/**
 *  Present a confirmation message.
 *  The message does autodismiss, but the user can dismiss the confirmation earlier if he chooses to.
 *
 *  @param confirmation An NSString containing the confirmation message to display.
 *  @param title        An NSString containing the confirmation title to display.
 *  @param accessory    A BOOL indicating if an accessory arrow should be displayed on the message.
 *  @param completion   A completion block called when the confirmation is dismissed by the user. This block has one BOOL parameter indicating if the dismissal was user generated.
 */
- (void)presentConfirmation:(NSString *)confirmation title:(NSString*)title accessory:(BOOL)accessory completion:(void(^)(IIShortNotificationDismissal dismissal))completion;

/**
 *  Present a notification message.
 *  The message does autodismiss, but the user can dismiss the notification earlier if he chooses to.
 *
 *  @note The class implementing this method has the freedom to choose a default title or not presenting the title.
 *
 *  @param notification An NSString containing the notification message to display.
 */
- (void)presentNotification:(NSString*)notification;

/**
 *  Present a notification message.
 *  The message does autodismiss, but the user can dismiss the notification earlier if he chooses to.
 *
 *  @param notification An NSString containing the notification message to display.
 *  @param title        An NSString containing the notification title to display.
 */
- (void)presentNotification:(NSString *)notification title:(NSString*)title;

/**
 *  Present a notification message.
 *  The message does autodismiss, but the user can dismiss the notification earlier if he chooses to.
 *
 *  @param notification An NSString containing the notification message to display.
 *  @param title        An NSString containing the notification title to display.
 *  @param accessory    A BOOL indicating if an accessory arrow should be displayed on the message.
 *  @param completion   A completion block called when the notification is dismissed by the user. This block has one BOOL parameter indicating if the dismissal was user generated.
 */
- (void)presentNotification:(NSString *)notification title:(NSString*)title accessory:(BOOL)accessory completion:(void(^)(IIShortNotificationDismissal dismissal))completion;


@end
