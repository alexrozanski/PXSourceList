//
//  PXSourceListDataSource.h
//  PXViewKit
//
//  Created by Alex Rozanski on 17/10/2009.
//  Copyright 2009-14 Alex Rozanski http://alexrozanski.com and other contributors.
//  This software is licensed under the New BSD License. Full details can be found in the README.
//

#import <Cocoa/Cocoa.h>

@class PXSourceList;

/**
 The `PXSourceListDataSource` protocol defines methods that can be implemented by data sources of `PXSourceList` objects.
 */
@protocol PXSourceListDataSource <NSObject>

@required
///---------------------------------------------------------------------------------------
/// @name Working with Items in a Source List
///---------------------------------------------------------------------------------------
/** 
 @brief Returns the number of child items of a given item

 @param sourceList The Source List that sent the message
 @param item An item in the data source

 @return The number of immediate child items of *item*. If *item* is `nil` then you should return the number of top-level items in the Source List item hierarchy.
 
 @since Requires the Mac OS X 10.5 SDK or above.
 
 @see sourceList:child:ofItem:
 */
- (NSUInteger)sourceList:(PXSourceList*)sourceList numberOfChildrenOfItem:(id)item;

/**
 @brief Returns the direct child of a given item at the specified index

 @param aSourceList The Source List that sent the message
 @param index The index of the child item of *item* to return
 @param item An item in the data source

 @return The immediate child of *item* at the specified *index*. If *item* is `nil`, then return the top-level item with index of *index*.

 @since Requires the Mac OS X 10.5 SDK or above.

 @see sourceList:numberOfChildrenOfItem:
 */
- (id)sourceList:(PXSourceList*)aSourceList child:(NSUInteger)index ofItem:(id)item;

/**
 @brief Returns a Boolean value indicating whether a given item in the Source List is expandable
 @discussion An expandable item is one which contains child items, and can be expanded to display these. Additionally, if a group item is always displayed as expanded (denoted by `-sourceList:isGroupAlwaysExpanded:` from the `PXSourceListDelegate` protocol) then you must return `YES` from this method for the given group item.

 @param aSourceList The Source List that sent the message
 @param item An item in the data source

 @return `YES` if *item* can be expanded, or `NO` otherwise.

 @since Requires the Mac OS X 10.5 SDK or above.
 */
- (BOOL)sourceList:(PXSourceList*)aSourceList isItemExpandable:(id)item;

@optional
- (id)sourceList:(PXSourceList*)aSourceList objectValueForItem:(id)item;
- (void)sourceList:(PXSourceList*)aSourceList setObjectValue:(id)object forItem:(id)item;

///---------------------------------------------------------------------------------------
/// @name Working with Badges
///---------------------------------------------------------------------------------------

/**
 @brief Returns a Boolean specifying whether a given item shows a badge or not
 @discussion This method can be implemented by the data source to specify whether a given item displays a badge or not. A badge is a rounded rectangle containing a number (the badge value), displayed to the right of a row's cell.

 This method must be implemented for the other badge-related data source methods – sourceList:badgeValueForItem:, sourceList:badgeTextColorForItem: and sourceList:badgeBackgroundColorForItem: – to be called.

 @param aSourceList The Source List that sent the message
 @param item An item in the data source

 @return `YES` if *item* should display a badge, or `NO` otherwise.
 
 @warning This method is only used by the Source List when operating in cell-based mode. When the Source List is operating in view-based mode, the view for each cell is responsible for managing a badge, if applicable.

 @see sourceList:badgeValueForItem:
 @see sourceList:badgeTextColorForItem:
 @see sourceList:badgeBackgroundColorForItem:

 @since Requires the Mac OS X 10.5 SDK or above.
 */
- (BOOL)sourceList:(PXSourceList*)aSourceList itemHasBadge:(id)item;

/**
 @brief Returns an integer specifying the badge value for a particular item
 @discussion This method can be implemented by the data source to specify a badge value for any particular item. If you want an item to display a badge, you must also implement sourceList:itemHasBadge: and return `YES` for that item. Returning `NO` for items in sourceList:itemHasBadge: means that this method will not be called for that item.

 @param aSourceList The Source List that sent the message
 @param item An item in the data source

 @return The badge value for *item*.
 
 @warning This method is only used by the Source List when operating in cell-based mode. When the Source List is operating in view-based mode, the view for each cell is responsible for managing a badge, if applicable.

 @see sourceList:itemHasBadge:
 @see sourceList:badgeTextColorForItem:
 @see sourceList:badgeBackgroundColorForItem:

 @since Requires the Mac OS X 10.5 SDK or above.
 */
- (NSInteger)sourceList:(PXSourceList*)aSourceList badgeValueForItem:(id)item;

/**
 @brief Returns a color that is used for the badge text color of an item in the Source List
 @discussion This method can be implemented by the data source to specify a custom badge color for a particular item.

 This method is only called for *item* if you return `YES` for *item* in sourceList:itemHasBadge:.

 @param aSourceList The Source List that sent the message
 @param item An item in the data source
 
 @return An `NSColor` object to use for the text color of *item*'s badge or `nil` to use the default badge text color.
 
 @warning This method is only used by the Source List when operating in cell-based mode. When the Source List is operating in view-based mode, the view for each cell is responsible for managing a badge, if applicable.

 @see sourceList:itemHasBadge:
 @see sourceList:badgeValueForItem:
 @see sourceList:badgeBackgroundColorForItem:

 @since Requires the Mac OS X 10.5 SDK or above.
 */
- (NSColor*)sourceList:(PXSourceList*)aSourceList badgeTextColorForItem:(id)item;

/**
 @brief Returns a color that is used for the badge background color of an item in the Source List
 @discussion This method can be implemented by the data source to specify a custom badge background color for a particular item.

 This method is only called for *item* if you return `YES` for *item* in sourceList:itemHasBadge:.

 @param aSourceList The Source List that sent the message
 @param item An item in the data source

 @return An `NSColor` object to use for the background color of *item*'s badge or `nil` to use the default badge background color.
 
 @warning This method is only used by the Source List when operating in cell-based mode. When the Source List is operating in view-based mode, the view for each cell is responsible for managing a badge, if applicable.

 @see sourceList:itemHasBadge:
 @see sourceList:badgeValueForItem:
 @see sourceList:badgeTextColorForItem:

 @since Requires the Mac OS X 10.5 SDK or above.
 */
- (NSColor*)sourceList:(PXSourceList*)aSourceList badgeBackgroundColorForItem:(id)item;

///---------------------------------------------------------------------------------------
/// @name Working with Icons
///---------------------------------------------------------------------------------------
- (BOOL)sourceList:(PXSourceList*)aSourceList itemHasIcon:(id)item;
- (NSImage*)sourceList:(PXSourceList*)aSourceList iconForItem:(id)item;

//The rest of these methods are basically "wrappers" for the NSOutlineViewDataSource methods
///---------------------------------------------------------------------------------------
/// @name Supporting Object Persistence
///---------------------------------------------------------------------------------------
- (id)sourceList:(PXSourceList*)aSourceList itemForPersistentObject:(id)object;
- (id)sourceList:(PXSourceList*)aSourceList persistentObjectForItem:(id)item;
- (void)sourceList:(PXSourceList *)outlineView sortDescriptorsDidChange:(NSArray *)oldDescriptors;

///---------------------------------------------------------------------------------------
/// @name Supporting Drag and Drop
///---------------------------------------------------------------------------------------
- (BOOL)sourceList:(PXSourceList*)aSourceList writeItems:(NSArray *)items toPasteboard:(NSPasteboard *)pboard;
- (NSDragOperation)sourceList:(PXSourceList*)sourceList validateDrop:(id < NSDraggingInfo >)info proposedItem:(id)item proposedChildIndex:(NSInteger)index;
- (BOOL)sourceList:(PXSourceList*)aSourceList acceptDrop:(id < NSDraggingInfo >)info item:(id)item childIndex:(NSInteger)index;
- (NSArray *)sourceList:(PXSourceList*)aSourceList namesOfPromisedFilesDroppedAtDestination:(NSURL *)dropDestination forDraggedItems:(NSArray *)items;

///---------------------------------------------------------------------------------------
/// @name Drag and drop methods for 10.7+
///---------------------------------------------------------------------------------------
- (id <NSPasteboardWriting>)sourceList:(PXSourceList *)aSourceList pasteboardWriterForItem:(id)item;
- (void)sourceList:(PXSourceList *)aSourceList draggingSession:(NSDraggingSession *)session willBeginAtPoint:(NSPoint)screenPoint forItems:(NSArray *)draggedItems;
- (void)sourceList:(PXSourceList *)aSourceList draggingSession:(NSDraggingSession *)session endedAtPoint:(NSPoint)screenPoint operation:(NSDragOperation)operation;
- (void)sourceList:(PXSourceList *)aSourceList updateDraggingItemsForDrag:(id <NSDraggingInfo>)draggingInfo;

@end
