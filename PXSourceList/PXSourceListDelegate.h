//
//  PXSourceListDelegate.h
//  PXViewKit
//
//  Created by Alex Rozanski on 17/10/2009.
//  Copyright 2009-10 Alex Rozanski http://perspx.com
//

#import <Cocoa/Cocoa.h>

@class PXSourceList;

@protocol PXSourceListDelegate <NSObject>

@optional
//Extra methods
- (BOOL)sourceList:(PXSourceList*)aSourceList isGroupAlwaysExpanded:(id)group;
- (NSMenu*)sourceList:(PXSourceList*)aSourceList menuForEvent:(NSEvent*)theEvent item:(id)item;

//Basically NSOutlineViewDelegate wrapper methods
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

