//
//  AppDelegate.h
//  PXSourceList
//
//  Created by Alex Rozanski on 08/01/2010.
//  Copyright 2010 Alex Rozanski http://perspx.com
//

#import <Cocoa/Cocoa.h>

#import "PXSourceList.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, PXSourceListDataSource, PXSourceListDelegate> {
	IBOutlet PXSourceList *sourceList;
	IBOutlet NSTextField *selectedItemLabel;
	
	NSMutableArray *sourceListItems;
}

@end
