//
//  IIShortNotificationDefaultView.m
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
    NSLayoutConstraint *_spacerConstraint;
    NSLayoutConstraint *_accessoryViewRightConstraint;
    UIView *_accessoryView;
    UIView *_slideupView;
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
                                                               constant:-MARGIN],
                                 ];

        [self addSubview:_accessoryView];
        [self addConstraints:constraints];
        _accessoryViewRightConstraint = [constraints lastObject];
        [_accessoryView setContentCompressionResistancePriority:1000 forAxis:UILayoutConstraintAxisHorizontal];
        [_accessoryView setContentCompressionResistancePriority:1000 forAxis:UILayoutConstraintAxisVertical];
        [_accessoryView setContentHuggingPriority:1000 forAxis:UILayoutConstraintAxisHorizontal];
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
                                                                 toItem:_accessoryView
                                                              attribute:NSLayoutAttributeRight
                                                             multiplier:1
                                                               constant:-MARGIN]
                                 ];
        [self addSubview:_titleLabel];
        [self addConstraints:constraints];
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
                                                               toItem:_accessoryView
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
    // adjust title/message space according to values set
    _spacerConstraint.constant = [self spacerHeight];
    _accessoryViewRightConstraint.constant = _accessoryView.hidden ? 0 : -MARGIN;
    [super updateConstraints];
}

- (CGFloat)spacerHeight {
    return IsEmpty(_titleLabel.attributedText) ? 0 : MARGIN;
}

- (void)layoutSubviews
{
    NSLayoutConstraint *labelAsWideAsPossibleConstraint = [NSLayoutConstraint constraintWithItem:_messageLabel
                                                                                       attribute:NSLayoutAttributeWidth
                                                                                       relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                                          toItem:nil
                                                                                       attribute:0
                                                                                      multiplier:1.0
                                                                                        constant:1e8]; // a big number
    labelAsWideAsPossibleConstraint.priority = [_messageLabel contentCompressionResistancePriorityForAxis:UILayoutConstraintAxisHorizontal];
    [_messageLabel addConstraint:labelAsWideAsPossibleConstraint];

    [super layoutSubviews];

    CGFloat availableLabelWidth = _messageLabel.frame.size.width;
    _messageLabel.preferredMaxLayoutWidth = availableLabelWidth;
    [_messageLabel removeConstraint:labelAsWideAsPossibleConstraint];

    [super layoutSubviews];
}


- (CGSize)intrinsicContentSize
{
    [self layoutSubviews];
    CGFloat titleHeight = [_titleLabel.text sizeWithAttributes:@{NSFontAttributeName:_titleLabel.font}].height;
    CGSize desired = [_messageLabel systemLayoutSizeFittingSize:UILayoutFittingExpandedSize];
    CGFloat width = desired.width + MARGIN*2;
    CGFloat messageHeight = desired.height;

    CGFloat sliderHeight = [(_slideupView ?: [self viewForSlideupAccessory]) intrinsicContentSize].height;
    if (sliderHeight > 0)
        sliderHeight += MARGIN;

    CGFloat height = MARGIN*2 + [self spacerHeight] + sliderHeight + titleHeight + messageHeight;
    return CGSizeMake(width, height);
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
    return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IIShortNotificationSlideUpChevron"]];
}

- (NSString*)defaultTitleForType:(IIShortNotificationType)type {
    return nil;
}

@end
