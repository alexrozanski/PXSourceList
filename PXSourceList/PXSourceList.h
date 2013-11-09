//
//  PXSourceList.h
//  PXSourceList
//
//  Created by Alex Rozanski on 05/09/2009.
//  Copyright 2009-10 Alex Rozanski http://perspx.com
//

#import <Cocoa/Cocoa.h>

#import "PXSourceListDelegate.h"
#import "PXSourceListDataSource.h"

@interface PXSourceList: NSOutlineView <NSOutlineViewDelegate, NSOutlineViewDataSource>
	
@property (nonatomic, assign) NSSize iconSize;
	
@property (weak) id<PXSourceListDataSource> dataSource;
@property (weak) id<PXSourceListDelegate> delegate;

@property (readonly) NSUInteger numberOfGroups;

- (BOOL)isGroupItem:(id)item;							//Returns whether `item` is a group
- (BOOL)isGroupAlwaysExpanded:(id)group;				//Returns whether `group` is displayed as always expanded

- (BOOL)itemHasBadge:(id)item;							//Returns whether `item` has a badge
- (NSInteger)badgeValueForItem:(id)item;				//Returns the badge value for `item`

@end

