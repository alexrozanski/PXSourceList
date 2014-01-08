//
//  AppDelegate.m
//  PXSourceList
//
//  Created by Alex Rozanski on 08/01/2010.
//  Copyright 2009-14 Alex Rozanski http://alexrozanski.com and other contributors.
//  This software is licensed under the New BSD License. Full details can be found in the README.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak, nonatomic) IBOutlet PXSourceList *sourceList;
@property (weak, nonatomic) IBOutlet NSTextField *selectedItemLabel;

@property (strong, nonatomic) NSMutableArray *sourceListItems;

@end

@implementation AppDelegate

#pragma mark -
#pragma mark Init/Dealloc

- (void)awakeFromNib
{
	[self.selectedItemLabel setStringValue:@"(none)"];
	
	self.sourceListItems = [[NSMutableArray alloc] init];
	
	//Set up the "Library" parent item and children
	PXSourceListItem *libraryItem = [PXSourceListItem itemWithTitle:@"LIBRARY" identifier:@"library"];
	PXSourceListItem *musicItem = [PXSourceListItem itemWithTitle:@"Music" identifier:@"music"];
	[musicItem setIcon:[NSImage imageNamed:@"music.png"]];
	PXSourceListItem *moviesItem = [PXSourceListItem itemWithTitle:@"Movies" identifier:@"movies"];
	[moviesItem setIcon:[NSImage imageNamed:@"movies.png"]];
	PXSourceListItem *podcastsItem = [PXSourceListItem itemWithTitle:@"Podcasts" identifier:@"podcasts"];
	[podcastsItem setIcon:[NSImage imageNamed:@"podcasts.png"]];
	[podcastsItem setBadgeValue:@10];
	PXSourceListItem *audiobooksItem = [PXSourceListItem itemWithTitle:@"Audiobooks" identifier:@"audiobooks"];
	[audiobooksItem setIcon:[NSImage imageNamed:@"audiobooks.png"]];
	[libraryItem setChildren:[NSArray arrayWithObjects:musicItem, moviesItem, podcastsItem,
							  audiobooksItem, nil]];
	
	//Set up the "Playlists" parent item and children
	PXSourceListItem *playlistsItem = [PXSourceListItem itemWithTitle:@"PLAYLISTS" identifier:@"playlists"];
	PXSourceListItem *playlist1Item = [PXSourceListItem itemWithTitle:@"Playlist1" identifier:@"playlist1"];
	
	//Create a second-level group to demonstrate
	PXSourceListItem *playlist2Item = [PXSourceListItem itemWithTitle:@"Playlist2" identifier:@"playlist2"];
	PXSourceListItem *playlist3Item = [PXSourceListItem itemWithTitle:@"Playlist3" identifier:@"playlist3"];
	[playlist1Item setIcon:[NSImage imageNamed:@"playlist.png"]];
	[playlist2Item setIcon:[NSImage imageNamed:@"playlist.png"]];
	[playlist3Item setIcon:[NSImage imageNamed:@"playlist.png"]];
	
	PXSourceListItem *playlistGroup = [PXSourceListItem itemWithTitle:@"Playlist Group" identifier:@"playlistgroup"];
	PXSourceListItem *playlistGroupItem = [PXSourceListItem itemWithTitle:@"Child Playlist" identifier:@"childplaylist"];
	[playlistGroup setIcon:[NSImage imageNamed:@"playlistFolder.png"]];
	[playlistGroupItem setIcon:[NSImage imageNamed:@"playlist.png"]];
	[playlistGroup setChildren:[NSArray arrayWithObject:playlistGroupItem]];
	
	[playlistsItem setChildren:[NSArray arrayWithObjects:playlist1Item, playlistGroup,playlist2Item,
								playlist3Item, nil]];
	
	[self.sourceListItems addObject:libraryItem];
	[self.sourceListItems addObject:playlistsItem];
	
	[self.sourceList reloadData];
}


#pragma mark -
#pragma mark Source List Data Source Methods

- (NSUInteger)sourceList:(PXSourceList*)sourceList numberOfChildrenOfItem:(id)item
{
	//Works the same way as the NSOutlineView data source: `nil` means a parent item
	if(item==nil) {
		return [self.sourceListItems count];
	}
	else {
		return [[item children] count];
	}
}


- (id)sourceList:(PXSourceList*)aSourceList child:(NSUInteger)index ofItem:(id)item
{
	//Works the same way as the NSOutlineView data source: `nil` means a parent item
	if(item==nil) {
		return [self.sourceListItems objectAtIndex:index];
	}
	else {
		return [[item children] objectAtIndex:index];
	}
}


- (id)sourceList:(PXSourceList*)aSourceList objectValueForItem:(id)item
{
	return [item title];
}


- (void)sourceList:(PXSourceList*)aSourceList setObjectValue:(id)object forItem:(id)item
{
	[item setTitle:object];
}


- (BOOL)sourceList:(PXSourceList*)aSourceList isItemExpandable:(id)item
{
	return [item hasChildren];
}


- (BOOL)sourceList:(PXSourceList*)aSourceList itemHasBadge:(id)item
{
	return !![(PXSourceListItem *)item badgeValue];
}


- (NSInteger)sourceList:(PXSourceList*)aSourceList badgeValueForItem:(id)item
{
	return [(PXSourceListItem *)item badgeValue].integerValue;
}


- (BOOL)sourceList:(PXSourceList*)aSourceList itemHasIcon:(id)item
{
	return !![item icon];
}


- (NSImage*)sourceList:(PXSourceList*)aSourceList iconForItem:(id)item
{
	return [item icon];
}

- (NSMenu*)sourceList:(PXSourceList*)aSourceList menuForEvent:(NSEvent*)theEvent item:(id)item
{
	if ([theEvent type] == NSRightMouseDown || ([theEvent type] == NSLeftMouseDown && ([theEvent modifierFlags] & NSControlKeyMask) == NSControlKeyMask)) {
		NSMenu * m = [[NSMenu alloc] init];
		if (item != nil) {
			[m addItemWithTitle:[item title] action:nil keyEquivalent:@""];
		} else {
			[m addItemWithTitle:@"clicked outside" action:nil keyEquivalent:@""];
		}
		return m;
	}
	return nil;
}

#pragma mark -
#pragma mark Source List Delegate Methods

- (BOOL)sourceList:(PXSourceList*)aSourceList isGroupAlwaysExpanded:(id)group
{
	if([[group identifier] isEqualToString:@"library"])
		return YES;
	
	return NO;
}


- (void)sourceListSelectionDidChange:(NSNotification *)notification
{
	NSIndexSet *selectedIndexes = [self.sourceList selectedRowIndexes];
	
	//Set the label text to represent the new selection
	if([selectedIndexes count]>1)
		[self.selectedItemLabel setStringValue:@"(multiple)"];
	else if([selectedIndexes count]==1) {
		NSString *identifier = [[self.sourceList itemAtRow:[selectedIndexes firstIndex]] identifier];
		
		[self.selectedItemLabel setStringValue:identifier];
	}
	else {
		[self.selectedItemLabel setStringValue:@"(none)"];
	}
}


- (void)sourceListDeleteKeyPressedOnRows:(NSNotification *)notification
{
	NSIndexSet *rows = [[notification userInfo] objectForKey:@"rows"];
	
	NSLog(@"Delete key pressed on rows %@", rows);
	
	//Do something here
}

@end
