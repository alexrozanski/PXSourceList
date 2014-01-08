//
//  PXSourceListItem.h
//  PXSourceList
//
//  Created by Alex Rozanski on 08/01/2014.
//  Copyright 2009-14 Alex Rozanski http://alexrozanski.com and other contributors.
//  This software is licensed under the New BSD License. Full details can be found in the README.
//

#import <Foundation/Foundation.h>

@interface PXSourceListItem : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSImage *icon;
@property (weak, nonatomic) id representedObject;
@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSNumber *badgeValue;
@property (strong, nonatomic) NSArray *children;

+ (instancetype)itemWithTitle:(NSString *)title;
+ (instancetype)itemWithTitle:(NSString *)title icon:(NSImage *)icon;
+ (instancetype)itemWithRepresentedObject:(id)object icon:(NSImage *)icon;

- (void)addChildItem:(PXSourceListItem *)childItem;
- (void)insertChildItem:(PXSourceListItem *)childItem atIndex:(NSUInteger)index;
- (void)removeChildItem:(PXSourceListItem *)childItem;
- (void)removeChildItemAtIndex:(NSUInteger)index;
- (void)removeChildItems:(NSArray *)items;
- (void)insertChildItems:(NSArray *)items atIndexes:(NSIndexSet *)indexes;

@end
