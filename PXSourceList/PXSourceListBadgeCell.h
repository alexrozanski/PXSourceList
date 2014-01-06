//
//  PXSourceListBadgeCell.h
//  PXSourceList
//
//  Created by Alex Rozanski on 15/11/2013.
//  Copyright 2009-14 Alex Rozanski http://alexrozanski.com and other contributors.
//  This software is licensed under the New BSD License. Full details can be found in the README.
//

#import <Cocoa/Cocoa.h>

@interface PXSourceListBadgeCell : NSCell

@property (strong, nonatomic) NSColor *badgeColor;
@property (strong, nonatomic) NSColor *textColor;
@property (assign, nonatomic) NSUInteger badgeValue;

@end
