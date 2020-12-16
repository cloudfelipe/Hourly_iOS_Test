platform :ios, '11.0'

workspace 'Hourbox.xcworkspace'

target 'Hourbox' do
  use_frameworks!
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'SwiftyDropbox'

  target 'HourboxTests' do
    inherit! :search_paths
  end

  target 'HourboxUITests' do
  end

  target 'Networking' do
  pod 'SwiftyDropbox'
  project 'Networking/Networking'
end


end
