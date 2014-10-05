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
    NSLayoutConstraint *_titleHeightConstraint;
    NSLayoutConstraint *_accessoryViewWidthConstraint;
    NSLayoutConstraint *_accessoryViewRightConstraint;
    UIView *_accessoryView;
    UIView *_sliderView;
    UIView *_contentView;
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

    _contentView = [UIView new];
    _contentView.opaque = NO;
    _contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_contentView];

    UIView *topView = nil;
    UIView *bottomView = nil;
    UIView *leftView = nil;
    UIView *rightView = nil;

    if (!_sliderView) {
        _sliderView = [self viewForSliderAccessory];
        if (_sliderView) {
            _sliderView.translatesAutoresizingMaskIntoConstraints = NO;
            NSMutableArray* constraints = [NSMutableArray array];

            UIRectEdge edge = [self edgeForSliderAccessory];
            if (edge == UIRectEdgeTop || edge == UIRectEdgeBottom) {
                // align horizontally
                [constraints addObject:[NSLayoutConstraint constraintWithItem:_sliderView
                                                                    attribute:NSLayoutAttributeCenterX
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self
                                                                    attribute:NSLayoutAttributeCenterX
                                                                   multiplier:1
                                                                     constant:0]];
            }
            else if (edge == UIRectEdgeLeft || edge == UIRectEdgeRight) {
                [constraints addObject:[NSLayoutConstraint constraintWithItem:_sliderView
                                                                    attribute:NSLayoutAttributeCenterY
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self
                                                                    attribute:NSLayoutAttributeCenterY
                                                                   multiplier:1
                                                                     constant:0]];
            }

            switch (edge) {
                case UIRectEdgeTop:
                    // pin to top
                    topView = _sliderView;
                    [constraints addObject:[NSLayoutConstraint constraintWithItem:_sliderView
                                                                        attribute:NSLayoutAttributeTop
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeTop
                                                                       multiplier:1
                                                                         constant:MARGIN]];
                    break;
                case UIRectEdgeBottom:
                    // pin to bottom
                    bottomView = _sliderView;
                    [constraints addObject:[NSLayoutConstraint constraintWithItem:_sliderView
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1
                                                                         constant:-MARGIN]];
                    break;
                case UIRectEdgeLeft:
                    // pin to left
                    leftView = _sliderView;
                    [constraints addObject:[NSLayoutConstraint constraintWithItem:_sliderView
                                                                        attribute:NSLayoutAttributeLeft
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeLeft
                                                                       multiplier:1
                                                                         constant:MARGIN]];
                    break;
                case UIRectEdgeRight:
                    // pin to right
                    rightView = _sliderView;
                    [constraints addObject:[NSLayoutConstraint constraintWithItem:_sliderView
                                                                        attribute:NSLayoutAttributeRight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeRight
                                                                       multiplier:1
                                                                         constant:-MARGIN]];
                    break;
                default:
                    break;
            }
            
            [self addSubview:_sliderView];
            [self addConstraints:constraints];
            [_sliderView setContentHuggingPriority:1000 forAxis:UILayoutConstraintAxisHorizontal];
            [_sliderView setContentHuggingPriority:1000 forAxis:UILayoutConstraintAxisVertical];
        }
    }

    if (!_accessoryView) {
        _accessoryView = [self viewForAccessory];
        if (_accessoryView) {
            _accessoryView.translatesAutoresizingMaskIntoConstraints = NO;
            NSArray* constraints = @[
                                     // width
                                     [NSLayoutConstraint constraintWithItem:_accessoryView
                                                                  attribute:NSLayoutAttributeWidth
                                                                  relatedBy:NSLayoutRelationLessThanOrEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1
                                                                   constant:1e8],
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
                                                                     toItem:rightView ?: self
                                                                  attribute:rightView ? NSLayoutAttributeLeft : NSLayoutAttributeRight
                                                                 multiplier:1
                                                                   constant:rightView ? -MARGIN : 0],
                                     ];

            [self addSubview:_accessoryView];
            [self addConstraints:constraints];
            rightView = _accessoryView;
            _accessoryViewWidthConstraint = [constraints firstObject];
            _accessoryViewRightConstraint = [constraints lastObject];
            [_accessoryView setContentCompressionResistancePriority:1000 forAxis:UILayoutConstraintAxisHorizontal];
            [_accessoryView setContentCompressionResistancePriority:1000 forAxis:UILayoutConstraintAxisVertical];
            [_accessoryView setContentHuggingPriority:1000 forAxis:UILayoutConstraintAxisHorizontal];
        }
    }


    [self addConstraints:@[
                           // pin left
                           [NSLayoutConstraint constraintWithItem:_contentView
                                                        attribute:NSLayoutAttributeLeft
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:leftView ?: self
                                                        attribute:leftView ? NSLayoutAttributeRight : NSLayoutAttributeLeft
                                                       multiplier:1
                                                         constant:MARGIN],
                           // pin right
                           [NSLayoutConstraint constraintWithItem:_contentView
                                                        attribute:NSLayoutAttributeRight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:rightView ?: self
                                                        attribute:rightView ? NSLayoutAttributeLeft : NSLayoutAttributeRight
                                                       multiplier:1
                                                         constant:-MARGIN],
                           // pin top
                           [NSLayoutConstraint constraintWithItem:_contentView
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:topView ?: self
                                                        attribute:topView ? NSLayoutAttributeBottom : NSLayoutAttributeTop
                                                       multiplier:1
                                                         constant:MARGIN],
                           // pin bottom
                           [NSLayoutConstraint constraintWithItem:_contentView
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:bottomView ?: self
                                                        attribute:bottomView ? NSLayoutAttributeTop : NSLayoutAttributeBottom
                                                       multiplier:1
                                                         constant:-MARGIN],
                           ]];

    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.font = [UIFont boldSystemFontOfSize:_titleLabel.font.pointSize];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self applyTitleAppearance:_titleLabel];
        NSArray* constraints = @[
                                 [NSLayoutConstraint constraintWithItem:_titleLabel
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationLessThanOrEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1
                                                               constant:1e8],
                                 [NSLayoutConstraint constraintWithItem:_titleLabel
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:_contentView
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1
                                                               constant:0],
                                 [NSLayoutConstraint constraintWithItem:_titleLabel
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:_contentView
                                                              attribute:NSLayoutAttributeLeft
                                                             multiplier:1
                                                               constant:0],
                                 [NSLayoutConstraint constraintWithItem:_titleLabel
                                                              attribute:NSLayoutAttributeRight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:_contentView
                                                              attribute:NSLayoutAttributeRight
                                                             multiplier:1
                                                               constant:0]
                                 ];
        [self addSubview:_titleLabel];
        _titleHeightConstraint = [constraints firstObject];
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
                                                             constant:0],
                               [NSLayoutConstraint constraintWithItem:_messageLabel
                                                            attribute:NSLayoutAttributeBottom
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_contentView
                                                            attribute:NSLayoutAttributeBottom
                                                           multiplier:1
                                                             constant:0],
                               [NSLayoutConstraint constraintWithItem:_messageLabel
                                                            attribute:NSLayoutAttributeLeft
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_contentView
                                                            attribute:NSLayoutAttributeLeft
                                                           multiplier:1
                                                             constant:0],
                               [NSLayoutConstraint constraintWithItem:_messageLabel
                                                            attribute:NSLayoutAttributeRight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_contentView
                                                            attribute:NSLayoutAttributeRight
                                                           multiplier:1
                                                             constant:0]
                               ];
        [self addSubview:_messageLabel];
        [self addConstraints:constraints];
        _spacerConstraint = [constraints firstObject];
    }

}

- (void)updateConstraints {
    // adjust title/message space according to values set
    _titleHeightConstraint.constant = IsEmpty(_titleLabel.attributedText) ? 0 : 1e8;

    _spacerConstraint.constant = [self spacerHeight];
    _accessoryViewWidthConstraint.constant = _accessoryView.hidden ? 0 : 1e8;
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
            return [UIColor colorWithRed:0 green:0.8 blue:0 alpha:1];

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

- (UIView *)viewForSliderAccessory {
    return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IIShortNotificationSlideUpChevron"]];
}

- (UIRectEdge)edgeForSliderAccessory
{
    return UIRectEdgeBottom;
}

- (NSString*)defaultTitleForType:(IIShortNotificationType)type {
    return nil;
}

@end
