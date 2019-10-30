Pod::Spec.new do |spec|
  spec.name = "BehaviorTextInput"
  spec.version = "1.0.0"
  spec.summary = "Floating input text field"
  spec.homepage = "https://www.facebook.com/trongnhan.nl"
  spec.license = { type: 'MIT', file: 'LICENSE' }
  spec.authors = { "Jacky Nguyen" => 'trongnhan68@gmail.com' }
  spec.social_media_url = "https://www.facebook.com/trongnhan.nl"

  spec.platform = :ios, "11.0"
  spec.requires_arc = true
  spec.source = { git: "https://github.com/trongnhan68/BehaviorTextInput.git", tag: "v#{spec.version}", submodules: true }
  spec.source_files = "BehaviorTextInput/*.{h,swift,xib}"

  spec.dependency "Curry"
end