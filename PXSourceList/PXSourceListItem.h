//
//  PXSourceListItem.h
//  PXSourceList
//
//  Created by Alex Rozanski on 08/01/2014.
//  Copyright 2009-14 Alex Rozanski http://alexrozanski.com and other contributors.
//  This software is licensed under the New BSD License. Full details can be found in the README.
//

#import <Foundation/Foundation.h>

/**
 
 `PXSourceListItem` is a generic `NSObject` subclass which can be used to build a hierarchical model for use by
 a `PXSourceList` data source.
 
 @warning While it is not mandatory to use `PXSourceListItem` objects in a `PXSourceList` data source, this
 class is generic enough that it should serve most use cases.
 
 @discussion # Basic properties
 
 `PXSourceListItem` has been designed to contain properties for the frequently-used information which you need
 from a Source List data source item when implementing the `PXSourceListDelegate` and `PXSourceListDataSource`
 methods, namely:
 
 * The title displayed in the Source List for the given item.
 * The icon displayed to the left of the given item in the Source List.
 * The badge value displayed to the right of the given item in the Source List.
 * Child items of the given item.
 
 The existence of these core properties mean that it is unlikely that you should have to create your own
 `PXSourceListItem` subclass.
 
 # Identifying objects
 
 `PXSourceListItem`'s API has been designed with being able to easily identify a given from any part of your
 code in mind. This is useful when you obtain an item using one of `NSOutlineView`'s methods or are given
 one as part of a PXSourceListDelegate or PXSourceListDataSource method.
 
 There are two (often distinct) methods of identifying a given object from a `PXSourceListItem`:

 * Using the `identifier` property. This is probably the easiest way of identifying items, and these identifiers
   are best defined as string constants which you can reference from multiple places in your code.
 * Using the `representedObject` property. Using `representedObject` can be useful if the underlying model
   object has identifying information about it which you can use when determining which Source List Item you're
   working with.

 */
@interface PXSourceListItem : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSImage *icon;
@property (weak, nonatomic) id representedObject;
@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSNumber *badgeValue;
@property (strong, nonatomic) NSArray *children;

///---------------------------------------------------------------------------------------
/// @name Convenience initialisers
///---------------------------------------------------------------------------------------
+ (instancetype)itemWithTitle:(NSString *)title identifier:(NSString *)identifier;
+ (instancetype)itemWithTitle:(NSString *)title identifier:(NSString *)identifier icon:(NSImage *)icon;
+ (instancetype)itemWithRepresentedObject:(id)object icon:(NSImage *)icon;

///---------------------------------------------------------------------------------------
/// @name Working with child items
///---------------------------------------------------------------------------------------
- (BOOL)hasChildren;

- (void)addChildItem:(PXSourceListItem *)childItem;
- (void)insertChildItem:(PXSourceListItem *)childItem atIndex:(NSUInteger)index;
- (void)removeChildItem:(PXSourceListItem *)childItem;
- (void)removeChildItemAtIndex:(NSUInteger)index;
- (void)removeChildItems:(NSArray *)items;
- (void)insertChildItems:(NSArray *)items atIndexes:(NSIndexSet *)indexes;

@end
