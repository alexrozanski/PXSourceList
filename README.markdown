#PXSourceList

A Source List control for use with the Mac OS X 10.5 SDK or above.

[Download the documentation][1]

`PXSourceList` is licensed under the New BSD License.

##Intention
[Source Lists][2] are used in a lot of Mac OS X applications, but the support for such controls is quite primitive – at best you create an Outline View with Source List highlighting, but none of the features such as badging are built in by default. `PXSourceList` is a reusable control – within the context of Source Lists – which makes creating applications with Source Lists a much easier process.

##Using the code
There are only a few steps involved:

 1. Download the source, and copy `PXSourceList.h`, `PXSourceList.m`, `PXSourceListDelegate.h` and `PXSourceListDataSource.h` into your Xcode project.
 2. To create the control in Interface Builder, drag an `NSOutlineView` object over to a window and in the Identity Inspector for the Outline View, change the class to `PXSourceList`. In the Attributes Inspector, set it to have only 1 column, uncheck "Headers" in the "Columns" section and set "Highlight" to "Source List" – there is an NIB in the example project bundled with the source.
 3. Make sure to `#import "PXSourceList.h"` for files that require it (the delegate and data source protocol files are imported in this main header), and ensure that your class(es) that are the `delegate` and/or `dataSource` for the Source List conform to the `PXSourceListDelegate` and `PXSourceListDataSource` protocols respectively.

**Note:** If you intend to use PXSourceList with the 10.5 SDK, you will need to remove some of the protocols that PXSourceList conforms to which do not exist – in `PXSourceList.h`, remove the `<NSOutlineViewDelegate, NSOutlineViewDataSource, NSMenuDelegate>` from the interface declaration.

There is also an example project bundled with the source to see how the control is used.

##Screenshots
![alt text][3]

##How the control works
I have tried to structure PXSourceList in a way such that it fits common Cocoa design patterns and therefore makes it easier to use.

PXSourceList adapts the delegate and data source design patterns, and extends those of the `NSOutlineViewDelegate` and `NSOutlineViewDataSource`, much in the way that these extend the appropriate `NSTableView` protocols.

If you want more information have a look at the [Outline View Programming Topics for Cocoa][4] – the Source List delegate and data source implementation work in much the same way, but with methods added and removed, as detailed in the documentation.

##Documentation
Documentation is available for PXSourceList, downloadable [here][5]. Provided in the ZIP file is a folder containing HTML documentation, or a docset which can be opened in Xcode and which is then searchable from the Xcode Developer Documentation.

If you feel that any areas of the documentation are lacking or missing, please feel free to [let me know][6], which will be much appreciated.

**Note:** the documentation for the Source List notifications can be found in the `NSObject(PXSourceListNotifications)` reference, which is linked to from the documentation index page.

###Documentation Revision History
For the latest documentation see the PXSourceList [downloads page][7].

##Known Issues

  - Calling `delegate` or `dataSource` on the Source List returns the Source List instance. This is, unfortunately, a side effect of how delegate and data source methods are handled within the Source List – I hope to work around it in the future.
  - No bindings implementation (yet).

##Attribution

I was spurred along the way by many sources, but in particular [BWToolkit][8] by Brandon Walkin and Fraser Kuyvenhoven, which gave me the idea of how to handle the Source List delegate and data source methods.

Also Brian Dunagan's post on [Source List badging][9] and determining state for the various colours was a great help when I came to the drawing code for that.

The documentation was created using [Doxygen][10] and [appledoc][11], thanks of which go to the developers of both.

The icons used in the demo project bundled with the source code are from the [Fugue icon set][12] by Yusuke Kamiyamane.


  [1]: http://github.com/Perspx/PXSourceList/downloads
  [2]: http://developer.apple.com/Mac/library/documentation/UserExperience/Conceptual/AppleHIGuidelines/XHIGWindows/XHIGWindows.html#//apple_ref/doc/uid/20000961-CHDDIGDE
  [3]: http://perspx.com/wp-content/uploads/2010/01/pxsourcelist.jpg
  [4]: http://developer.apple.com/mac/library/DOCUMENTATION/Cocoa/Conceptual/OutlineView/Articles/UsingOutlineDataSource.html
  [5]: http://github.com/Perspx/PXSourceList/downloads
  [6]: http://perspx.com/contact
  [7]: http://github.com/Perspx/PXSourceList/downloads
  [8]: http://brandonwalkin.com/bwtoolkit/
  [9]: http://www.bdunagan.com/2008/11/10/cocoa-tutorial-source-list-badges-part-2/
  [10]: http://www.doxygen.org/
  [11]: http://www.gentlebytes.com/freeware/appledoc/
  [12]: http://www.pinvoke.com/