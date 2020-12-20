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
}
