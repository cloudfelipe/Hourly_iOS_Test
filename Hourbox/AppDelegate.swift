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
    var rootNavigationVC: UINavigationController!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let client = WebClient(authProvider: AuthProvider())
        let service = FilesServices(baseUrlProvider: URLProvider(), client: client)
        let repo = FilesRepository(service: service)
        let interactor = GetFilesInteractor(repository: repo)
        
        rootNavigationVC = UINavigationController()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = rootNavigationVC
        window?.makeKeyAndVisible()
        
        let coordinatorDep = FileBrowserCoordinator.Dependency(path: .root, getFilesInteractor: interactor)
        let coordinator = FileBrowserCoordinator(router: rootNavigationVC, dependencies: coordinatorDep)
        coordinator.start()
        
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
