//
//  PXSourceListBadgeCell.m
//  PXSourceList
//
//  Created by Alex Rozanski on 15/11/2013.
//
//

#import "PXSourceListBadgeCell.h"

//Drawing constants
static inline NSColor *badgeBackgroundColor() { return [NSColor colorWithCalibratedRed:(152/255.0) green:(168/255.0) blue:(202/255.0) alpha:1]; }
static inline NSColor *badgeHiddenBackgroundColor() { return [NSColor colorWithDeviceWhite:(180/255.0) alpha:1]; }
static inline NSColor *badgeSelectedTextColor() { return [NSColor keyboardFocusIndicatorColor]; }
static inline NSColor *badgeSelectedUnfocusedTextColor() { return [NSColor colorWithCalibratedRed:(153/255.0) green:(169/255.0) blue:(203/255.0) alpha:1]; }
static inline NSColor *badgeSelectedHiddenTextColor() { return [NSColor colorWithCalibratedWhite:(170/255.0) alpha:1]; }
static inline NSFont *badgeFont() { return [NSFont boldSystemFontOfSize:11]; }

@implementation PXSourceListBadgeCell

@end
