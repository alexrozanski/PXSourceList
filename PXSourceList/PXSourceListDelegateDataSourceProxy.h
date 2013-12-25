//
//  PXSourceListDelegateDataSourceProxy.h
//  PXSourceList
//
//  Created by Alex Rozanski on 25/12/2013.
//
//

#import <Foundation/Foundation.h>

@class PXSourceList;
@protocol PXSourceListDelegate;
@protocol PXSourceListDataSource;

@interface PXSourceListDelegateDataSourceProxy : NSObject <NSOutlineViewDelegate, NSOutlineViewDataSource>

@property (weak, nonatomic) PXSourceList *sourceList;
@property (weak, nonatomic) id <PXSourceListDelegate> delegate;
@property (weak, nonatomic) id <PXSourceListDataSource> dataSource;

- (id)initWithSourceList:(PXSourceList *)sourceList;

@end
