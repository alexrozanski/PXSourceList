//
//  PXSourceList.h
//  PXSourceList
//
//  Created by Alex Rozanski on 05/09/2009.
//  Copyright 2009-14 Alex Rozanski http://alexrozanski.com and other contributors.
//  This software is licensed under the New BSD License. Full details can be found in the README.
//

#import <Cocoa/Cocoa.h>

#import "PXSourceListDelegate.h"
#import "PXSourceListDataSource.h"
#import "PXSourceListItem.h"
#import "PXSourceListBadgeView.h"
#import "PXSourceListTableCellView.h"

/**

 `PXSourceList` is an `NSOutlineView` subclass that uses 'Source List' styling similar to that used by the
 sidebar in applications such as iTunes and Mail.app.

 Unlike `NSOutlineView`, `PXSourceList` objects operate with only one column and do not display a header.

 Like `NSOutlineView` and `NSTableView`, a `PXSourceList` object does not store its own data, but retrieves
 values from a weakly-referenced data source (see the `PXSourceListDataSource` protocol). A `PXSourceList`
 object can also have a delegate, to which it sends messages when certain events occur (see the
 `PXSourceListDelegate` protocol and the `NSObject(PXSourceListNotifications)` category for more information).
 
 ### Cell-based vs. view-based mode
 
 Like `NSTableView` and `NSOutlineView`, `PXSourceList` can operate in both cell-based and view-based mode in
 relation to how you provide content to be displayed.
 
 There are several classes provided alongside `PXSourceList` which make providing content when using
 `PXSourceList` in view-based mode a lot easier:
 
 - `PXSourceListTableCellView`: an `NSTableCellView` subclass which exposes a `badgeView` outlet that can be
   hooked up to a `PXSourceListBadgeView` instance (see below) in Interface Builder. Along with `NSTableCellView`
   and its `textField` and `imageView` properties, `PXSourceListTableCellView` is an `NSTableCellView` subclass which
   allows you to easily display an icon, title and a badge for each item in the Source List.
 - `PXSourceListBadgeView`: a view class for displaying badges, which can be used in your table cell views and
   configured to display a particular badge number. Additionally, it can be configured to use custom text and
   background colours, although it will use the regular Source List styling of light text on a grey-blue background
   by default.
 
 When using `PXSourceList` in cell-based mode, it can manage drawing of icons and badges for you through custom
 drawing. However, when using `PXSourceList` in view-based mode, it can't do this directly, because cell views
 are configured independently in Interface Builder (or programmatically and set up) and configured in the
 `PXSourceListDataSource` method, `-sourceList:viewForItem:`. Of particular note, the following
 `PXSourceListDataSource` methods are not used by `PXSourceList` when operating in view-based mode.
 
 - `-sourceList:itemHasBadge:`
 - `-sourceList:badgeValueForItem:`
 - `-sourceList:badgeTextColorForItem:`
 - `-sourceList:badgeBackgroundColorForItem:`
 - `-sourceList:itemHasIcon:`
 - `-sourceList:iconForItem:`
 
 Instead, you should set up the icon for each item in `-sourceList:viewForItem:` using the `imageView` property
 of `NSTableCellView`, and the `badgeView` property if using `PXSourceListTableCellView` objects to display
 your content.

 */
@interface PXSourceList: NSOutlineView <NSOutlineViewDelegate, NSOutlineViewDataSource>

///---------------------------------------------------------------------------------------
/// @name Delegate and Data Source
///---------------------------------------------------------------------------------------

/** Used to set the Source List's data source.
 
 @warning Unfortunately, due to the way that `PXSourceList` is implemented, sending `-dataSource` to the Source List
 will return a proxy object which is used internally. As such you shouldn't use this property to retrieve the data source,
 only set it.
 */

@property (weak) id<PXSourceListDataSource> dataSource;

/** Used to set the Source List's delegate.
 
 @warning Unfortunately, due to the way that `PXSourceList` is implemented, sending `-delegate` to the Source List
 will return a proxy object which is used internally. As such you shouldn't use this property to retrieve the data source,
 only set it.
 */

@property (weak) id<PXSourceListDelegate> delegate;

///---------------------------------------------------------------------------------------
/// @name Setting Display Attributes
///---------------------------------------------------------------------------------------

/** Returns the size of icons to display in items in the Source List.
 
 @discussion The default value is 16 x 16.

 @warning This property only applies when using `PXSourceList` in cell-based mode. If set on a Source List
 operating in view-based mode, this value is not used.
 */

@property (nonatomic, assign) NSSize iconSize;

///---------------------------------------------------------------------------------------
/// @name Working with Groups
///---------------------------------------------------------------------------------------

@property (readonly) NSUInteger numberOfGroups;

/** Returns a Boolean value that indicates whether a given item in the Source List is a group item.

 @param item The item to query about.
 
 @return `YES` if *item* exists in the Source List and is a group item, otherwise `NO`.
 
 @discussion "Group" items are defined as items at level 0 in the Source List tree hierarchy.
 */
- (BOOL)isGroupItem:(id)item;

/** Returns a Boolean value that indicates whether a given group item in the Source List is always expanded.
 
 @param group The given group item.
 
 @return `YES` if *group* is a group item in the Source List which is displayed as always expanded, or `NO` otherwise.
 
 @discussion A group item that is displayed as always expanded doesn't show a 'Show'/'Hide' button on hover as
 with regular group items. It is automatically expanded when the Source List's data is reloaded and cannot be
 collapsed.
 
 This method calls the `-sourceList:isGroupAlwaysExpanded:` method on the Source List's delegate to determine
 whether the particular group item is displayed as always expanded or not.
 */
- (BOOL)isGroupAlwaysExpanded:(id)group;

///---------------------------------------------------------------------------------------
/// @name Working with Badges
///---------------------------------------------------------------------------------------

/** Returns a Boolean value that indicates whether a given item in the Source List displays a badge.

 @param item The given item.

 @return `YES` if the Source List is operating in cell-based mode and *item* displays a badge, or `NO` otherwise.

 @discussion This method calls the `-sourceList:itemHasBadge:` method on the Source List's delegate to determine
 whether the item displays a badge or not.
 
 @warning This method only applies when using a Source List in cell-based mode. If sent to a Source List in view-based mode, this
 method returns `NO`.
 */
- (BOOL)itemHasBadge:(id)item;

/** Returns the integer value of the badge for a given item.

 @param item The given item.

 @return The integer value of the badge for *item* if the Source List is operating in cell-based mode and *item* displays a badge, or `NSNotFound` otherwise.

 @discussion This method calls the `-sourceList:badgeValueForItem:` method on the Source List's data source to determine
 the item's badge value.

 @warning This method only applies when using a Source List in cell-based mode. If sent to a Source List in view-based mode, this
 method returns `NSNotFound`.
 */
- (NSInteger)badgeValueForItem:(id)item;

@end

