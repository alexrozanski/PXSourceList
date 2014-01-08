//
//  PXSourceListTableCellView.h
//  PXSourceList
//
//  Created by Alex Rozanski on 31/12/2013.
//  Copyright 2009-14 Alex Rozanski http://alexrozanski.com and other contributors.
//  This software is licensed under the New BSD License. Full details can be found in the README.
//

#import <Cocoa/Cocoa.h>

@class PXSourceListBadgeView;

/**
 `PXSourceListTableCellView` is an `NSTableCellView` subclass which can be used when using `PXSourceList`
 in view-based mode.
 
 Similar to `NSTableCellView` and its `textField` and `imageView` outlets, `PXSourceListTableCellView`
 provides a `badgeView` outlet which can be hooked up to a `PXSourceListBadgeView` in Interface Builder
 and then configured in `sourceList:viewForItem:`.
 */
@interface PXSourceListTableCellView : NSTableCellView

/**
 @brief The badge view displayed by the cell.
 @discussion When a `PXSourceListTableCellView` instance is created, a `PXSourceListTableCellView` instance
 is *not* automatically created and set to this property (just like with `NSTableCellView` and its
 `textField` and `imageView` properties. This property is purely declared on this class to make creating
 table cell views for a `PXSourceList` in Interface Builder easier without having to declare your own
 `NSTableCellView` subclass.
 
 This property is typically configured in the `PXSourceListDataSource` method `sourceList:viewForItem:`.
 */
@property (weak, nonatomic) IBOutlet PXSourceListBadgeView *badgeView;

@end
