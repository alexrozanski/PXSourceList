#PXSourceList


[![Pod Version](http://img.shields.io/cocoapods/v/PXSourceList.svg)](http://cocoadocs.org/docsets/PXSourceList/2.0.5/)
[![Platform](http://img.shields.io/cocoapods/p/PXSourceList.svg)](http://cocoadocs.org/docsets/PXSourceList/2.0.5/)
[![Licence](http://img.shields.io/cocoapods/l/PXSourceList.svg)](https://github.com/Perspx/PXSourceList/blob/master/LICENSE)

`PXSourceList` is an `NSOutlineView` subclass used for easily implementing source lists in your applications.

PXSourceList requires the OS X 10.7 SDK and above and is licensed under the New BSD License.

![PXSourceList in action: The view-based example project included in the repository.](Examples/Screenshots/PXSourceList-ViewBased-Example.png)

## Overview
Using a [source list](http://developer.apple.com/library/mac/documentation/UserExperience/Conceptual/AppleHIGuidelines/Windows/Windows.html#//apple_ref/doc/uid/20000961-CHDDIGDE) for navigation is a common user interface paradigm in OS X applications, but requires a fair amount of manual set up and customisation of standard Cocoa controls.

**PXSourceList subclasses NSOutlineView and provides much of the common styling and idiomatic behaviour of source lists for you through a clean and simple API.**

PXSourceList has several key features:

- Built-in support for displaying badges — blue-grey pills which display numerical values such as the number of photos in a particular album.
- Always displaying root-level items with ‘group styling’ — the blue-grey uppercase text seen in the source lists in apps such as Mail.app. This requires no extra configuration.
- Support for displaying specific groups as ‘always expanded’ through implementation of a single delegate method. These groups will always show their child items and won’t show a Show/Hide button on hover.
- Since idiomatic source lists use only a single column and don’t display column headers, PXSourceList operates with only a single table column and doesn’t display a header. This is reflected in PXSourceList’s API and makes the control easier to use.
- The project includes a generic data model class which can be used for building a data source data model without having to roll your own.

Note that [in the OS X Human Interface Guidelines](https://developer.apple.com/library/mac/documentation/userexperience/conceptual/applehiguidelines/Windows/Windows.html#//apple_ref/doc/uid/20000961-CHDDIGDE), source lists are broken down into those which provide navigation for the app as a whole (and have a blue-grey background), and those which provide selection functionality for the window (with a white background). PXSourceList implements this *first* style of source list; the second type doesn’t require quite as much common customisation so would not be useful as a standalone control.

## Using PXSourceList

### Installing with Cocoapods

You can install PXSourceList by adding the following line to your `Podfile`:

    pod 'PXSourceList', '~> 2.0'

### Cloning with git

You can also get the source by cloning with git:

    $ git clone https://github.com/Perspx/PXSourceList.git

You can then either:

  * Copy all of the files from the `PXSourceList` directory (including those in the `Internal` subdirectory) into your project

***or***

  * Add the Xcode project as a subproject to your own Xcode project or to your workspace and link against the `PXSourceList` framework target.

### Using PXSourceList in your application

 1. Drag an `NSOutlineView` object into the window/view that you're displaying the source list in. Often source lists are placed in the leftmost panel of an `NSSplitView`.
 2. In the Identity inspector for the outline view, change the class from the `NSOutlineView` placeholder to `PXSourceList`.
 3. With the *source list* selected (it helps to use Interface Builder’s *Document Outline* view for this), select "Source List" for the "Highlight" attribute under the "Table View" section in the Attributes inspector.
 4. Control-click on the Source List and drag connectors to the object(s) that you want to be your Source List's delegate and data source, selecting "delegate" or "dataSource" respectively from the popup menu that is shown when you release the mouse button. A Source List *requires* a data source object, but having a delegate is optional.
 5. Make sure to `#import "PXSourceList.h"` for files that require it (the delegate and data source protocol files are imported in this main header), and ensure that your source list delegate and data source class(es) conform to the `PXSourceListDelegate` and `PXSourceListDataSource` protocols respectively.

There are also two example projects included in the project to see how PXSourceList should be used.

### Cell-based vs. View-based mode
As an `NSOutlineView` subclass, PXSourceList can display its contents using cells (in *cell-based* mode) or views (in *view-based* mode). Some delegate and data source methods (see below) are only applicable when PXSourceList is used in cell-based mode, and is noted as such in the documentation.

## Documentation
`PXSourceList` and its related classes and protocols are documented in the header files included in the repository using [appledoc](http://gentlebytes.com/appledoc/)-style documentation.

Documentation (in HTML and docset formats) can be generated by building the *Documentation* target from the Xcode project. The resulting documentation will be placed in `docs` in the root directory of the project. To generate documentation in this way, appledoc [must be installed](https://github.com/tomaz/appledoc#quick-install) and the script which builds the documentation expects it to be installed under `/usr/local/bin`.

If you notice any mistakes or feel that any areas of the documentation are lacking or missing, please [file a GitHub issue](https://github.com/Perspx/PXSourceList/issues).

## PXSourceList 2
PXSourceList 2 is a great improvement over PXSourceList 0.x and 1.x that adds view-based table support and many other small improvements and bugfixes.

For view-based table support, new delegate and data source methods have been added to bring PXSourceList on-par with `NSOutlineView`’s API, and a generic badge view and `NSTableCellView` subclass have been implemented to allow easy setup of `NSTableCellView`s with PXSourceList.

Additionally, a generic `PXSourceListItem` class has been implemented for building a data source model without having to roll your own class. A new internal implementation of PXSourceList fixes problems in prior versions where some source list delegate and data source methods weren’t being called.

Take a look at the [Release Notes](ReleaseNotes.md) for a comprehensive list of changes as well as API changes in version 2.

## Delegate and Data Source Objects
Like `NSOutlineView`, `PXSourceList` objects obtain their content and other information from their *data source* and *delegate* objects using methods defined in the `PXSourceListDataSource` and `PXSourceListDelegate` protocols respectively.

As well as declaring new delegate and data source methods, since `PXSourceList` subclasses `NSOutlineView`, `PXSourceListDataSource` and `PXSourceListDelegate` include most `NSOutlineViewDelegate` and `NSOutlineViewDataSource` methods but with the "outlineView" prefix replaced with "sourceList". For more information on implementing a data source object, take a look at *[Outline View Programming Topics](https://developer.apple.com/library/mac/documentation/cocoa/conceptual/OutlineView/Articles/UsingOutlineDataSource.html)* — PXSourceList’s delegate and data source implementation works in a very similar way.

Note that some of the `NSOutlineView` delegate and data source methods are not relevant to PXSourceList, so they haven't been added to `PXSourceListDelegate` and `PXSourceListDataSource`.

Note also that because of the way PXSourceList works under the hood, `-[PXSourceList delegate]` and `-[PXSourceList dataSource]` have been marked as unavailable (they return an internal proxy object). You should therefore only use `-setDelegate:` and `-setDataSource:`.

### Required Methods 
A PXSourceList data source must implement the following methods:

    - (NSUInteger)sourceList:(PXSourceList*)sourceList numberOfChildrenOfItem:(id)item
    - (id)sourceList:(PXSourceList*)aSourceList child:(NSUInteger)index ofItem:(id)item
    - (BOOL)sourceList:(PXSourceList*)aSourceList isItemExpandable:(id)item

If you are using PXSourceList in cell-based mode, you also need to implement:

    - (id)sourceList:(PXSourceList*)aSourceList objectValueForItem:(id)item

If you are using PXSourceList in view-based mode, you should implement:

    - (NSView *)sourceList:(PXSourceList *)aSourceList viewForItem:(id)item

 in your **delegate** object class.

Take a look at both the view-based and cell-based example projects in the repository for more information about implementing PXSourceList delegate and data source objects.

## View-Based Source Lists
As mentioned above, PXSourceList can be used in either cell-based- or view-based mode to display content using cells or views.

When using PXSourceList in view-based mode, several classes have been included in the project to help with setting up views for each item in the table, which is done in the `PXSourceListDataSource` method, `-sourceList:viewForItem:`.

### PXSourceListBadgeView
This is a view class that draws a badge with a given numeric value. Badges are displayed to the right of rows that show them and are displayed with a grey-blue background when the row containing them is not selected, or a white background otherwise.

### PXSourceListTableCellView
This is an `NSTableCellView` subclass that exposes a `badgeView` outlet that can be hooked up to a `PXSourceListBadgeView` instance in Interface Builder and can then be configured in `-sourceList:viewForItem:`. Like with `NSTableCellView`, `PXSourceListTableCellView` positions its `badgeView` automatically for you.

## Data Source Model Using PXSourceListItem
The generic `PXSourceListItem` class has been added in PXSourceList 2 for creation of a data source model without having to roll your own classes.

Since `PXSourceListDataSource` works by building up a tree structure of model objects (which maps to the tree-like presentation of the content), `PXSourceListItem` allows you to build up a tree structure of model objects using the `children` property and other convenience methods.

Each item can have associated with it:
- **A title**. Useful for setting the `textField` property of an `NSTableCellView` in `-sourceListForItem:`.
- **An icon image**. Useful for setting the image on the `imageView` property of an `NSTableCellView` in `-sourceListForItem:`.
- **An identifier**. Useful for identifying a given item when given one as the return value from `PXSourceList` method or as a parameter to a `PXSourceListDelegate` or `PXSourceListDataSource` method.
- **A badge value**. Useful to store the badge value for a particular item if it doesn’t have a backing data model object that you pull this value from.

Additionally, each item has a `representedObject` property associated with it which is useful when you don’t want to set the data on a source list item directly, but instead want to pull it from an associated model object. This means that you don’t have to keep your data model and properties on `PXSourceListItem` in sync.

## Attribution

Thanks first of all to the [wonderful people](https://github.com/Perspx/PXSourceList/graphs/contributors) who have contributed to the project and helped in improving the project, fixing bugs and adding new features.

In the initial release of PXSourceList, I was spurred along the way by many sources, but in particular [BWToolkit](http://brandonwalkin.com/bwtoolkit/) by Brandon Walkin and Fraser Kuyvenhoven, which gave me the idea of how to handle the source list delegate and data source methods.

Brian Dunagan's post on [Source List badging](http://www.bdunagan.com/2008/11/10/cocoa-tutorial-source-list-badges-part-2/) and determining state for the various colours was also a great help when I came to the drawing code for source list badges.

The *Documentation* target in the Xcode project makes use of the fantastic [appledoc](http://www.gentlebytes.com/appledoc/), which has been an invaluable tool utilised since the very first version of PXSourceList.

The icons used in the example projects bundled with the source code are from the [Fugue icon set](http://p.yusukekamiyamane.com) by Yusuke Kamiyamane (in the cell-based example) and the [Mimi Glyphs set](http://salleedesign.com/resources/mimi-glyphs/) by Jeremy Salée (in the view-based example).

## Licence
PXSourceList is licensed under the New BSD License, as detailed below (adapted from OSI [http://www.opensource.org/licenses/bsd-license.php](http://www.opensource.org/licenses/bsd-license.php)):


Copyright &copy; 2009-14, Alex Rozanski and other contributors.
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

- Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
- Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
- Neither the name of the author nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
