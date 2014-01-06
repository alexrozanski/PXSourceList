//
//  AppDelegate.h
//  PXSourceList
//
//  Created by Alex Rozanski on 08/01/2010.
//  Copyright 2009-14 Alex Rozanski http://alexrozanski.com and other contributors.
//  This software is licensed under the New BSD License. Full details can be found in the README.
//

#import <Cocoa/Cocoa.h>

#import "PXSourceList.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, PXSourceListDataSource, PXSourceListDelegate>

@end
