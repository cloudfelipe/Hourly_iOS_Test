//
//  Texts.swift
//  Hourbox
//
//  Created by Felipe Correa on 19/12/20.
//  Copyright © 2020 Felipe & Co. Studios. All rights reserved.
//

enum Texts {
    enum Logout {
        static let title = "Logout.Alert.Title".localized()
        static let message = "Logout.Alert.Message".localized()
    }
    
    enum General {
        static let ok = "General.Ok".localized()
        static let thumbnail = "General.Thumbnail".localized()
        static let na = "N/A"
        static let logout = "General.Logout".localized()
        static let home = "General.Home".localized()
    }
    
    enum Error {
        static let title = "Error.Title".localized()
        static let message = "Error.Message".localized()
    }
    
    enum SignIn {
        static let welcomeTitle = "SignIn.Welcome.Title".localized()
        static let button = "SignIn.Button.Title".localized()
    }
    
    enum FileInformation {
        static let title = "FileInformation.Title".localized()
        static let name = "FileInformation.Name".localized()
        static let type = "FileInformation.Type".localized()
        static let downloadable = "FileInformation.Downloadable".localized()
        static let size = "FileInformation.size".localized()
        static let lastModified = "FileInformation.LastModified".localized()
        static let fullPath = "FileInformation.FullPath".localized()
        static let hashValue = "FileInformation.HasValue".localized()
        static let dateFormat = "dd/MM/yyyy HH:mm"
    }
    
    enum EmptyState {
        static let title = "EmptyState.title".localized()
        static let description = "EmptyState.description".localized()
    }
}
