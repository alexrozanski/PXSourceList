//
//  PXSourceListBadgeCell.m
//  PXSourceList
//
//  Created by Alex Rozanski on 15/11/2013.
//  Copyright 2009-14 Alex Rozanski http://alexrozanski.com and other contributors.
//  This software is licensed under the New BSD License. Full details can be found in the README.
//

#import "PXSourceListBadgeCell.h"

//Drawing constants
static inline NSColor *badgeBackgroundColor() { return [NSColor colorWithCalibratedRed:(152/255.0) green:(168/255.0) blue:(202/255.0) alpha:1]; }
static inline NSColor *badgeHiddenBackgroundColor() { return [NSColor colorWithDeviceWhite:(180/255.0) alpha:1]; }
static inline NSColor *badgeSelectedTextColor() { return [NSColor keyboardFocusIndicatorColor]; }
static inline NSColor *badgeSelectedUnfocusedTextColor() { return [NSColor colorWithCalibratedRed:(153/255.0) green:(169/255.0) blue:(203/255.0) alpha:1]; }
static inline NSColor *badgeSelectedHiddenTextColor() { return [NSColor colorWithCalibratedWhite:(170/255.0) alpha:1]; }
static inline NSFont *badgeFont() { return [NSFont boldSystemFontOfSize:11]; }

// Sizing constants.
static const CGFloat badgeLeftAndRightPadding = 5.0;

@implementation PXSourceListBadgeCell

- (id)init
{
    if (!(self = [super initTextCell:@""]))
        return nil;

    return self;
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    CGFloat borderRadius = NSHeight(cellFrame)/2.0f;
	NSBezierPath *badgePath = [NSBezierPath bezierPathWithRoundedRect:cellFrame xRadius:borderRadius yRadius:borderRadius];

	// Get the window and control state to determine the badge colours used.
	BOOL isMainWindowVisible = [[NSApp mainWindow] isVisible];
	NSDictionary *attributes;
	NSColor *backgroundColor;

	if(self.isHighlighted) {
		backgroundColor = [NSColor whiteColor];

        NSResponder *firstResponder = controlView.window.firstResponder;
        BOOL isFocused = [firstResponder isKindOfClass:[NSView class]] && [(NSView *)firstResponder isDescendantOf:controlView];
        NSColor *textColor;

		if (isMainWindowVisible && isFocused)
			textColor = badgeSelectedTextColor();
		else if (isMainWindowVisible && !isFocused)
			textColor = badgeSelectedUnfocusedTextColor();
		else
			textColor = badgeSelectedHiddenTextColor();

		attributes = @{NSForegroundColorAttributeName: textColor};
	} else {
		NSColor *textColor = textColor = self.textColor ? self.textColor : [NSColor whiteColor];;

		if(isMainWindowVisible)
            backgroundColor = self.backgroundColor ? self.backgroundColor : badgeBackgroundColor();
		else
			backgroundColor = badgeHiddenBackgroundColor();

		attributes = @{NSForegroundColorAttributeName: textColor};
	}

	[backgroundColor set];
	[badgePath fill];

	//Draw the badge text
    NSMutableAttributedString *badgeString = [self.badgeString mutableCopy];
    [badgeString addAttributes:attributes range:NSMakeRange(0, badgeString.length)];

	NSSize stringSize = badgeString.size;
	NSPoint badgeTextPoint = NSMakePoint(NSMidX(cellFrame) - (stringSize.width/2.0),
										 NSMidY(cellFrame) - (stringSize.height/2.0));
	[badgeString drawAtPoint:badgeTextPoint];
}

- (NSSize)cellSize
{
    NSSize size = self.badgeString.size;
    size.width += 2 * badgeLeftAndRightPadding;

    return size;
}

- (NSAttributedString *)badgeString
{
	return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", self.badgeValue]
                                           attributes:@{NSFontAttributeName: badgeFont()}];
}

@end
