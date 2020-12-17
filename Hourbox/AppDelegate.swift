//
//  AppDelegate.swift
//  Hourbox
//
//  Created by Felipe Correa on 14/12/20.
//  Copyright © 2020 Felipe & Co. Studios. All rights reserved.
//

import UIKit
import Networking
import SwiftyDropbox

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var rootNavigationVC: UINavigationController!
    weak var applicationCoordinator: ApplicationCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        rootNavigationVC = UINavigationController()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = rootNavigationVC
        window?.makeKeyAndVisible()
        
        let coordinator = ApplicationCoordinator(router: rootNavigationVC)
        coordinator.start()
        applicationCoordinator = coordinator
        
        DropboxClientsManager.setupWithAppKey("lpwlc9qrng9mdbm")
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let oauthCompletion: DropboxOAuthCompletion = {
          if let authResult = $0 {
            self.applicationCoordinator?.dropboxAccessToken(token: authResult)
          }
        }
        let canHandleUrl = DropboxClientsManager.handleRedirectURL(url, completion: oauthCompletion)
        return canHandleUrl
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
