//
//  PhotoCollection.h
//  PXSourceList
//
//  Created by Alex Rozanski on 06/01/2014.
//  Copyright 2009-14 Alex Rozanski http://alexrozanski.com and other contributors.
//  This software is licensed under the New BSD License. Full details can be found in the README.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PhotoCollectionType) {
    PhotoCollectionTypeLibrary,
    PhotoCollectionTypeUserCreated
};

/* A simple example of a model class which is used by this project for storing information
   about a particular collection of objects in our sample library scenario. These objects
   are used by the SourceListItems to populate the Source List's content without having to
   synchronise the data (e.g. title) with each SourceListItem.
 */
@interface PhotoCollection : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *identifier;
@property (copy, nonatomic) NSArray *photos;
@property (assign, nonatomic) PhotoCollectionType type;

+ (id)collectionWithTitle:(NSString *)title identifier:(NSString *)identifier type:(PhotoCollectionType)type;

@end
