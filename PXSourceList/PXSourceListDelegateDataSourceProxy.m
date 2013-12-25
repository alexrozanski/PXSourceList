//
//  PXSourceListDelegateDataSourceProxy.m
//  PXSourceList
//
//  Created by Alex Rozanski on 25/12/2013.
//
//

#import "PXSourceListDelegateDataSourceProxy.h"

#import <objc/runtime.h>
#import "PXSourceList.h"
#import "PXSourceListPrivateConstants.h"
#import "PXSourceListRuntimeAdditions.h"

// Internal constants.
static NSString * const forwardingMapForwardingMethodNameKey = @"methodName";
static NSString * const forwardingMapOriginatingProtocolKey = @"originatingProtocol";

@implementation PXSourceListDelegateDataSourceProxy

+ (void)initialize
{
    [self addEntriesToMethodForwardingMap:[self methodNameMappingsForProtocol:@protocol(NSOutlineViewDelegate)]];
    [self addEntriesToMethodForwardingMap:[self methodNameMappingsForProtocol:@protocol(NSOutlineViewDataSource)]];
}

- (id)initWithSourceList:(PXSourceList *)sourceList
{
    if (!(self = [super init]))
        return nil;

    _sourceList = sourceList;

    return self;
}

#pragma mark - Accessors

- (void)setDelegate:(id<PXSourceListDelegate>)delegate
{
    if (self.delegate)
        [[NSNotificationCenter defaultCenter] removeObserver:self.delegate name:nil object:self];

    _delegate = delegate;

    //Register the new delegate to receive notifications
	[self registerDelegateToReceiveNotification:PXSLSelectionIsChangingNotification
								   withSelector:@selector(sourceListSelectionIsChanging:)];
	[self registerDelegateToReceiveNotification:PXSLSelectionDidChangeNotification
								   withSelector:@selector(sourceListSelectionDidChange:)];
	[self registerDelegateToReceiveNotification:PXSLItemWillExpandNotification
								   withSelector:@selector(sourceListItemWillExpand:)];
	[self registerDelegateToReceiveNotification:PXSLItemDidExpandNotification
								   withSelector:@selector(sourceListItemDidExpand:)];
	[self registerDelegateToReceiveNotification:PXSLItemWillCollapseNotification
								   withSelector:@selector(sourceListItemWillCollapse:)];
	[self registerDelegateToReceiveNotification:PXSLItemDidCollapseNotification
								   withSelector:@selector(sourceListItemDidCollapse:)];
	[self registerDelegateToReceiveNotification:PXSLDeleteKeyPressedOnRowsNotification
								   withSelector:@selector(sourceListDeleteKeyPressedOnRows:)];
}

- (void)setDataSource:(id<PXSourceListDataSource>)dataSource
{
    _dataSource = dataSource;
}

#pragma mark - Method Forwarding

- (BOOL)respondsToSelector:(SEL)aSelector
{
    if ([self.sourceList respondsToSelector:aSelector])
        return YES;

    if(![[[self class] methodForwardingMap] objectForKey:NSStringFromSelector(aSelector)])
        return [super respondsToSelector:aSelector];

    id forwardingObject;
    SEL forwardingSelector = NULL;

    if(![self getForwardingObject:&forwardingObject andForwardingSelector:&forwardingSelector forSelector:aSelector])
        return [super respondsToSelector:aSelector];

    return [forwardingObject respondsToSelector:forwardingSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    id forwardingObject;
    SEL forwardingSelector = NULL;

    if ([self.sourceList respondsToSelector:anInvocation.selector]) {
        [anInvocation invokeWithTarget:self.sourceList];
        return;
    }

    if(![self getForwardingObject:&forwardingObject andForwardingSelector:&forwardingSelector forSelector:anInvocation.selector]) {
        [super forwardInvocation:anInvocation];
        return;
    }

    anInvocation.selector = forwardingSelector;
    [anInvocation invokeWithTarget:forwardingObject];
}

+ (NSDictionary *)methodForwardingMap
{
    static NSMutableDictionary *_methodForwardingMap = nil;
    if (!_methodForwardingMap)
        _methodForwardingMap = [[NSMutableDictionary alloc] init];

    return _methodForwardingMap;
}

+ (void)addEntriesToMethodForwardingMap:(NSDictionary *)entries
{
    NSArray *methodForwardingBlacklist = [self methodForwardingBlacklist];
    for (NSString *key in entries) {
        if (![methodForwardingBlacklist containsObject:key])
            ((NSMutableDictionary*)[self methodForwardingMap])[key] = entries[key];
    }
}

+ (NSDictionary *)methodNameMappingsForProtocol:(Protocol *)protocol
{
    NSMutableDictionary *methodNameMappings = [[NSMutableDictionary alloc] init];
    NSArray *protocolMethods = px_allProtocolMethods(protocol);
    NSString *protocolName = NSStringFromProtocol(protocol);

    for (NSDictionary *methodInfo in protocolMethods) {
        NSString *methodName = methodInfo[px_protocolMethodNameKey];
        NSString *mappedMethodName = [self mappedMethodNameForMethodName:methodName];
        if (!mappedMethodName) {
            NSLog(@"PXSourceList: couldn't map method %@ from %@", methodName, protocolName);
            continue;
        }

        [methodNameMappings setObject:@{forwardingMapForwardingMethodNameKey: mappedMethodName,
                                        forwardingMapOriginatingProtocolKey: protocolName}
                               forKey:methodName];
    }

    return methodNameMappings;
}

+ (NSString *)mappedMethodNameForMethodName:(NSString *)methodName
{
    NSString *customMappedName = [self customMethodNameMappings][methodName];
    if (customMappedName)
        return customMappedName;

    NSString *outlineViewSearchString = @"outlineView";
    NSUInteger letterVOffset = [outlineViewSearchString rangeOfString:@"V"].location;
    NSCharacterSet *uppercaseLetterCharacterSet = [NSCharacterSet uppercaseLetterCharacterSet];

    NSRange outlineViewStringRange = [methodName rangeOfString:outlineViewSearchString options:NSCaseInsensitiveSearch];

    // If for some reason we can't map the method name, try to fail gracefully.
    if (outlineViewStringRange.location == NSNotFound)
        return nil;

    BOOL isOCapitalized = [uppercaseLetterCharacterSet characterIsMember:[methodName characterAtIndex:outlineViewStringRange.location]];
    BOOL isVCapitalized = [uppercaseLetterCharacterSet characterIsMember:[methodName characterAtIndex:outlineViewStringRange.location + letterVOffset]];
    return [methodName stringByReplacingCharactersInRange:outlineViewStringRange
                                               withString:[NSString stringWithFormat:@"%@ource%@ist", isOCapitalized ? @"S" : @"s", isVCapitalized ? @"L" : @"l"]];

}

// These methods won't have mappings created for them.
+ (NSArray *)methodForwardingBlacklist
{
    return @[NSStringFromSelector(@selector(outlineView:shouldSelectTableColumn:)),
             NSStringFromSelector(@selector(outlineView:shouldReorderColumn:toColumn:)),
             NSStringFromSelector(@selector(outlineView:mouseDownInHeaderOfTableColumn:)),
             NSStringFromSelector(@selector(outlineView:didClickTableColumn:)),
             NSStringFromSelector(@selector(outlineView:didDragTableColumn:)),
             NSStringFromSelector(@selector(outlineView:sizeToFitWidthOfColumn:)),
             NSStringFromSelector(@selector(outlineView:shouldReorderColumn:toColumn:)),
             NSStringFromSelector(@selector(outlineViewColumnDidMove:)),
             NSStringFromSelector(@selector(outlineViewColumnDidResize:)),
             NSStringFromSelector(@selector(outlineView:isGroupItem:))];
}

+ (NSDictionary *)customMethodNameMappings
{
    return @{NSStringFromSelector(@selector(outlineView:objectValueForTableColumn:byItem:)): NSStringFromSelector(@selector(sourceList:objectValueForItem:)),
             NSStringFromSelector(@selector(outlineView:setObjectValue:forTableColumn:byItem:)): NSStringFromSelector(@selector(sourceList:setObjectValue:forItem:)),
             NSStringFromSelector(@selector(outlineView:viewForTableColumn:item:)): NSStringFromSelector(@selector(sourceList:viewForItem:)),
             NSStringFromSelector(@selector(outlineView:willDisplayCell:forTableColumn:item:)): NSStringFromSelector(@selector(sourceList:willDisplayCell:forItem:)),
             NSStringFromSelector(@selector(outlineView:shouldEditTableColumn:item:)): NSStringFromSelector(@selector(sourceList:shouldEditItem:)),
             NSStringFromSelector(@selector(outlineView:toolTipForCell:rect:tableColumn:item:mouseLocation:)): NSStringFromSelector(@selector(sourceList:tooltipForCell:rect:item:mouseLocation:)),
             NSStringFromSelector(@selector(outlineView:typeSelectStringForTableColumn:item:)): NSStringFromSelector(@selector(sourceList:typeSelectStringForItem:)),
             NSStringFromSelector(@selector(outlineView:shouldShowCellExpansionForTableColumn:item:)): NSStringFromSelector(@selector(sourceList:shouldShowCellExpansionForItem:)),
             NSStringFromSelector(@selector(outlineView:shouldTrackCell:forTableColumn:item:)): NSStringFromSelector(@selector(sourceList:shouldTrackCell:forItem:)),
             NSStringFromSelector(@selector(outlineView:dataCellForTableColumn:item:)): NSStringFromSelector(@selector(sourceList:dataCellForItem:))};
}

- (BOOL)getForwardingObject:(id*)outObject andForwardingSelector:(SEL*)outSelector forSelector:(SEL)selector
{
    NSDictionary *methodForwardingMap = [[self class] methodForwardingMap];
    NSDictionary *forwardingInfo = methodForwardingMap[NSStringFromSelector(selector)];
    if (!forwardingInfo)
        return NO;

    NSString *originatingProtocol = forwardingInfo[forwardingMapOriginatingProtocolKey];

    id forwardingObject;
    if ([originatingProtocol isEqualToString:NSStringFromProtocol(@protocol(NSOutlineViewDelegate))])
        forwardingObject = self.delegate;
    else if ([originatingProtocol isEqualToString:NSStringFromProtocol(@protocol(NSOutlineViewDataSource))])
        forwardingObject = self.dataSource;

    if (!forwardingObject)
        return NO;

    if (outObject)
        *outObject = forwardingObject;

    if (outSelector)
        *outSelector = NSSelectorFromString(forwardingInfo[forwardingMapForwardingMethodNameKey]);
    
    return YES;
}

#pragma mark - Notifications

- (void)registerDelegateToReceiveNotification:(NSString*)notification withSelector:(SEL)selector
{
	NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];

	//Set the delegate as a receiver of the notification if it implements the notification method
	if([self.delegate respondsToSelector:selector]) {
		[defaultCenter addObserver:self.delegate
						  selector:selector
							  name:notification
							object:self];
	}
}

/* Notification wrappers */
- (void)outlineViewSelectionIsChanging:(NSNotification *)notification
{
	[[NSNotificationCenter defaultCenter] postNotificationName:PXSLSelectionIsChangingNotification object:self];
}


- (void)outlineViewSelectionDidChange:(NSNotification *)notification
{
	[[NSNotificationCenter defaultCenter] postNotificationName:PXSLSelectionDidChangeNotification object:self];
}

- (void)outlineViewItemWillExpand:(NSNotification *)notification
{
	[[NSNotificationCenter defaultCenter] postNotificationName:PXSLItemWillExpandNotification
														object:self
													  userInfo:[notification userInfo]];
}

- (void)outlineViewItemDidExpand:(NSNotification *)notification
{
	[[NSNotificationCenter defaultCenter] postNotificationName:PXSLItemDidExpandNotification
														object:self
													  userInfo:[notification userInfo]];
}

- (void)outlineViewItemWillCollapse:(NSNotification *)notification
{
	[[NSNotificationCenter defaultCenter] postNotificationName:PXSLItemWillCollapseNotification
														object:self
													  userInfo:[notification userInfo]];
}

- (void)outlineViewItemDidCollapse:(NSNotification *)notification
{
	[[NSNotificationCenter defaultCenter] postNotificationName:PXSLItemDidCollapseNotification
														object:self
													  userInfo:[notification userInfo]];
}

@end