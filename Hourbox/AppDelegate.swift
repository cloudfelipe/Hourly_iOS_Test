//
//  AppDelegate.swift
//  Hourbox
//
//  Created by Felipe Correa on 14/12/20.
//  Copyright © 2020 Felipe & Co. Studios. All rights reserved.
//

import UIKit
import Networking

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var viewModel: HomeViewModelType?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let client = WebClient(authProvider: AuthProvider())
        let service = FilesServices(baseUrlProvider: URLProvider(), client: client)
        let repo = FilesRepository(service: service)
        let interactor = GetHomeFilesInteractor(repository: repo)
        let input = HomeViewModel.InputDependencies(getFilesInteractor: interactor)
        let cviewModel = HomeViewModel(dependencies: input)
//        cviewModel.getData()
        viewModel = cviewModel
        
        let viewController = HomeViewController(viewModel: cviewModel)
        cviewModel.bind(view: viewController)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        
        return true
    }

}

struct URLProvider: BaseURLProviderType {
    var baseURL: String {
        "https://api.dropboxapi.com/2/"
    }
}

struct AuthProvider: AuthProviderType {
    var token: String {
        "Bearer uQGtRzNwT60AAAAAAAAAAaqSLwcTHK2RSzirh3JqtbNr7RcKoc2iq090L52S0h9Q"
    }
}
