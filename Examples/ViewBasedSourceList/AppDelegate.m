//
//  AppDelegate.m
//  ViewBasedSourceList
//
//  Created by Alex Rozanski on 28/12/2013.
//  Copyright 2009-14 Alex Rozanski http://alexrozanski.com and other contributors.
//  This software is licensed under the New BSD License. Full details can be found in the README.
//

#import "AppDelegate.h"
#import "SourceListItem.h"
#import "PhotoCollection.h"

@interface AppDelegate ()
@property (strong, nonatomic) NSMutableArray *libraryCollections;
@property (strong, nonatomic) NSMutableArray *albums;
@property (strong, nonatomic) NSMutableArray *sourceListItems;
@end

static NSString * const draggingType = @"SourceListExampleDraggingType";

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Used to support drag and drop in the source list.
    [self.sourceList registerForDraggedTypes:@[draggingType]];

    // Set up our data model.
    PhotoCollection *photosCollection = [PhotoCollection collectionWithTitle:@"Photos" numberOfItems:264];
    PhotoCollection *eventsCollection = [PhotoCollection collectionWithTitle:@"Events" numberOfItems:689];
    PhotoCollection *peopleCollection = [PhotoCollection collectionWithTitle:@"People" numberOfItems:135];
    PhotoCollection *placesCollection = [PhotoCollection collectionWithTitle:@"Places" numberOfItems:28];

    self.libraryCollections = [@[photosCollection, eventsCollection, peopleCollection, placesCollection] mutableCopy];
    self.albums = [@[[PhotoCollection collectionWithTitle:@"Holiday Snaps" numberOfItems:200],
                     [PhotoCollection collectionWithTitle:@"Graduation" numberOfItems:1050]] mutableCopy];

    self.sourceListItems = [[NSMutableArray alloc] init];

    // Icon images we're going to use in the Source List.
    NSImage *photosImage = [NSImage imageNamed:@"photos"];
    [photosImage setTemplate:YES];
    NSImage *eventsImage = [NSImage imageNamed:@"events"];
    [eventsImage setTemplate:YES];
    NSImage *peopleImage = [NSImage imageNamed:@"people"];
    [peopleImage setTemplate:YES];
    NSImage *placesImage = [NSImage imageNamed:@"places"];
    [placesImage setTemplate:YES];
    NSImage *albumImage = [NSImage imageNamed:@"album"];
    [albumImage setTemplate:YES];

    // Set up our Source List data model used in the Source List data source methods.
    SourceListItem *libraryItem = [SourceListItem itemWithTitle:@"LIBRARY" identifier:nil];
    libraryItem.children = @[[SourceListItem itemWithRepresentedObject:photosCollection icon:photosImage],
                             [SourceListItem itemWithRepresentedObject:eventsCollection icon:eventsImage],
                             [SourceListItem itemWithRepresentedObject:peopleCollection icon:peopleImage],
                             [SourceListItem itemWithRepresentedObject:placesCollection icon:placesImage]];

    SourceListItem *albumsItem = [SourceListItem itemWithTitle:@"ALBUMS" identifier:nil];
    for (PhotoCollection *collection in self.albums) {
        [albumsItem addChildItem:[SourceListItem itemWithRepresentedObject:collection icon:albumImage]];
    }

    [self.sourceListItems addObject:libraryItem];
    [self.sourceListItems addObject:albumsItem];

    [self.sourceList reloadData];
}

#pragma mark - Actions

- (IBAction)addButtonAction:(id)sender
{
    NSImage *albumImage = [NSImage imageNamed:@"album"];
    [albumImage setTemplate:YES];

    SourceListItem *newItem = [SourceListItem itemWithTitle:@"New Album" identifier:nil icon:albumImage];
    [self.sourceListItems[1] addChildItem:newItem];

    NSUInteger childIndex = [[self.sourceListItems[1] children] indexOfObject:newItem];
    [self.sourceList insertItemsAtIndexes:[NSIndexSet indexSetWithIndex:childIndex]
                                 inParent:self.sourceListItems[1]
                            withAnimation:NSTableViewAnimationEffectNone];

    [self.sourceList editColumn:0 row:[self.sourceList rowForItem:newItem] withEvent:nil select:YES];
}

- (IBAction)removeButtonAction:(id)sender
{
    SourceListItem *selectedItem = [self.sourceList itemAtRow:self.sourceList.selectedRow];
    SourceListItem *parentItem = self.sourceListItems[1];


    [self.sourceList removeItemsAtIndexes:[NSIndexSet indexSetWithIndex:[parentItem.children indexOfObject:selectedItem]]
                                 inParent:parentItem
                            withAnimation:NSTableViewAnimationSlideUp];

    // Only 'album' items can be deleted.
    [parentItem removeChildItem:selectedItem];
}

#pragma mark - PXSourceList Data Source

- (NSUInteger)sourceList:(PXSourceList*)sourceList numberOfChildrenOfItem:(id)item
{
    if (!item)
        return self.sourceListItems.count;

    return [[item children] count];
}

- (id)sourceList:(PXSourceList*)aSourceList child:(NSUInteger)index ofItem:(id)item
{
    if (!item)
        return self.sourceListItems[index];

    return [[item children] objectAtIndex:index];
}

- (BOOL)sourceList:(PXSourceList*)aSourceList isItemExpandable:(id)item
{
    return [item hasChildren];
}

#pragma mark - PXSourceList Delegate

- (BOOL)sourceList:(PXSourceList *)aSourceList isGroupAlwaysExpanded:(id)group
{
    return YES;
}

- (NSView *)sourceList:(PXSourceList *)aSourceList viewForItem:(id)item
{
    PXSourceListTableCellView *cellView = nil;
    if ([aSourceList levelForItem:item] == 0)
        cellView = [aSourceList makeViewWithIdentifier:@"HeaderCell" owner:nil];
    else
        cellView = [aSourceList makeViewWithIdentifier:@"MainCell" owner:nil];
    SourceListItem *sourceListItem = item;

    // Don't allow us to double-click to edit the title for items in the "Library" group.
    BOOL isTitleEditable = ![[self.sourceListItems[0] children] containsObject:item];
    cellView.textField.editable = isTitleEditable;
    cellView.textField.selectable = isTitleEditable;

    PhotoCollection *collection = sourceListItem.representedObject;

    cellView.textField.stringValue = sourceListItem.title ? sourceListItem.title : [sourceListItem.representedObject title];
    cellView.imageView.image = [item icon];
    cellView.badgeView.hidden = !collection;
    cellView.badgeView.badgeValue = collection.numberOfItems;

    return cellView;
}

- (void)sourceListSelectionDidChange:(NSNotification *)notification
{
    SourceListItem *selectedItem = [self.sourceList itemAtRow:self.sourceList.selectedRow];

    // Only allow us to remove items in the 'albums' group.
    self.removeButton.enabled = [[self.sourceListItems[1] children] containsObject:selectedItem];
}

#pragma mark - Drag and Drop

- (BOOL)sourceList:(PXSourceList*)aSourceList writeItems:(NSArray *)items toPasteboard:(NSPasteboard *)pboard
{
    // Only allow the items in the 'Albums' group to be moved around.
    for (SourceListItem *item in items) {
        if (![[self.sourceListItems[1] children] containsObject:item])
            return NO;
    }

    // We're dragging from and to the 'Albums' group.
    SourceListItem *parentItem = self.sourceListItems[1];

    // For simplicity in this example, put the dragged indexes on the pasteboard. Since we use the representedObject
    // on SourceListItem, we cannot reliably archive it directly.
    NSMutableIndexSet *draggedChildIndexes = [NSMutableIndexSet indexSet];
    for (SourceListItem *item in items)
        [draggedChildIndexes addIndex:[[parentItem children] indexOfObject:item]];

    [pboard declareTypes:@[draggingType] owner:self];
    [pboard setData:[NSKeyedArchiver archivedDataWithRootObject:draggedChildIndexes] forType:draggingType];

    return YES;
}

- (NSDragOperation)sourceList:(PXSourceList*)sourceList validateDrop:(id < NSDraggingInfo >)info proposedItem:(id)item proposedChildIndex:(NSInteger)index
{
    SourceListItem *albumsItem = self.sourceListItems[1];

    // Only allow the items in the 'albums' group to be moved around. It can either be dropped on the group header, or inserted between other child items.
    // It can't be made the child of another item in this group, so the only valid case is when the proposedItem is the 'Albums' group item.
    if (![item isEqual:albumsItem])
        return NSDragOperationNone;

    return NSDragOperationMove;
}

- (BOOL)sourceList:(PXSourceList*)aSourceList acceptDrop:(id < NSDraggingInfo >)info item:(id)item childIndex:(NSInteger)index
{
    NSPasteboard *draggingPasteboard = info.draggingPasteboard;
    NSMutableIndexSet *draggedChildIndexes = [NSKeyedUnarchiver unarchiveObjectWithData:[draggingPasteboard dataForType:draggingType]];

    SourceListItem *parentItem = self.sourceListItems[1];
    NSMutableArray *draggedItems = [NSMutableArray array];
    [draggedChildIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [draggedItems addObject:[[parentItem children] objectAtIndex:idx]];
    }];

    // An index of -1 means it's been dropped on the group header itself, so insert at the end of the group.
    if (index == -1)
        index = parentItem.children.count;

    // Perform the Source List and model updates.
    [aSourceList beginUpdates];
    [aSourceList removeItemsAtIndexes:draggedChildIndexes
                             inParent:parentItem
                        withAnimation:NSTableViewAnimationEffectNone];
    [parentItem removeChildItems:draggedItems];

    // We have to calculate the new child index which we have to perform the drop at, since we've just removed items from the parent item which
    // may have come before the drop index.
    NSUInteger adjustedDropIndex = index - [draggedChildIndexes countOfIndexesInRange:NSMakeRange(0, index)];

    // The insertion indexes are now simply from the adjusted drop index.
    NSIndexSet *insertionIndexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(adjustedDropIndex, draggedChildIndexes.count)];
    [parentItem insertChildItems:draggedItems atIndexes:insertionIndexes];

    [aSourceList insertItemsAtIndexes:insertionIndexes
                             inParent:parentItem
                        withAnimation:NSTableViewAnimationEffectNone];
    [aSourceList endUpdates];

    return YES;
}

@end
