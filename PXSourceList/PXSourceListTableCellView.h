//
//  PXSourceListTableCellView.h
//  PXSourceList
//
//  Created by Alex Rozanski on 31/12/2013.
//
//

#import <Cocoa/Cocoa.h>

@class PXSourceListBadgeView;

@interface PXSourceListTableCellView : NSTableCellView

@property (weak, nonatomic) IBOutlet PXSourceListBadgeView *badgeView;

@end
