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

 @warning Most of the methods defined by this protocol are analagous to those declared by `NSOutlineViewDelegate` (and are marked as such in the member's documentation), but are prefixed by "sourceList:" instead of "outlineView:". Only the most basic information about these methods is included here, and you should refer to the `NSOutlineViewDelegate` protocol documentation for more information. Several methods differ to those declared on `NSOutlineViewDelegate` in that they don't have an `NSTableColumn` parameter since `PXSourceList` works implicitly with only one table column.
 */
@protocol PXSourceListDelegate <NSObject>

@optional
//Extra methods
/**
 @brief Returns a Boolean value that indicates whether a particular group item is displayed as always expanded.
 @discussion A group that is displayed as *always expanded* displays no 'Show'/'Hide' button to the right on hover, and its direct children are always expanded.

 @param aSourceList The Source List that sent the message
 @param group A group item in the data source

 @return `YES` to specify that the group should be displayed as always expanded, or `NO` if not.

 @since Requires PXSourceList 2.0.0 or above.
 */
- (BOOL)sourceList:(PXSourceList*)aSourceList isGroupAlwaysExpanded:(id)group;

/**
 @brief Returns a context menu which is to be displayed for a given mouse-down event.
 @discussion See `-menuForEvent:` declared on `NSView` for more information.

 @param aSourceList The Source List that sent the message
 @param theEvent A mouse event
 @param item An item in the data source

 @return An instantiated `NSMenu` object to be displayed by the Source List for *event*, or `nil` if no menu is to be shown for the given event.

 @since Requires PXSourceList 0.8 or above.
 */
- (NSMenu*)sourceList:(PXSourceList*)aSourceList menuForEvent:(NSEvent*)theEvent item:(id)item;

//Basically NSOutlineViewDelegate wrapper methods
/**
 @brief Returns the view used to display the given item
 @discussion This method is analagous to `-outlineView:viewForTableColumn:item:` except the `NSTableColumn` parameter is omitted from this method (PXSourceList only makes use of a single table column). Aside from that, this method works in exactly the same way.
 
 Unlike when using PXSourceList in cell-based mode where the icon and badge value for each item can be set up using the PXSourceListDataSource methods, it is in this method that you should set up the icon and badge for the view (if applicable) when using PXSourceList in view-based mode. You can make use of the PXSourceListTableCellView class which exposes an outlet for a PXSourceListBadgeView (the built in view class which displays badges), and the `textField` and `imageView` outlets (which are inherited from its superclass, `NSTableCellView`) for the item's label and icon, respectively.

 @param aSourceList The Source List that sent the message
 @param item An item in the data source

 @return The view to display for the specified item, or `nil` if you don't want to display a view for the item.
 
 @warning This is a required method when using the Source List in view-based mode.

 @since Requires PXSourceList 2.0.0 or above.
 */
- (NSView *)sourceList:(PXSourceList *)aSourceList viewForItem:(id)item;

/**
 @brief Returns the view used to display the given row.
 @discussion See `-outlineView:rowViewForItem:` declared on `NSOutlineViewDelegate` for more information.

 @param aSourceList The Source List that sent the message
 @param item An item in the data source

 @return An `NSTableRowView` instance. As with `NSOutlineViewDelegate`, if `nil` is returned for a row, an `NSTableRowView` instance will be created by the Source List and used instead.

 @since Requires PXSourceList 2.0.0 or above.
 */
- (NSTableRowView *)sourceList:(PXSourceList *)aSourceList rowViewForItem:(id)item;

/**
 @brief Sent when a row view has been added to the Source List.
 @discussion See `-outlineView:didAddRowView:forRow:` declared on `NSOutlineViewDelegate` for more information.

 @param aSourceList The Source List that sent the message
 @param rowView The view that was added to the Source List
 @param row The row index

 @since Requires PXSourceList 2.0.0 or above.
 */
- (void)sourceList:(PXSourceList *)aSourceList didAddRowView:(NSTableRowView *)rowView forRow:(NSInteger)row;

/**
 @brief Sent when a row view has been removed to the Source List.
 @discussion See `-outlineView:didRemoveRowView:forRow:` declared on `NSOutlineViewDelegate` for more information.

 @param aSourceList The Source List that sent the message
 @param rowView The view that was removed
 @param row The row index

 @since Requires PXSourceList 2.0.0 or above.
 */
- (void)sourceList:(PXSourceList *)aSourceList didRemoveRowView:(NSTableRowView *)rowView forRow:(NSInteger)row;

/**
 @brief Returns a Boolean value indicating whether a given item should be selected.
 @discussion This method is analagous to `-outlineView:shouldSelectItem:` declared on `NSOutlineViewDelegate`. See the documentation for this method for more information.

 @param aSourceList The Source List that sent the message
 @param item An item in the data source

 @since Requires PXSourceList 0.8 or above.
 */
- (BOOL)sourceList:(PXSourceList*)aSourceList shouldSelectItem:(id)item;

/**
 @brief Returns the indexes that should be selected for a user-initiated selection.
 @discussion This method is analagous to `-outlineView:selectionIndexesForProposedSelection:` declared on `NSOutlineViewDelegate`. See the documentation for this method for more information.

 @param aSourceList The Source List that sent the message
 @param proposedSelectionIndexes The proposed indexes of rows that should be selected

 @since Requires PXSourceList 0.8 or above.
 */
- (NSIndexSet*)sourceList:(PXSourceList*)aSourceList selectionIndexesForProposedSelection:(NSIndexSet *)proposedSelectionIndexes;

/**
 @brief Returns the tooltip string that should be displayed for a given cell.
 @discussion This method is analagous to `-outlineView:toolTipForCell:rect:tableColumn:item:mouseLocation:` declared on `NSOutlineViewDelegate`, although it doesn't pass an `NSTableColumn` parameter as `PXSourceList` implicitly only uses one table column. See the documentation for `-outlineView:toolTipForCell:rect:tableColumn:item:mouseLocation:` for more information.

 @param sourceList The Source List that sent the message.
 @param cell The cell to return the tooltip for.
 @param rect The proposed active area of the tooltip.
 @param item The item in the data source to display the tooltip for.
 @param mouseLocation The current mouse location in view coordinates.

 @since Requires PXSourceList 2.0.0 or above.
 */
- (NSString *)sourceList:(PXSourceList *)sourceList toolTipForCell:(NSCell *)cell rect:(NSRectPointer)rect item:(id)item mouseLocation:(NSPoint)mouseLocation;

/**
 @brief Returns the string that is used for type selection for a given item.
 @discussion This method is analagous to `-outlineView:typeSelectStringForTableColumn:item:` declared on `NSOutlineViewDelegate`, although it doesn't pass an `NSTableColumn` parameter as `PXSourceList` implicitly only uses one table column. See the documentation for `-outlineView:typeSelectStringForTableColumn:item:` for more information.

 @param sourceList The Source List that sent the message.
 @param item The item to generate the type selection string for.
 
 @return The string value used for type selection of *item*.

 @since Requires PXSourceList 2.0.0 or above.
 */
- (NSString *)sourceList:(PXSourceList *)sourceList typeSelectStringForItem:(id)item;

/**
 @brief Returns the first item that matches the given search string from within the given range.
 @discussion This method is analagous to `-outlineView:nextTypeSelectMatchFromItem:toItem:forString:` declared on `NSOutlineViewDelegate`. See the documentation for this method for more information.

 @param sourceList The Source List that sent the message.
 @param startItem The first item to search.
 @param endItem The item before which to stop searching.
 @param searchString The string to search.
 
 @return The first item in the *startItem*--*endItem* range which matches *searchString*, or `nil` if there is no match.

 @since Requires PXSourceList 2.0.0 or above.
 */
- (id)sourceList:(PXSourceList *)sourceList nextTypeSelectMatchFromItem:(id)startItem toItem:(id)endItem forString:(NSString *)searchString;

/**
 @brief Returns a Boolean value which indicates whether type select should proceed for a given event and search string.
 @discussion This method is analagous to `-outlineView:shouldTypeSelectForEvent:withCurrentSearchString:` declared on `NSOutlineViewDelegate`. See the documentation for this method for more information.

 @param sourceList The Source List that sent the message.
 @param event The event that caused this message to be sent.
 @param searchString The search string for which searching is to proceed from.

 @return `YES` if type select should proceed, or `NO` otherwise.

 @since Requires PXSourceList 2.0.0 or above.
 */
- (BOOL)sourceList:(PXSourceList *)sourceList shouldTypeSelectForEvent:(NSEvent *)event withCurrentSearchString:(NSString *)searchString;

/**
 @brief Returns a Boolean value which indicates whether a cell expansion tooltip should be displayed for a given item.
 @discussion This method is analagous to `-outlineView:shouldShowCellExpansionForItem:` declared on `NSOutlineViewDelegate`, although it doesn't pass an `NSTableColumn` parameter as `PXSourceList` implicitly only uses one table column. See the documentation for `-outlineView:shouldShowCellExpansionForItem:` for more information.

 @param sourceList The Source List that sent the message.
 @param item An item in the data source.

 @return `YES` to allow an expansion tooltip to be displayed for *item*, otherwise `NO`.

 @since Requires PXSourceList 0.8 or above.
 */
- (BOOL)sourceList:(PXSourceList *)sourceList shouldShowCellExpansionForItem:(id)item;

/**
 @brief Returns a Boolean value which indicates whether the Source List should allow editing of a given item.
 @discussion This method is analagous to `-outlineView:shouldEditTableColumn:item:` declared on `NSOutlineViewDelegate`, although it doesn't pass an `NSTableColumn` parameter as `PXSourceList` implicitly only uses one table column. See the documentation for `-outlineView:shouldEditTableColumn:item:` for more information.

 @param aSourceList The Source List that sent the message.
 @param item An item in the data source.

 @return `YES` to allow editing of *item*, or `NO` otherwise.

 @since Requires PXSourceList 0.8 or above.
 */
- (BOOL)sourceList:(PXSourceList*)aSourceList shouldEditItem:(id)item;

/**
 @brief Returns a Boolean value that indicates whether a given cell should be tracked
 @discussion This method is analagous to `-outlineView:shouldTrackCell:forTableColumn:item:` declared on `NSOutlineViewDelegate`, although it doesn't pass an `NSTableColumn` parameter as `PXSourceList` implicitly only uses one table column. See the documentation for `-outlineView:shouldTrackCell:forTableColumn:item:` for more information.

 @param aSourceList The Source List that sent the message.
 @param cell The cell used to display *item*
 @param item An item in the data source

 @return `YES` if the cell should be tracked for *item*, otherwise `NO`.

 @since Requires PXSourceList 0.8 or above.
 */
- (BOOL)sourceList:(PXSourceList*)aSourceList shouldTrackCell:(NSCell *)cell forItem:(id)item;

/**
 @brief Returns a Boolean value that indicates whether a given item should be expanded.
 @discussion This method is analagous to `-outlineView:shouldExpandItem:` declared on `NSOutlineViewDelegate`. See the documentation for this method for more information.

 @param aSourceList The Source List that sent the message.
 @param item An item in the data source

 @return `YES` to allow expansion of *item*, otherwise `NO`.

 @since Requires PXSourceList 0.8 or above.
 */
- (BOOL)sourceList:(PXSourceList*)aSourceList shouldExpandItem:(id)item;

/**
 @brief Returns a Boolean value that indicates whether a given item should be collapsed.
 @discussion This method is analagous to `-outlineView:shouldCollapseItem:` declared on `NSOutlineViewDelegate`. See the documentation for this method for more information.

 @param aSourceList The Source List that sent the message.
 @param item An item in the data source

 @return `YES` to allow *item* to be collapsed, otherwise `NO`.

 @since Requires PXSourceList 0.8 or above.
 */
- (BOOL)sourceList:(PXSourceList*)aSourceList shouldCollapseItem:(id)item;

/**
 @brief Returns the height in points of the row for the given item.
 @discussion This method is analagous to `-outlineView:heightOfRowByItem:` declared on `NSOutlineViewDelegate`. See the documentation for this method for more information.

 @param aSourceList The Source List that sent the message.
 @param item An item in the data source

 @return The height of the row used to display *item* in points.

 @since Requires PXSourceList 0.8 or above.
 */
- (CGFloat)sourceList:(PXSourceList*)aSourceList heightOfRowByItem:(id)item;

/**
 @brief Informs the delegate that the Source List is about to display the cell associated with the given item.
 @discussion This method is analagous to `-outlineView:willDisplayCell:forTableColumn:item:` declared on `NSOutlineViewDelegate`, although it doesn't pass an `NSTableColumn` parameter as `PXSourceList` implicitly only uses one table column. See the documentation for `-outlineView:willDisplayCell:forTableColumn:item:` for more information.

 @param aSourceList The Source List that sent the message.
 @param cell The cell about to be displayed
 @param item An item in the data source

 @since Requires PXSourceList 0.8 or above.
 */
- (NSCell*)sourceList:(PXSourceList*)aSourceList willDisplayCell:(id)cell forItem:(id)item;

/**
 @brief Returns the cell for use with a given item in the Source List.
 @discussion This method is analagous to `-outlineView:dataCellForTableColumn:item:` declared on `NSOutlineViewDelegate`, although it doesn't pass an `NSTableColumn` parameter as `PXSourceList` implicitly only uses one table column. See the documentation for `-outlineView:dataCellForTableColumn:item:` for more information.

 @param aSourceList The Source List that sent the message.
 @param item An item in the data source

 @since Requires PXSourceList 0.8 or above.
 */
- (NSCell*)sourceList:(PXSourceList*)aSourceList dataCellForItem:(id)item;

/**
 @brief Invoked when *notification* is posted (when the Source List's selection changes).
 @discussion This method is invoked when the `PXSLSelectionIsChangingNotification` notification is posted.
 
 This method is analagous to `-outlineViewSelectionIsChanging:` declared on `NSOutlineViewDelegate`. See the documentation for this method for more information.

 @param notification The posted notification.

 @since Requires PXSourceList 0.8 or above.
 */
- (void)sourceListSelectionIsChanging:(NSNotification *)notification;

/**
 @brief Invoked when *notification* is posted (when the Source List's selection has finished changing).
 @discussion This method is invoked when the `PXSLSelectionDidChangeNotification` notification is posted.

 This method is analagous to `-outlineViewSelectionDidChange:` declared on `NSOutlineViewDelegate`. See the documentation for this method for more information.

 @param notification The posted notification.

 @since Requires PXSourceList 0.8 or above.
 */
- (void)sourceListSelectionDidChange:(NSNotification *)notification;

/**
 @brief Invoked when *notification* is posted (when an item in the Source List is about to expand in response to user input).
 @discussion This method is invoked when the `PXSLItemWillExpandNotification` notification is posted.

 This method is analagous to `-outlineViewItemWillExpand:` declared on `NSOutlineViewDelegate`. See the documentation for this method for more information.

 @param notification The posted notification.

 @since Requires PXSourceList 0.8 or above.
 */
- (void)sourceListItemWillExpand:(NSNotification *)notification;

/**
 @brief Invoked when *notification* is posted (when an item in the Source List was expanded in response to user input).
 @discussion This method is invoked when the `PXSLItemDidExpandNotification` notification is posted.

 This method is analagous to `-outlineViewItemDidExpand:` declared on `NSOutlineViewDelegate`. See the documentation for this method for more information.

 @param notification The posted notification.

 @since Requires PXSourceList 0.8 or above.
 */
- (void)sourceListItemDidExpand:(NSNotification *)notification;

/**
 @brief Invoked when *notification* is posted (when an item in the Source List is about to collapse in response to user input).
 @discussion This method is invoked when the `PXSLItemWillCollapseNotification` notification is posted.

 This method is analagous to `-outlineViewItemWillCollapse:` declared on `NSOutlineViewDelegate`. See the documentation for this method for more information.

 @param notification The posted notification.

 @since Requires PXSourceList 0.8 or above.
 */
- (void)sourceListItemWillCollapse:(NSNotification *)notification;

/**
 @brief Invoked when *notification* is posted (when an item in the Source List was collapsed in response to user input).
 @discussion This method is invoked when the `PXSLItemDidCollapseNotification` notification is posted.

 This method is analagous to `-outlineViewItemDidCollapse:` declared on `NSOutlineViewDelegate`. See the documentation for this method for more information.

 @param notification The posted notification.

 @since Requires PXSourceList 0.8 or above.
 */
- (void)sourceListItemDidCollapse:(NSNotification *)notification;

/**
 @brief Invoked when *notification* is posted (when a deletion key is pressed and a row in the Source List is selected).
 @discussion This method is invoked when the `PXSLDeleteKeyPressedOnRowsNotification` notification is posted.

 @param notification The posted notification.

 @since Requires PXSourceList 0.8 or above.
 */
- (void)sourceListDeleteKeyPressedOnRows:(NSNotification *)notification;

@end

//PXSourceList delegate notifications
/**
 @brief This is analagous to the `NSOutlineViewSelectionIsChangingNotification` notification. Take a look at the `NSOutlineView` documentation for more information.
 @since Requires PXSourceList 0.8 or above.
 */
extern NSString * const PXSLSelectionIsChangingNotification;

/**
 @brief This is analagous to the `NSOutlineViewSelectionDidChangeNotification` notification. Take a look at the `NSOutlineView` documentation for more information.
 @since Requires PXSourceList 0.8 or above.
 */
extern NSString * const PXSLSelectionDidChangeNotification;

/**
 @brief This is analagous to the `NSOutlineViewItemWillExpandNotification` notification. Take a look at the `NSOutlineView` documentation for more information.
 @since Requires PXSourceList 0.8 or above.
 */
extern NSString * const PXSLItemWillExpandNotification;

/**
 @brief This is analagous to the `NSOutlineViewItemDidExpandNotification` notification. Take a look at the `NSOutlineView` documentation for more information.
 @since Requires PXSourceList 0.8 or above.
 */
extern NSString * const PXSLItemDidExpandNotification;

/**
 @brief This is analagous to the `NSOutlineViewItemWillCollapseNotification` notification. Take a look at the `NSOutlineView` documentation for more information.
 @since Requires PXSourceList 0.8 or above.
 */
extern NSString * const PXSLItemWillCollapseNotification;

/**
 @brief This is analagous to the `NSOutlineViewItemDidCollapseNotification` notification. Take a look at the `NSOutlineView` documentation for more information.
 @since Requires PXSourceList 0.8 or above.
 */
extern NSString * const PXSLItemDidCollapseNotification;

/**
 @brief Posted whenever a "deletion key" (backspace, cmd-backspace or fn-backspace) is pressed and handled by the Source List and a row is selected.
 @discussion The notification *object* is the `PXSourceList` object which the notification was posted by. The *userInfo* dictionary contains a `@"rows"` key which maps to an `NSIndexSet` object which contains the selected row indexes that were selected when the notification was posted.
 @since Requires PXSourceList 0.8 or above.
 */
extern NSString * const PXSLDeleteKeyPressedOnRowsNotification;
