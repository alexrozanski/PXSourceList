//
//  AppDelegate.m
//  ViewBasedSourceList
//
//  Created by Alex Rozanski on 28/12/2013.
//
//

#import "AppDelegate.h"
#import "SourceListItem.h"
#import "PhotoCollection.h"

@interface AppDelegate ()
@property (strong, nonatomic) NSMutableArray *libraryCollections;
@property (strong, nonatomic) NSMutableArray *albums;
@property (strong, nonatomic) NSMutableArray *sourceListItems;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    PhotoCollection *photosCollection = [PhotoCollection collectionWithTitle:@"Photos" numberOfItems:264];
    PhotoCollection *eventsCollection = [PhotoCollection collectionWithTitle:@"Events" numberOfItems:689];
    PhotoCollection *peopleCollection = [PhotoCollection collectionWithTitle:@"People" numberOfItems:135];
    PhotoCollection *placesCollection = [PhotoCollection collectionWithTitle:@"Places" numberOfItems:28];

    self.libraryCollections = [@[photosCollection, eventsCollection, peopleCollection, placesCollection] mutableCopy];
    self.albums = [@[[PhotoCollection collectionWithTitle:@"Holiday Snaps" numberOfItems:200],
                     [PhotoCollection collectionWithTitle:@"Graduation" numberOfItems:1050]] mutableCopy];

    self.sourceListItems = [[NSMutableArray alloc] init];

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

@end
