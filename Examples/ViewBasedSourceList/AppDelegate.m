//
//  AppDelegate.m
//  ViewBasedSourceList
//
//  Created by Alex Rozanski on 28/12/2013.
//  Copyright 2009-14 Alex Rozanski http://alexrozanski.com and other contributors.
//  This software is licensed under the New BSD License. Full details can be found in the README.
//

#import "AppDelegate.h"
#import "Photo.h"
#import "PhotoCollection.h"

@interface AppDelegate ()
@property (strong, nonatomic) NSMutableArray *modelObjects;
@property (strong, nonatomic) NSMutableArray *sourceListItems;
@end

static NSString * const draggingType = @"SourceListExampleDraggingType";

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Used to support drag and drop in the source list.
    [self.sourceList registerForDraggedTypes:@[draggingType]];

    self.sourceListItems = [[NSMutableArray alloc] init];
    [self setUpDataModel];

    [self.sourceList reloadData];
}

#pragma mark - Data Model

/* We could set an identifier on the PXSourceListItem instances, but it makes more sense to put our
   identifying information on the underlying model object in this case.

   We also add some dummy Photo objects to each collection to emulate how a real model class would work.
 */
- (void)setUpDataModel
{
    PhotoCollection *photosCollection = [PhotoCollection collectionWithTitle:@"Photos" identifier:@"photos" type:PhotoCollectionTypeLibrary];
    [self addNumberOfPhotoObjects:264 toCollection:photosCollection];

    PhotoCollection *eventsCollection = [PhotoCollection collectionWithTitle:@"Events" identifier:@"events" type:PhotoCollectionTypeLibrary];
    [self addNumberOfPhotoObjects:689 toCollection:eventsCollection];

    PhotoCollection *peopleCollection = [PhotoCollection collectionWithTitle:@"People" identifier:@"people" type:PhotoCollectionTypeLibrary];
    [self addNumberOfPhotoObjects:135 toCollection:peopleCollection];

    PhotoCollection *placesCollection = [PhotoCollection collectionWithTitle:@"Places" identifier:@"places" type:PhotoCollectionTypeLibrary];
    [self addNumberOfPhotoObjects:28 toCollection:placesCollection];

    PhotoCollection *snapsCollection = [PhotoCollection collectionWithTitle:@"Holiday Snaps" identifier:nil type:PhotoCollectionTypeUserCreated];
    [self addNumberOfPhotoObjects:40 toCollection:snapsCollection];

    PhotoCollection *graduationCollection = [PhotoCollection collectionWithTitle:@"Graduation" identifier: nil type:PhotoCollectionTypeUserCreated];
    [self addNumberOfPhotoObjects:1050 toCollection:graduationCollection];

    // Store all of the model objects in an array because each source list item only holds a weak reference to them.
    self.modelObjects = [@[photosCollection, eventsCollection, peopleCollection, placesCollection, snapsCollection, graduationCollection] mutableCopy];

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
    PXSourceListItem *libraryItem = [PXSourceListItem itemWithTitle:@"LIBRARY" identifier:nil];
    libraryItem.children = @[[PXSourceListItem itemWithRepresentedObject:photosCollection icon:photosImage],
                             [PXSourceListItem itemWithRepresentedObject:eventsCollection icon:eventsImage],
                             [PXSourceListItem itemWithRepresentedObject:peopleCollection icon:peopleImage],
                             [PXSourceListItem itemWithRepresentedObject:placesCollection icon:placesImage]];

    PXSourceListItem *albumsItem = [PXSourceListItem itemWithTitle:@"ALBUMS" identifier:nil];
    for (PhotoCollection *collection in @[snapsCollection, graduationCollection]) {
        [albumsItem addChildItem:[PXSourceListItem itemWithRepresentedObject:collection icon:albumImage]];
    }

    [self.sourceListItems addObject:libraryItem];
    [self.sourceListItems addObject:albumsItem];
}

/* Convenience method for adding dummy Photo objects to a PhotoCollection instance. */
- (void)addNumberOfPhotoObjects:(NSUInteger)numberOfObjects toCollection:(PhotoCollection *)collection
{
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < numberOfObjects; ++i)
        [photos addObject:[[Photo alloc] init]];
    collection.photos = photos;
}

// Methods to avoid hardcoding subscripts into multiple places in the code.
- (PXSourceListItem *)libraryItem
{
    return self.sourceListItems[0];
}

- (PXSourceListItem *)albumsItem
{
    return self.sourceListItems[1];
}

#pragma mark - Actions

- (IBAction)addButtonAction:(id)sender
{
    NSImage *albumImage = [NSImage imageNamed:@"album"];
    [albumImage setTemplate:YES];

    PhotoCollection *collection = [PhotoCollection collectionWithTitle:@"New Album" identifier:nil type:PhotoCollectionTypeUserCreated];
    [self.modelObjects addObject:collection];

    PXSourceListItem *newItem = [PXSourceListItem itemWithRepresentedObject:collection icon:albumImage];
    [self.albumsItem addChildItem:newItem];

    NSUInteger childIndex = [[self.albumsItem children] indexOfObject:newItem];
    [self.sourceList insertItemsAtIndexes:[NSIndexSet indexSetWithIndex:childIndex]
                                 inParent:self.albumsItem
                            withAnimation:NSTableViewAnimationEffectNone];

    [self.sourceList editColumn:0 row:[self.sourceList rowForItem:newItem] withEvent:nil select:YES];
}

- (IBAction)removeButtonAction:(id)sender
{
    PXSourceListItem *selectedItem = [self.sourceList itemAtRow:self.sourceList.selectedRow];
    PXSourceListItem *parentItem = self.albumsItem;

    [self.sourceList removeItemsAtIndexes:[NSIndexSet indexSetWithIndex:[parentItem.children indexOfObject:selectedItem]]
                                 inParent:parentItem
                            withAnimation:NSTableViewAnimationSlideUp];

    [self.modelObjects removeObject:selectedItem.representedObject];

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

    PXSourceListItem *sourceListItem = item;
    PhotoCollection *collection = sourceListItem.representedObject;

    // Only allow us to edit the user created photo collection titles.
    BOOL isTitleEditable = [collection isKindOfClass:[PhotoCollection class]] && collection.type == PhotoCollectionTypeUserCreated;
    cellView.textField.editable = isTitleEditable;
    cellView.textField.selectable = isTitleEditable;

    cellView.textField.stringValue = sourceListItem.title ? sourceListItem.title : [sourceListItem.representedObject title];
    cellView.imageView.image = [item icon];
    cellView.badgeView.hidden = collection.photos.count == 0;
    cellView.badgeView.badgeValue = collection.photos.count;

    return cellView;
}

- (void)sourceListSelectionDidChange:(NSNotification *)notification
{
    PXSourceListItem *selectedItem = [self.sourceList itemAtRow:self.sourceList.selectedRow];
    BOOL removeButtonEnabled = NO;
    NSString *newLabel = @"";
    if (selectedItem) {
        // Only allow us to remove items in the 'albums' group.
        removeButtonEnabled = [[self.albumsItem children] containsObject:selectedItem];

        // We can use the underlying model object to do something based on the selection.
        PhotoCollection *collection = selectedItem.representedObject;

        if (collection.identifier)
            newLabel = [NSString stringWithFormat:@"'%@' collection selected.", collection.identifier];
        else
            newLabel = @"User-created collection selected.";
    }

    self.selectedItemLabel.stringValue = newLabel;
    self.removeButton.enabled = removeButtonEnabled;
}

#pragma mark - Drag and Drop

- (BOOL)sourceList:(PXSourceList*)aSourceList writeItems:(NSArray *)items toPasteboard:(NSPasteboard *)pboard
{
    // Only allow user-created items (not those in "Library" to be moved around).
    for (PXSourceListItem *item in items) {
        PhotoCollection *collection = item.representedObject;
        if (![collection isKindOfClass:[PhotoCollection class]] || collection.type != PhotoCollectionTypeUserCreated)
            return NO;
    }

    // We're dragging from and to the 'Albums' group.
    PXSourceListItem *parentItem = self.albumsItem;

    // For simplicity in this example, put the dragged indexes on the pasteboard. Since we use the representedObject
    // on SourceListItem, we cannot reliably archive it directly.
    NSMutableIndexSet *draggedChildIndexes = [NSMutableIndexSet indexSet];
    for (PXSourceListItem *item in items)
        [draggedChildIndexes addIndex:[[parentItem children] indexOfObject:item]];

    [pboard declareTypes:@[draggingType] owner:self];
    [pboard setData:[NSKeyedArchiver archivedDataWithRootObject:draggedChildIndexes] forType:draggingType];

    return YES;
}

- (NSDragOperation)sourceList:(PXSourceList*)sourceList validateDrop:(id < NSDraggingInfo >)info proposedItem:(id)item proposedChildIndex:(NSInteger)index
{
    PXSourceListItem *albumsItem = self.albumsItem;

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

    PXSourceListItem *parentItem = self.albumsItem;
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
