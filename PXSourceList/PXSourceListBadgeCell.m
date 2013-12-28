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
            backgroundColor = self.badgeColor ? self.badgeColor : badgeBackgroundColor();
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
    return self.badgeString.size;
}

- (NSAttributedString *)badgeString
{
	return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", self.integerValue]
                                           attributes:@{NSFontAttributeName: badgeFont()}];
}

@end
