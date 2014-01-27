//
//  PhotoCollection.m
//  PXSourceList
//
//  Created by Alex Rozanski on 06/01/2014.
//  Copyright 2009-14 Alex Rozanski http://alexrozanski.com and other contributors.
//  This software is licensed under the New BSD License. Full details can be found in the README.
//

#import "PhotoCollection.h"

@implementation PhotoCollection

+ (id)collectionWithTitle:(NSString *)title identifier:(NSString *)identifier type:(PhotoCollectionType)type
{
    PhotoCollection *collection = [[PhotoCollection alloc] init];

    collection.title = title;
    collection.identifier = identifier;
    collection.type = type;

    return collection;
}

@end
