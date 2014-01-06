//
//  SourceListItem.m
//  PXSourceList
//
//  Created by Alex Rozanski on 08/01/2010.
//  Copyright 2010 Alex Rozanski http://perspx.com
//

#import "SourceListItem.h"

@interface SourceListItem () {
    NSMutableArray *_children;
}
@end

@implementation SourceListItem

@synthesize children = _children;

#pragma mark -
#pragma mark Init/Dealloc

- (id)init
{
	if(self=[super init])
	{
		_badgeValue = -1;	//We don't want a badge value by default
        _children = [[NSMutableArray alloc] init];
	}
	
	return self;
}


+ (id)itemWithTitle:(NSString*)aTitle identifier:(NSString*)anIdentifier
{	
	SourceListItem *item = [SourceListItem itemWithTitle:aTitle identifier:anIdentifier icon:nil];
	
	return item;
}


+ (id)itemWithTitle:(NSString*)aTitle identifier:(NSString*)anIdentifier icon:(NSImage*)anIcon
{
	SourceListItem *item = [[SourceListItem alloc] init];
	
	[item setTitle:aTitle];
	[item setIdentifier:anIdentifier];
	[item setIcon:anIcon];
	
	return item;
}

/* Associates an arbitrary object with the Source List item. This is useful for cases where we don't 
   want to have to synchronise changes in our model object (such as the name) with the Source List item
   and can instead read from them in the Source List data source methods directly. */
+ (id)itemWithRepresentedObject:(id)representedObject icon:(NSImage *)anIcon
{
    SourceListItem *item = [[SourceListItem alloc] init];

    item.representedObject = representedObject;
    item.icon = anIcon;

    return item;
}

#pragma mark -
#pragma mark Custom Accessors

- (BOOL)hasBadge
{
	return self.badgeValue!=-1;
}

- (BOOL)hasChildren
{
	return _children.count > 0;
}

- (BOOL)hasIcon
{
	return self.icon!=nil;
}

- (NSArray *)children
{
    return [_children copy];
}

- (void)setChildren:(NSArray *)children
{
    _children = [children mutableCopy];
}

#pragma mark -
#pragma mark Custom Accessors

- (NSString *)description
{
	return [NSString stringWithFormat:@"<%@: %p | identifier = %@ | title = %@ >", [self class], self, self.identifier, self.title];
}

- (void)addChildItem:(SourceListItem *)childItem
{
    [_children addObject:childItem];
}

- (void)removeChildItem:(SourceListItem *)childItem
{
    [_children removeObject:childItem];
}
@end
