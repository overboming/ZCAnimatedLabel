Pod::Spec.new do |s|


  s.name         = "ZCAnimatedLabel"
  s.version      = "0.1"
  s.summary      = "UILabel replacement with customizable fine-grain appear/disappear animation"

  s.description  = <<-DESC
                   DESC

  s.homepage     = "http://github.com/overboming/ZCAnimatedLabel"
  s.license      = "MIT"
  s.author             = { "Chen Zhang" => "overboming@gmail.com" }
  s.social_media_url   = "http://twitter.com/overboming"
  s.platform     = :ios
  s.ios.deployment_target = "6.0"
  s.source       = { :git => "http://EXAMPLE/ZCAnimatedLabel.git", :tag => "0.0.1" }
  s.source_files  = "ZCAnimatedLabel/ZCAnimatedLabel/*.{h,m}"
  s.exclude_files = "Classes/Exclude"
  s.frameworks = "CoreText"
  s.requires_arc = true

end
