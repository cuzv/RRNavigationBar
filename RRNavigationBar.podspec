Pod::Spec.new do |s|
  s.name         = "RRNavigationBar"
  s.version      = "0.2.0"
  s.summary      = "bring `UINavigationBar` to` UIViewController`"

  s.homepage     = "https://github.com/cuzv/RRNavigationBar.git"
  s.license      = "MIT"
  s.author       = { "Moch Xiao" => "cuzval@gmail.com" }
  s.platform     = :ios, "7.0"
  s.requires_arc = true
  s.source       = { :git => "https://github.com/cuzv/RRNavigationBar.git",
:tag => s.version.to_s }
  s.source_files = "Sources/*.{h,m}"
  s.frameworks   = 'Foundation', 'UIKit'
end

