//
//  PXSourceListBadgeView.m
//  PXSourceList
//
//  Created by Alex Rozanski on 15/11/2013.
//
//

#import "PXSourceListBadgeView.h"
#import "PXSourceListBadgeCell.h"

@implementation PXSourceListBadgeView

+ (Class)cellClass
{
    return [PXSourceListBadgeCell class];
}

- (void)setBadgeValue:(NSUInteger)badgeValue
{
    [self.cell setBadgeValue:badgeValue];
}

- (NSUInteger)badgeValue
{
    return [self.cell badgeValue];
}

@end
