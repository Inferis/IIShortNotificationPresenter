//
//  IIShortNotificationDefaultView.m
//  NotificationDemo
//
//  Created by Tom Adriaenssen on 02/02/14.
//  Copyright (c) 2014 Tom Adriaenssen. All rights reserved.
//

#import "IIShortNotificationDefaultView.h"

static inline BOOL IsEmpty(id thing) {
    if (thing == nil) return YES;
    if ([thing isEqual:[NSNull null]]) return YES;
    if ([thing respondsToSelector:@selector(count)]) return [thing performSelector:@selector(count)] == 0;
    if ([thing respondsToSelector:@selector(length)]) return [thing performSelector:@selector(length)] == 0;
    return NO;
}

@implementation IIShortNotificationDefaultView {
    UILabel *_messageLabel, *_titleLabel;
    NSLayoutConstraint* _topConstraint;
    NSLayoutConstraint* _spacerConstraint;
    NSLayoutConstraint* _accessoryTopConstraint;
    UIView* _accessoryView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

-(void)commonInit {
    self.backgroundColor = [UIColor grayColor];
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowRadius = 12;
    self.layer.shadowOpacity = 0.5;
    self.layer.masksToBounds = NO;

    if (!_accessoryView) {
        _accessoryView = [self viewForAccessory];
        _accessoryView.translatesAutoresizingMaskIntoConstraints = NO;
        NSArray* constraints = @[
                                 // align horizontally
                                 [NSLayoutConstraint constraintWithItem:_accessoryView
                                                              attribute:NSLayoutAttributeCenterY
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self
                                                              attribute:NSLayoutAttributeCenterY
                                                             multiplier:1
                                                               constant:0],
                                 // pin to right
                                 [NSLayoutConstraint constraintWithItem:_accessoryView
                                                              attribute:NSLayoutAttributeRight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self
                                                              attribute:NSLayoutAttributeRight
                                                             multiplier:1
                                                               constant:-10]
                                 ];

        [self addSubview:_accessoryView];
        [self addConstraints:constraints];
        [_accessoryView setContentHuggingPriority:1000 forAxis:UILayoutConstraintAxisHorizontal];
        _accessoryTopConstraint = [constraints firstObject];
    }

    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.font = [UIFont boldSystemFontOfSize:_titleLabel.font.pointSize];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self applyTitleAppearance:_titleLabel];
        NSArray* constraints = @[
                                 [NSLayoutConstraint constraintWithItem:_titleLabel
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1
                                                               constant:10],
                                 [NSLayoutConstraint constraintWithItem:_titleLabel
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self
                                                              attribute:NSLayoutAttributeLeft
                                                             multiplier:1
                                                               constant:10],
                                 [NSLayoutConstraint constraintWithItem:_titleLabel
                                                              attribute:NSLayoutAttributeRight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self
                                                              attribute:NSLayoutAttributeRight
                                                             multiplier:1
                                                               constant:-10]
                                 ];
        [self addSubview:_titleLabel];
        [self addConstraints:constraints];
        _topConstraint = [constraints firstObject];
    }

    if (!_messageLabel) {
        _messageLabel = [UILabel new];
        _messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _messageLabel.textColor = [UIColor whiteColor];
        _messageLabel.numberOfLines = 999;
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        [self applyTitleAppearance:_messageLabel];
        NSArray* constraints = @[
                               [NSLayoutConstraint constraintWithItem:_messageLabel
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_titleLabel
                                                            attribute:NSLayoutAttributeBottom
                                                           multiplier:1
                                                             constant:10],
                               [NSLayoutConstraint constraintWithItem:_messageLabel
                                                            attribute:NSLayoutAttributeLeft
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeLeft
                                                           multiplier:1
                                                             constant:10],
                               [NSLayoutConstraint constraintWithItem:_messageLabel
                                                            attribute:NSLayoutAttributeRight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeRight
                                                           multiplier:1
                                                             constant:-10]
                               ];
        [self addSubview:_messageLabel];
        [self addConstraints:constraints];
        _spacerConstraint = [constraints firstObject];
    }

}

- (void)updateConstraints {
    // adjust the top constraint according to detected statusbarheight
    _topConstraint.constant = 10 + [self statusBarHeight];

    // adjust title/message space according to values set
    _spacerConstraint.constant = [self spacerHeight];

    // adjust accessory vertical offset according to statusbarheigt
    _accessoryTopConstraint.constant = [self statusBarHeight]/2;

    [super updateConstraints];
}

- (CGFloat)spacerHeight {
    return IsEmpty(_titleLabel.attributedText) ? 0 : 10;
}

- (CGFloat)statusBarHeight {
    UIView* sv = [self superview];
    UIView* psv = nil;
    while (sv) {
        CGFloat diff = CGRectGetHeight(psv.bounds) > 0 ? (CGRectGetHeight(sv.bounds) - CGRectGetHeight(psv.bounds)) : 0;
        if (diff > 0) {
            return 0;
        }
        if ([sv isKindOfClass:NSClassFromString(@"UIViewControllerWrapperView")]) {
            return UIInterfaceOrientationIsPortrait([[UIDevice currentDevice] orientation]) ? 52 : 64;
        }
        psv = sv;
        sv = [sv superview];
    }
    return 20;
}

- (CGSize)intrinsicContentSize {
    CGFloat titleHeight = [_titleLabel.text sizeWithAttributes:@{NSFontAttributeName:_titleLabel.font}].height;
    NSStringDrawingContext* context = [NSStringDrawingContext new];
    CGRect rect = [_messageLabel.text boundingRectWithSize:CGSizeMake(300, CGFLOAT_MAX)
                                                             options:NSStringDrawingUsesLineFragmentOrigin
                                                          attributes:@{NSFontAttributeName:_messageLabel.font}
                                                             context:context];

    CGFloat messageHeight = rect.size.height;

    CGFloat height = 20 + [self spacerHeight] + titleHeight + messageHeight + [self statusBarHeight];
    return CGSizeMake(320, height);
}

- (void)setError:(NSString *)error {
    _messageLabel.text = error;
    [self invalidateIntrinsicContentSize];
}

- (NSString *)error {
    return _messageLabel.text;
}

- (void)setShortNotificationTitle:(NSString*)title
{
    _titleLabel.text = title;
    [self invalidateIntrinsicContentSize];
    [self setNeedsUpdateConstraints];
}

- (void)setShortNotificationMessage:(NSString*)message;
{
    _messageLabel.text = message;
    [self invalidateIntrinsicContentSize];
    [self setNeedsUpdateConstraints];
}

- (void)setShortNotificationType:(IIShortNotificationType)type;
{
    self.backgroundColor = [self colorForType:type];
    self.layer.shadowColor = self.backgroundColor.CGColor;
    [self invalidateIntrinsicContentSize];
    [self setNeedsUpdateConstraints];
}

- (void)setShortNotificationAccessoryVisible:(BOOL)accessoryVisible;
{
    _accessoryView.hidden = !accessoryVisible;
    [self setNeedsUpdateConstraints];
}

#pragma mark - customisation

- (UIColor*)colorForType:(IIShortNotificationType)type {
    switch (type) {
        case IIShortNotificationError:
            return [UIColor redColor];
            break;

        case IIShortNotificationConfirmation:
            return [UIColor greenColor];

        default:
            return [UIColor blueColor];
    }

    return [UIColor grayColor];

}

- (void)applyTitleAppearance:(UILabel*)label {

}

- (void)applyMessageAppearance:(UILabel*)label {

}

- (UIView *)viewForAccessory {
    return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IIShortNotificationDefaultChevron"]];
}

@end
