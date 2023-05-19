//
//  MGEAvailability.h
//

#ifndef MGEAvailability_h
#define MGEAvailability_h
#include <TargetConditionals.h>
#include <Availability.h>
#include <AvailabilityMacros.h>

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>
#endif

#if TARGET_OS_IPHONE
#define MGEView UIView
#define MGEColor UIColor
#define MGEImage UIImage
#define MGEBezierPath UIBezierPath
#define MGEButton UIButton
#else
#define MGEView NSView
#define MGEColor NSColor
#define MGEBezierPath NSBezierPath
#define MGEImage NSImage
#define MGEButton NSButton
#endif


// Screen Scale
#if TARGET_OS_IPHONE
#define MGE_MAINSCREEN_SCALE  ([UIScreen mainScreen].scale)
#else
#define MGE_MAINSCREEN_SCALE  ([NSScreen mainScreen].backingScaleFactor)
#endif

#endif /* MGEAvailability_h */
