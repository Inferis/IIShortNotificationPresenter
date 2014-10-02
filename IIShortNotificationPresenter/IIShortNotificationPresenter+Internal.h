//
//  IIShortNotificationPresenter+Internal.h
//  Copyright (c) 2014 Tom Adriaenssen. All rights reserved.
//

// Blatantly picked up from [Wil Shipley](http://blog.wilshipley.com/2005/10/pimp-my-code-interlude-free-code.html)
//
// > Essentially, if you're wondering if an NSString or NSData or
// > NSAttributedString or NSArray or NSSet has actual useful data in
// > it, this is your macro. Instead of checking things like
// > `if (inputString == nil || [inputString length] == 0)` you just
// > say, "if (IsEmpty(inputString))".
//
// It rocks.
static inline BOOL IsEmpty(id thing) {
    if (thing == nil) return YES;
    if ([thing isEqual:[NSNull null]]) return YES;
    if ([thing respondsToSelector:@selector(count)]) return [thing performSelector:@selector(count)] == 0;
    if ([thing respondsToSelector:@selector(length)]) return [thing performSelector:@selector(length)] == 0;
    return NO;
}
