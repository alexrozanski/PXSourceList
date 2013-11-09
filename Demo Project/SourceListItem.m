//
//  SourceListItem.m
//  PXSourceList
//
//  Created by Alex Rozanski on 08/01/2010.
//  Copyright 2010 Alex Rozanski http://perspx.com
//

#import "SourceListItem.h"


@implementation SourceListItem

#pragma mark -
#pragma mark Init/Dealloc

- (id)init
{
	if(self=[super init])
	{
		_badgeValue = -1;	//We don't want a badge value by default
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



#pragma mark -
#pragma mark Custom Accessors

- (BOOL)hasBadge
{
	return self.badgeValue!=-1;
}

- (BOOL)hasChildren
{
	return [self.children count]>0;
}

- (BOOL)hasIcon
{
	return self.icon!=nil;
}

#pragma mark -
#pragma mark Custom Accessors

- (NSString *)description
{
	return [NSString stringWithFormat:@"<%@: %p | identifier = %@ | title = %@ >", [self class], self, self.identifier, self.title];
}
@end
