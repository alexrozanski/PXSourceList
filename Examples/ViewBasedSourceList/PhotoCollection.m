//
//  PhotoCollection.m
//  PXSourceList
//
//  Created by Alex Rozanski on 06/01/2014.
//
//

#import "PhotoCollection.h"

@implementation PhotoCollection

+ (id)collectionWithTitle:(NSString *)title numberOfItems:(NSUInteger)numberOfItems
{
    PhotoCollection *collection = [[PhotoCollection alloc] init];

    collection.title = title;
    collection.numberOfItems = numberOfItems;

    return collection;
}

@end
