Pod::Spec.new do |s|

  s.name         = "SIPopView"
  s.version      = "1.0"
  s.summary      = "简单弹出框"
  s.description  = <<-DESC
                    iOS自定义简单弹出框
                   DESC
  s.homepage     = "https://github.com/silence0201/SIPopView"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Silence" => "374619540@qq.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/silence0201/SIPopView.git", :tag => "#{s.version}" }
  s.source_files  = "PopView", "PopView/**/*.{h,m}"
end
