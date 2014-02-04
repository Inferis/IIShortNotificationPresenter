//
//  ViewController.m
//  NotificationDemo
//
//  Created by Tom Adriaenssen on 02/02/14.
//  Copyright (c) 2014 Tom Adriaenssen. All rights reserved.
//

#import "ViewController.h"
#import "IIShortNotificationPresenter.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (IBAction)pressedError:(UIButton*)sender {
    switch (arc4random() % 3) {
        case 0:
            [self presentError:@"Only a message"];
            break;
        case 1:
            [self presentError:@"This error has a title too." title:@"Woah there"];
            break;
        case 2:
            sender.alpha = 0.5;
            [self presentError:@"A message, a title and a callback. This is pretty long.\n\nEven multiline." title:@"Awesomeness" completion:^{
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
