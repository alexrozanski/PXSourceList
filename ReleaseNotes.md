# PXSourceList Release Notes

## 2.0.7
- Remove -setFlipped: call which was causing a deprecation warning on OS X 10.10.
- Fix whitespace in PXSourceList.m.

## 2.0.6
- Merge PR #49: Fix PXSourceListBadgeCell accessibility. Adds accessibility for PXSourceListBadgeCell when using PXSourceList in view-based mode.

## 2.0.5
- Fix #43: sourceListDeleteKeyPressedOnRows: called twice. This was caused by an issue where PXSourceList was incorrectly removing the old delegate as an observer of PXSourceList notifications in -setDelegate:.

## 2.0.4
- PR #41: fix a Zeroing Weak References problem. This fixes an issue where using an `NSWindow`, `NSWindowController` or `NSViewController` as a PXSourceList delegate or dataSource would cause problems on 10.7 because prior to 10.8, these classes could not be referenced by zeroing weak references.
- Remove unused `badgeMargin` constant from PXSourceList.m.

## 2.0.3
- Fix #40: Editing titles on cell based source list causes exception.
- Fix issue in view-based source list example where items created with the add button couldn't be dragged.

## 2.0.2
- Fix #39: Badges not drawn correctly when Source List row is selected.

## 2.0.1
- Add missing note to the 2.0.0 release notes about marking `-[PXSourceList delegate]` and `-[PXSourceList dataSource]` as unavailable using \_\_attribute\_\_.

## 2.0.0

### New Features

- Added support for view-based mode to `PXSourceList`, whilst retaining legacy cell-based support. (View-based delegate methods added are detailed below).
- Added a new view-based Source List example target which includes an example of how to use drag-and-drop in the Source List.
- Added `PXSourceListTableCellView`, an `NSTableCellView` subclass which is useful when using `PXSourceList` in view-based mode.
- Added `PXSourceListBadgeView`, which can be used in `PXSourceListTableCellView`s to display badges. This class's drawing is done by the internal `PXSourceListBadgeCell` class.
- Added a generic `PXSourceListItem` data source model class which can be used for easily constructing data source models without having to implement your own class.

### API Changes
- **Incompatible change.* Marked `-[PXSourceList delegate]` and -[PXSourceList dataSource]` as unavailable using the “unavailable” \_\_attribute\_\_. These methods shouldn’t be used because of the internal implementation of PXSourceList, and have been documented as such since version 0.8. However, adding this \_\_attribute\_\_ is more robust because a compile-time error will be generated if you use either of these methods.
- Added view-based Source List delegate methods to `PXSourceListDelegate`, namely:
	- `-sourceList:viewForItem:`
	- `-sourceList:rowViewForItem:`
	- `-sourceList:didAddRowView:forRow:`
	- `-sourceList:didRemoveRowView:forRow:`
- Added missing `PXSourceListDelegate` methods which map to their `NSOutlineViewDelegate` counterpart methods, namely:
	- `-sourceList:toolTipForCell:rect:item:mouseLocation:`
	- `-sourceList:typeSelectStringForItem:`
	- `-sourceList:nextTypeSelectMatchFromItem:toItem:forString:`
	- `-sourceList:shouldTypeSelectForEvent:withCurrentSearchString:`
- Moved the Source List delegate notification methods that were previously part of an `NSObject` category into `PXSourceListDelegate`. The methods affected are:
	- `-sourceListSelectionIsChanging:`
	- `-sourceListSelectionDidChange:`
	- `-sourceListItemWillExpand:`
	- `-sourceListItemDidExpand:`
	- `-sourceListItemWillCollapse:`
	- `-sourceListItemDidCollapse:`
	- `-sourceListDeleteKeyPressedOnRows:`

### Bugfixes

- Fixed a *huge* bug where several delegate methods which weren't being called in version 0.x and 1.x of PXSourceList, by removing explicit implementations of `NSOutlineViewDelegate` methods in `PXSourceList` which are now forwarded using a shiny new proxy-based implementation. The stub method implementations removed from `PXSourceList` are:
	- `-outlineView:numberOfChildrenOfItem:`
	- `-outlineView:child:ofItem:`
	- `-outlineView:isItemExpandable:`
	- `-outlineView:objectValueForTableColumn:byItem:`
	- `-outlineView:setObjectValue:forTableColumn:byItem:`
	- `-outlineView:itemForPersistentObject:`
	- `-outlineView:persistentObjectForItem:`
	- `-outlineView:writeItems:toPasteboard:`
	- `-outlineView:writeItems:toPasteboard:`
	- `-outlineView:validateDrop:proposedItem:proposedChildIndex:`
	- `-outlineView:acceptDrop:item:childIndex:`
	- `-outlineView:namesOfPromisedFilesDroppedAtDestination:forDraggedItems:`
	- `-outlineView:pasteboardWriterForItem:`
	- `-outlineView:draggingSession:willBeginAtPoint:forItems:`
	- `-outlineView:draggingSession:endedAtPoint:operation:`
	- `-outlineView:updateDraggingItemsForDrag:`
	- `-outlineView:shouldExpandItem:`
	- `-outlineView:shouldTrackCell:forTableColumn:item:`
	- `-outlineView:heightOfRowByItem:`
	- `-outlineView:selectionIndexesForProposedSelection:`
	- `-outlineView:dataCellForTableColumn:item:`
	- `-outlineView:willDisplayCell:forTableColumn:item:`
- Fixed the PXSourceList framework's `CFBundleIdentifier`. It should have been `com.alexrozanski.PXSourceList`.

### Documentation, Documentation, Documentation
- Updated documentation for all public members of `PXSourceList` and its related classes and protocols.
- Added documentation for new classes and `PXSourceListDelegate` methods.
- Added documentation for `PXSourceList` delegate notifications.
- Added a Documentation target to the Xcode project, which can be used to build documentation from source using [appledoc](http://gentlebytes.com/appledoc/).

### Other Changes
- Removed `SourceListItem` from the old example project as it has been superseded by `PXSourceListItem`.
- Removed the TODO.rtf file from the project as all issues are now being tracked through GitHub.
- Upgraded the Xcode project to the Xcode 5 project format. `LastUpgradeCheck` was updated from `0450` to`0500`.
- Added a Release Notes file ;)
