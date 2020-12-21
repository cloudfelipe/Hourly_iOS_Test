//
//  DIMock.swift
//  Hourbox
//
//  Created by Felipe Correa on 20/12/20.
//  Copyright © 2020 Felipe & Co. Studios. All rights reserved.
//

import UIKit
import Foundation

final class DIMock: DependencyInversionType {

    var getFilesInteractor: GetFilesInteractorType = InteractorStubs.shared

    var downloadFileInteractor: DownloadFileInteractorType = InteractorStubs.shared

    var isUserLoggedInInteractor: IsUserLoggedInInteractorType = InteractorStubs.shared

    var storeAccessTokenInteractor: StoreAccessTokenInteractorType = InteractorStubs.shared

    var removeAccessTokenInteractor: RemoveAccessTokenInteractorType = InteractorStubs.shared

    var getThumbnailInteractor: GetThumbnailInteractorType = InteractorStubs.shared

    var logoutInteractor: LogoutInteractorType = InteractorStubs.shared

}

private class InteractorStubs: GetFilesInteractorType, DownloadFileInteractorType, IsUserLoggedInInteractorType, StoreAccessTokenInteractorType, RemoveAccessTokenInteractorType, GetThumbnailInteractorType, LogoutInteractorType {
    
    static var shared = InteractorStubs()
    var loggedIn = true
    
    private init () { }
    
    func downloadFile(file: Entry, completion: @escaping DataResultable<DownloadedFile>) {
        let imageData = #imageLiteral(resourceName: "frontLogo").pngData()!
        completion(.success(DownloadedFile(data: imageData)))
    }
    
    func isLoggedIn() -> Bool {
        loggedIn
    }
    
    func store(token: String) {
        debugPrint("Token stored")
    }
    
    func remove() {
        loggedIn = false
    }
    
    func get(for file: Entry, completion: @escaping DataResultable<DownloadedFile>) {
        let imageData = #imageLiteral(resourceName: "frontLogo").pngData()!
        completion(.success(DownloadedFile(data: imageData)))
    }
    
    func logout() {
        NotificationCenter.default.post(name: .logout, object: nil)
    }

    func getFiles(param: FilePath, completion: @escaping DataResultable<Files>) {
        let fileEntry = Entry(tag: .file,
                              name: "Sample.png",
                              pathLower: "Sample.png",
                              pathDisplay: "/sample",
                              hashValue: "UUDI",
                              isDownloadable: true,
                              size: 1234567,
                              modifiedDate: Date())
        
        let pdfFile = Entry(tag: .file,
                            name: "Sample.pdf",
                            pathLower: "Sample.pdf",
                            pathDisplay: "/sample",
                            hashValue: "UUDI",
                            isDownloadable: true,
                            size: 1234567,
                            modifiedDate: Date())
        
        let folderEntry = Entry(tag: .folder,
                                name: "Sample",
                                pathLower: "/sample",
                                pathDisplay: "/Sample",
                                hashValue: nil,
                                isDownloadable: false,
                                size: nil,
                                modifiedDate: nil)
        
        let file = Files(entries: [fileEntry, pdfFile, folderEntry], coursor: nil)
        completion(.success(file))
    }
}
