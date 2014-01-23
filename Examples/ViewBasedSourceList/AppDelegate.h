//
//  AppDelegate.h
//  ViewBasedSourceList
//
//  Created by Alex Rozanski on 28/12/2013.
//  Copyright 2009-14 Alex Rozanski http://alexrozanski.com and other contributors.
//  This software is licensed under the New BSD License. Full details can be found in the README.
//

#import <Cocoa/Cocoa.h>
#import "PXSourceList.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, PXSourceListDataSource, PXSourceListDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet PXSourceList *sourceList;
@property (assign) IBOutlet NSButton *removeButton;
@property (weak, nonatomic) IBOutlet NSTextField *selectedItemLabel;

- (IBAction)addButtonAction:(id)sender;
- (IBAction)removeButtonAction:(id)sender;

@end
