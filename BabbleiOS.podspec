#
# Be sure to run `pod lib lint Survey.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'BabbleiOS'
  s.version          = '0.0.15'
  s.summary          = 'Survey for the app'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'Survey for app with different types of UI elements.'

  s.homepage         = 'https://github.com/nirmalvora/babble_ios_sdk'
  s.license          = { :type => 'Apache', :file => 'LICENSE' }
  s.author           = 'Nirmal Vora.'
  s.source           = { :git => 'https://github.com/nirmalvora/babble_ios_sdk.git', :tag => s.version.to_s }
  s.ios.deployment_target = '10.0'
  s.swift_version = '5'
  s.source_files = 'BabbleiOS/Classes/**/*'
  s.resource_bundles = {
    'SurveySDK' => ['BabbleiOS/Resources/**/*']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
end
