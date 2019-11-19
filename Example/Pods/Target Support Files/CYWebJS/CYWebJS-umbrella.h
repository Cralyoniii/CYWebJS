#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "CYJSWebView.h"
#import "CYWebJSController.h"

FOUNDATION_EXPORT double CYWebJSVersionNumber;
FOUNDATION_EXPORT const unsigned char CYWebJSVersionString[];

