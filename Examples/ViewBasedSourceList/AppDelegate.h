//
//  AppDelegate.h
//  ViewBasedSourceList
//
//  Created by Alex Rozanski on 28/12/2013.
//
//

#import <Cocoa/Cocoa.h>
#import "PXSourceList.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, PXSourceListDataSource, PXSourceListDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet PXSourceList *sourceList;
@property (assign) IBOutlet NSButton *removeButton;

- (IBAction)addButtonAction:(id)sender;
- (IBAction)removeButtonAction:(id)sender;

@end
