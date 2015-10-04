
Pod::Spec.new do |s|
  s.name             = "NavigationControllerBlurTransition"
  s.version          = "1.0.0"
  s.summary          = "A simple blur transition for your UINavigationController."

  s.description      = <<-DESC
    NavigationControllerBlurTransition provides a simple interface for creating a blur transition for your UINavigationController. Utilizing a clean, one-line interface, this transition makes it incredibly simple to add a blur transition to your UINavigationController's push / pop methods.'

                       DESC

  s.homepage         = "https://github.com/ProlificInteractive/NavigationControllerBlurTransition"
  s.license          = 'MIT'
  s.author           = { "Christopher Jones" => "chris.jones@haud.co" }
  s.source           = { :git => "https://github.com/ProlificInteractive/NavigationControllerBlurTransition.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'

end
