//
//  PXSourceListDelegateDataSourceProxy.h
//  PXSourceList
//
//  Created by Alex Rozanski on 25/12/2013.
//
//

#import <Foundation/Foundation.h>
#import "PXSourceList.h"

@interface PXSourceListDelegateDataSourceProxy : NSObject <NSOutlineViewDelegate, NSOutlineViewDataSource, PXSourceListDelegate, PXSourceListDataSource>

@property (weak, nonatomic) PXSourceList *sourceList;
@property (weak, nonatomic) id <PXSourceListDelegate> delegate;
@property (weak, nonatomic) id <PXSourceListDataSource> dataSource;

- (id)initWithSourceList:(PXSourceList *)sourceList;

@end
