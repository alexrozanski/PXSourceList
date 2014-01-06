//
//  PhotoCollection.h
//  PXSourceList
//
//  Created by Alex Rozanski on 06/01/2014.
//
//

#import <Foundation/Foundation.h>

/* A simple example of a model class which is used by this project for storing information
   about a particular collection of objects in our sample library scenario. These objects
   are used by the SourceListItems to populate the Source List's content without having to
   synchronise the data (e.g. title) with each SourceListItem.
 */
@interface PhotoCollection : NSObject

@property (strong, nonatomic) NSString *title;
@property (assign, nonatomic) NSUInteger numberOfItems;

+ (id)collectionWithTitle:(NSString *)title numberOfItems:(NSUInteger)numberOfItems;

@end
