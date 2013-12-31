//
//  PXSourceListRuntimeAdditions.h
//  PXSourceList
//
//  Created by Alex Rozanski on 25/12/2013.
//
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

extern NSString * const px_protocolMethodNameKey;
extern NSString * const px_protocolMethodArgumentTypesKey;
extern NSString * const px_protocolIsRequiredMethodKey;

NSArray *px_allProtocolMethods(Protocol *protocol);
NSArray *px_methodNamesForProtocol(Protocol *protocol);