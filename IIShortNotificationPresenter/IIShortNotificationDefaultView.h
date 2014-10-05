//
//  IIShortNotificationDefaultView.h
//  Copyright (c) 2014 Tom Adriaenssen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IIShortNotificationView.h"

@interface IIShortNotificationDefaultView : UIView<IIShortNotificationView>

- (UIView*)viewForAccessory;
- (UIView *)viewForSliderAccessory;
- (UIRectEdge)edgeForSliderAccessory;
- (UIColor*)colorForType:(IIShortNotificationType)type;
- (void)applyTitleAppearance:(UILabel*)label;
- (void)applyMessageAppearance:(UILabel*)label;
- (NSString*)defaultTitleForType:(IIShortNotificationType)type;

@end
