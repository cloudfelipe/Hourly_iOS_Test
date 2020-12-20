platform :ios, '11.0'

workspace 'Hourbox.xcworkspace'

target 'Hourbox' do
  use_frameworks!
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'SwiftyDropbox'
  pod 'KeychainAccess'
  pod 'SwifterSwift'

  pod 'Lightbox'
  pod 'SkeletonView'
  pod 'DZNEmptyDataSet'
  pod 'SVProgressHUD'

  target 'HourboxTests' do
    inherit! :search_paths
    pod 'RxBlocking'
    pod 'RxTest'
  end

  target 'HourboxUITests' do
  end

end

target 'Networking' do
    pod 'SwiftyDropbox'
    project 'Networking/Networking'

    target 'NetworkingTests' do
      inherit! :search_paths
    end
end
