//
//  ViewController.m
//  NotificationDemo
//
//  Created by Tom Adriaenssen on 02/02/14.
//  Copyright (c) 2014 Tom Adriaenssen. All rights reserved.
//

#import "ViewController.h"
#import "IIShortNotificationPresenter.h"
#import "IIShortNotificationConcurrentQueue.h"
#import "IIShortNotificationRightSideLayout.h"
#import "TestNotificationView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[IIShortNotificationPresenter defaultConfiguration] setAutoDismissDelay:3];
    [[IIShortNotificationPresenter defaultConfiguration] setNotificationViewClass:[TestNotificationView class]];
    [[IIShortNotificationPresenter defaultConfiguration] setNotificationQueueClass:[IIShortNotificationConcurrentQueue class]];
    [[IIShortNotificationPresenter defaultConfiguration] setNotificationLayoutClass:[IIShortNotificationRightSideLayout class]];
}


- (IBAction)pressedBurst:(UIButton*)sender {
    NSUInteger count = 1 + arc4random() % 4;
    [self presentConfirmation:[NSString stringWithFormat:@"Sending a burst of %lu notifications.", count]];
    for (NSUInteger i=0; i<count; ++i) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(i*0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self pressedNotification:sender];
        });
    }
}


- (IBAction)pressedError:(UIButton*)sender {
    switch (arc4random() % 3) {
        case 0:
            [self presentErrorMessage:@"Only a message"];
            break;
        case 1:
            [self presentErrorMessage:@"This error has a title too." title:@"Woah there"];
            break;
        case 2:
            sender.alpha = 0.5;
            [self presentErrorMessage:@"A message, a title and a callback. This is pretty long.\n\nEven multiline." title:@"Awesomeness" completion:^{
                sender.alpha = 1;
            }];
            break;
    }
}

- (IBAction)pressedNotification:(UIButton*)sender {
    switch (arc4random() % 3) {
        case 0:
            [self presentNotification:@"Only a message"];
            break;
        case 1:
            [self presentNotification:@"This notification has a title too." title:@"Woah there"];
            break;
        case 2:
            sender.alpha = 0.5;
            [self presentNotification:@"A message, a title and a callback. There more to it than meets the eye." title:@"Awesomeness" accessory:arc4random()%2 completion:^(IIShortNotificationDismissal dismissal){
                sender.alpha = 1;
            }];
            break;
    }
}

- (IBAction)pressedConfirmation:(UIButton*)sender {
    switch (arc4random() % 3) {
        case 0:
            [self presentConfirmation:@"Only a message"];
            break;
        case 1:
            [self presentConfirmation:@"This confirmation has a title too." title:@"Woah there"];
            break;
        case 2:
            sender.alpha = 0.5;
            [self presentConfirmation:@"A message, a title and a callback." title:@"Awesomeness" accessory:arc4random()%2 completion:^(IIShortNotificationDismissal dismissal){
                sender.alpha = 1;
            }];
            break;
    }
}

@end
