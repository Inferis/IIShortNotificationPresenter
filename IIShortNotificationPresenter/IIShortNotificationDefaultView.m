//
//  IIShortNotificationDefaultView.m
//  NotificationDemo
//
//  Created by Tom Adriaenssen on 02/02/14.
//  Copyright (c) 2014 Tom Adriaenssen. All rights reserved.
//

#import "IIShortNotificationDefaultView.h"

#define MARGIN 15

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
    UIView* _slideupView;
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
                                                               constant:-MARGIN]
                                 ];

        [self addSubview:_accessoryView];
        [self addConstraints:constraints];
        [_accessoryView setContentHuggingPriority:1000 forAxis:UILayoutConstraintAxisHorizontal];
        _accessoryTopConstraint = [constraints firstObject];
    }

    if (!_slideupView) {
        _slideupView = [self viewForSlideupAccessory];
        _slideupView.translatesAutoresizingMaskIntoConstraints = NO;
        NSArray* constraints = @[
                                 // align horizontally
                                 [NSLayoutConstraint constraintWithItem:_slideupView
                                                              attribute:NSLayoutAttributeCenterX
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self
                                                              attribute:NSLayoutAttributeCenterX
                                                             multiplier:1
                                                               constant:0],
                                 // pin to bottom
                                 [NSLayoutConstraint constraintWithItem:_slideupView
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1
                                                               constant:-MARGIN]
                                 ];

        [self addSubview:_slideupView];
        [self addConstraints:constraints];
        [_slideupView setContentHuggingPriority:1000 forAxis:UILayoutConstraintAxisVertical];
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
                                                               constant:MARGIN],
                                 [NSLayoutConstraint constraintWithItem:_titleLabel
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self
                                                              attribute:NSLayoutAttributeLeft
                                                             multiplier:1
                                                               constant:MARGIN],
                                 [NSLayoutConstraint constraintWithItem:_titleLabel
                                                              attribute:NSLayoutAttributeRight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self
                                                              attribute:NSLayoutAttributeRight
                                                             multiplier:1
                                                               constant:-MARGIN]
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
        [self applyMessageAppearance:_messageLabel];
        NSArray* constraints = @[
                               [NSLayoutConstraint constraintWithItem:_messageLabel
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_titleLabel
                                                            attribute:NSLayoutAttributeBottom
                                                           multiplier:1
                                                             constant:MARGIN],
                               [NSLayoutConstraint constraintWithItem:_messageLabel
                                                            attribute:NSLayoutAttributeLeft
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeLeft
                                                           multiplier:1
                                                             constant:MARGIN],
                               [NSLayoutConstraint constraintWithItem:_messageLabel
                                                            attribute:NSLayoutAttributeRight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeRight
                                                           multiplier:1
                                                             constant:-MARGIN]
                               ];
        [self addSubview:_messageLabel];
        [self addConstraints:constraints];
        _spacerConstraint = [constraints firstObject];
    }

}

- (void)updateConstraints {
    // adjust the top constraint according to detected statusbarheight
    _topConstraint.constant = MARGIN + [self statusBarHeight];

    // adjust title/message space according to values set
    _spacerConstraint.constant = [self spacerHeight];

    // adjust accessory vertical offset according to statusbarheigt
    _accessoryTopConstraint.constant = [self statusBarHeight]/2;

    [super updateConstraints];
}

- (CGFloat)spacerHeight {
    return IsEmpty(_titleLabel.attributedText) ? 0 : MARGIN;
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

- (CGSize)intrinsicContentSize
{
    CGFloat titleHeight = [_titleLabel.text sizeWithAttributes:@{NSFontAttributeName:_titleLabel.font}].height;
    NSStringDrawingContext* context = [NSStringDrawingContext new];
    CGRect rect = [_messageLabel.text boundingRectWithSize:CGSizeMake(320-MARGIN*2, CGFLOAT_MAX)
                                                             options:NSStringDrawingUsesLineFragmentOrigin
                                                          attributes:@{NSFontAttributeName:_messageLabel.font}
                                                             context:context];

    CGFloat messageHeight = rect.size.height;
    CGFloat sliderHeight = [(_slideupView ?: [self viewForSlideupAccessory]) intrinsicContentSize].height;
    if (sliderHeight > 0)
        sliderHeight += MARGIN;

    CGFloat height = MARGIN*2 + [self spacerHeight] + sliderHeight + titleHeight + messageHeight + [self statusBarHeight];
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
    [self invalidateIntrinsicContentSize];
    [self setNeedsUpdateConstraints];
}

- (void)setShortNotificationMessage:(NSString*)message;
{
    [self invalidateIntrinsicContentSize];
    [self setNeedsUpdateConstraints];
}

- (void)setShortNotificationType:(IIShortNotificationType)type title:(NSString *)title message:(NSString *)message accessoryVisible:(BOOL)accessoryVisible
{
    self.backgroundColor = [self colorForType:type];

    // darker shadow
    CGFloat h, s, b, a;
    [self.backgroundColor getHue:&h saturation:&s brightness:&b alpha:&a];
    s *= 0.5;
    b *= 0.5;
    self.layer.shadowColor = [UIColor colorWithHue:h saturation:s brightness:b alpha:a].CGColor;

    // strings
    _titleLabel.text = title ?: [self defaultTitleForType:type];
    _messageLabel.text = message;
    // accessory
    _accessoryView.hidden = !accessoryVisible;

    [self invalidateIntrinsicContentSize];
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

- (UIView *)viewForSlideupAccessory {
    return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IIShortNotificationSlideupChevron"]];
}

- (NSString*)defaultTitleForType:(IIShortNotificationType)type {
    return nil;
}

@end
