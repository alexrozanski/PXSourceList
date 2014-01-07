//
//  PXSourceListDelegate.h
//  PXViewKit
//
//  Created by Alex Rozanski on 17/10/2009.
//  Copyright 2009-14 Alex Rozanski http://alexrozanski.com and other contributors.
//  This software is licensed under the New BSD License. Full details can be found in the README.
//

#import <Cocoa/Cocoa.h>

@class PXSourceList;

/**
 The `PXSourceListDelegate` protocol defines methods that can be implemented by delegates of `PXSourceList` objects.
 */
@protocol PXSourceListDelegate <NSObject>

@optional
//Extra methods
- (BOOL)sourceList:(PXSourceList*)aSourceList isGroupAlwaysExpanded:(id)group;
- (NSMenu*)sourceList:(PXSourceList*)aSourceList menuForEvent:(NSEvent*)theEvent item:(id)item;

//Basically NSOutlineViewDelegate wrapper methods
/**
 @brief Returns the view used to display the given item
 @discussion This method is analagous to `-outlineView:viewForTableColumn:item:` except the `NSTableColumn` parameter is omitted from this method (PXSourceList only makes use of a single table column). Aside from that, this method works in exactly the same way.
 
 Unlike when using PXSourceList in cell-based mode where the icon and badge value for each item can be set up using the PXSourceListDataSource methods, it is in this method that you should set up the icon and badge for the view (if applicable) when using PXSourceList in view-based mode. You can make use of the PXSourceListTableCellView class which exposes an outlet for a PXSourceListBadgeView (the built in view class which displays badges), and the `textField` and `imageView` outlets (which are inherited from its superclass, `NSTableCellView`) for the item's label and icon, respectively.

 @param aSourceList The Source List that sent the message
 @param item An item in the data source

 @return The view to display for the specified item, or `nil` if you don't want to display a view for the item.

 @since Requires the Mac OS X 10.7 SDK or above.
 */
- (NSView *)sourceList:(PXSourceList *)aSourceList viewForItem:(id)item;
- (NSTableRowView *)sourceList:(PXSourceList *)aSourceList rowViewForItem:(id)item;
- (void)sourceList:(PXSourceList *)aSourceList didAddRowView:(NSTableRowView *)rowView forRow:(NSInteger)row;
- (void)sourceList:(PXSourceList *)aSourceList didRemoveRowView:(NSTableRowView *)rowView forRow:(NSInteger)row;

- (BOOL)sourceList:(PXSourceList*)aSourceList shouldSelectItem:(id)item;
- (NSIndexSet*)sourceList:(PXSourceList*)aSourceList selectionIndexesForProposedSelection:(NSIndexSet *)proposedSelectionIndexes;

- (NSString *)sourceList:(PXSourceList *)sourceList toolTipForCell:(NSCell *)cell rect:(NSRectPointer)rect item:(id)item mouseLocation:(NSPoint)mouseLocation;

- (NSString *)sourceList:(PXSourceList *)sourceList typeSelectStringForItem:(id)item;
- (id)sourceList:(PXSourceList *)sourceList nextTypeSelectMatchFromItem:(id)startItem toItem:(id)endItem forString:(NSString *)searchString;
- (BOOL)sourceList:(PXSourceList *)sourceList shouldTypeSelectForEvent:(NSEvent *)event withCurrentSearchString:(NSString *)searchString;

- (BOOL)sourceList:(PXSourceList*)aSourceList shouldEditItem:(id)item;

- (BOOL)sourceList:(PXSourceList*)aSourceList shouldTrackCell:(NSCell *)cell forItem:(id)item;

- (BOOL)sourceList:(PXSourceList*)aSourceList shouldExpandItem:(id)item;
- (BOOL)sourceList:(PXSourceList*)aSourceList shouldCollapseItem:(id)item;

- (CGFloat)sourceList:(PXSourceList*)aSourceList heightOfRowByItem:(id)item;

- (NSCell*)sourceList:(PXSourceList*)aSourceList willDisplayCell:(id)cell forItem:(id)item;
- (NSCell*)sourceList:(PXSourceList*)aSourceList dataCellForItem:(id)item;

@end

@interface NSObject (PXSourceListNotifications)

//Selection
- (void)sourceListSelectionIsChanging:(NSNotification *)notification;
- (void)sourceListSelectionDidChange:(NSNotification *)notification;

//Item expanding/collapsing
- (void)sourceListItemWillExpand:(NSNotification *)notification;
- (void)sourceListItemDidExpand:(NSNotification *)notification;
- (void)sourceListItemWillCollapse:(NSNotification *)notification;
- (void)sourceListItemDidCollapse:(NSNotification *)notification;

- (void)sourceListDeleteKeyPressedOnRows:(NSNotification *)notification;


@end

//PXSourceList delegate notifications
extern NSString * const PXSLSelectionIsChangingNotification;
extern NSString * const PXSLSelectionDidChangeNotification;
extern NSString * const PXSLItemWillExpandNotification;
extern NSString * const PXSLItemDidExpandNotification;
extern NSString * const PXSLItemWillCollapseNotification;
extern NSString * const PXSLItemDidCollapseNotification;
extern NSString * const PXSLDeleteKeyPressedOnRowsNotification;

