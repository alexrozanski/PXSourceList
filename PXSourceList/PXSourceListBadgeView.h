//
//  PXSourceListBadgeView.h
//  PXSourceList
//
//  Created by Alex Rozanski on 15/11/2013.
//  Copyright 2009-14 Alex Rozanski http://alexrozanski.com and other contributors.
//  This software is licensed under the New BSD License. Full details can be found in the README.
//

#import <Cocoa/Cocoa.h>

/**
 `PXSourceListBadgeView` is an `NSControl` subclass which can be used for displaying Source List badges.
 
 @discussion Instances of this class can be used by table cell views which are used to display content when
 using `PXSourceList` in view-based mode. These table cell views have to be set up to display badges manually,
 unlike when using `PXSourceList` in cell-based mode, where this is done automatically behind-the-scenes.
 
 `PXSourceListTableCellView` has an outlet for a `PXSourceListBadgeView` instance which can be hooked up in Interface
 Builder or set in code.
 
 ### Display customisation
 
 `PXSourceListBadgeView` displays badges like a 'system default' Source List such as in Mail.app with a grey-blue
 background and light text. However, the colours used for the badge value and the background colour of the badge can be
 changed by using the `textColor` and `backgroundColor` properties.
 
 @warning Note that the `textColor` and `backgroundColor` properties are only respected when the row displaying the badge
 isn't highlighted. When the row is highlighted, the badge is displayed with a white background and a blue text colour.

 */
@interface PXSourceListBadgeView : NSControl

///---------------------------------------------------------------------------------------
/// @name Reading and setting the badge value
///---------------------------------------------------------------------------------------
/**
 @brief Returns the numeric value displayed by the receiver.
 
 @since Requires the Mac OS X 10.7 SDK or above.
 */
@property (assign, nonatomic) NSUInteger badgeValue;

///---------------------------------------------------------------------------------------
/// @name Customising the badge appearance
///---------------------------------------------------------------------------------------
/**
 @brief Returns the custom text colour used to display the receiver.
 @discussion The default value for this property is `nil`. Set this property to `nil` to use the default
 badge text colour.
 
 @see backgroundColor

 @since Requires the Mac OS X 10.7 SDK or above.
 */
@property (strong, nonatomic) NSColor *textColor;

/**
 @brief Returns the custom background colour used to display the receiver.
 @discussion The default value for this property is `nil`. Set this property to `nil` to use the default
 badge background colour.
 
 @see textColor

 @since Requires the Mac OS X 10.7 SDK or above.
 */
@property (strong, nonatomic) NSColor *backgroundColor;

@end
