//
//  PXSourceListDelegateDataSourceProxy.h
//  PXSourceList
//
//  Created by Alex Rozanski on 25/12/2013.
//
//

#import <Foundation/Foundation.h>

@protocol PXSourceListDelegate;
@protocol PXSourceListDataSource;

@interface PXSourceListDelegateDataSourceProxy : NSObject

@property (weak, nonatomic) id <PXSourceListDelegate> delegate;
@property (weak, nonatomic) id <PXSourceListDataSource> dataSource;

- (id)init;

@end
