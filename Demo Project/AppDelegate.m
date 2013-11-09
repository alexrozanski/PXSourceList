//
//  AppDelegate.m
//  PXSourceList
//
//  Created by Alex Rozanski on 08/01/2010.
//  Copyright 2010 Alex Rozanski http://perspx.com
//

#import "AppDelegate.h"
#import "SourceListItem.h"

@implementation AppDelegate

#pragma mark -
#pragma mark Init/Dealloc

- (void)awakeFromNib
{
	[selectedItemLabel setStringValue:@"(none)"];
	
	sourceListItems = [[NSMutableArray alloc] init];
	
	//Set up the "Library" parent item and children
	SourceListItem *libraryItem = [SourceListItem itemWithTitle:@"LIBRARY" identifier:@"library"];
	SourceListItem *musicItem = [SourceListItem itemWithTitle:@"Music" identifier:@"music"];
	[musicItem setIcon:[NSImage imageNamed:@"music.png"]];
	SourceListItem *moviesItem = [SourceListItem itemWithTitle:@"Movies" identifier:@"movies"];
	[moviesItem setIcon:[NSImage imageNamed:@"movies.png"]];
	SourceListItem *podcastsItem = [SourceListItem itemWithTitle:@"Podcasts" identifier:@"podcasts"];
	[podcastsItem setIcon:[NSImage imageNamed:@"podcasts.png"]];
	[podcastsItem setBadgeValue:10];
	SourceListItem *audiobooksItem = [SourceListItem itemWithTitle:@"Audiobooks" identifier:@"audiobooks"];
	[audiobooksItem setIcon:[NSImage imageNamed:@"audiobooks.png"]];
	[libraryItem setChildren:[NSArray arrayWithObjects:musicItem, moviesItem, podcastsItem,
							  audiobooksItem, nil]];
	
	//Set up the "Playlists" parent item and children
	SourceListItem *playlistsItem = [SourceListItem itemWithTitle:@"PLAYLISTS" identifier:@"playlists"];
	SourceListItem *playlist1Item = [SourceListItem itemWithTitle:@"Playlist1" identifier:@"playlist1"];
	
	//Create a second-level group to demonstrate
	SourceListItem *playlist2Item = [SourceListItem itemWithTitle:@"Playlist2" identifier:@"playlist2"];
	SourceListItem *playlist3Item = [SourceListItem itemWithTitle:@"Playlist3" identifier:@"playlist3"];
	[playlist1Item setIcon:[NSImage imageNamed:@"playlist.png"]];
	[playlist2Item setIcon:[NSImage imageNamed:@"playlist.png"]];
	[playlist3Item setIcon:[NSImage imageNamed:@"playlist.png"]];
	
	SourceListItem *playlistGroup = [SourceListItem itemWithTitle:@"Playlist Group" identifier:@"playlistgroup"];
	SourceListItem *playlistGroupItem = [SourceListItem itemWithTitle:@"Child Playlist" identifier:@"childplaylist"];
	[playlistGroup setIcon:[NSImage imageNamed:@"playlistFolder.png"]];
	[playlistGroupItem setIcon:[NSImage imageNamed:@"playlist.png"]];
	[playlistGroup setChildren:[NSArray arrayWithObject:playlistGroupItem]];
	
	[playlistsItem setChildren:[NSArray arrayWithObjects:playlist1Item, playlistGroup,playlist2Item,
								playlist3Item, nil]];
	
	[sourceListItems addObject:libraryItem];
	[sourceListItems addObject:playlistsItem];
	
	[sourceList reloadData];
}


#pragma mark -
#pragma mark Source List Data Source Methods

- (NSUInteger)sourceList:(PXSourceList*)sourceList numberOfChildrenOfItem:(id)item
{
	//Works the same way as the NSOutlineView data source: `nil` means a parent item
	if(item==nil) {
		return [sourceListItems count];
	}
	else {
		return [[item children] count];
	}
}


- (id)sourceList:(PXSourceList*)aSourceList child:(NSUInteger)index ofItem:(id)item
{
	//Works the same way as the NSOutlineView data source: `nil` means a parent item
	if(item==nil) {
		return [sourceListItems objectAtIndex:index];
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
	return [item hasBadge];
}


- (NSInteger)sourceList:(PXSourceList*)aSourceList badgeValueForItem:(id)item
{
	return [item badgeValue];
}


- (BOOL)sourceList:(PXSourceList*)aSourceList itemHasIcon:(id)item
{
	return [item hasIcon];
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
	NSIndexSet *selectedIndexes = [sourceList selectedRowIndexes];
	
	//Set the label text to represent the new selection
	if([selectedIndexes count]>1)
		[selectedItemLabel setStringValue:@"(multiple)"];
	else if([selectedIndexes count]==1) {
		NSString *identifier = [[sourceList itemAtRow:[selectedIndexes firstIndex]] identifier];
		
		[selectedItemLabel setStringValue:identifier];
	}
	else {
		[selectedItemLabel setStringValue:@"(none)"];
	}
}


- (void)sourceListDeleteKeyPressedOnRows:(NSNotification *)notification
{
	NSIndexSet *rows = [[notification userInfo] objectForKey:@"rows"];
	
	NSLog(@"Delete key pressed on rows %@", rows);
	
	//Do something here
}

@end
