//
//  PXSourceList.m
//  PXSourceList
//
//  Created by Alex Rozanski on 05/09/2009.
//  Copyright 2009-10 Alex Rozanski http://perspx.com
//

#import "PXSourceList.h"
#import <objc/runtime.h>

//Layout constants
static const CGFloat minBadgeWidth = 22.0;              // The minimum badge width for each item (default 22.0).
static const CGFloat badgeHeight = 14.0;                // The badge height for each item (default 14.0).
static const CGFloat badgeMargin = 5.0;                 // The spacing between the badge and the cell for that row.
static const CGFloat rowRightMargin = 5.0;              // The spacing between the right edge of the badge and the edge of the table column.
static const CGFloat iconSpacing = 2.0;                 // The spacing between the icon and it's adjacent cell.
static const CGFloat disclosureTriangleSpace = 18.0;    // The indentation reserved for disclosure triangles for non-group items.

//Drawing constants
static inline NSColor *badgeBackgroundColor() { return [NSColor colorWithCalibratedRed:(152/255.0) green:(168/255.0) blue:(202/255.0) alpha:1]; }
static inline NSColor *badgeHiddenBackgroundColor() { return [NSColor colorWithDeviceWhite:(180/255.0) alpha:1]; }
static inline NSColor *badgeSelectedTextColor() { return [NSColor keyboardFocusIndicatorColor]; }
static inline NSColor *badgeSelectedUnfocusedTextColor() { return [NSColor colorWithCalibratedRed:(153/255.0) green:(169/255.0) blue:(203/255.0) alpha:1]; }
static inline NSColor *badgeSelectedHiddenTextColor() { return [NSColor colorWithCalibratedWhite:(170/255.0) alpha:1]; }
static inline NSFont *badgeFont() { return [NSFont boldSystemFontOfSize:11]; }

//Delegate notification constants
NSString * const PXSLSelectionIsChangingNotification = @"PXSourceListSelectionIsChanging";
NSString * const PXSLSelectionDidChangeNotification = @"PXSourceListSelectionDidChange";
NSString * const PXSLItemWillExpandNotification = @"PXSourceListItemWillExpand";
NSString * const PXSLItemDidExpandNotification = @"PXSourceListItemDidExpand";
NSString * const PXSLItemWillCollapseNotification = @"PXSourceListItemWillCollapse";
NSString * const PXSLItemDidCollapseNotification = @"PXSourceListItemDidCollapse";
NSString * const PXSLDeleteKeyPressedOnRowsNotification = @"PXSourceListDeleteKeyPressedOnRows";


// Internal constants.
static NSString * const protocolMethodNameKey = @"methodName";
static NSString * const protocolArgumentTypesKey = @"types";

static NSArray *px_allProtocolMethods(Protocol *protocol)
{
    NSMutableArray *methodList = [[NSMutableArray alloc] init];

    // We have 4 permutations as protocol_copyMethodDescriptionList() takes two BOOL arguments for the types of methods to return.
    for (NSUInteger i = 0; i < 4; ++i) {
        unsigned int numberOfMethodDescriptions = 0;
        struct objc_method_description *methodDescriptions = protocol_copyMethodDescriptionList(protocol, (i / 2) % 2, i % 2, &numberOfMethodDescriptions);

        for (unsigned int j = 0; j < numberOfMethodDescriptions; ++j) {
            struct objc_method_description methodDescription = methodDescriptions[j];
            [methodList addObject:@{protocolMethodNameKey: NSStringFromSelector(methodDescription.name),
                                    protocolArgumentTypesKey: [NSString stringWithUTF8String:methodDescription.types]}];
        }

        free(methodDescriptions);
    }

    return methodList;
}

#pragma mark -
@interface PXSourceList ()

@property (weak, nonatomic) id <PXSourceListDelegate> secondaryDelegate;		//Used to store the publicly visible delegate.
@property (weak, nonatomic) id <PXSourceListDataSource> secondaryDataSource;	//Used to store the publicly visible data source.

@end

#pragma mark -
@implementation PXSourceList

@dynamic dataSource;
@dynamic delegate;

static NSMutableDictionary * _forwardingMethodMap;

#pragma mark - Setup/Teardown

+ (void)initialize
{
    _forwardingMethodMap = [[NSMutableDictionary alloc] init];

    [_forwardingMethodMap addEntriesFromDictionary:[self methodNameMappingsForProtocol:@protocol(NSOutlineViewDelegate)]];
    [_forwardingMethodMap addEntriesFromDictionary:[self methodNameMappingsForProtocol:@protocol(NSOutlineViewDataSource)]];
}

- (id)initWithCoder:(NSCoder*)decoder
{	
	if(self=[super initWithCoder:decoder]) {
        [self PXSL_setup];
	}
	
	return self;
}

- (id)initWithFrame:(NSRect)frameRect
{
    if((self = [super initWithFrame:frameRect])) {
        [self PXSL_setup];
    }
    
    return self;
}

- (void)PXSL_setup
{
    [self setDelegate:(id<PXSourceListDelegate>)[super delegate]];
    [super setDelegate:self];
    
    [self setDataSource:(id<PXSourceListDataSource>)[super dataSource]];
    [super setDataSource:self];
    
    _iconSize = NSMakeSize(16,16);
}

- (void)dealloc
{
	//Remove ourselves as the delegate and data source to be safe
	[super setDataSource:nil];
	[super setDelegate:nil];
	
	//Unregister the delegate from receiving notifications
	[[NSNotificationCenter defaultCenter] removeObserver:_secondaryDelegate name:nil object:self];
	
}


#pragma mark -
#pragma mark Custom Accessors

- (void)setDelegate:(id<PXSourceListDelegate>)aDelegate
{
	//Unregister the old delegate from receiving notifications
	[[NSNotificationCenter defaultCenter] removeObserver:_secondaryDelegate name:nil object:self];
	
	_secondaryDelegate = aDelegate;
	
	//Register the new delegate to receive notifications
	[self registerDelegateToReceiveNotification:PXSLSelectionIsChangingNotification
								   withSelector:@selector(sourceListSelectionIsChanging:)];
	[self registerDelegateToReceiveNotification:PXSLSelectionDidChangeNotification
								   withSelector:@selector(sourceListSelectionDidChange:)];
	[self registerDelegateToReceiveNotification:PXSLItemWillExpandNotification
								   withSelector:@selector(sourceListItemWillExpand:)];
	[self registerDelegateToReceiveNotification:PXSLItemDidExpandNotification
								   withSelector:@selector(sourceListItemDidExpand:)];
	[self registerDelegateToReceiveNotification:PXSLItemWillCollapseNotification
								   withSelector:@selector(sourceListItemWillCollapse:)];
	[self registerDelegateToReceiveNotification:PXSLItemDidCollapseNotification
								   withSelector:@selector(sourceListItemDidCollapse:)];
	[self registerDelegateToReceiveNotification:PXSLDeleteKeyPressedOnRowsNotification
								   withSelector:@selector(sourceListDeleteKeyPressedOnRows:)];
}


- (void)setDataSource:(id<PXSourceListDataSource>)aDataSource
{
	_secondaryDataSource = aDataSource;
	
	[self reloadData];
}

- (void)setIconSize:(NSSize)newIconSize
{
	_iconSize = newIconSize;
	
	CGFloat rowHeight = [self rowHeight];
	
	//Make sure icon height does not exceed row height; if so constrain, keeping width and height in proportion
	if(_iconSize.height>rowHeight)
	{
		_iconSize.width = _iconSize.width * (rowHeight/_iconSize.height);
		_iconSize.height = rowHeight;
	}
}

#pragma mark -
#pragma mark Data Management

- (void)reloadData
{
	[super reloadData];
	
	//Expand items that are displayed as always expanded
	if([_secondaryDataSource conformsToProtocol:@protocol(PXSourceListDataSource)] &&
	   [_secondaryDelegate respondsToSelector:@selector(sourceList:isGroupAlwaysExpanded:)])
	{
		for(NSUInteger i=0;i<[self numberOfGroups];i++)
		{
			id item = [_secondaryDataSource sourceList:self child:i ofItem:nil];
			
			if([self isGroupAlwaysExpanded:item]) {
				[self expandItem:item expandChildren:NO];
			}
		}
		
	}
	
	//If there are selected rows and the item hierarchy has changed, make sure a Group row isn't
	//selected
	if([self numberOfSelectedRows]>0) {
		NSIndexSet *selectedIndexes = [self selectedRowIndexes];
		NSUInteger firstSelectedRow = [selectedIndexes firstIndex];
		
		//Is a group item selected?
		if([self isGroupItem:[self itemAtRow:firstSelectedRow]]) {
			//Work backwards to find the first non-group row
			BOOL foundRow = NO;
			for(NSUInteger i=firstSelectedRow;i>0;i--)
			{
				if(![self isGroupItem:[self itemAtRow:i]]) {
					[self selectRowIndexes:[NSIndexSet indexSetWithIndex:i] byExtendingSelection:NO];
					foundRow = YES;
					break;
				}
			}
			
			//If there is no non-group row preceding the currently selected group item, remove the selection
			//from the Source List
			if(!foundRow) {
				[self deselectAll:self];
			}
		}
	}
	else if(![self allowsEmptySelection]&&[self numberOfSelectedRows]==0)
	{
		//Select the first non-group row if no rows are selected, and empty selection is disallowed
		for(NSUInteger i=0;i<[self numberOfRows];i++)
		{
			if(![self isGroupItem:[self itemAtRow:i]]) {
				[self selectRowIndexes:[NSIndexSet indexSetWithIndex:i] byExtendingSelection:NO];
				break;
			}
		}
	}
}

- (NSUInteger)numberOfGroups
{	
	if([_secondaryDataSource respondsToSelector:@selector(sourceList:numberOfChildrenOfItem:)]) {
		return [_secondaryDataSource sourceList:self numberOfChildrenOfItem:nil];
	}
	
	return 0;
}


- (BOOL)isGroupItem:(id)item
{
	//Groups are defined as root items (at level 0)
	return 0==[self levelForItem:item];
}


- (BOOL)isGroupAlwaysExpanded:(id)group
{
	//Make sure that the item IS a group to prevent unwanted queries sent to the data source
	if([self isGroupItem:group]) {
		//Query the data source
		if([_secondaryDelegate respondsToSelector:@selector(sourceList:isGroupAlwaysExpanded:)]) {
			return [_secondaryDelegate sourceList:self isGroupAlwaysExpanded:group];
		}
	}
	
	return NO;
}


- (BOOL)itemHasBadge:(id)item
{
	if([_secondaryDataSource respondsToSelector:@selector(sourceList:itemHasBadge:)]) {
		return [_secondaryDataSource sourceList:self itemHasBadge:item];
	}
	
	return NO;
}

- (NSInteger)badgeValueForItem:(id)item
{	
	//Make sure that the item has a badge
	if(![self itemHasBadge:item]) {
		return NSNotFound;
	}
	
	if([_secondaryDataSource respondsToSelector:@selector(sourceList:badgeValueForItem:)]) {
		return [_secondaryDataSource sourceList:self badgeValueForItem:item];
	}
	
	return NSNotFound;
}

#pragma mark -
#pragma mark Selection Handling

- (void)selectRowIndexes:(NSIndexSet*)indexes byExtendingSelection:(BOOL)extend
{
	NSUInteger numberOfIndexes = [indexes count];
	
	//Prevent empty selection if we don't want it
	if(![self allowsEmptySelection]&&0==numberOfIndexes) {
		return;
	}
	
	//Would use blocks but we're also targeting 10.5...
	//Get the selected indexes
	NSUInteger *selectedIndexes = malloc(sizeof(NSUInteger)*numberOfIndexes);
	[indexes getIndexes:selectedIndexes maxCount:numberOfIndexes inIndexRange:nil];
	
	//Loop through the indexes and only add non-group row indexes
	//Allows selection across groups without selecting the group rows
	NSMutableIndexSet *newSelectionIndexes = [NSMutableIndexSet indexSet];
	for(NSInteger i=0;i<numberOfIndexes;i++)
	{
		if(![self isGroupItem:[self itemAtRow:selectedIndexes[i]]]) {
			[newSelectionIndexes addIndex:selectedIndexes[i]];
		}
	}
	
	//If there are any non-group rows selected
	if([newSelectionIndexes count]>0) {
		[super selectRowIndexes:newSelectionIndexes byExtendingSelection:extend];
	}
	
	//C memory management... *sigh*
	free(selectedIndexes);
}

#pragma mark -
#pragma mark Layout

- (NSRect)frameOfOutlineCellAtRow:(NSInteger)row
{	
	//Return a zero-rect if the item is always expanded (a disclosure triangle will not be drawn)
	if([self isGroupAlwaysExpanded:[self itemAtRow:row]]) {
		return NSZeroRect;
	}
    
    NSRect frame = [super frameOfOutlineCellAtRow:row];
    
    if([self levelForRow:row] > 0) {
        frame.origin.x = [self levelForRow:row] * [self indentationPerLevel];
    }
    
    return frame;
}


- (NSRect)frameOfCellAtColumn:(NSInteger)column row:(NSInteger)row
{
	id item = [self itemAtRow:row];
	
	NSCell *cell = [self preparedCellAtColumn:column row:row];
	NSSize cellSize = [cell cellSize];
	if (!([cell type] == NSImageCellType) && !([cell type] == NSTextCellType))
		cellSize = [cell cellSizeForBounds:[super frameOfCellAtColumn:column row:row]];
	NSRect cellFrame = [super frameOfCellAtColumn:column row:row];
	
	NSRect rowRect = [self rectOfRow:row];
	
	if([self isGroupItem:item])
	{	
		CGFloat minX = NSMinX(cellFrame);
		
		//Set the origin x-coord; if there are no children of the group at current, there will still be a 
		//margin to the left of the cell (in cellFrame), which we don't want
		if([self isGroupAlwaysExpanded:[self itemAtRow:row]]) {
			minX = 7;
		}
		
		return NSMakeRect(minX,
						  NSMidY(cellFrame)-(cellSize.height/2.0),
						  NSWidth(rowRect)-minX,
						  cellSize.height);
	}
	else
	{
		CGFloat leftIndent = [self levelForRow:row]*[self indentationPerLevel]+disclosureTriangleSpace;
		
		//Calculate space left for a badge if need be
		CGFloat rightIndent = [self sizeOfBadgeAtRow:row].width+rowRightMargin;
		
		//Allow space for an icon if need be
		if(![self isGroupItem:item]&&[_secondaryDataSource respondsToSelector:@selector(sourceList:itemHasIcon:)])
		{
			if([_secondaryDataSource sourceList:self itemHasIcon:item]) {
				leftIndent += [self iconSize].width+(iconSpacing*2);
			}
		}
		
		return NSMakeRect(leftIndent,
						  NSMidY(rowRect)-(cellSize.height/2.0),
						  NSWidth(rowRect)-rightIndent-leftIndent,
						  cellSize.height);
	}
}


//This method calculates and returns the size of the badge for the row index passed to the method. If the
//row for the row index passed to the method does not have a badge, then NSZeroSize is returned.
- (NSSize)sizeOfBadgeAtRow:(NSInteger)rowIndex
{
	id rowItem = [self itemAtRow:rowIndex];
	
	//Make sure that the item has a badge
	if(![self itemHasBadge:rowItem]) {
		return NSZeroSize;
	}
	
	NSAttributedString *badgeAttrString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", (long)[self badgeValueForItem:rowItem]]
																		  attributes:[NSDictionary dictionaryWithObjectsAndKeys:badgeFont(), NSFontAttributeName, nil]];
	
	NSSize stringSize = [badgeAttrString size];
	
	//Calculate the width needed to display the text or the minimum width if it's smaller
	CGFloat width = stringSize.width+(2*badgeMargin);
	
	if(width<minBadgeWidth) {
		width = minBadgeWidth;
	}
	
	
	return NSMakeSize(width, badgeHeight);
}

- (void)viewDidMoveToSuperview
{
    //If set to YES, this will cause display issues in Lion where the right part of the outline view is cut off
    [self setAutoresizesOutlineColumn:NO];
}

#pragma mark -
#pragma mark Drawing

- (void)drawRow:(NSInteger)rowIndex clipRect:(NSRect)clipRect
{	
	[super drawRow:rowIndex clipRect:clipRect];
	
	id item = [self itemAtRow:rowIndex];
	
	//Draw an icon if the item has one
	if(![self isGroupItem:item]&&[_secondaryDataSource respondsToSelector:@selector(sourceList:itemHasIcon:)])
	{
		if([_secondaryDataSource sourceList:self itemHasIcon:item])
		{
			NSRect cellFrame = [self frameOfCellAtColumn:0 row:rowIndex];
			NSSize iconSize = [self iconSize];
			NSRect iconRect = NSMakeRect(NSMinX(cellFrame)-iconSize.width-iconSpacing,
										 NSMidY(cellFrame)-(iconSize.height/2.0f),
										 iconSize.width,
										 iconSize.height);
			
			if([_secondaryDataSource respondsToSelector:@selector(sourceList:iconForItem:)])
			{
				NSImage *icon = [_secondaryDataSource sourceList:self iconForItem:item];
				
				if(icon!=nil)
				{
					NSSize actualIconSize = [icon size];
					
					//If the icon is *smaller* than the size retrieved from the -iconSize property, make sure we
					//reduce the size of the rectangle to draw the icon in, so that it is not stretched.
					if((actualIconSize.width<iconSize.width)||(actualIconSize.height<iconSize.height))
					{
						iconRect = NSMakeRect(NSMidX(iconRect)-(actualIconSize.width/2.0f),
											  NSMidY(iconRect)-(actualIconSize.height/2.0f),
											  actualIconSize.width,
											  actualIconSize.height);
					}
					
                    //Use 10.6 NSImage drawing if we can
                    if([icon respondsToSelector:@selector(drawInRect:fromRect:operation:fraction:respectFlipped:hints:)]) {
                        [icon drawInRect:iconRect
                                fromRect:NSZeroRect
                               operation:NSCompositeSourceOver
                                fraction:1
                          respectFlipped:YES hints:nil];
                    }
                    else {
                        [icon setFlipped:[self isFlipped]];
                        [icon drawInRect:iconRect
                                fromRect:NSZeroRect
                               operation:NSCompositeSourceOver
                                fraction:1];
                    }
				}
			}
		}
	}
	
	//Draw the badge if the item has one
	if([self itemHasBadge:item])
	{
		NSRect rowRect = [self rectOfRow:rowIndex];
		NSSize badgeSize = [self sizeOfBadgeAtRow:rowIndex];
		
		NSRect badgeFrame = NSMakeRect(NSMaxX(rowRect)-badgeSize.width-rowRightMargin,
									   NSMidY(rowRect)-(badgeSize.height/2.0),
									   badgeSize.width,
									   badgeSize.height);
		
		[self drawBadgeForRow:rowIndex inRect:badgeFrame];
	}
}

- (void)drawBadgeForRow:(NSInteger)rowIndex inRect:(NSRect)badgeFrame
{
	id rowItem = [self itemAtRow:rowIndex];
	
	NSBezierPath *badgePath = [NSBezierPath bezierPathWithRoundedRect:badgeFrame
															  xRadius:(badgeHeight/2.0)
															  yRadius:(badgeHeight/2.0)];
	
	//Get window and control state to determine colours used
	BOOL isVisible = [[NSApp mainWindow] isVisible];
	BOOL isFocused = [[[self window] firstResponder] isEqual:self];
	NSInteger rowBeingEdited = [self editedRow];
	
	//Set the attributes based on the row state
	NSDictionary *attributes;
	NSColor *backgroundColor;
	
	if([[self selectedRowIndexes] containsIndex:rowIndex])
	{
		backgroundColor = [NSColor whiteColor];
		
		//Set the text color based on window and control state
		NSColor *textColor;
		
		if(isVisible && (isFocused || rowBeingEdited==rowIndex)) {
			textColor = badgeSelectedTextColor();
		}
		else if(isVisible && !isFocused) {
			textColor = badgeSelectedUnfocusedTextColor();
		}
		else {
			textColor = badgeSelectedHiddenTextColor();
		}
		
		attributes = [[NSDictionary alloc] initWithObjectsAndKeys:badgeFont(), NSFontAttributeName,
					  textColor, NSForegroundColorAttributeName, nil];
	}
	else
	{
		//Set the text colour based on window and control state
		NSColor *badgeColor = [NSColor whiteColor];
		
		if(isVisible) {
			//If the data source returns a custom colour..
			if([_secondaryDataSource respondsToSelector:@selector(sourceList:badgeBackgroundColorForItem:)]) {
				backgroundColor = [_secondaryDataSource sourceList:self badgeBackgroundColorForItem:rowItem];
				
				if(backgroundColor==nil)
					backgroundColor = badgeBackgroundColor();
			}
			else { //Otherwise use the default (purple-blue colour)
				backgroundColor = badgeBackgroundColor();
			}
			
			//If the delegate wants a custom badge text colour..
			if([_secondaryDataSource respondsToSelector:@selector(sourceList:badgeTextColorForItem:)]) {
				badgeColor = [_secondaryDataSource sourceList:self badgeTextColorForItem:rowItem];
				
				if(badgeColor==nil)
					badgeColor = [NSColor whiteColor];
			}
		}
		else { //Gray colour
			backgroundColor = badgeHiddenBackgroundColor();
		}
		
		attributes = [[NSDictionary alloc] initWithObjectsAndKeys:badgeFont(), NSFontAttributeName,
					  badgeColor, NSForegroundColorAttributeName, nil];
	}
	
	[backgroundColor set];
	[badgePath fill];
	
	//Draw the badge text
	NSAttributedString *badgeAttrString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", (long)[self badgeValueForItem:rowItem]]
																		  attributes:attributes];
	NSSize stringSize = [badgeAttrString size];
	NSPoint badgeTextPoint = NSMakePoint(NSMidX(badgeFrame)-(stringSize.width/2.0),		//Center in the badge frame
										 NSMidY(badgeFrame)-(stringSize.height/2.0));	//Center in the badge frame
	[badgeAttrString drawAtPoint:badgeTextPoint];
	
}

#pragma mark -
#pragma mark Keyboard Handling

- (void)keyDown:(NSEvent *)theEvent
{
	NSIndexSet *selectedIndexes = [self selectedRowIndexes];
	
	NSString *keyCharacters = [theEvent characters];
	
	//Make sure we have a selection
	if([selectedIndexes count]>0)
	{
		if([keyCharacters length]>0)
		{
			unichar firstKey = [keyCharacters characterAtIndex:0];
			
			if(firstKey==NSUpArrowFunctionKey||firstKey==NSDownArrowFunctionKey)
			{
				//Handle keyboard navigation across groups
				if([selectedIndexes count]==1&&!([theEvent modifierFlags] & NSShiftKeyMask))
				{
					int delta = firstKey==NSDownArrowFunctionKey?1:-1;	//Search "backwards" if up arrow, "forwards" if down
					NSInteger newRow = [selectedIndexes firstIndex];
					
					//Keep incrementing/decrementing the row until a non-header row is reached
					do {
						newRow+=delta;
						
						//If out of bounds of the number of rows..
						if(newRow<0||newRow==[self numberOfRows])
							break;
					} while([self isGroupItem:[self itemAtRow:newRow]]);
					
					
					[self selectRowIndexes:[NSIndexSet indexSetWithIndex:newRow] byExtendingSelection:NO];
					return;
				}
			}
			else if(firstKey==NSDeleteCharacter||firstKey==NSBackspaceCharacter||firstKey==0xf728)
			{	
				//Post the notification
				[[NSNotificationCenter defaultCenter] postNotificationName:PXSLDeleteKeyPressedOnRowsNotification
																	object:self
																  userInfo:[NSDictionary dictionaryWithObject:selectedIndexes forKey:@"rows"]];
				
				return;
			}
		}
	}
	
	//We don't care about it
	[super keyDown:theEvent];
}

#pragma mark -
#pragma mark Menu Handling


- (NSMenu *)menuForEvent:(NSEvent *)theEvent
{
	NSMenu * m = nil;
	if([_secondaryDelegate respondsToSelector:@selector(sourceList:menuForEvent:item:)]) {
		NSPoint clickPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
		NSInteger row = [self rowAtPoint:clickPoint];
		id clickedItem = [self itemAtRow:row];
		m = [_secondaryDelegate sourceList:self menuForEvent:theEvent item:clickedItem];
	}
	if (m == nil) {
		m = [super menuForEvent:theEvent];
	}
	return m;
}

#pragma mark - Method Forwarding


+ (NSDictionary *)methodNameMappingsForProtocol:(Protocol *)protocol
{
    NSMutableDictionary *methodNameMappings = [[NSMutableDictionary alloc] init];
    NSArray *protocolMethods = px_allProtocolMethods(protocol);

    NSString *outlineViewSearchString = @"outlineView";
    NSUInteger letterVOffset = [outlineViewSearchString rangeOfString:@"V"].location;
    NSCharacterSet *uppercaseLetterCharacterSet = [NSCharacterSet uppercaseLetterCharacterSet];

    for (NSDictionary *methodInfo in protocolMethods) {
        NSString *methodName = methodInfo[protocolMethodNameKey];

        NSRange outlineViewStringRange = [methodName rangeOfString:outlineViewSearchString options:NSCaseInsensitiveSearch];

        // If for some reason we can't map the method name, try to fail gracefully.
        if (outlineViewStringRange.location == NSNotFound) {
            NSLog(@"PXSourceList: couldn't map method %@ from %@", methodName, NSStringFromProtocol(protocol));
            continue;
        }

        BOOL isOCapitalized = [uppercaseLetterCharacterSet characterIsMember:[methodName characterAtIndex:outlineViewStringRange.location]];
        BOOL isVCapitalized = [uppercaseLetterCharacterSet characterIsMember:[methodName characterAtIndex:outlineViewStringRange.location + letterVOffset]];
        NSString *forwardingMethodName = [methodName stringByReplacingCharactersInRange:outlineViewStringRange
                                                                             withString:[NSString stringWithFormat:@"%@ource%@ist", isOCapitalized ? @"S" : @"s", isVCapitalized ? @"L" : @"l"]];

        [methodNameMappings setObject:forwardingMethodName forKey:methodName];
    }

    return methodNameMappings;
}

#pragma mark -
#pragma mark NSOutlineView Data Source methods

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{	
	if([_secondaryDataSource conformsToProtocol:@protocol(PXSourceListDataSource)]) {
		return [_secondaryDataSource sourceList:self numberOfChildrenOfItem:item];
	}
	
	return 0;
}


- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{	
	if([_secondaryDataSource conformsToProtocol:@protocol(PXSourceListDataSource)]) {
		return [_secondaryDataSource sourceList:self child:index ofItem:item];
	}
	
	return nil;
}


- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{	
	if([_secondaryDataSource conformsToProtocol:@protocol(PXSourceListDataSource)]) {
		return [_secondaryDataSource sourceList:self isItemExpandable:item];
	}
	
	return NO;
}


- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
	if([_secondaryDataSource conformsToProtocol:@protocol(PXSourceListDataSource)]) {
		return [_secondaryDataSource sourceList:self objectValueForItem:item];
	}
	
	return nil;
}


- (void)outlineView:(NSOutlineView *)outlineView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{	
	if([_secondaryDataSource conformsToProtocol:@protocol(PXSourceListDataSource)]) {
		[_secondaryDataSource sourceList:self setObjectValue:object forItem:item];
	}
}


- (id)outlineView:(NSOutlineView *)outlineView itemForPersistentObject:(id)object
{
	if([_secondaryDataSource respondsToSelector:@selector(sourceList:itemForPersistentObject:)]) {
		return [_secondaryDataSource sourceList:self itemForPersistentObject:object];
	}
	
	return nil;
}

- (id)outlineView:(NSOutlineView *)outlineView persistentObjectForItem:(id)item
{
	if([_secondaryDataSource respondsToSelector:@selector(sourceList:persistentObjectForItem:)]) {
		return [_secondaryDataSource sourceList:self persistentObjectForItem:item];
	}
	
	return nil;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView writeItems:(NSArray *)items toPasteboard:(NSPasteboard *)pasteboard
{
	if([_secondaryDataSource respondsToSelector:@selector(sourceList:writeItems:toPasteboard:)]) {
		return [_secondaryDataSource sourceList:self writeItems:items toPasteboard:pasteboard];
	}
	
	return NO;
}

- (NSDragOperation)outlineView:(NSOutlineView *)outlineView validateDrop:(id <NSDraggingInfo>)info proposedItem:(id)item proposedChildIndex:(NSInteger)index
{
	if([_secondaryDataSource respondsToSelector:@selector(sourceList:validateDrop:proposedItem:proposedChildIndex:)]) {
		return [_secondaryDataSource sourceList:self validateDrop:info proposedItem:item proposedChildIndex:index];
	}
	
	return NSDragOperationNone;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView acceptDrop:(id <NSDraggingInfo>)info item:(id)item childIndex:(NSInteger)index
{
	if([_secondaryDataSource respondsToSelector:@selector(sourceList:acceptDrop:item:childIndex:)]) {
		return [_secondaryDataSource sourceList:self acceptDrop:info item:item childIndex:index];
	}
	
	return NO;
}
- (NSArray *)outlineView:(NSOutlineView *)outlineView namesOfPromisedFilesDroppedAtDestination:(NSURL *)dropDestination forDraggedItems:(NSArray *)items
{
	if([_secondaryDataSource respondsToSelector:@selector(sourceList:namesOfPromisedFilesDroppedAtDestination:forDraggedItems:)]) {
		return [_secondaryDataSource sourceList:self namesOfPromisedFilesDroppedAtDestination:dropDestination forDraggedItems:items];
	}
	
	return nil;
}

- (id <NSPasteboardWriting>)outlineView:(NSOutlineView *)outlineView pasteboardWriterForItem:(id)item
{
    if ([_secondaryDataSource respondsToSelector:@selector(sourceList:pasteboardWriterForItem:)]) {
        return [_secondaryDataSource sourceList:self pasteboardWriterForItem:item];
    }

    return nil;
}
- (void)outlineView:(NSOutlineView *)outlineView draggingSession:(NSDraggingSession *)session willBeginAtPoint:(NSPoint)screenPoint forItems:(NSArray *)draggedItems
{
    if ([_secondaryDataSource respondsToSelector:@selector(sourceList:draggingSession:willBeginAtPoint:forItems:)]) {
        return [_secondaryDataSource sourceList:self draggingSession:session willBeginAtPoint:screenPoint forItems:draggedItems];
    }
    
}

- (void)outlineView:(NSOutlineView *)outlineView draggingSession:(NSDraggingSession *)session endedAtPoint:(NSPoint)screenPoint operation:(NSDragOperation)operation
{
    if ([_secondaryDataSource respondsToSelector:@selector(sourceList:draggingSession:endedAtPoint:operation:)]) {
        return [_secondaryDataSource sourceList:self draggingSession:session endedAtPoint:screenPoint operation:operation];
    }
}

- (void)outlineView:(NSOutlineView *)outlineView updateDraggingItemsForDrag:(id <NSDraggingInfo>)draggingInfo
{
    if ([_secondaryDataSource respondsToSelector:@selector(sourceList:updateDraggingItemsForDrag:)]) {
        return [_secondaryDataSource sourceList:self updateDraggingItemsForDrag:draggingInfo];
    }
}

#pragma mark -
#pragma mark NSOutlineView Delegate methods

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldExpandItem:(id)item
{
	if([_secondaryDelegate respondsToSelector:@selector(sourceList:shouldExpandItem:)]) {
		return [_secondaryDelegate sourceList:self shouldExpandItem:item];
	}
	
	return YES;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldCollapseItem:(id)item
{
	//Make sure the item isn't displayed as always expanded
	if([self isGroupItem:item])
	{
		if([self isGroupAlwaysExpanded:item]) {
			return NO;
		}
	}
	
	if([_secondaryDelegate respondsToSelector:@selector(sourceList:shouldCollapseItem:)]) {
		return [_secondaryDelegate sourceList:self shouldCollapseItem:item];
	}
	
	return YES;
}

- (NSCell *)outlineView:(NSOutlineView *)outlineView dataCellForTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
	if([_secondaryDelegate respondsToSelector:@selector(sourceList:dataCellForItem:)]) {
		return [_secondaryDelegate sourceList:self dataCellForItem:item];
	}
	
	NSInteger row = [self rowForItem:item];
	
	//Return the default table column
	return [[[self tableColumns] objectAtIndex:0] dataCellForRow:row];
}

- (void)outlineView:(NSOutlineView *)outlineView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
	if([_secondaryDelegate respondsToSelector:@selector(sourceList:willDisplayCell:forItem:)]) {
		[_secondaryDelegate sourceList:self willDisplayCell:cell forItem:item];
	}
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item
{	
	//Make sure that the item isn't a group as they can't be selected
	if(![self isGroupItem:item]) {		
		if([_secondaryDelegate respondsToSelector:@selector(sourceList:shouldSelectItem:)]) {
			return [_secondaryDelegate sourceList:self shouldSelectItem:item];
		}
	}
	else {
		return NO;
	}
	
	return YES;
}


- (NSIndexSet *)outlineView:(NSOutlineView *)outlineView selectionIndexesForProposedSelection:(NSIndexSet *)proposedSelectionIndexes
{	
	//The outline view will try to select the first row if -[allowsEmptySelection:] is set to NO – if this is a group row
	//stop it from doing so and leave it to our implementation of-[reloadData] which will select the first non-group row
	//for us.
	if([self numberOfSelectedRows]==0) {
		if([self isGroupItem:[self itemAtRow:[proposedSelectionIndexes firstIndex]]]) {
			return [NSIndexSet indexSet];
		}
	}
	
	if([_secondaryDelegate respondsToSelector:@selector(sourceList:selectionIndexesForProposedSelection:)]) {
		return [_secondaryDelegate sourceList:self selectionIndexesForProposedSelection:proposedSelectionIndexes];
	}
	
	//Since we implement this method, something must be returned to the outline view
	return proposedSelectionIndexes;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldEditTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
	//Group titles can't be edited
	if([self isGroupItem:item])
		return NO;
	
	if([_secondaryDelegate respondsToSelector:@selector(sourceList:shouldEditItem:)]) {
		return [_secondaryDelegate sourceList:self shouldEditItem:item];
	}
	
	return YES;
}


- (BOOL)outlineView:(NSOutlineView *)outlineView shouldTrackCell:(NSCell *)cell forTableColumn:(NSTableColumn *)tableColumn item:(id)item
{	
	if([_secondaryDelegate respondsToSelector:@selector(sourceList:shouldTrackCell:forItem:)]) {
		return [_secondaryDelegate sourceList:self shouldTrackCell:cell forItem:item];
	}
	
	return NO;
}

- (CGFloat)outlineView:(NSOutlineView *)outlineView heightOfRowByItem:(id)item
{
	if([_secondaryDelegate respondsToSelector:@selector(sourceList:heightOfRowByItem:)]) {
		return [_secondaryDelegate sourceList:self heightOfRowByItem:item];
	}	
	
	return [self rowHeight];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item
{
	return [self isGroupItem:item];
}

#pragma mark -
#pragma mark Notification handling

/* Notification wrappers */
- (void)outlineViewSelectionIsChanging:(NSNotification *)notification
{
	[[NSNotificationCenter defaultCenter] postNotificationName:PXSLSelectionIsChangingNotification object:self];
}


- (void)outlineViewSelectionDidChange:(NSNotification *)notification
{
	[[NSNotificationCenter defaultCenter] postNotificationName:PXSLSelectionDidChangeNotification object:self];	
}

- (void)outlineViewItemWillExpand:(NSNotification *)notification
{
	[[NSNotificationCenter defaultCenter] postNotificationName:PXSLItemWillExpandNotification
														object:self
													  userInfo:[notification userInfo]];
}

- (void)outlineViewItemDidExpand:(NSNotification *)notification
{
	[[NSNotificationCenter defaultCenter] postNotificationName:PXSLItemDidExpandNotification
														object:self
													  userInfo:[notification userInfo]];	
}

- (void)outlineViewItemWillCollapse:(NSNotification *)notification
{
	[[NSNotificationCenter defaultCenter] postNotificationName:PXSLItemWillCollapseNotification
														object:self
													  userInfo:[notification userInfo]];	
}

- (void)outlineViewItemDidCollapse:(NSNotification *)notification
{
	[[NSNotificationCenter defaultCenter] postNotificationName:PXSLItemDidCollapseNotification
														object:self
													  userInfo:[notification userInfo]];	
}

- (void)registerDelegateToReceiveNotification:(NSString*)notification withSelector:(SEL)selector
{
	NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
	
	//Set the delegate as a receiver of the notification if it implements the notification method
	if([_secondaryDelegate respondsToSelector:selector]) {
		[defaultCenter addObserver:_secondaryDelegate
						  selector:selector
							  name:notification
							object:self];
	}
}

@end
