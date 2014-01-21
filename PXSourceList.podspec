Pod::Spec.new do |s|
  s.name         = "PXSourceList"
  s.version      = "2.0.0"
  s.summary      = "A Source List control for OS X."

  s.description  = <<-DESC
                   PXSourceList is an NSOutlineView subclass which provides an easy-to-use
                   implementation of a sidebar similar to that found in iTunes, iPhoto and
                   Mail.app.

                   PXSourceList provides an API for displaying *icons* and *badges* which
                   are often used in Source Lists. The project additionally contains and
                   NSTableCellView subclass and generic data source model item for quick
                   and easy setup.
                   DESC

  s.homepage     = "https://github.com/Perspx/PXSourceList"
  s.license      = 'MIT'

  s.author       = { "Alex Rozanski" => "alex@rozanski.me" }
  s.social_media_url = "http://twitter.com/alexrozanski"

  s.platform     = :osx
  s.osx.deployment_target = '10.7'

  s.source       = { :git => "https://github.com/Perspx/PXSourceList.git", :tag => "2.0.0" }
  s.source_files = 'PXSourceList/**/*.{h,m}'

  s.public_header_files = 'PXSourceList/*.h'
  s.requires_arc = true
end
