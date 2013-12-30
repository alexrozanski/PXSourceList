//
//  PXSourceListRuntimeAdditions.m
//  PXSourceList
//
//  Created by Alex Rozanski on 25/12/2013.
//
//

#import "PXSourceListRuntimeAdditions.h"

NSString * const px_protocolMethodNameKey = @"methodName";
NSString * const px_protocolMethodArgumentTypesKey = @"types";
NSString * const px_protocolIsRequiredMethodKey = @"isRequired";

NSArray *px_allProtocolMethods(Protocol *protocol)
{
    NSMutableArray *methodList = [[NSMutableArray alloc] init];

    // We have 4 permutations as protocol_copyMethodDescriptionList() takes two BOOL arguments for the types of methods to return.
    for (NSUInteger i = 0; i < 4; ++i) {
        BOOL isRequiredMethod = (i / 2) % 2;

        unsigned int numberOfMethodDescriptions = 0;
        struct objc_method_description *methodDescriptions = protocol_copyMethodDescriptionList(protocol, isRequiredMethod, i % 2, &numberOfMethodDescriptions);

        for (unsigned int j = 0; j < numberOfMethodDescriptions; ++j) {
            struct objc_method_description methodDescription = methodDescriptions[j];
            [methodList addObject:@{px_protocolMethodNameKey: NSStringFromSelector(methodDescription.name),
                                    px_protocolMethodArgumentTypesKey: [NSString stringWithUTF8String:methodDescription.types],
                                    px_protocolIsRequiredMethodKey: @(isRequiredMethod)}];
        }

        free(methodDescriptions);
    }

    return methodList;
}
