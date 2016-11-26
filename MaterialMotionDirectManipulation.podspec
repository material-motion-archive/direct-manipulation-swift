Pod::Spec.new do |s|
  s.name         = "MaterialMotionDirectManipulation"
  s.summary      = "Direct Manipulation for Material Motion (Swift)"
  s.version      = "1.1.0"
  s.authors      = "The Material Motion Authors"
  s.license      = "Apache 2.0"
  s.homepage     = "https://github.com/material-motion/direct-manipulation-swift"
  s.source       = { :git => "https://github.com/material-motion/direct-manipulation-swift.git", :tag => "v" + s.version.to_s }
  s.platform     = :ios, "8.0"
  s.requires_arc = true
  s.default_subspec = "lib"

  s.subspec "lib" do |ss|
    ss.source_files = "src/*.{swift}", "src/private/*.{swift}"
  end

  s.subspec "examples" do |ss|
    ss.source_files = "examples/*.{swift}", "examples/supplemental/*.{swift}"
    ss.exclude_files = "examples/TableOfContents.swift"
    ss.resources = "examples/supplemental/*.{xcassets}"
    ss.dependency "MaterialMotionDirectManipulation/lib"

    ss.dependency "MaterialMotionRuntime", "~> 6.0"
  end

  s.subspec "tests" do |ss|
    ss.source_files = "tests/src/*.{swift}", "tests/src/private/*.{swift}"
    ss.dependency "MaterialMotionDirectManipulation/lib"
    ss.dependency "MaterialMotionRuntime/tests"
  end

  s.dependency "MaterialMotionRuntime", ">= 5.0", "< 7.0"
end
